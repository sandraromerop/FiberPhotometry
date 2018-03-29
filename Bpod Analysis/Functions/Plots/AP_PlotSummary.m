function AP_PlotSummary(Analysis,channelnb,varargin)

thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-Plot Summary %s',char(Analysis.Properties.PhotoCh{channelnb}));

%% Plot Parameters
nbofgroups=nargin-2;
color4plot={'-k';'-b';'-r';'-g';'-c';'-c';'-k'};
AVGPosition=Analysis.Properties.NidaqRange(1)/2;
for i=1:nbofgroups
    thisgroup=sprintf('thisgroup_%.0d',i);
	GP.(thisgroup).types=cell2mat(varargin(i));
    if ischar(GP.(thisgroup).types)
        GP.(thisgroup).types=A_NameToTrialNumber(Analysis,GP.(thisgroup).types);
    end
    k=1;
    for j=GP.(thisgroup).types 
        GP.(thisgroup).title(k)=Analysis.Properties.TrialNames(j);
        k=k+1;
    end
end

labelx='Time (sec)';   
xTime=[Analysis.Properties.PlotEdges(1) Analysis.Properties.PlotEdges(2)];
transparency=Analysis.Properties.Transparency;
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Licks Rate (Hz)';
maxrate=10;
labely2='DF/F (%)';
NidaqRange=Analysis.Properties.NidaqRange;

%% Table Parameters
TableTitles={'Trial Type','Cue Max DF/F(%)','Cue AVG DF/F(%)','SEM','Outcome Max DF/F(%)','Outcome AVG DF/F(%)','SEM','nb of trials','ignored trials'};
for i=1:Analysis.Properties.nbOfTrialTypes
    thistype        =   sprintf('type_%.0d',i);
    TableData{i,1}	=   Analysis.(thistype).Name;
    TableData{i,2}	=   Analysis.(thistype).(thisChStruct).CueMax;
    TableData{i,3}	=   Analysis.(thistype).(thisChStruct).CueAVG;
    TableData{i,4}	=   Analysis.(thistype).(thisChStruct).CueSEM;
    TableData{i,5}	=   Analysis.(thistype).(thisChStruct).OutcomeMax;
    TableData{i,6} =    Analysis.(thistype).(thisChStruct).OutcomeAVG;
    TableData{i,7} =    Analysis.(thistype).(thisChStruct).OutcomeSEM;
    TableData{i,8} =    Analysis.(thistype).nTrials;
    TableData{i,9} =    Analysis.(thistype).IgnoredTrials;
end

%% Figure
FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
figData.figure=figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

%% Table
spt=subplot(3,4,[9 11]);
pos=get(spt,'position');
delete(spt);

TypeWidth=100;
NbWidth=(pos(3)-TypeWidth)/(length(TableTitles)-1);
TableColumnWidth{1}=TypeWidth;
for i=2:length(TableTitles)
    TableColumnWidth{i}=70;
end

t=uitable('ColumnWidth',TableColumnWidth,'Data',TableData,'ColumnName',TableTitles);
set(t,'units','normalized');
set(t,'position',pos);

%% Bleach plot
subplot(3,4,12);
plot(Analysis.AllData.(thisChStruct).Bleach,'-k');
title('Bleaching')
xlabel('Trial Nb');
ylabel('Normalized Fluo');

%% Group plot
for i=1:nbofgroups
	thisgroup=sprintf('thisgroup_%.0d',i);
% Population of the plots
    k=1;
    for j=GP.(thisgroup).types
        thistype=sprintf('type_%.0d',j);
        subplot(3,4,i); hold on;
        hs=shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,color4plot{k},transparency); 
        hp(k)=hs.mainLine;
        subplot(3,4,i+4); hold on;
        shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{k},transparency);
        k=k+1;
    end
% Makes Plot pretty
    subplot(3,4,i); hold on;
	if i==1
        ylabel(labely1);
    end
    plot([0 0],[0 maxrate],'-r');
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate]);
    title(num2str(GP.(thisgroup).types));
	legend(hp,GP.(thisgroup).title,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;

    subplot(3,4,i+4); hold on;
    if i==1
        ylabel(labely2);
    end
    xlabel(labelx);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',NidaqRange);
    plot([0 0],NidaqRange,'-r');
	plot(Analysis.AllData.CueTime(1,:)+Analysis.Properties.CueTimeReset,[AVGPosition AVGPosition],'-b','LineWidth',2);
	plot(Analysis.AllData.OutcomeTime(1,:)+Analysis.Properties.OutcomeTimeReset,[AVGPosition AVGPosition],'-b','LineWidth',2);
end
end