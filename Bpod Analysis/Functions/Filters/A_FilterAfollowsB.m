function Analysis=A_FilterAfollowsB(Analysis,FilterName,TypeA,TypeB)
% Function to filter trials according to a trial type sequence
%
% function designed by Quentin 2016 for Analysis_Photometry

%% Parameters
if ischar(TypeA)
    TypeA=A_NameToTrialNumber(Analysis,TypeA);
elseif iscell(TypeA)
    n=size(TypeA,1);
    TempTypeA=[];
    for i=1:n
        TempTypeA=[TempTypeA A_NameToTrialNumber(Analysis,TypeA{i})];
    end
    TypeA=TempTypeA;
end

if ischar(TypeB)
    TypeB=A_NameToTrialNumber(Analysis,TypeB);
elseif iscell(TypeB)
    n=size(TypeB,1);
    TempTypeB=[];
    for i=1:n
        TempTypeB=[TempTypeB A_NameToTrialNumber(Analysis,TypeB{i})];
    end
    TypeB=TempTypeB;
end

% Name
FilterNb=length(Analysis.Filters.Names);
Analysis.Filters.Names{FilterNb+1}=FilterName;
% Filter
Logicals=false(Analysis.AllData.nTrials,1);

%% Filter
for i=1:Analysis.AllData.nTrials-1
    if ismember(Analysis.AllData.TrialTypes(i),TypeB) && ismember (Analysis.AllData.TrialTypes(i+1),TypeA) 
        Logicals(i+1)=true;
    end
end
Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals];
end