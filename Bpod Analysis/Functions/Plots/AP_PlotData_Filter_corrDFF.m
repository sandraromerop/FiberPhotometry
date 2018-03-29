function AP_PlotData_Filter_corrDFF(Analysis,thistype,channelnb)

if nargin==2
    channelnb=1;
end
thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-PlotSingle %s',char(Analysis.Properties.PhotoCh{channelnb}));

%% Plot Parameters
Title=sprintf('%s (%.0d)',strrep(Analysis.(thistype).Name,'_',' '),Analysis.(thistype).nTrials);
labelx='Time (sec)';   
xTime=[Analysis.Properties.PlotEdges(1) Analysis.Properties.PlotEdges(2)];
xtickvalues=linspace(xTime(1),xTime(2),5);
labelyA={'DFF (%)','Licks (Hz)','Run (cm)','Pupil (%)','Run (cm/sec)','DFF (%)'};
LimRanges={[-5 40], [0 10],     [-5 100],   [-5 20],    [-5 30],        [-5 15]};
labelyB={'Trial # DFF','Trial # Licks','Trial # Run','Trial # Pupi'};
maxtrial=Analysis.(thistype).nTrials;
yraster=1:Analysis.(thistype).nTrials;
transparency=Analysis.Properties.Transparency;
color4plot={'k';'b';'r';'g';'c';'c';'k'};
k=1;
%% Figure
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
figData.figure=figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

