function AP_AuditoryTuning_FiltersAndPlot(Analysis)

%% Filters
WNtypes=A_NameToTrialNumber(Analysis,'White');
ChirpTypes=A_NameToTrialNumber(Analysis,'to');
if Analysis.Properties.nbOfTrialTypes>3
    ToneTypes=4:1:Analysis.Properties.nbOfTrialTypes;
else
    ToneTypes=NaN;
end

%% Data
TuningYAVG=NaN(Analysis.Properties.nbOfTrialTypes,1);
TuningYMAX=NaN(Analysis.Properties.nbOfTrialTypes,1);
TuningYSEM=NaN(Analysis.Properties.nbOfTrialTypes,1);
TuningX=1:1:Analysis.Properties.nbOfTrialTypes;

%% Plot Parameters
labelx='Time (sec)';   
xTime=[Analysis.Properties.PlotEdges(1) Analysis.Properties.PlotEdges(2)];
xtickvalues=linspace(xTime(1),xTime(2),5);
labely='DF/F (%)';
color4plot={'-k';'-b';'-r';'-g';'-c';'-m';'-y'};
transparency=Analysis.Properties.Transparency;
% Photometry
if isempty(Analysis.Properties.NidaqRange)
        NidaqRange=[0-6*Analysis.Properties.NidaqSTD 6*Analysis.Properties.NidaqSTD];
        Analysis.Properties.NidaqRange=NidaqRange;
else
    NidaqRange=Analysis.Properties.NidaqRange;
end

for thisCh=1:length(Analysis.Properties.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{thisCh}));
    FigTitle=['Auditory Tuning Curve' char(Analysis.Properties.PhotoCh{thisCh})];
    
%% Plot
FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
figData.figure=figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 
% WhiteNoise
subplot(2,3,1); hold on;
title('White Noise');
xlabel(labelx);
ylabel(labely);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',NidaqRange);
if isnan(WNtypes)==false
    counter=1;
    thislegend=cell(length(WNtypes),1);
    for i=WNtypes
        thistype=sprintf('type_%.0d',i);
        hs=shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{counter},transparency);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
        TuningYAVG(i)=Analysis.(thistype).(thisChStruct).CueAVG;
        TuningYMAX(i)=Analysis.(thistype).(thisChStruct).CueMax;
        TuningYSEM(i)=Analysis.(thistype).(thisChStruct).CueSEM;
    end
    plot([0 0],NidaqRange,'-r');
    legend(hp,thislegend,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
end

% Chirp
subplot(2,3,2); hold on
xlabel(labelx);
title('Chirp');
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',NidaqRange);
if isnan(ChirpTypes)==false
    counter=1;
    thislegend=cell(length(ChirpTypes),1);
    for i=ChirpTypes
        thistype=sprintf('type_%.0d',i);
        hs=shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{counter},transparency);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
        TuningYAVG(i)=Analysis.(thistype).(thisChStruct).CueAVG;
        TuningYMAX(i)=Analysis.(thistype).(thisChStruct).CueMax;
        TuningYSEM(i)=Analysis.(thistype).(thisChStruct).CueSEM;
    end
    plot([0 0],NidaqRange,'-r');
	legend(hp,thislegend,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
end

% pure tones
subplot(2,3,3); hold on
xlabel(labelx);
title('Pure Tones');
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',NidaqRange);
if isnan(ToneTypes)==false
    counter=1;
    thislegend=cell(length(ToneTypes),1);
    for i=ToneTypes
        thistype=sprintf('type_%.0d',i);
        hs=shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{counter},transparency);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
        TuningYAVG(i)=Analysis.(thistype).(thisChStruct).CueAVG;
        TuningYMAX(i)=Analysis.(thistype).(thisChStruct).CueMax;
        TuningYSEM(i)=Analysis.(thistype).(thisChStruct).CueSEM;
    end
    plot([0 0],NidaqRange,'-r');
	legend(hp,thislegend,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
end


% AudTuning curve
subplot(2,3,[4 5]); hold on
set(gca,'XLim',[0 Analysis.Properties.nbOfTrialTypes+1],'YLim',NidaqRange,...
                                        'XTick',TuningX,'XTickLabel',Analysis.Properties.TrialNames,'XTickLabelRotation', 15);
title('Auditory Tuning'); ylabel(labely);
plot(TuningX,TuningYMAX,'sr'); 
plot(TuningX,TuningYAVG,'sb'); 
plot([0 Analysis.Properties.nbOfTrialTypes+1],[0 0],'-g');
% Bleach
subplot(2,3,6); hold on
title('Bleaching'); ylabel('Norm. DF/F'); xlabel('Trial Number');
plot(Analysis.AllData.(thisChStruct).Bleach);

%% Save
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_AudTun' char(Analysis.Properties.PhotoCh{thisCh}) '.png']);
if Analysis.Properties.Illustrator
saveas(gcf,[DAnalysis.Properties.DirFig Analysis.Properties.Name '_AudTun' char(Analysis.Properties.PhotoCh{thisCh})],'epsc');
end

end
end