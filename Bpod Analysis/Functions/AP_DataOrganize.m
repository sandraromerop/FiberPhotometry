function Analysis=AP_DataOrganize(Analysis,SessionData,Pup)
%AP_OrganizeData extracts, reorganizes and generates different dataset
%from the bpod file 'SessionData'. The structure generated contains:
%1) The properties of the trial succesfully analyzed (number and types)
%2) The timing of the cue and the outcome to the 'StateToZero' time
%3) The lick timestamps and the lickrates
%4) The photometry values (raw and normalized)
%
%function designed by Quentin 2016 for Analysis_Photometry
if isfield(Analysis,'AllData')==0
        Analysis.AllData.nTrials=0;
        Analysis.AllData.IgnoredTrials=0;
end
BaselineTime=Analysis.Properties.NidaqBaseline;
BaselinePt=Analysis.Properties.NidaqBaselinePoints;

%% Recompute Pupil Baseline according to this Baseline
if Analysis.Properties.Pupillometry
    Pup.PupilSmoothBaseline=mean(Pup.PupilSmooth(Pup.Time>BaselineTime(1) & Pup.Time<BaselineTime(2),:));
    Pup.PupilSmoothBaselineNorm=Pup.PupilSmoothBaseline/mean(Pup.PupilSmoothBaseline);
    Pup.PupilSmoothDPP=100*(Pup.PupilSmooth-Pup.PupilSmoothBaseline)./Pup.PupilSmoothBaseline;
end

%% Extract and organize data 
for thisTrial=1:SessionData.nTrials
try
    if Analysis.Filters.ignoredTrials(thisTrial)==1
    [thislick,thisPhoto,thisWheel]=AP_DataExtract(SessionData,Analysis,thisTrial);
    i=Analysis.AllData.nTrials+1;
    Analysis.AllData.nTrials=i;
    Analysis.AllData.TrialNumbers(i)=i;
    Analysis.AllData.TrialTypes(i)=SessionData.TrialTypes(thisTrial);
% Timimg
    Analysis.AllData.States{i}          =SessionData.RawEvents.Trial{1,thisTrial}.States;
    Analysis.AllData.ZeroTime(i)        =SessionData.RawEvents.Trial{1,thisTrial}.States.(Analysis.Properties.StateToZero)(1);
    Analysis.AllData.CueTime(i,:)       =SessionData.RawEvents.Trial{1,thisTrial}.States.(Analysis.Properties.StateOfCue)...
                                            -Analysis.AllData.ZeroTime(i);
    Analysis.AllData.OutcomeTime(i,:)   =SessionData.RawEvents.Trial{1,thisTrial}.States.(Analysis.Properties.StateOfOutcome)...
                                            -Analysis.AllData.ZeroTime(i);
    CueTime     =Analysis.AllData.CueTime(i,:)+Analysis.Properties.CueTimeReset;
    OutcomeTime =Analysis.AllData.OutcomeTime(i,:)+Analysis.Properties.OutcomeTimeReset;
% Licks                                    
    Analysis.AllData.Licks.Events{i}                =thislick;
    Analysis.AllData.Licks.Trials{i}                =linspace(i,i,size(thislick,2));
    Analysis.AllData.Licks.Bin{i}                   =(Analysis.Properties.LickEdges(1):Analysis.Properties.Bin:Analysis.Properties.LickEdges(2));
    Analysis.AllData.Licks.Rate(i,:)                =histcounts(thislick,Analysis.AllData.Licks.Bin{i})/Analysis.Properties.Bin;
    Analysis.AllData.Licks.Cue(i)                   =mean(Analysis.AllData.Licks.Rate(i,Analysis.AllData.Licks.Bin{i}>CueTime(1) & Analysis.AllData.Licks.Bin{i}<CueTime(2)));
    Analysis.AllData.Licks.Outcome(i)               =mean(Analysis.AllData.Licks.Rate(i,Analysis.AllData.Licks.Bin{i}>OutcomeTime(1) & Analysis.AllData.Licks.Bin{i}<OutcomeTime(2)));
