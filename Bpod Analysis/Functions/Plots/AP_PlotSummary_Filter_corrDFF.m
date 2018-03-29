function AP_PlotSummary_Filter_corrDFF(Analysis,Title,Group,channelnb)

thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-Plot %s %s',char(Analysis.Properties.PhotoCh{channelnb}),Title);

%% Plot Parameters
nboftypes=length(Group);
color4plot={'k';'b';'r';'g';'c';'c';'k'};
AVGPosition=Analysis.Properties.NidaqRange(1)/2;

Title=strrep(Title,'_',' ');
labelx='Time (sec)';   
xTime=[Analysis.Properties.PlotEdges(1) Analysis.Properties.PlotEdges(2)];
xtickvalues=linspace(xTime(1),xTime(2),5);
transparency=Analysis.Properties.Transparency;
LimRanges={[-5 40],[0 10],[-5 100],[-5 20],[-5 50]};
labelyA={'DFF (%)','Licks (Hz)','Run (cm)','Pupil (%)','Run (cm/sec)'};

%% Figure
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
figData.figure=figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

plotIndex=[1 6 NaN NaN];

%% Group plot
k=1;
for i=1:nboftypes
	thistype=Group{i};
if Analysis.(thistype).nTrials~=0
    titleLegend{k}=sprintf('%s (%.0d)',Analysis.(thistype).Name,Analysis.(thistype).nTrials);
% row 1 DFF
    subplot(4,5,1); hold on;
    shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,['-' color4plot{k}],transparency);
    subplot(4,5,2); hold on;
    plot(Analysis.(thistype).(thisChStruct).Outcome,Analysis.(thistype).(thisChStruct).Cue,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
    xlabel('Outcome DFF (%)'); ylabel('Cue DFF (%)');
    set(gca,'XLim',LimRanges{1},'YLim',LimRanges{1});
    subplot(4,5,3); hold on;
    plot(-1,-1,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});    
% row 2 Licks 
    subplot(4,5,6); hold on;
    shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,['-' color4plot{k}],transparency); 
	subplot(4,5,7); hold on;
    title('Outcome DFF vs Cue');
    plot(Analysis.(thistype).(thisChStruct).Outcome,Analysis.(thistype).Licks.Cue,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
    xlabel('Outcome DFF (%)'); ylabel('Cue Licks (Hz)');
    set(gca,'XLim',LimRanges{1},'YLim',LimRanges{2});
	subplot(4,5,8); hold on;
    title('Cue DFF vs Cue');
    plot(Analysis.(thistype).(thisChStruct).Cue,Analysis.(thistype).Licks.Cue,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
    xlabel('Cue DFF (%)'); ylabel('Cue Licks (Hz)');
    set(gca,'XLim',LimRanges{1},'YLim',LimRanges{2});
    subplot(4,5,9); hold on;
    title('Outcome DFF vs Outcome');
    plot(Analysis.(thistype).(thisChStruct).Outcome,Analysis.(thistype).Licks.Outcome,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
    xlabel('Outcome DFF (%)'); ylabel('Outcome Licks (Hz)');
    set(gca,'XLim',LimRanges{1},'YLim',LimRanges{2});
    
% row 3 Running
if Analysis.Properties.Wheel
    plotIndex(3)=11;
    subplot(4,5,11); hold on;
    shadedErrorBar(Analysis.(thistype).Wheel.Time(1,:),Analysis.(thistype).Wheel.DistanceAVG,Analysis.(thistype).Wheel.DistanceSEM,['-' color4plot{k}],transparency);
    subplot(4,5,12); hold on;
	plot(Analysis.(thistype).(thisChStruct).Outcome,Analysis.(thistype).Wheel.Cue,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
    xlabel('Outcome DFF (%)'); ylabel('Cue Run (cm/sec)');
    set(gca,'XLim',LimRanges{1},'YLim',LimRanges{5});   
    subplot(4,5,13); hold on;
	plot(Analysis.(thistype).(thisChStruct).Cue,Analysis.(thistype).Wheel.Cue,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
    xlabel('Cue DFF (%)'); ylabel('Cue Run (cm/sec)');
    set(gca,'XLim',LimRanges{1},'YLim',LimRanges{5});
    subplot(4,5,14); hold on;
 	plot(Analysis.(thistype).(thisChStruct).Outcome,Analysis.(thistype).Wheel.Outcome,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
    xlabel('Outcome DFF (%)'); ylabel('Outcome Run (cm/sec)');
    set(gca,'XLim',LimRanges{1},'YLim',LimRanges{5});
end
% row 4 Pupillometry
if Analysis.Properties.Pupillometry
    
    plotIndex(4)=16;
    subplot(4,5,16); hold on;
	shadedErrorBar(Analysis.(thistype).Pupil.Time(1,:),Analysis.(thistype).Pupil.PupilAVG,Analysis.(thistype).Pupil.PupilSEM,['-' color4plot{k}],transparency);
    subplot(4,5,17); hold on;
    plot(Analysis.(thistype).(thisChStruct).Outcome,Analysis.(thistype).Pupil.Cue,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
    xlabel('Outcome DFF (%)'); ylabel('Cue Pupil (%)');
    set(gca,'XLim',LimRanges{1},'YLim',LimRanges{4});	
    subplot(4,5,18); hold on;
    plot(Analysis.(thistype).(thisChStruct).Cue,Analysis.(thistype).Pupil.Cue,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
    xlabel('Cue DFF (%)'); ylabel('Cue Pupil (%)');
    set(gca,'XLim',LimRanges{1},'YLim',LimRanges{4});
    subplot(4,5,19); hold on;
    plot(Analysis.(thistype).(thisChStruct).Outcome,Analysis.(thistype).Pupil.Outcome,'o','markerSize',5,'MarkerEdgeColor','none','MarkerFaceColor',color4plot{k});
    xlabel('Outcome DFF (%)'); ylabel('Outcome Pupil (%)');
    set(gca,'XLim',LimRanges{1},'YLim',LimRanges{4});
end
k=k+1;
end  
end

LimRanges={[-5 15],[0 10],[-5 100],[-5 20],[-5 50]};
%% Make Plot pretty
for i=1:4
    thisSubPlot=plotIndex(i);
    subplot(4,5,thisSubPlot); hold on;
	ylabel(labelyA{i});
    plot([0 0],LimRanges{i},'-r');
	plot(Analysis.AllData.CueTime(1,:)+Analysis.Properties.CueTimeReset,[AVGPosition AVGPosition],'-b','LineWidth',2);
	plot(Analysis.AllData.OutcomeTime(1,:)+Analysis.Properties.OutcomeTimeReset,[AVGPosition AVGPosition],'-b','LineWidth',2);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',LimRanges{i});
end
subplot(4,5,1); hold on;
title(Title);
subplot(4,5,3); hold on;
set(gca,'XLim',[0 1],'YLim',[0 1]);
legend(titleLegend,'Location','northwest','FontSize',8);
legend('boxoff');
end