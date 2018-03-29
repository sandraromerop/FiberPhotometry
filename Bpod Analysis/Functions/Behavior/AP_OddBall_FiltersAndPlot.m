function Analysis=AP_OddBall_FiltersAndPlot(Analysis,DefaultParam)

%% Timing
Analysis.type_1.Oddball.counter=0;
Analysis.type_2.Oddball.counter=0;
StandValue=1;
OddValue=2;
TimeOffset=0.1;
for thisTrial=1:Analysis.AllData.nTrials
    % Parameters
    thistype=sprintf('type_%.0d',Analysis.AllData.TrialTypes(thisTrial));
    counterTrials=Analysis.(thistype).Oddball.counter+1;
    Analysis.(thistype).Oddball.counter=counterTrials;
    TimeToZero      =   Analysis.AllData.ZeroTime(thisTrial);
    SequenceNb      =	Analysis.AllData.Oddball_SoundSeq{1,thisTrial};
    SequenceNames   =   Analysis.AllData.Oddball_StateSeq{1,thisTrial};
    SequenceState   =   Analysis.AllData.States{1,thisTrial};
    % Extract timing of Early and Late Standard sound and Odd Stimulus
    testFirst=1;
    counterOdd=1;
    timeEarly=[];
    timeLate=[];
    timeOdd=[];
    for i=1:length(SequenceNb)
        if SequenceNb(i)==StandValue && testFirst==1
            thisState=SequenceNames{i};
            timeEarly(counterOdd,:)=SequenceState.(thisState)-TimeToZero;
            testFirst=0;
        end
        if SequenceNb(i)==OddValue && testFirst==0
            thisState=SequenceNames{i};
            prevState=SequenceNames{i-1};
            timeLate(counterOdd,:)=SequenceState.(prevState)-TimeToZero;
            timeOdd(counterOdd,:)=SequenceState.(thisState)-TimeToZero;
            testFirst=1;
            counterOdd=counterOdd+1;
        end
        Analysis.(thistype).Oddball.Early{counterTrials}=timeEarly(1:counterOdd-1,:);
        Analysis.(thistype).Oddball.Late{counterTrials}=timeLate(1:counterOdd-1,:);
        Analysis.(thistype).Oddball.Odd{counterTrials}=timeOdd(1:counterOdd-1,:);
    end
end

