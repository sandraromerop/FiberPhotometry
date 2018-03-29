function Analysis=A_FilterPupilNaNCheck(Analysis,FilterName,Threshold)
% Function to filter trials according to the running activity of the animal
% Threshold and behavioral state can be specified in the
% Analysis.Properties structure (see parameters part).
% Generates an additional inverted filter.
%
% Function designed by Quentin 2017 for Analysis_Photometry
%% Parameters
switch nargin
    case 1
       FilterName='PupilNaN'; 
       Threshold=25;
    case 2
       Threshold=25;
end

% Name
FilterNb=length(Analysis.Filters.Names);
Analysis.Filters.Names{FilterNb+1}=FilterName;
% Filter
Logicals=ones(Analysis.AllData.nTrials,1);
%% Filter
if Analysis.Properties.Pupillometry==1   
    testnan=isnan(Analysis.AllData.Pupil.Pupil);
    sumnan=sum(testnan(:,1:200),2)*(100/200);
    Logicals(sumnan>Threshold)=false;
end
Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals];
end
