function Analysis=A_FilterBeforeAfter(Analysis,Number,FilterName1,FilterName2)
% Function to filter trials according to the number of trials
%
% Function designed by Quentin 2017 for Analysis_Photometry

%% Parameters
% Name
FilterNb=length(Analysis.Filters.Names);
switch nargin
    case 2
Analysis.Filters.Names{FilterNb+1}='Before';
Analysis.Filters.Names{FilterNb+2}='After';
    case 4
Analysis.Filters.Names{FilterNb+1}=FilterName1;
Analysis.Filters.Names{FilterNb+2}=FilterName2;
    otherwise
        disp('Needs 2 or 4 input arguments for A_FilterBeforeAfter function')
        return
end
% Filter
Logicals=false(Analysis.AllData.nTrials,1);
Logicals(1:Number)=true;
Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals ~Logicals];
end