function Analysis=A_FilterTrialType(Analysis)
% Function to filter trials according to their types.
% Primarly designed to be the first filtering script to be ran.
%
% Function designed by Quentin 2017 for Analysis_Photometry

%% Parameters
%Name
if isfield(Analysis.Filters,'Names')
    if contains(Analysis.Filters.Names{1},'type')
        disp('TrialTypes have already been filtered out');
        return
    else
        filterNameCounter=length(Analysis.Filters.Names);
    end
else
    filterNameCounter=0;
    Analysis.Filters.Logicals=[];
end

%Filter
Logicals=false(Analysis.AllData.nTrials,Analysis.Properties.nbOfTrialTypes);

%% Filter
for i=1:Analysis.Properties.nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
    Analysis.Filters.Names{i+filterNameCounter}=thistype;
    Logicals(Analysis.AllData.TrialTypes==i,i)=true;
end

Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals];
end