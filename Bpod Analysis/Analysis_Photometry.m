function Analysis=Analysis_Photometry(DefaultParam)
% Function to analyze photometry data. 
% Generates a struct named 'Analysis' using the functions:
% AP_Parameters                 : extracts parameters of acquisition
% AP_DataOrganize               : extracts data from SessionData
% A_Filer#                      : filters out trials
% AP_DataSort                   : sort data according to trialtypes and filters
% AP_PlotData / AP_PlotSummary  : plot data
% Need to be used with Analysis_Photometry_Launcher
%
%function designed by Quentin 2017

%% Loads File, Extracts and Organizes all the data
for i=1:length(DefaultParam.FileToOpen)
    FileName=DefaultParam.FileToOpen{1,i}
    cd(DefaultParam.PathName); load(FileName);
    DirName=fullfile(DefaultParam.PathName, FileName);
    [~,FileNameNoExt]=fileparts(DirName);
if DefaultParam.Load==0
if exist([FileNameNoExt '_Pupil.mat'],'file')==2 
    load([FileNameNoExt '_Pupil.mat']);
else
    disp('Could not find the pupillometry data');
    Pupillometry=[];
end
try
        Analysis.Properties=AP_Parameters(SessionData,Pupillometry,DefaultParam,FileNameNoExt);
        Analysis=A_FilterIgnoredTrials(Analysis,DefaultParam.TrialToFilterOut,DefaultParam.LoadIgnoredTrials);
        tic
        Analysis=AP_DataOrganize(Analysis,SessionData,Pupillometry);
        toc
catch
        disp([FileName ' NOT ANALYZED - Error in Parameters extraction or Data organization']);
end
    clear SessionData Pupillometry;
else
    Analysis.Properties=AP_Parameters4Loading(Analysis.Properties,DefaultParam);
end
end

%% Sorts data by trial types and generates plots
if DefaultParam.Load==0
Analysis=A_FilterTrialType(Analysis);
Analysis=AP_DataSort(Analysis);
end
% figure folder
Analysis.Properties.DirFig=[DefaultParam.PathName Analysis.Properties.Phase filesep];
if isdir(Analysis.Properties.DirFig)==0
    mkdir(Analysis.Properties.DirFig);
end

if Analysis.Properties.PlotSummary1==1
    if Analysis.Properties.Photometry==0
        Analysis=AP_PlotData(Analysis,'nophoto');
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_AllData.png']);
    else 
    for thisCh=1:length(Analysis.Properties.PhotoCh)
        Analysis=AP_PlotData(Analysis,thisCh);
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_AllData' char(Analysis.Properties.PhotoCh{thisCh}) '.png']);
        if Analysis.Properties.Illustrator
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_AllData' char(Analysis.Properties.PhotoCh{thisCh})],'epsc');
        end
    end
    end
end
Analysis.Properties.WheelThreshold=DefaultParam.WheelThreshold;
%% Filters and Extra Plots
if Analysis.Properties.Photometry==1
switch Analysis.Properties.Behavior
    case 'CuedReward'
Analysis=AP_CuedReward_FiltersAndPlot(Analysis);
    case 'GoNogo'
Analysis=AP_GoNogo_FiltersAndPlot(Analysis);
    case 'AuditoryTuning'
AP_AuditoryTuning_FiltersAndPlot(Analysis);
    case 'Oddball'
Analysis=AP_OddBall_FiltersAndPlot(Analysis);
end
end

%% Save Analysis
if DefaultParam.Save
    Analysis.Properties.Files=DefaultParam.FileToOpen;
    DirAnalysis=[DefaultParam.PathName 'Analysis' filesep];
    if isdir(DirAnalysis)==0
        mkdir(DirAnalysis);
    end
FileName=[Analysis.Properties.Name '_' Analysis.Properties.Phase];
DirFile=[DirAnalysis FileName];
save(DirFile,'Analysis');
end
end