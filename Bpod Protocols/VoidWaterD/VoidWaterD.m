function VoidWaterD

% SETUP
% > Connect the water valve in the box to Bpod Port#1.%%%%%%%%%%
% > Connect the air valve in the box to Bpod
% Port#2.%------------------------------
global BpodSystem

%% Define parameters
S = BpodSystem.ProtocolSettings; % Load settings chosen in launch manager into current workspace as a struct called S
if isempty(fieldnames(S))  % If settings file was an empty struct, populate struct with default settings
    
    S.GUI.RewardAmount = 5; % ul
    S.GUI.MaxTrials = 100;
    S.GUI.ITI = 4;
    
end

%% Define trials
MaxTrials = S.GUI.MaxTrials;
%% Initialize parameter GUI plugin
BpodParameterGUI('init', S);
TotalRewardDisplay('init');

%% Main trial loop
for currentTrial = 1:MaxTrials
    
    S = BpodParameterGUI('sync', S); % Sync parameters with BpodParameterGUI plugin
    R = GetValveTimes(S.GUI.RewardAmount, [1]);
    RewardValveTime = R; % Update reward amounts
    ValveState = 1;
    
    sma = NewStateMatrix(); % Assemble state matrix
    sma = AddState(sma, 'Name', 'TrialStart', ...
        'Timer', 1,... % time before trial start
        'StateChangeConditions', {'Tup', 'Reward'},...
        'OutputActions', {'BNCState', 1});
    sma = AddState(sma, 'Name', 'Reward', ...
        'Timer', 0.5,... % reward delay
        'StateChangeConditions', {'Tup', 'DeliverReward'},...
        'OutputActions', {});
    sma = AddState(sma, 'Name', 'DeliverReward', ...
        'Timer', RewardValveTime,... % reward amount
        'StateChangeConditions', {'Tup', 'ITI'},...
        'OutputActions', {'ValveState', ValveState}); % 'SoftCode', soundID
    sma = AddState(sma, 'Name', 'ITI', ...
        'Timer', S.GUI.ITI-1,...
        'StateChangeConditions', {'Tup', 'exit'},...
        'OutputActions', {});
    
    SendStateMatrix(sma);
    RawEvents = RunStateMatrix;
    
    if ~isempty(fieldnames(RawEvents)) % If trial data was returned
        BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents); % Computes trial events from raw data
        BpodSystem.Data.TrialSettings(currentTrial) = S; % Adds the settings used for the current trial to the Data struct (to be saved after the trial ends)
        UpdateTotalRewardDisplay(S.GUI.RewardAmount, currentTrial);
    end
    HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
    if BpodSystem.Status.BeingUsed == 0
        return
    end
end

function UpdateTotalRewardDisplay(RewardAmount, currentTrial)
% If rewarded based on the state data, update the TotalRewardDisplay
global BpodSystem
if ~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Reward(1))
    TotalRewardDisplay('add', RewardAmount);
end
