function Analysis=AP_OddBall_Plot(Analysis,channelnb)

%% test channel
thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-Plot %s',char(Analysis.Properties.PhotoCh{channelnb}));

%% Parameters
FigTitle='Oddball';
labelx='Time (sec)';
labely='DF/F(%)';

xEdges=[-0.1 1];
xEdges2=[-0.1 10];
yEdges=Analysis.Properties.NidaqRange;
yEdges2=Analysis.Properties.NidaqRange;
indexplot=0;
color4plot={'-k';'-b';'-r';'-g';'-c';'-c';'-k'};
transparency=Analysis.Properties.Transparency;
Leg={'Early','Late','Odd'};

%% Figure
FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
figData.figure=figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

for i=1:2
thistype=sprintf('type_%.0d',i);
titlePlot1=sprintf('Early to Late - %s',thistype);
%% Early to Late
subplot(2,7,1+indexplot:3+indexplot); hold on;
title(titlePlot1)
xlabel(labelx); ylabel(labely);
set(gca,'XLim',xEdges2,'YLim',yEdges);
plot(Analysis.(thistype).Oddball.(thisChStruct).TimeEarlyToLate,Analysis.(thistype).Oddball.(thisChStruct).PhotoEarlyToLate,'-k');
p=plot(Analysis.(thistype).Oddball.(thisChStruct).TimeEarlyToLate,Analysis.(thistype).Oddball.(thisChStruct).PhotoEarlyToLateAVG,'-r');
p.LineWidth=2;

plot([0:1:xEdges2(2)],(ones(xEdges(2),1).*yEdges(2)),'v','MarkerSize',5,'MarkerFaceColor','b','MarkerEdgeColor','none');

%% Early
subplot(2,7,4+indexplot); hold on;
xlabel(labelx); ylabel(labely);
set(gca,'XLim',xEdges,'XTick',[0 0.5 1],'YLim',yEdges);
title('Early Sound');
plot(Analysis.(thistype).Oddball.(thisChStruct).TimeEarly,Analysis.(thistype).Oddball.(thisChStruct).PhotoEarly,'-k');
p=plot(Analysis.(thistype).Oddball.(thisChStruct).TimeEarly,Analysis.(thistype).Oddball.(thisChStruct).PhotoEarlyAVG,'-b');
p.LineWidth=2;

%% Late
subplot(2,7,5+indexplot); hold on;
xlabel(labelx);
set(gca,'XLim',xEdges,'XTick',[0 0.5 1],'YLim',yEdges);
title('Late Sound');
plot(Analysis.(thistype).Oddball.(thisChStruct).TimeLate,Analysis.(thistype).Oddball.(thisChStruct).PhotoLate,'-k');
p=plot(Analysis.(thistype).Oddball.(thisChStruct).TimeLate,Analysis.(thistype).Oddball.(thisChStruct).PhotoLateAVG,'-g');
p.LineWidth=2;

%% Odd
subplot(2,7,6+indexplot);
xlabel(labelx);
set(gca,'XLim',xEdges,'XTick',[0 0.5 1],'YLim',yEdges);
title('Odd Sound'); hold on;
plot(Analysis.(thistype).Oddball.(thisChStruct).TimeOdd,Analysis.(thistype).Oddball.(thisChStruct).PhotoOdd,'-k');
p=plot(Analysis.(thistype).Oddball.(thisChStruct).TimeOdd,Analysis.(thistype).Oddball.(thisChStruct).PhotoOddAVG,'-r');
p.LineWidth=2;

%% Overlay
subplot(2,7,7+indexplot);
xlabel(labelx);
set(gca,'XLim',xEdges,'XTick',[0 0.5 1],'YLim',yEdges2);
title('Overlay'); hold on;
hs=shadedErrorBar(Analysis.(thistype).Oddball.(thisChStruct).TimeEarly,Analysis.(thistype).Oddball.(thisChStruct).PhotoEarlyAVG,Analysis.(thistype).Oddball.(thisChStruct).PhotoEarlySEM,'b',transparency);
hp(1)=hs.mainLine;
hs=shadedErrorBar(Analysis.(thistype).Oddball.(thisChStruct).TimeLate,Analysis.(thistype).Oddball.(thisChStruct).PhotoLateAVG,Analysis.(thistype).Oddball.(thisChStruct).PhotoLateSEM,'g',transparency);
hp(2)=hs.mainLine;
hs=shadedErrorBar(Analysis.(thistype).Oddball.(thisChStruct).TimeOdd,Analysis.(thistype).Oddball.(thisChStruct).PhotoOddAVG,Analysis.(thistype).Oddball.(thisChStruct).PhotoOddSEM,'r',transparency);
hp(3)=hs.mainLine;
legend(hp,Leg,'Location','northwest','FontSize',8);
legend('boxoff');
clear hp hs;

indexplot=indexplot+7;
end

end