function Analysis=A_FilterLick(Analysis,FilterName,Time,Number)
% Function to filter trials according to the number of Lick in a defined
% time window. Generates an additional inverted filter.
%
% Function designed by Quentin 2017 for Analysis_Photometry

%% Parameters
% Name
FilterNb=length(Analysis.Filters.Names);
Analysis.Filters.Names{FilterNb+1}=FilterName;
Analysis.Filters.Names{FilterNb+2}=[FilterName 'Inv'];
% Filter
Logicals=false(Analysis.AllData.nTrials,1);

%% Filter
for i=1:Analysis.AllData.nTrials
	counter = 0;
% Quentin Specific Timing
if ischar(Time)
    switch Time
        case 'Cue'
            Time=Analysis.AllData.CueTime(i,:)+Analysis.Properties.CueTimeReset;
        case 'Outcome'
            Time=Analysis.AllData.OutcomeTime(i,:)+Analysis.Properties.OutcomeTimeReset;
    end
end
    for j = Analysis.AllData.Licks.Events{i}
        if j > Time(1)  && j < Time(2)
            counter = counter + 1;
        end
    end
    if counter > Number
        Logicals(i)=true;
    end
end
Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals ~Logicals];
end