function [Analysis,Logicals]=A_FilterMeta(Analysis,FilterName,FiltersCell)
% Function to merge filters specified in 'FiltersCell' into one filter array (0 or 1) 
%
% function designed by Quentin 2017 for Analysis_Photometry

%% Pre-existing filter
preexist=0;
if nargin==2 || isempty(FiltersCell)==1
    preexist=1;
else
    counter=0;
    for j=1:length(Analysis.Filters.Names)
        counter=counter+1;
        if strcmp(Analysis.Filters.Names{j},FilterName)
            preexist=1;
        end
    end
end

if preexist==1
     Logicals=Analysis.Filters.Logicals(:,counter);
     fprintf('%s have already been filtered out',FilterName);
else
    
%% Parameters
NbOfFilter=length(FiltersCell);
%Name
FilterNb=length(Analysis.Filters.Names);
Analysis.Filters.Names{FilterNb+1}=FilterName;
%Filter
Logicals=true(Analysis.AllData.nTrials,1);

%% Filter
for i=1:NbOfFilter
    FilterName=FiltersCell{i};
    for j=1:length(Analysis.Filters.Names)
        if strcmp(Analysis.Filters.Names{j},FilterName)
            Logicals=Logicals.*Analysis.Filters.Logicals(:,j);
        end
    end
end
Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals];
end
end