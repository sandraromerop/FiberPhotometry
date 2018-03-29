function  Analysis=AP_GoNogo_FiltersAndPlot(Analysis)
%This function can be used to generates filters based on behavior or states
%and to plot single and summary figures.
%COMMENTS TO COME
%
%function designed by Quentin 2017

%% Generates filters
% Trial types
Analysis=A_FilterState(Analysis,'Go','Nogo');
% Wheel
Analysis=A_FilterWheel(Analysis,'Run',Analysis.Properties.WheelState,Analysis.Properties.WheelThreshold);
% Pupil
Analysis=A_FilterPupil(Analysis,'Pupil',Analysis.Properties.PupilState,Analysis.Properties.PupilThreshold);
Analysis=A_FilterPupilNaNCheck(Analysis,'PupilNaN',25);

%% Plot Filters
if Analysis.Properties.PlotFiltersSummary==1
GroupToPlot=AP_Filter_GroupToPlot(Analysis);
for i=1:size(GroupToPlot,1)
    Title=GroupToPlot{i,1};
    MetaFilterGroup=cell(size(GroupToPlot{i,2},1),1);
    for j=1:size(GroupToPlot{i,2},1)
        MetaFilter=GroupToPlot{i,2}{j,1};
        Filters=GroupToPlot{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort_Filter(Analysis,MetaFilter,thisFilter);
        if Analysis.Properties.PlotFiltersSingle==1 && Analysis.(MetaFilter).nTrials>0
            for thisCh=1:length(Analysis.Properties.PhotoCh)
                %AP_PlotData_filter(Analysis,MetaFilter,thisCh);
                AP_PlotData_Filter_corrDFF(Analysis,MetaFilter,thisCh);
                saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name MetaFilter char(Analysis.Properties.PhotoCh{thisCh}) '.png']);
                if Analysis.Properties.Illustrator
                saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name MetaFilter char(Analysis.Properties.PhotoCh{thisCh})],'epsc');
                end
            end
        end
    end
    for thisCh=1:length(Analysis.Properties.PhotoCh)
        %AP_PlotSummary_filter(Analysis,Title,MetaFilterGroup,thisCh);
        AP_PlotSummary_Filter_corrDFF(Analysis,Title,MetaFilterGroup,thisCh);
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name Title char(Analysis.Properties.PhotoCh{thisCh}) '.png']);
        if Analysis.Properties.Illustrator
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name Title char(Analysis.Properties.PhotoCh{thisCh})],'epsc');
        end
    end
end
end
end
