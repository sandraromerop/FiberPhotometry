    %% Bpod Photometry Launcher
clear SessionData Analysis DefaultParam; close all;
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
DefaultParam.PlotYNidaq=[-15 15];
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
[DefaultParam.FileList,DefaultParam.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
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