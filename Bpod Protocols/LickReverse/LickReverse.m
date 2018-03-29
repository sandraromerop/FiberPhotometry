function LickReverse

% SETUP
% > Connect the water valve in the box to Bpod Port#1.
% > Connect the air valve in the box to Bpod Port#2.
% > Lick: Bpod Port#3
% > Running: Bpod Port #4 (TODO)

global BpodSystem

%% Define parameters
S = BpodSystem.ProtocolSettings; % Load settings chosen in launch manager into current workspace as a struct called S
if isempty(fieldnames(S))  % If settings file was an empty struct, populate struct with default settings
    S.GUI.TrainingLevel = 2; % Configurable training level
    S.GUI.RewardAmount = 10; % ul
    S.GUI.PunishAmount = 0.2; % s (air puff)
	S.GUI.AssistProb = 0.5;
    S.GUI.TrialGoProb = 0.5;
    S.GUI.PreGoTrialNum = 0;
    S.isAlwaysPunish = false;
    S.GUI.ResponseTimeGo = 2; % How long until the mouse must make a choice, or forefeit the trial
	if (S.GUI.TrainingLevel >= 2 && S.GUI.TrainingLevel <= 3 && S.isAlwaysPunish)
		S.GUI.ResponseTimeNoGo = 0; %Always punish the mouse if it's a NoGo trial.
		S.GUI.ResponseTimeNoGoDelay = 2; %Wait before punishing the mouse.
	else
		S.GUI.ResponseTimeNoGo = 2; % How long until the mouse must make a choice, or forefeit the trial
		S.GUI.ResponseTimeNoGoDelay = 0; %Wait before punishing the mouse.
	end
    
    S.GUIMeta.TrainingLevel.Style = 'popupmenu'; % the GUIMeta field is used by the ParameterGUI plugin to customize UI objects.
    S.GUIMeta.TrainingLevel.String = {'Habituation','Habituation','LearnReversal', 'Active Reversal'};
        
    S.GUI.PunishDelayMean = 0.1;
    S.PunishDelayMax = 0.1;
    S.PunishDelayMin = 0.1;
    S.GUI.RewardDelayMean = 0.1;
    S.RewardDelayMax = 0.1;
    S.RewardDelayMin = 0.1;

    S.CueDelay = 1.0; % the time from cue to response
    S.ITI = 5;
    S.ITI_min=4; S.ITI_max=7;
    S.SoundDuration = 1.0;
    
    S.RndFlag = 1;
    S.ReTeaching = 0;
    
end

LickPort = 'Port3In';
RewardValveState = 1;
PunishValveState = 2;

% Initialize parameter GUI plugin
BpodParameterGUI('init', S);
TotalRewardDisplay('init');

%% Define trials
MaxTrials = BpodSystem.PluginObjects.maxTrials;
if S.GUI.TrainingLevel==1
    TrialTypes = ones(1,MaxTrials);
elseif S.GUI.TrainingLevel>=2
    % Randomise the training conditions. 
    TrialTypes = ones(1,MaxTrials);
    for ii=(S.GUI.PreGoTrialNum+1):MaxTrials
        if rand<S.GUI.TrialGoProb
            TrialTypes(ii) = 1;
        else
            TrialTypes(ii) = 0;
        end
    end
    
    if S.RndFlag
        seq_type = [1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0];
        for ii=(S.GUI.PreGoTrialNum+1):length(seq_type):MaxTrials            
            TrialTypes(ii:ii+length(seq_type)-1) = seq_type(randperm(length(seq_type)));
        end
    end
    
end

R = repmat(S.GUI.PunishDelayMean,1,MaxTrials);
if S.PunishDelayMax>S.PunishDelayMin
    for k=1:MaxTrials
        candidate_delay = exprnd(S.GUI.PunishDelayMean);
        while candidate_delay>S.PunishDelayMax || candidate_delay<S.PunishDelayMin
            candidate_delay = exprnd(S.GUI.PunishDelayMean);
        end
        R(k) = candidate_delay;
    end
end
PunishDelay = R;