%% Nidaq
MaxTime=20*Analysis.Properties.NidaqDecimatedSR; %(sec)
MaxNb=1000;
for i=1:Analysis.Properties.nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
    for thisCh=1:length(Analysis.Properties.PhotoCh)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{thisCh}));        
        counter=0;
        % Matrices to store Photometry and timing data
        TimeEarly=[];
        TimeLate=[];
        TimeOdd=[];
        TimeEarlyToLate=[];
        PhotoEarly=NaN(MaxNb,MaxTime);
        PhotoLate=NaN(MaxNb,MaxTime);
        PhotoOdd=NaN(MaxNb,MaxTime);
        PhotoEarlyToLate=NaN(MaxNb,MaxTime);
        for thistrial=1:Analysis.(thistype).nTrials
            % Load timing of sounds
            Photo=Analysis.(thistype).(thisChStruct).DFF(thistrial,:);
            Time=Analysis.(thistype).(thisChStruct).Time(thistrial,:);
            Early=Analysis.(thistype).Oddball.Early{1,thistrial};
            Late=Analysis.(thistype).Oddball.Late{1,thistrial};
            Odd=Analysis.(thistype).Oddball.Odd{1,thistrial};            
            for j=1:length(Odd)
                counter=counter+1;
                %Early
                thisPhoto=Photo(Time>(Early(j,1)-TimeOffset) & Time<Early(j,2))-mean(Photo(Time>(Early(j,1)-TimeOffset) & Time<Early(j,1)));
                thisTime=Time(Time>(Early(j,1)-TimeOffset) & Time<Early(j,2))-Early(j,1);
                PhotoEarly(counter,1:length(thisPhoto))=thisPhoto;
                if length(thisTime)>length(TimeEarly)
                    TimeEarly=thisTime;
                end
                %Late
                thisPhoto=Photo(Time>(Late(j,1)-TimeOffset) & Time<Late(j,2))-mean(Photo(Time>(Late(j,1)-TimeOffset) & Time<Late(j,1)));
                thisTime=Time(Time>(Late(j,1)-TimeOffset) & Time<Late(j,2))-Late(j,1);
                PhotoLate(counter,1:length(thisPhoto))=thisPhoto;
                if length(thisTime)>length(TimeLate)
                    TimeLate=thisTime;
                end
                %Odd
                thisPhoto=Photo(Time>(Odd(j,1)-TimeOffset) & Time<Odd(j,2))-mean(Photo(Time>(Odd(j,1)-TimeOffset) & Time<Odd(j,1)));
                thisTime=Time(Time>(Odd(j,1)-TimeOffset) & Time<Odd(j,2))-Odd(j,1);
                PhotoOdd(counter,1:length(thisPhoto))=thisPhoto;
                if length(thisTime)>length(TimeOdd)
                    TimeOdd=thisTime;
                end
                %EarlyToLate
                thisPhoto=Photo(Time>(Early(j,1)-TimeOffset) & Time<Late(j,2))-mean(Photo(Time>(Early(j,1)-TimeOffset) & Time<Early(j,1)));
                thisTime=Time(Time>(Early(j,1)-TimeOffset) & Time<Late(j,2))-Early(j,1);
                PhotoEarlyToLate(counter,1:length(thisPhoto))=thisPhoto;
                if length(thisTime)>length(TimeEarlyToLate)
                    TimeEarlyToLate=thisTime;
                end
            end
        end
        % Save Photometry and Timing Data
        Analysis.(thistype).Oddball.(thisChStruct).TimeEarly            = TimeEarly; % Early
        Analysis.(thistype).Oddball.(thisChStruct).PhotoEarly           = PhotoEarly(1:counter,1:length(TimeEarly));
        Analysis.(thistype).Oddball.(thisChStruct).PhotoEarlyAVG        = nanmean(PhotoEarly(1:counter,1:length(TimeEarly)),1);
        Analysis.(thistype).Oddball.(thisChStruct).PhotoEarlySEM        = std(PhotoEarly(1:counter,1:length(TimeEarly)),0,1,'omitnan'); 
        Analysis.(thistype).Oddball.(thisChStruct).TimeLate             = TimeLate; % Late
        Analysis.(thistype).Oddball.(thisChStruct).PhotoLate            = PhotoLate(1:counter,1:length(TimeLate));
        Analysis.(thistype).Oddball.(thisChStruct).PhotoLateAVG         = nanmean(PhotoLate(1:counter,1:length(TimeLate)),1);
        Analysis.(thistype).Oddball.(thisChStruct).PhotoLateSEM         = std(PhotoLate(1:counter,1:length(TimeLate)),0,1,'omitnan');
        Analysis.(thistype).Oddball.(thisChStruct).TimeOdd              = TimeOdd; % Odd
        Analysis.(thistype).Oddball.(thisChStruct).PhotoOdd             = PhotoOdd(1:counter,1:length(TimeEarly));
        Analysis.(thistype).Oddball.(thisChStruct).PhotoOddAVG          = nanmean(PhotoOdd(1:counter,1:length(TimeOdd)),1);
        Analysis.(thistype).Oddball.(thisChStruct).PhotoOddSEM          = std(PhotoOdd(1:counter,1:length(TimeOdd)),0,1,'omitnan');
        Analysis.(thistype).Oddball.(thisChStruct).TimeEarlyToLate      = TimeEarlyToLate; % Early to Late
        Analysis.(thistype).Oddball.(thisChStruct).PhotoEarlyToLate     = PhotoEarlyToLate(1:counter,1:length(TimeEarlyToLate));
        Analysis.(thistype).Oddball.(thisChStruct).PhotoEarlyToLateAVG  = nanmean(PhotoEarlyToLate(1:counter,1:length(TimeEarlyToLate)),1);
        Analysis.(thistype).Oddball.(thisChStruct).PhotoEarlyToLateSEM  = std(PhotoEarlyToLate(1:counter,1:length(TimeEarlyToLate)),0,1,'omitnan');
    end
end

%% PLOT
for thisCh=1:length(Analysis.Properties.PhotoCh)
Analysis=AP_OddBall_Plot(Analysis,thisCh);
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name char(Analysis.Properties.PhotoCh{thisCh}) '.png']);
if Analysis.Properties.Illustrator
    saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name char(Analysis.Properties.PhotoCh{thisCh})],'epsc');
end
end
end
