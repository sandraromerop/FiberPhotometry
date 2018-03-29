function Analysis=AP_CuedReward_FiltersAndPlot(Analysis)
%This function can be used to generates filters based on behavior or states
%and to plot single and summary figures.
%
%function designed by Quentin 2017

%% Plot Summary figure 2
if Analysis.Properties.PlotSummary2==1
    for thisCh=1:length(Analysis.Properties.PhotoCh)
if contains(Analysis.Properties.Phase,'Pun')
    AP_PlotSummary(Analysis,thisCh,'Cue A','Cue B','Reward','Punish');
else
    AP_PlotSummary(Analysis,thisCh,'Cue A','Cue B','Reward');
end
    saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_Summary' char(Analysis.Properties.PhotoCh{thisCh}) '.png']);
    if Analysis.Properties.Illustrator
    saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_Summary' char(Analysis.Properties.PhotoCh{thisCh}) ],'epsc');
    end
    end
end

%% Generates Classical filters
% Groups
FilterNames={'Cue A','Cue B','Uncued','Reward','Punish','Omission','Cue C'};
for i=1:length(FilterNames)
    Analysis=A_FilterName(Analysis,FilterNames{i});
end
% Licks
Analysis=A_FilterLick(Analysis,'LicksCue','Cue',Analysis.Properties.LicksCue);
Analysis=A_FilterLick(Analysis,'LicksOutcome','Outcome',Analysis.Properties.LicksOutcome);
% Wheel
Analysis=A_FilterWheel(Analysis,'Run',Analysis.Properties.WheelState,Analysis.Properties.WheelThreshold);
% Sequence
Analysis=A_FilterAfollowsB(Analysis,'Reward_After_Punish','Reward','Punish');

%% Plot Filters
if Analysis.Properties.PlotFiltersSummary || Analysis.Properties.PlotFiltersSingle
[GroupToPlot]=AP_Filter_GroupToPlot(Analysis);
for i=1:size(GroupToPlot,1)
    Title=GroupToPlot{i,1};
    MetaFilterGroup=cell(size(GroupToPlot{i,2},1),1);
    for j=1:size(GroupToPlot{i,2},1)
        MetaFilter=GroupToPlot{i,2}{j,1};
        Filters=GroupToPlot{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort_Filter(Analysis,MetaFilter,thisFilter);
        if Analysis.Properties.PlotFiltersSingle && Analysis.(MetaFilter).nTrials>0
            for thisCh=1:length(Analysis.Properties.PhotoCh)
                AP_PlotData_filter(Analysis,MetaFilter,thisCh);
                saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name MetaFilter char(Analysis.Properties.PhotoCh{thisCh}) '.png']);
                if Analysis.Properties.Illustrator
                saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name MetaFilter char(Analysis.Properties.PhotoCh{thisCh})],'epsc');
                end
            end
        end
        clear thisFilter
    end
    for thisCh=1:length(Analysis.Properties.PhotoCh)
        AP_PlotSummary_filter(Analysis,Title,MetaFilterGroup,thisCh);
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name Title char(Analysis.Properties.PhotoCh{thisCh}) '.png']);
        if Analysis.Properties.Illustrator
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name Title char(Analysis.Properties.PhotoCh{thisCh})],'epsc');
        end
    end
end
end
%% Behavior Filters
if Analysis.Properties.PlotFiltersBehavior
[~,GroupToPlot]=AP_Filter_GroupToPlot(Analysis);
for i=1:size(GroupToPlot,1)
    Title=GroupToPlot{i,1};
    MetaFilterGroup=cell(size(GroupToPlot{i,2},1),1);
    for j=1:size(GroupToPlot{i,2},1)
        MetaFilter=GroupToPlot{i,2}{j,1};
        Filters=GroupToPlot{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort_Filter(Analysis,MetaFilter,thisFilter);
        if Analysis.(MetaFilter).nTrials
            for thisCh=1:length(Analysis.Properties.PhotoCh)
                AP_PlotData_Filter_corrDFF(Analysis,MetaFilter,thisCh);
                saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name MetaFilter char(Analysis.Properties.PhotoCh{thisCh}) '.png']);
                if Analysis.Properties.Illustrator
                saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name MetaFilter char(Analysis.Properties.PhotoCh{thisCh})],'epsc');
                end
            end
        end
        clear thisFilter
    end
    for thisCh=1:length(Analysis.Properties.PhotoCh)
        AP_PlotSummary_Filter_corrDFF(Analysis,Title,MetaFilterGroup,thisCh);
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name Title char(Analysis.Properties.PhotoCh{thisCh}) '.png']);
        if Analysis.Properties.Illustrator
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name Title char(Analysis.Properties.PhotoCh{thisCh})],'epsc');
        end
    end
end
end
end