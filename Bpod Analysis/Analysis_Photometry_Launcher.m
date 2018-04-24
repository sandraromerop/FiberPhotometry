    %% Bpod Photometry Launcher
clear SessionData Analysis DefaultParam; close all;clear
%% Analysis type Single/Group
DefaultParam.Analysis_type='Group';
DefaultParam.Save=0;
DefaultParam.Load=0;
% Figures
DefaultParam.PlotSummary1=1;
DefaultParam.PlotSummary2=1;
DefaultParam.PlotFiltersSingle=0; %AP_Filter_GroupToPlot #1 Output
DefaultParam.PlotFiltersSummary=0;
DefaultParam.PlotFiltersBehavior=0; %AP_Filter_GroupToPlot #2 Ouput
DefaultParam.Illustrator=0;
DefaultParam.Transparency=1;
% Axis
DefaultParam.PlotYNidaq=[-40 40];
DefaultParam.PlotX=[-4 4];
% States
DefaultParam.CueTimeReset=[0 1];
DefaultParam.OutcomeTimeReset=[0 2]; %  0 -3 for GoNogo - 0 2 for CuedRew
DefaultParam.StateToZero='StateOfOutcome'; %'StateOfCue' 'StateOfOutcome'
DefaultParam.ZeroAtZero=0;
DefaultParam.WheelState='Outcome'; %'Baseline','Cue','Outcome'
DefaultParam.PupilState='Outcome';
% Filters
DefaultParam.PupilThreshold=2;
DefaultParam.WheelThreshold=2; %Speed cm/s
DefaultParam.LicksCue=2;
DefaultParam.LicksOutcome=2;
DefaultParam.TrialToFilterOut=[];
DefaultParam.LoadIgnoredTrials=1;
%% Overwrite Parameters found in AP_Parameters
DefaultParam.Name='VIP';
DefaultParam.Rig='Unknown';
DefaultParam.Behavior='CuedReward';
DefaultParam.Phase='RewardA';
DefaultParam.TrialNames={'T1','T2','T3','T4','T5','T6','T7','T8','T9','T10'};
DefaultParam.LickPort='Port1In';
DefaultParam.StateOfCue='Cue';
DefaultParam.StateOfOutcome='Outcome';
DefaultParam.NidaqBaseline=[1.5 2.5]; %% Absolute time 1.5 2.5
% Photometry
DefaultParam.SamplingRate=6100;  %(Hz)
DefaultParam.NewSamplingRate=20; %(Hz)
%DefaultParam.DecimateFactor=305;
DefaultParam.NidaqDuration=15;
%% Run Analysis_Photometry
%[DefaultParam.FileList,DefaultParam.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
close all

generalDir = 'E:\Data\Photometry\Fred\'
subjects = {'mar012','mar012','mar012','mar012','mar012',...
            'mar012','mar012','mar012','mar012','mar012','mar012','mar012',...
            'mar012','mar012','mar012','mar012','mar012',...
            'mar011','mar011','mar011','mar011','mar011',...
            'mar011','mar011','mar011'};
 sessions = [1,2,3,4,5,1,2,3,1,2,3,1,1,2,1,2,3,4,...
             1,1,1,2,3,1,2,1];
dates = {'Apr17_2018','Apr17_2018','Apr17_2018','Apr17_2018','Apr17_2018',...
         'Apr13_2018','Apr13_2018','Apr13_2018','Apr12_2018','Apr12_2018','Apr12_2018','Apr11_2018',...
         'Apr10_2018','Apr10_2018','Apr09_2018','Apr09_2018','Apr09_2018',...
         'Apr09_2018','Apr10_2018','Apr11_2018','Apr11_2018','Apr11_2018',...
         'Apr12_2018','Apr12_2018','Apr17_2018' };
protocol = 'CuedReward';

for ss=2%length(sessions);
    
    dir = [generalDir subjects{ss} '\' protocol '\Session Data\'];
    DefaultParam.PathName = dir;
    DefaultParam.FileList = [subjects{ss} '_' protocol '_' dates{ss} '_Session' num2str(sessions(ss)) '.mat'];
    if iscell(DefaultParam.FileList)==0
        DefaultParam.FileToOpen=cellstr(DefaultParam.FileList);
        DefaultParam.Analysis_type='Single';
        Analysis=Analysis_Photometry(DefaultParam); 
    else
    switch DefaultParam.Analysis_type
        case 'Single'
             for i=1:length(DefaultParam.FileList)
                DefaultParam.FileToOpen=DefaultParam.FileList(i);
                try
                Analysis=Analysis_Photometry(DefaultParam);
                catch
                disp([DefaultParam.FileToOpen ' NOT ANALYZED']);
                end
                close all;
             end    
        case 'Group'
            DefaultParam.FileToOpen=DefaultParam.FileList;
            Analysis=Analysis_Photometry(DefaultParam);
    end
    end

% Correlate all time points within each standard trial type
idTrials =1:5;
AP_PlotData_DFFvsVelocity(Analysis,DefaultParam,idTrials)
AP_PlotCorr_DFFvsVelocity(Analysis,DefaultParam,idTrials)
AP_PlotSummary_AllSignals(Analysis,DefaultParam,idTrials)
end
%%

