function AP_PlotSummary_filter(Analysis,Title,Group,channelnb)

thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-Plot %s %s',char(Analysis.Properties.PhotoCh{channelnb}),Title);

%% Plot Parameters
nboftypes=length(Group);
color4plot={'-k';'-b';'-r';'-g';'-c';'-c';'-k'};
AVGPosition=Analysis.Properties.NidaqRange(1)/2;

Title=strrep(Title,'_',' ');
labelx='Time (sec)';   
xTime=[Analysis.Properties.PlotEdges(1) Analysis.Properties.PlotEdges(2)];
xtickvalues=linspace(xTime(1),xTime(2),5);
transparency=Analysis.Properties.Transparency;
labely1='Licks Rate (Hz)';
maxrate=10;
labely2='DF/F (%)';
NidaqRange=Analysis.Properties.NidaqRange;

%% Figure
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
figData.figure=figure('Name',FigTitle,'Position', [25 25 scrsz(3)/4 scrsz(4)-150], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

%% Group plot
k=1;
for i=1:nboftypes
	thistype=Group{i};
if Analysis.(thistype).nTrials~=0
    handle.title{k}=sprintf('%s (%.0d)',Analysis.(thistype).Name,Analysis.(thistype).nTrials);
    subplot(2,1,1); hold on;
    hs=shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,color4plot{k},transparency); 
    hp(k)=hs.mainLine;
	subplot(2,1,2); hold on;
    shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{k},transparency);
	k=k+1;
end
end
% Makes Plot pretty
    subplot(2,1,1); hold on;
	ylabel(labely1);
    plot([0 0],[0 maxrate],'-r');
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate]);
	title(Title);
    legend(hp,handle.title,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
    
    subplot(2,1,2); hold on;
	ylabel(labely2);
    xlabel(labelx);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',NidaqRange);
    plot([0 0],NidaqRange,'-r');
	plot(Analysis.AllData.CueTime(1,:)+Analysis.Properties.CueTimeReset,[AVGPosition AVGPosition],'-b','LineWidth',2);
	plot(Analysis.AllData.OutcomeTime(1,:)+Analysis.Properties.OutcomeTimeReset,[AVGPosition AVGPosition],'-b','LineWidth',2);
end