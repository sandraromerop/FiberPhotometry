% thisTrial=100;

function A_WheelDecoder(thisTrial,SessionData)
global pupil
%% Extract Data
% Wheel Data
DataCount=SessionData.NidaqWheelData{1,thisTrial};
% Time To Zero
StateToZero='PostOutcome';
TimeToZero=SessionData.RawEvents.Trial{1,thisTrial}.States.(StateToZero)(1,1);
% Time Outcome
StateOutcome='PostOutcome';
TimeOutcome=SessionData.RawEvents.Trial{1,thisTrial}.States.(StateOutcome)-TimeToZero;
% Time Cue
StateCue='CueDelivery';
TimeCue=SessionData.RawEvents.Trial{1,thisTrial}.States.(StateCue)-TimeToZero;
% Licks
Port='Port1In';
try
DataLicks=SessionData.RawEvents.Trial{1, thisTrial}.Events.(Port);
DataLicks=DataLicks-TimeToZero;
catch
    DataLicks=NaN
end
% Photometry
DataPhoto=SessionData.NidaqData{1,thisTrial};

%% Parameters
SamplingRate    = 6100;
DecimateFactor  = 61;
CounterNBits    = 32;
EncoderCPR      = 1024;
newSR           = SamplingRate/DecimateFactor; % 10 msec for decimate=61
deltaT          = 1/newSR;

%% Decoding
signedThreshold = 2^(CounterNBits-1);
signedData = DataCount;
signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^CounterNBits;
DataDeg  = signedData * 360/EncoderCPR;
%DataDeg=smooth(DataDeg,'linear',3);
DataDeg  = decimate(DataDeg,DecimateFactor);
ActualDuration=length(DataDeg)*deltaT-deltaT;

%% Speed
%time array
Time=deltaT:deltaT:ActualDuration;
Time=Time'-TimeToZero;

%speed calculation
speed=diff(DataDeg)/deltaT;
%speedSmooth=smooth(speed);

%% PhotometryData
DataPhoto=decimate(DataPhoto,DecimateFactor);
Fo=mean(DataPhoto(1:newSR*2));
DataPhoto=100*(DataPhoto-Fo)/Fo;

% %% Eyes
% PupilArea=pupil(:,1);
% PupilTime=pupil(:,2)-TimeToZero;
%% Plot Parameters
ScrSze=get(0,'ScreenSize');
FigSze=[ScrSze(3)*0 ScrSze(2)+40 ScrSze(3)*1/3 600];

labelx='Time(sec)'; labely='Angle (deg)'; labely2='DF/F (%)';
minx=-4; maxx=4; xstep=1; xtickvalues=minx:xstep:maxx;

minSp=min(DataDeg); maxSp=max(DataDeg);

MkSze=(maxSp-minSp)/10;

try
    close 'Wheel Position';
end
% Figure
WheelFigure =   figure('Name','Wheel Position','Position',FigSze,'numbertitle','off');
WheelAxes   =   axes();
hold on
yyaxis left
PositionPlot  =   plot(Time,DataDeg(1:length(Time)),'-b');
LimY=get(WheelAxes,'YLim');
% OutcomePlot =   plot(TimeOutcome,LimY,'-g','LineWidth',3);
CuePlot     =   plot(TimeCue,[LimY(2) LimY(2)],'-g','LineWidth',6);
LicksY= ones(length(DataLicks),1)*LimY(2);
LickPlot      =   scatter(DataLicks,LicksY,10,'filled','k','v');

xlabel(labelx);ylabel(labely);
set(WheelAxes,'XLim',[minx maxx],'XTick',xtickvalues,'YLim',LimY);

yyaxis right
PhotoPlot   =   plot(Time,DataPhoto(1:length(Time)),'-r');
% PupilPlot   =   plot(PupilTime,PupilArea,'-k');
ylabel(labely2);



end