% Photometry    
    for thisCh=1:length(Analysis.Properties.PhotoCh)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{thisCh}));
        Analysis.AllData.(thisChStruct).Time(i,:)	=thisPhoto{thisCh}(1,:);
        Analysis.AllData.(thisChStruct).Raw(i,:)  	=thisPhoto{thisCh}(2,:);
        Analysis.AllData.(thisChStruct).DFF(i,:)  	=thisPhoto{thisCh}(3,:);
        Analysis.AllData.(thisChStruct).Baseline(i)	=mean(thisPhoto{thisCh}(2,BaselinePt(1):BaselinePt(2)));
        Analysis.AllData.(thisChStruct).Cue(i)     	=max(thisPhoto{thisCh}(3,thisPhoto{thisCh}(1,:)>CueTime(1) & thisPhoto{thisCh}(1,:)<CueTime(2)));
        Analysis.AllData.(thisChStruct).Outcome(i)	=max(thisPhoto{thisCh}(3,thisPhoto{thisCh}(1,:)>OutcomeTime(1) & thisPhoto{thisCh}(1,:)<OutcomeTime(2)));
        Analysis.AllData.(thisChStruct).OutcomeZ(i) =Analysis.AllData.(thisChStruct).Outcome(i)-mean(thisPhoto{thisCh}(3,thisPhoto{thisCh}(1,:)>-0.01 & thisPhoto{thisCh}(1,:)<0.01));
    end
% Wheel    
    if Analysis.Properties.Wheel==1
        Analysis.AllData.Wheel.Time(i,:)          	=thisWheel(1,:);
        Analysis.AllData.Wheel.Deg(i,:)          	=thisWheel(2,:);
        Analysis.AllData.Wheel.Distance(i,:)       	=thisWheel(3,:);
        Analysis.AllData.Wheel.Baseline(i)        	=sumabs(diff(thisWheel(3,BaselinePt(1):BaselinePt(2))));
        Analysis.AllData.Wheel.Cue(i)             	=sumabs(diff(thisWheel(3,thisWheel(1,:)>CueTime(1) & thisWheel(1,:)<CueTime(2))))/(CueTime(2)-CueTime(1));
        Analysis.AllData.Wheel.Outcome(i)           =sumabs(diff(thisWheel(3,thisWheel(1,:)>OutcomeTime(1) & thisWheel(1,:)<OutcomeTime(2))))/(OutcomeTime(2)-OutcomeTime(1));
    end
% Pupillometry
    if Analysis.Properties.Pupillometry
        thisPupTime=Pup.Time(1:300)'-Analysis.AllData.ZeroTime(i);
        thisPupilDPP=Pup.PupilSmoothDPP(1:300,thisTrial)';
        if Analysis.Properties.ZeroAtZero
            thisPupilDPP=thisPupilDPP-mean(thisPupilDPP(thisPupTime>-0.01 & thisPupTime<0.01));
        end
        % Organize in the structure
        Analysis.AllData.Pupil.Time(i,:)            =thisPupTime;
        Analysis.AllData.Pupil.Pupil(i,:)           =Pup.Pupil(1:300,thisTrial)';
        Analysis.AllData.Pupil.PupilDPP(i,:)        =thisPupilDPP;
        Analysis.AllData.Pupil.Blink(i,:)           =Pup.Blink(:,thisTrial)';
        Analysis.AllData.Pupil.Baseline(i)          =Pup.PupilSmoothBaseline(thisTrial);
        Analysis.AllData.Pupil.NormBaseline(i)      =Pup.PupilSmoothBaselineNorm(thisTrial);
        Analysis.AllData.Pupil.Cue(i)               =nanmean(thisPupilDPP(thisPupTime>CueTime(1) & thisPupTime<CueTime(2)));
        Analysis.AllData.Pupil.Outcome(i)           =nanmean(thisPupilDPP(thisPupTime>OutcomeTime(1) & thisPupTime<OutcomeTime(2)));
    end
    else
        Analysis.AllData.IgnoredTrials=Analysis.AllData.IgnoredTrials+1;
    end
% Behavior Specific
switch Analysis.Properties.Behavior
    case 'Oddball'
    Analysis.AllData.Oddball_StateSeq{i}=SessionData.TrialSettings(thisTrial).StateSequence;
    Analysis.AllData.Oddball_SoundSeq{i}=SessionData.TrialSettings(thisTrial).SoundSequence;
    Analysis.Properties.Oddball_SoundITI=SessionData.TrialSettings(1).GUI.ITI;
end  
% Ignored Trials
catch
        Analysis.Filters.IgnoredTrials(thisTrial)=0;
        Analysis.AllData.IgnoredTrials=Analysis.AllData.IgnoredTrials+1;
end
end

for thisCh=1:length(Analysis.Properties.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{thisCh}));
    Analysis.AllData.(thisChStruct).Bleach=Analysis.AllData.(thisChStruct).Baseline/mean(Analysis.AllData.(thisChStruct).Baseline(1:2));
    Analysis.Properties.NidaqSTD=std2(Analysis.AllData.(thisChStruct).DFF(:,BaselinePt(1):BaselinePt(2)));
end 
end