%% row 1 DFF
% Raster
subplot(4,5,1); hold on;
title('Raster');
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yraster,Analysis.(thistype).(thisChStruct).DFF,LimRanges{6});
xlabel(labelx);ylabel(labelyB{1});
plot([0 0],[0 maxtrial],'-r');
plot(Analysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
pos=get(gca,'pos');
colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.005 pos(4)]);
% Time
subplot(4,5,2); hold on;
title(Title);
shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,['-' color4plot{k}],transparency);
ylabel(labelyA{1}); xlabel(labelx);
plot([0 0],LimRanges{6},'-r');
plot(Analysis.AllData.CueTime(1,:)+Analysis.Properties.CueTimeReset,[LimRanges{6}(2) LimRanges{6}(2)],'-b','LineWidth',2);
plot(Analysis.AllData.OutcomeTime(1,:)+Analysis.Properties.OutcomeTimeReset,[LimRanges{6}(2) LimRanges{6}(2)],'-b','LineWidth',2);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',LimRanges{6});
% Correlation
subplot(4,5,3); hold on;
title('Correlations');
x=Analysis.(thistype).(thisChStruct).Outcome;y=Analysis.(thistype).(thisChStruct).Cue;
plot(x,y,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
%fit
p=polyfit(x,y,1); f=polyval(p,x); [Rho,Pval]=corr(x,y);
plot(x,f,'-r');
xlabel('Outcome DFF (%)'); ylabel('Cue DFF (%)');
set(gca,'XLim',LimRanges{1},'YLim',LimRanges{1});

%% row 2 Licks 
% Raster
subplot(4,5,6); hold on;
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
plot(Analysis.(thistype).Licks.Events,Analysis.(thistype).Licks.Trials,'sk',...
    'MarkerSize',2,'MarkerFaceColor','k');
plot([0 0],[0 maxtrial],'-r');
plot(Analysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
xlabel(labelx);ylabel(labelyB{2});
% Time
subplot(4,5,7); hold on;
shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,['-' color4plot{k}],transparency); 
ylabel(labelyA{2}); xlabel(labelx);
plot([0 0],LimRanges{2},'-r');
plot(Analysis.AllData.CueTime(1,:)+Analysis.Properties.CueTimeReset,[LimRanges{2}(2) LimRanges{2}(2)],'-b','LineWidth',2);
plot(Analysis.AllData.OutcomeTime(1,:)+Analysis.Properties.OutcomeTimeReset,[LimRanges{2}(2) LimRanges{2}(2)],'-b','LineWidth',2);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',LimRanges{2});
% Correlations
subplot(4,5,8); hold on;
title('Outcome DFF vs Cue');
x=Analysis.(thistype).(thisChStruct).Outcome;y=Analysis.(thistype).Licks.Cue;
plot(x,y,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
%fit
p=polyfit(x,y,1); f=polyval(p,x); [Rho,Pval]=corr(x,y);
plot(x,f,'-r');
xlabel('Outcome DFF (%)'); ylabel('Cue Licks (Hz)');
set(gca,'XLim',LimRanges{1},'YLim',LimRanges{2});

subplot(4,5,9); hold on;
title('Cue DFF vs Cue');
x=Analysis.(thistype).(thisChStruct).Cue;y=Analysis.(thistype).Licks.Cue;
plot(x,y,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
xlabel('Cue DFF (%)'); ylabel('Cue Licks (Hz)');
%fit
p=polyfit(x,y,1); f=polyval(p,x); [Rho,Pval]=corr(x,y);
plot(x,f,'-r');
set(gca,'XLim',LimRanges{1},'YLim',LimRanges{2});

subplot(4,5,10); hold on;
title('Outcome DFF vs Outcome');
x=Analysis.(thistype).(thisChStruct).Outcome;y=Analysis.(thistype).Licks.Outcome;
plot(x,y,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
%fit
p=polyfit(x,y,1); f=polyval(p,x); [Rho,Pval]=corr(x,y);
plot(x,f,'-r');
xlabel('Outcome DFF (%)'); ylabel('Outcome Licks (Hz)');
set(gca,'XLim',LimRanges{1},'YLim',LimRanges{2});

%% row 3 Running
if Analysis.Properties.Wheel
% Raster
subplot(4,5,11); hold on;
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
imagesc(Analysis.(thistype).Wheel.Time(1,:),yraster,Analysis.(thistype).Wheel.Distance,LimRanges{3});
xlabel(labelx);ylabel(labelyB{3});
plot([0 0],[0 maxtrial],'-r');
plot(Analysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
pos=get(gca,'pos');
colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.005 pos(4)]);
% Time
subplot(4,5,12); hold on;
shadedErrorBar(Analysis.(thistype).Wheel.Time(1,:),Analysis.(thistype).Wheel.DistanceAVG,Analysis.(thistype).Wheel.DistanceSEM,['-' color4plot{k}],transparency);
ylabel(labelyA{3}); xlabel(labelx);
plot([0 0],LimRanges{3},'-r');
plot(Analysis.AllData.CueTime(1,:)+Analysis.Properties.CueTimeReset,[LimRanges{3}(2) LimRanges{3}(2)],'-b','LineWidth',2);
plot(Analysis.AllData.OutcomeTime(1,:)+Analysis.Properties.OutcomeTimeReset,[LimRanges{3}(2) LimRanges{3}(2)],'-b','LineWidth',2);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',LimRanges{3});
% Correlation
subplot(4,5,13); hold on;
x=Analysis.(thistype).(thisChStruct).Outcome; y=Analysis.(thistype).Wheel.Cue;
plot(x,y,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
%fit
p=polyfit(x,y,1); f=polyval(p,x); [Rho,Pval]=corr(x,y);
plot(x,f,'-r');
xlabel('Outcome DFF (%)'); ylabel('Cue Run (cm/sec)');
set(gca,'XLim',LimRanges{1},'YLim',LimRanges{5});

subplot(4,5,14); hold on;
x=Analysis.(thistype).(thisChStruct).Cue;y=Analysis.(thistype).Wheel.Cue;
plot(x,y,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
%fit
p=polyfit(x,y,1); f=polyval(p,x); [Rho,Pval]=corr(x,y);
plot(x,f,'-r');
xlabel('Cue DFF (%)'); ylabel('Cue Run (cm/sec)');
set(gca,'XLim',LimRanges{1},'YLim',LimRanges{5});

subplot(4,5,15); hold on;
x=Analysis.(thistype).(thisChStruct).Outcome;y=Analysis.(thistype).Wheel.Outcome;
plot(x,y,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
%fit
p=polyfit(x,y,1); f=polyval(p,x); [Rho,Pval]=corr(x,y);
plot(x,f,'-r');
xlabel('Outcome DFF (%)'); ylabel('Outcome Run (cm/sec)');
set(gca,'XLim',LimRanges{1},'YLim',LimRanges{5});
end
%% row 4 Pupillometry
if Analysis.Properties.Pupillometry
% Raster
subplot(4,5,16); hold on;
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
imagesc(Analysis.(thistype).Pupil.Time(1,:),yraster,Analysis.(thistype).Pupil.PupilDPP,LimRanges{4});
xlabel(labelx);ylabel(labelyB{4});
plot([0 0],[0 maxtrial],'-r');
plot(Analysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
pos=get(gca,'pos');
colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.005 pos(4)]);
% Time
subplot(4,5,17); hold on;
shadedErrorBar(Analysis.(thistype).Pupil.Time(1,:),Analysis.(thistype).Pupil.PupilAVG,Analysis.(thistype).Pupil.PupilSEM,['-' color4plot{k}],transparency);
ylabel(labelyA{4}); xlabel(labelx);
plot([0 0],LimRanges{4},'-r');
plot(Analysis.AllData.CueTime(1,:)+Analysis.Properties.CueTimeReset,[LimRanges{4}(2) LimRanges{4}(2)],'-b','LineWidth',2);
plot(Analysis.AllData.OutcomeTime(1,:)+Analysis.Properties.OutcomeTimeReset,[LimRanges{4}(2) LimRanges{4}(2)],'-b','LineWidth',2);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',LimRanges{4});
% Correlations
subplot(4,5,18); hold on;
x=Analysis.(thistype).(thisChStruct).Outcome;y=Analysis.(thistype).Pupil.Cue;
plot(x,y,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
%fit
p=polyfit(x,y,1); f=polyval(p,x); [Rho,Pval]=corr(x,y);
plot(x,f,'-r');
xlabel('Outcome DFF (%)'); ylabel('Cue Pupil (%)');
set(gca,'XLim',LimRanges{1},'YLim',LimRanges{4});	

subplot(4,5,19); hold on;
x=Analysis.(thistype).(thisChStruct).Cue;y=Analysis.(thistype).Pupil.Cue;
plot(x,y,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
%fit
p=polyfit(x,y,1); f=polyval(p,x); [Rho,Pval]=corr(x,y);
plot(x,f,'-r');
xlabel('Cue DFF (%)'); ylabel('Cue Pupil (%)');
set(gca,'XLim',LimRanges{1},'YLim',LimRanges{4});

subplot(4,5,20); hold on;
x=Analysis.(thistype).(thisChStruct).Outcome;y=Analysis.(thistype).Pupil.Outcome;
plot(x,y,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
%fit
p=polyfit(x,y,1); f=polyval(p,x); [Rho,Pval]=corr(x,y);
plot(x,f,'-r');
xlabel('Outcome DFF (%)'); ylabel('Outcome Pupil (%)');
set(gca,'XLim',LimRanges{1},'YLim',LimRanges{4});
end
end