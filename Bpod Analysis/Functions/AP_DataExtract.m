function [LickData, Photo, Wheel]=AP_DataExtract(SessionData,Analysis,thisTrial)
%AP_DataExtract extracts licks timestamp, raw and normalized photometry value together with
%a time array of the trial 'thistrial' from the 'sessiondata' file. This
%function is using the parameters contained in the 'Analysis' structure
%
%function designed by Quentin 2016 for Analysis_Photometry

%% Timing parameters
StateToZero=Analysis.Properties.StateToZero;
TimeToZero=SessionData.RawEvents.Trial{1,thisTrial}.States.(StateToZero)(1);    

%% Licks
LickPort=Analysis.Properties.LickPort;
try
    LickData=SessionData.RawEvents.Trial{1,thisTrial}.Events.(LickPort);
    LickData=LickData-TimeToZero;
catch
    LickData=NaN;  
end

%% Nidaq
if Analysis.Properties.Photometry==1
% Parameters  
SampRate=Analysis.Properties.NidaqSamplingRate;
SampRateSR=Analysis.Properties.NidaqDecimatedSR;
DecimateFactor=Analysis.Properties.NidaqDecimateFactor;
Baseline=Analysis.Properties.NidaqBaselinePoints;         %points with decimated SR
Duration=Analysis.Properties.NidaqDuration;

% Expeced Data set
ExpectedSize=Duration*SampRateSR;
Time=linspace(0,Duration,ExpectedSize);
Time=Time-TimeToZero;

% Data
Photo=cell(length(Analysis.Properties.PhotoCh),1);
for thisCh=1:length(Analysis.Properties.PhotoCh)
    Data=NaN(ExpectedSize,1);
    if Analysis.Properties.Modulation
        thisNidaqField=char(Analysis.Properties.PhotoField{thisCh});
        thisAmp=SessionData.TrialSettings(thisTrial).GUI.(char(Analysis.Properties.PhotoAmpField{thisCh}));
        if thisAmp~=0
        thisFreq=SessionData.TrialSettings(thisTrial).GUI.(char(Analysis.Properties.PhotoFreqField{thisCh}));
        switch Analysis.Properties.recordedMod
            case 0
                thisModulation=AP_Modulation(Analysis,thisAmp,thisFreq);
            case 1
                thisModulation=SessionData.(thisNidaqField){1,thisTrial}(:,Analysis.Properties.PhotoModulData(thisCh));
        end
        thisData=AP_Demodulation(SessionData.(thisNidaqField){1,thisTrial}(:,1),thisModulation,SampRate,thisAmp,thisFreq,15);
        thisData=decimate(thisData,DecimateFactor);
        else    % Amplitude=0 for this channel for this trial
            thisData=Data;
        end
    else        % no modulation of this channel for this trial
        thisData=decimate(SessionData.NidaqData{1,thisTrial}(:,1),DecimateFactor);
    end
    if length(thisData)>ExpectedSize
        Data=thisData(1:length(Data));
    else
        Data(1:length(thisData))=thisData;
    end
% DFF and zero
    DFFBaseline=mean(Data(Baseline(1):Baseline(2)));
    DFF=(Data'-DFFBaseline)/DFFBaseline;
    if Analysis.Properties.ZeroAtZero
        DFF=DFF-mean(DFF(Time>-0.01 & Time<0.01));
    end
    Photo{thisCh}(1,:)=Time;
    Photo{thisCh}(2,:)=Data';
    Photo{thisCh}(3,:)=100*DFF;
end  
    else
        Photo=[];
end

%% Wheel
if Analysis.Properties.Wheel==1
% Timimg parameters 
    if Analysis.Properties.Photometry==0
SampRateSR=Analysis.Properties.NidaqDecimatedSR;
DecimateFactor=Analysis.Properties.NidaqDecimateFactor;
Duration=Analysis.Properties.NidaqDuration;
ExpectedSize=Duration*SampRateSR;
Time=linspace(0,Duration,ExpectedSize);
Time=Time-TimeToZero;
    end
DTsec=0.01; % in sec
DTpoints=SampRateSR*DTsec;

% Expected Data set   
DataWheel=NaN(ExpectedSize,1);
% Data
signedData = SessionData.NidaqWheelData{1,thisTrial};
signedThreshold = 2^(Analysis.Properties.WheelCounterNbits-1);
signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^Analysis.Properties.WheelCounterNbits;
DataDeg  = signedData * 360/Analysis.Properties.WheelEncoderCPR;
DataDeg  = decimate(DataDeg,DecimateFactor);
DataWheel(1:length(DataDeg))=DataDeg;
DataWheelDistance=DataWheel.*(Analysis.Properties.WheelPolarity*Analysis.Properties.WheelDiameter*pi/360);

Wheel(1,:)=Time;
Wheel(2,:)=DataWheel;
Wheel(3,:)=DataWheelDistance;

else
    Wheel=[];
end
end