function [handles,DefaultParam]=AP_Parameters(SessionData,Pup,DefaultParam,Name)

%% Nidaq Fields
handles.PhotometryField='NidaqData';
handles.Photometry2Field='Nidaq2Data';
handles.WheelField='NidaqWheelData';

%% General
% Animal Name
USindex=strfind(Name,'_');
if isempty(USindex)==0
    handles.Animal=Name(1:USindex(1)-1);
else
    handles.Animal=DefaultParam.Name;
end
switch DefaultParam.Analysis_type
    case 'Group'
handles.Name=handles.Animal;
    otherwise
handles.Name=Name;
end
% Rig Name
try
    handles.Rig=SessionData.TrialSettings(1).Names.Rig;
catch
    handles.Rig=DefaultParam.Rig;
end
% Plots
handles.PlotSummary1=DefaultParam.PlotSummary1;
handles.PlotSummary2=DefaultParam.PlotSummary2;
handles.PlotFiltersSingle=DefaultParam.PlotFiltersSingle;
handles.PlotFiltersSummary=DefaultParam.PlotFiltersSummary; 
handles.PlotFiltersBehavior=DefaultParam.PlotFiltersBehavior;
handles.Illustrator=DefaultParam.Illustrator;
handles.Transparency=DefaultParam.Transparency;
% Behavior specific : Plots and States
if contains(Name,'CuedReward','IgnoreCase',true)
    handles.Behavior='CuedReward';
	handles.StateOfCue='SoundDelivery';
    handles.StateOfOutcome='Outcome';
elseif contains(Name,'GoNogo','IgnoreCase',true)
    handles.Behavior='GoNogo';
	handles.StateOfCue='CueDelivery';
    handles.StateOfOutcome='PostOutcome';
elseif contains(Name,'AuditoryTuning','IgnoreCase',true)
    handles.Behavior='AuditoryTuning';
	handles.StateOfCue='CueDelivery';
    handles.StateOfOutcome='CueDelivery';
    handles.PlotSummary1=0;
    handles.PlotSummary2=0;
    handles.PlotFiltersSingle=0;
    handles.PlotFiltersSummary=0; 
    handles.PlotFiltersBehavior=0;
elseif contains(Name,'Oddball','IgnoreCase',true)
    handles.Behavior='Oddball';
	handles.StateOfCue='PreState';
    handles.StateOfOutcome='PreState';
    handles.PlotSummary1=0;
    handles.PlotSummary2=0;
    handles.PlotFiltersSingle=0;
    handles.PlotFiltersSummary=0;
    handles.PlotFiltersBehavior=0;
else
    handles.Behavior=DefaultParam.Behavior;
	handles.StateOfCue=DefaultParam.StateOfCue;
	handles.StateOfOutcome=DefaultParam.StateOfOutcome; 
    if isempty(handles.StateOfCue) || isempty(handles.StateOfOutcome)
        disp('State names for cue and outcome delivery (or other type of states)...') ;
        disp('need to be defined in the launcher (or directly in AP_Parameters function)');
        return
    end
end
% Phase
try
    handles.Phase=SessionData.TrialSettings(1).Names.Phase{SessionData.TrialSettings(1).GUI.Phase};
catch
    handles.Phase=DefaultParam.Phase;
end
% Trial types and Names
handles.nTrials=SessionData.nTrials;
handles.nbOfTrialTypes=max(SessionData.TrialTypes);
if isfield(SessionData.TrialSettings(1),'TrialsNames')
    handles.TrialNames=SessionData.TrialSettings(1).TrialsNames;
else
if isfield(SessionData.TrialSettings(1),'TirlasNames')
    handles.TrialNames=SessionData.TrialSettings(1).TirlasNames;
else
    handles.TrialNames=DefaultParam.TrialNames;
end
end
%% Timing
handles.StateToZero     =handles.(DefaultParam.StateToZero);
ZeroTime                =SessionData.RawEvents.Trial{1,1}.States.(handles.StateToZero)(1);
handles.CueTime         =SessionData.RawEvents.Trial{1,1}.States.(handles.StateOfCue)-ZeroTime;
handles.OutcomeTime     =SessionData.RawEvents.Trial{1,1}.States.(handles.StateOfOutcome)-ZeroTime;
handles.CueTimeReset    =DefaultParam.CueTimeReset;
handles.OutcomeTimeReset=DefaultParam.OutcomeTimeReset;

%% Licks
if isfield(SessionData.RawEvents.Trial{1, 1}.Events,'Port1In')
    handles.LickPort='Port1In';
elseif isfield(SessionData.RawEvents.Trial{1, 1}.Events,'Port2In')
    handles.LickPort='Port2In';
else
    handles.LickPort=DefaultParam.LickPort;
end
handles.LicksCue=DefaultParam.LicksCue;
handles.LicksOutcome=DefaultParam.LicksOutcome;
handles.LickEdges=DefaultParam.PlotX;
handles.Bin=0.25;

%% Photometry
% Plots
handles.PlotEdges=DefaultParam.PlotX;
handles.NidaqRange=DefaultParam.PlotYNidaq;
% Processing

