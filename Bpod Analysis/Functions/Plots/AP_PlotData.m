function Analysis=AP_PlotData(Analysis,channelnb)
%AP_PlotData generates a figure from the licks and 405 photometry data
%contained in the structure 'Analysis'. The figure shows for each trial types: 
%1) a raster plot of the licks events 
%2) the average lick rate
%3) a pseudocolored raster plot of the individual photometry traces
%4) the average photometry signal
%To plot the different graph, this function is using the parameters
%specified in Analysis.Properties
%
%function designed by Quentin 2016 for Analysis_Photometry

%% test for channels
if Analysis.Properties.Photometry==1
    if nargin==1
        channelnb=1;
    end
        thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{channelnb}));
        FigTitle=sprintf('Analysis-Plot %s',char(Analysis.Properties.PhotoCh{channelnb}));
    else
    FigTitle='Analysis-Plot';
end

%% Plot Parameters
labelx='Time (sec)';   
xTime=[Analysis.Properties.PlotEdges(1) Analysis.Properties.PlotEdges(2)];
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Trial Number (licks)';
labely2='Licks Rate (Hz)';
if Analysis.Properties.Photometry==1
    labely3='Trial Number (DF/F)';
    labely4='DF/F (%)';
end
nbOfTrialTypes=Analysis.Properties.nbOfTrialTypes;
if nbOfTrialTypes>6
    nbOfPlots=nbOfTrialTypes;
else
    nbOfPlots=6;
end

% Automatic definition of axes
maxtrial=0; maxrate=10;
for i=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
%Raster plots y axes
    if Analysis.(thistype).nTrials > maxtrial
        maxtrial=Analysis.(thistype).nTrials;
    end
%Lick AVG y axes
    if max(Analysis.(thistype).Licks.AVG)>maxrate
        maxrate=max(Analysis.(thistype).Licks.AVG);
    end
end

if Analysis.Properties.Photometry==1
%Nidaq y axes
if isempty(Analysis.Properties.NidaqRange)
        NidaqRange=[0-6*Analysis.Properties.NidaqSTD 6*Analysis.Properties.NidaqSTD];
        Analysis.Properties.NidaqRange=NidaqRange;
else
    NidaqRange=Analysis.Properties.NidaqRange;
end
end

%% Plot
FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
figData.figure=figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

thisplot=1;
for i=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
% Lick Raster
    subplot(6,nbOfPlots,[thisplot thisplot+nbOfPlots]); hold on;
    title(Analysis.(thistype).Name);
    if thisplot==1
        ylabel(labely1);
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
    plot(Analysis.(thistype).Licks.Events,Analysis.(thistype).Licks.Trials,'sk',...
        'MarkerSize',2,'MarkerFaceColor','k');
    plot([0 0],[0 maxtrial],'-r');
    plot(Analysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
% Lick AVG
    subplot(6,nbOfPlots,thisplot+(2*nbOfPlots)); hold on;
    if thisplot==1
        ylabel(labely2);
    end
    xlabel(labelx);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate+1]);
    shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,'-k',0);
    plot([0 0],[0 maxrate+1],'-r');
    plot(Analysis.(thistype).CueTime,[maxrate maxrate],'-b','LineWidth',2);
    
if Analysis.Properties.Photometry==1    
% Nidaq Raster
    subplot(6,nbOfPlots,[thisplot+(3*nbOfPlots) thisplot+(4*nbOfPlots)]); hold on;
    if thisplot==1
                ylabel(labely3);
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
    yrasternidaq=1:Analysis.(thistype).nTrials;
    imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yrasternidaq,Analysis.(thistype).(thisChStruct).DFF,NidaqRange);
    plot([0 0],[0 maxtrial],'-r');
    plot(Analysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
    if thisplot==nbOfTrialTypes
        pos=get(gca,'pos');
        c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
        c.Label.String = labely4;
    end
% Nidaq AVG
    subplot(6,nbOfPlots,thisplot+(5*nbOfPlots)); hold on;
    if thisplot==1
        ylabel(labely4);
    end
    xlabel(labelx);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',NidaqRange);
    shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,'-k',0);
    plot([0 0],NidaqRange,'-r');
    plot(Analysis.(thistype).CueTime,[NidaqRange(2) NidaqRange(2)],'-b','LineWidth',2);
end    
    thisplot=thisplot+1;
end
end