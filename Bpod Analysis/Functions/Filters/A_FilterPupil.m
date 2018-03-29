function Analysis=A_FilterPupil(Analysis,FilterName,State,threshold)
% Function to filter trials according to the running activity of the animal
% Threshold and behavioral state can be specified in the
% Analysis.Properties structure (see parameters part).
% Generates an additional inverted filter.
%
% Function designed by Quentin 2017 for Analysis_Photometry
%% Parameters

switch nargin
    case 1
        FilterName='Pupil';
        State=Analysis.Properties.PupilState;
        threshold=Analysis.Properties.PupilThreshold;
    case 2
        State=Analysis.Properties.PupilState;
        threshold=Analysis.Properties.PupilThreshold;
end

% Name
FilterNb=length(Analysis.Filters.Names);
Analysis.Filters.Names{FilterNb+1}=FilterName;
Analysis.Filters.Names{FilterNb+2}=[FilterName 'Inv'];
% Filter
Logicals=false(Analysis.AllData.nTrials,1);

%% Filter
if Analysis.Properties.Pupillometry==1
    Logicals(Analysis.AllData.Pupil.(State)>threshold)=true;
    LogicalsInv=~Logicals;
else
    LogicalsInv=Logicals;
end
Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals LogicalsInv];
end