R = repmat(S.GUI.RewardDelayMean,1,MaxTrials);
if S.RewardDelayMax>S.RewardDelayMin
    for k=1:MaxTrials
        candidate_delay = exprnd(S.GUI.RewardDelayMean);
        while candidate_delay>S.RewardDelayMax || candidate_delay<S.RewardDelayMin
            candidate_delay = exprnd(S.GUI.RewardDelayMean);
        end
        R(k) = candidate_delay;
    end
end
RewardDelay = R;

R = repmat(S.ITI,1,MaxTrials);
for k=1:MaxTrials
    candidate_delay = exprnd(S.ITI);
    while candidate_delay>S.ITI_max || candidate_delay<S.ITI_min
        candidate_delay = exprnd(S.ITI);
    end
    R(k) = candidate_delay;
end
ITI = R;

BpodSystem.Data.TrialTypes = []; % The trial type of each trial completed will be added here.
BpodSystem.Data.TrialRewarded = []; % The trial type of each trial completed will be added here.
BpodSystem.Data.RewardDelay = [];
BpodSystem.Data.PunishDelay = [];
BpodSystem.Data.ITI = [];
%% Initialize plots
BpodSystem.ProtocolFigures.SideOutcomePlotFig = figure('Position', [500 200 800 300],'name','Outcome plot','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
BpodSystem.GUIHandles.SideOutcomePlot = axes('Position', [.075 .3 .89 .6]);
% BpodSystem.ProtocolFigures.LickPlotFig = figure('Position', [600 200 600 200],'name','Licking','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
GoNoGoOutcomePlot(BpodSystem.GUIHandles.SideOutcomePlot,'init',TrialTypes);

% Set soft code handler to trigger sounds
BpodSystem.SoftCodeHandlerFunction = 'SoftCodeHandler_PlaySoundX';

SF = 192000; % Sound card sampling rate
SinWaveFreq1 = 10000;
sounddata1 = GenerateSineWave(SF, SinWaveFreq1, S.SoundDuration); % Sampling freq (hz), Sine frequency (hz), duration (s)
SinWaveFreq2 = 3000;
sounddata2 = GenerateSineWave(SF, SinWaveFreq2, S.SoundDuration); % Sampling freq (hz), Sine frequency (hz), duration (s)
% sounddata3 = (rand(1,SF*S.SoundDuration+1)*2) - 1;
% WidthOfFrequencies=1.5; NumberOfFrequencies=7; MeanSoundFreq4 = 6000; SoundRamping=0.2;
% sounddata4 = SoundGenerator(SF, MeanSoundFreq4, WidthOfFrequencies, NumberOfFrequencies, S.SoundDuration, SoundRamping);

% Program sound server
PsychToolboxSoundServer('init')
PsychToolboxSoundServer('Load', 1, 1.2*sounddata1);
PsychToolboxSoundServer('Load', 2, 0.25*sounddata2);
% PsychToolboxSoundServer('Load', 3, sounddata3);
% PsychToolboxSoundServer('Load', 4, sounddata4);

%% Main trial loop
delete(timerfind);
T = timer('period',1,'executionmode','fixedrate','taskstoexecute',9999999);
T.TimerFcn = @(~,~)TotalRewardDisplay('update');
T.Period = 1;
T.ExecutionMode = 'fixedRate';
start(T);
for currentTrial = 1:MaxTrials
    
    S = BpodParameterGUI('sync', S); % Sync parameters with BpodParameterGUI plugin
    R = GetValveTimes(S.GUI.RewardAmount, [1]);
    RewardValveTime = R; % Update reward amounts
    
    switch TrialTypes(currentTrial) % Determine trial-specific state matrix fields
        case 1 % go trial
            soundID = 1;
            LickOutcome = 'Reward';
            ResponseTime = S.GUI.ResponseTimeGo;
			if (S.GUI.TrainingLevel == 2 && rand<S.GUI.AssistProb)
				%Habituation phase, always provide reward.
				Tup_Action = 'AssistReward';
			else
				Tup_Action = 'ITI';
			end
        case 0 % no-go trial
            soundID = 2;
			if (S.GUI.TrainingLevel >= 2 && S.GUI.TrainingLevel <= 3 && S.isAlwaysPunish)
				%Always provide punishment for the reversal training.
				LickOutcome = 'DelayPunishment';
				ResponseTime = S.GUI.ResponseTimeNoGo;
				Tup_Action = 'DelayPunishment';
			else
				LickOutcome = 'Punishment';
				ResponseTime = S.GUI.ResponseTimeNoGo;
				Tup_Action = 'ITI';
			end
    end
    
    sma = NewStateMatrix(); % Assemble state matrix
    
    if S.GUI.TrainingLevel==1 % habituation
        
        sma = AddState(sma, 'Name', 'TrialStart', ...%1
            'Timer', 0.01,... % time before trial start
            'StateChangeConditions', {'Tup', 'ResponseW'},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'ResponseW', ...%2
            'Timer', 15,... % reponse time window
            'StateChangeConditions', {LickPort, 'Reward'},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'AssistReward', ...%3
            'Timer', RewardDelay(currentTrial),...
            'StateChangeConditions', {'Tup', 'DeliverReward'},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'Reward', ...%4
            'Timer', 0,... % reward delay
            'StateChangeConditions', {'Tup', 'DeliverReward'},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'DeliverReward', ...%5
            'Timer', RewardValveTime,... % reward amount
            'StateChangeConditions', {'Tup', 'ITI'},...
            'OutputActions', {'ValveState', RewardValveState}); % 'SoftCode', soundID
        sma = AddState(sma, 'Name', 'ITI', ...%6
            'Timer', 0,...
            'StateChangeConditions', {'Tup', 'exit'},...
            'OutputActions', {});
        
    else % unlearning and active avoidance
        
        sma = AddState(sma, 'Name', 'TrialStart', ...%1
            'Timer', 2,...
            'StateChangeConditions', {'Tup', 'StimulusDeliver'},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'StimulusDeliver', ...%2
            'Timer', 0,...
            'StateChangeConditions', {'Tup', 'CueDelay'},...
            'OutputActions', {'SoftCode', soundID});
        sma = AddState(sma, 'Name', 'CueDelay', ...%3
            'Timer', S.CueDelay,...
            'StateChangeConditions', {'Tup', 'ResponseW'},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'ResponseW', ...%4
            'Timer', ResponseTime,...
            'StateChangeConditions', {LickPort, LickOutcome, 'Tup', Tup_Action},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'AssistReward', ...%5
            'Timer', RewardDelay(currentTrial),...
            'StateChangeConditions', {'Tup', 'DeliverReward'},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'Reward', ...%6
            'Timer', RewardDelay(currentTrial),...
            'StateChangeConditions', {'Tup', 'DeliverReward'},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'DelayPunishment', ...%7
            'Timer', S.GUI.ResponseTimeNoGoDelay,...
            'StateChangeConditions', {'Tup', 'Punishment'},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'Punishment', ...%8
            'Timer', PunishDelay(currentTrial),...
            'StateChangeConditions', {'Tup', 'DeliverPunishment'},...
            'OutputActions', {});
        sma = AddState(sma, 'Name', 'DeliverReward', ...%9
            'Timer', RewardValveTime,...
            'StateChangeConditions', {'Tup', 'ITI'},...
            'OutputActions', {'ValveState', RewardValveState});
        sma = AddState(sma, 'Name', 'DeliverPunishment', ...%10
            'Timer', S.GUI.PunishAmount,...
            'StateChangeConditions', {'Tup', 'ITI'},...
            'OutputActions', {'ValveState', PunishValveState});
        sma = AddState(sma, 'Name', 'ITI', ...%11
            'Timer', ITI(currentTrial),...
            'StateChangeConditions', {'Tup', 'exit'},...
            'OutputActions', {});
	end
    
	BpodSystem.ProtocolFigures.CurrentTrialStartTime = datenum(datetime)*86400-BpodSystem.ProtocolFigures.StartTime;
    SendStateMatrix(sma);
    RawEvents = RunStateMatrix;
	BpodSystem.Data.CurrentTrialLickTimes = [];
    if ~isempty(fieldnames(RawEvents)) % If trial data was returned
		%disp(RawEvents);
		RE = RawEvents.Events;
        %disp(RE);
		RES = RawEvents.States;
        %disp(RES);
		REST = RawEvents.StateTimestamps(2:end);
		%disp(REST);
		RET = RawEvents.EventTimestamps;
        %disp(RET);
		%Find if any timestamps contain a reward deliver (event 9) and
		%record that as the current trial reward delivery timestamp.
		RESR = (RES==9);
		%disp(RESR);
		BpodSystem.Data.CurrentTrialRewardTime = round(BpodSystem.ProtocolFigures.CurrentTrialStartTime+sum(RESR.*REST));
		%Filter the timestamps for licks (In3Up, 53/30 depending on computer) 
		%and turn them into a list.
		REE = (RE==32);
		BpodSystem.Data.CurrentTrialLickTimes = round(nonzeros(REE.*RET)+BpodSystem.ProtocolFigures.CurrentTrialStartTime);
        %disp(BpodSystem.Data.CurrentTrialLickTimes)
        BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents); % Computes trial events from raw data
        BpodSystem.Data.TrialSettings(currentTrial) = S; % Adds the settings used for the current trial to the Data struct (to be saved after the trial ends)
        BpodSystem.Data.TrialTypes(currentTrial) = TrialTypes(currentTrial); % Adds the trial type of the current trial to data
        BpodSystem.Data.RewardDelay(currentTrial) = RewardDelay(currentTrial);
        BpodSystem.Data.PunishDelay(currentTrial) = PunishDelay(currentTrial);
        BpodSystem.Data.ITI(currentTrial) = ITI(currentTrial);
        
        %Outcome
        if ~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.AssistReward(1))
			BpodSystem.Data.Outcomes(currentTrial) = 3; %Receives reward
		elseif ~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Reward(1))
			BpodSystem.Data.Outcomes(currentTrial) = 1; %Receives reward
        elseif ~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Punishment(1))
            BpodSystem.Data.Outcomes(currentTrial) = 0; %Receives punishement
        elseif TrialTypes(currentTrial)==1
            BpodSystem.Data.Outcomes(currentTrial) = -1; %Ignored go
        else
            BpodSystem.Data.Outcomes(currentTrial) = 2; %Ignored no-go
        end
        
        if S.ReTeaching==1 && S.GUI.TrainingLevel<=2 % full task or running task
            if BpodSystem.Data.Outcomes(currentTrial) == 0
                TrialTypes(currentTrial+1)=0;
            elseif BpodSystem.Data.Outcomes(currentTrial) == -1
                TrialTypes(currentTrial+1)=1;
            end
        end
        
        UpdateTotalRewardDisplay(S.GUI.RewardAmount, currentTrial);
        UpdateGoNoGoOutcomePlot(TrialTypes, BpodSystem.Data);
        SaveBpodSessionData; % Saves the field BpodSystem.Data to the current data file
    end
    HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
    if BpodSystem.Status.BeingUsed == 0
        return
    end
end

function UpdateGoNoGoOutcomePlot(TrialTypes, Data)
global BpodSystem
Outcomes = zeros(1,Data.nTrials);
for x = 1:Data.nTrials
    if ~isnan(Data.RawEvents.Trial{x}.States.AssistReward(1))
        Outcomes(x) = 3;
    elseif ~isnan(Data.RawEvents.Trial{x}.States.Reward(1))
        Outcomes(x) = 1;
    elseif ~isnan(Data.RawEvents.Trial{x}.States.Punishment(1))
        Outcomes(x) = 0;
    elseif BpodSystem.Data.TrialTypes(x)==1
        Outcomes(x) = -1;
    else
        Outcomes(x) = 2;
    end
end
GoNoGoOutcomePlot(BpodSystem.GUIHandles.SideOutcomePlot,'update',Data.nTrials+1,TrialTypes,Outcomes);

function UpdateTotalRewardDisplay(RewardAmount, currentTrial)
% If rewarded based on the state data, update the TotalRewardDisplay
global BpodSystem
    HasReward = 0;
    if (~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.DeliverReward(1)))
        HasReward = 1;
    end
    TotalRewardDisplay('add', RewardAmount*HasReward);