if isfield(SessionData.TrialSettings(1).GUI,'NidaqSamplingRate')
    handles.NidaqSamplingRate=SessionData.TrialSettings(1).GUI.NidaqSamplingRate;
else
    handles.NidaqSamplingRate=DefaultParam.SamplingRate;
end
handles.NidaqDecimatedSR=DefaultParam.NewSamplingRate;
handles.NidaqDecimateFactor=handles.NidaqSamplingRate/handles.NidaqDecimatedSR;
%handles.NidaqDecimateFactor=DefaultParam.DecimateFactor;
%handles.NidaqDecimatedSR=handles.NidaqSamplingRate/handles.NidaqDecimateFactor;

switch DefaultParam.Analysis_type
    case 'Group'
handles.NidaqDuration=DefaultParam.NidaqDuration;
    otherwise
if isfield(SessionData.TrialSettings(1).GUI,'NidaqDuration')
	handles.NidaqDuration=SessionData.TrialSettings(1).GUI.NidaqDuration;
else
    handles.NidaqDuration=DefaultParam.NidaqDuration;
end
end
% Timing
handles.NidaqBaseline=DefaultParam.NidaqBaseline;
handles.NidaqBaselinePoints=handles.NidaqBaseline*handles.NidaqDecimatedSR;
if handles.NidaqBaselinePoints(1)==0
    handles.NidaqBaselinePoints(1)=1;
end
handles.ZeroAtZero=DefaultParam.ZeroAtZero;
% Data structure, Modulation, 405 etc...
if isfield(SessionData,handles.PhotometryField)
    handles.Photometry=1;
% First Channel
    handles.PhotoCh={'470'};
    handles.PhotoField={handles.PhotometryField};
    handles.PhotoAmpField={'LED1_Amp'};
    handles.PhotoFreqField={'LED1_Freq'};
	handles.Modulation=1;
	handles.recordedMod=1;
	handles.PhotoModulData=2;
% test if Laser/Lock-in Amplifier (old bpod/photometry)  
if isfield(SessionData.TrialSettings(1).GUI,'Photometry')==0   %% kinda test version of bpod protocol, if not laser/lockin
    handles.Modulation=0;
else
    if SessionData.TrialSettings(1).GUI.LED1_Amp==0
            handles.Modulation=0;
        else
            switch size(SessionData.NidaqData{1,1},2)
                case 1                                      %% LED commads not recorded
                    handles.recordedMod=0;
                case 2
                    if max(SessionData.(handles.PhotometryField){1,1}(:,2))<0.9*SessionData.TrialSettings(1).GUI.LED1_Amp
                            handles.Modulation=0;
                    end
            end
    end
end
% 405    
    if isfield(SessionData.TrialSettings(1).GUI,'LED2_Amp') % can be absent in some early version of Bpod parameters
        if SessionData.TrialSettings(1).GUI.LED2_Amp~=0
            handles.PhotoCh{length(handles.PhotoCh)+1}={'405'};
            handles.PhotoField{length(handles.PhotoField)+1}={handles.PhotometryField};
            handles.PhotoAmpField{length(handles.PhotoAmpField)+1}={'LED2_Amp'};
            handles.PhotoFreqField{length(handles.PhotoFreqField)+1}={'LED2_Freq'};
            handles.PhotoModulData=[handles.PhotoModulData 3];
            handles.Modulation=1;
            handles.recordedMod=1;
        end
    end
% Dual Fibers / PhotoDetet
    if isfield(SessionData,handles.Photometry2Field)
        handles.PhotoCh{length(handles.PhotoCh)+1}={'470b'};
        handles.PhotoField{length(handles.PhotoField)+1}={handles.Photometry2Field};
        handles.PhotoAmpField{length(handles.PhotoAmpField)+1}={'LED1b_Amp'};
        handles.PhotoFreqField{length(handles.PhotoFreqField)+1}={'LED1b_Freq'};
        handles.PhotoModulData=[handles.PhotoModulData 2];
        handles.Modulation=1;
        handles.recordedMod=1;
    end
else % No Photometry field
	handles.Photometry=0;
    handles.PhotoCh={};
end
%% Wheel 
handles.Wheel=0;
handles.WheelCounterNbits=32;
handles.WheelEncoderCPR=1024;
handles.WheelThreshold=DefaultParam.WheelThreshold;
handles.WheelState=DefaultParam.WheelState;
handles.WheelDiameter=14; %cm
handles.WheelPolarity=-1;
if isfield(SessionData,handles.WheelField)
    handles.Wheel=1;
end
%% Pupillometry
handles.Pupillometry=0;
handles.PupilThreshold=DefaultParam.PupilThreshold;
handles.PupilState=DefaultParam.PupilState;
if ~isempty(Pup)
    if handles.nTrials==Pup.Parameters.nTrials
                handles.Pupillometry=1;
                handles.Pupillometry_Parameters=Pup.Parameters;    
    else
        disp('not the same number of trials analyzed for Bpod and for pupillometry');
        
    end
    handles.nTrials=SessionData.nTrials;
end
end  