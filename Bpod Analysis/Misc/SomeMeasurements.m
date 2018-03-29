%% Loading Files
[FileList,PathName]=uigetfile('*.mat','Select the Analysis file(s)','MultiSelect', 'on');
cd(PathName)

%% Data to Extract
Reward.Names={'NoAnticipLick_CueA_Reward','AnticipLick_CueA_Reward'...
'Cue_A_reward','Uncued_Reward'};

Cue.Names={'NoAnticipLick_CueA','AnticipLick_CueA','Cue_A'...
'NoAnticipLick_CueB','AnticipLick_CueB','Cue_B'};

%% Extraction
for i=1:length(FileList)
    i
    load(FileList{i})
    for j=1:length(Reward.Names)
        if isfield(Analysis,Reward.Names{j})
            if Analysis.(Reward.Names{j}).nTrials
                Time=Analysis.(Reward.Names{j}).Photo_470.Time(1,:);
                DFF=Analysis.(Reward.Names{j}).Photo_470.DFFAVG;
                Reward.zero(i,j)=mean(DFF(Time>-0.01 & Time<0.01));
                Reward.Max(i,j)=max(DFF(Time>-0.01 & Time<2));
                Reward.MaxZ(i,j)=Reward.Max(i,j)-Reward.zero(i,j);
                Reward.Time.(Reward.Names{j})(i,:)=Time(Time>-0.01 & Time<2);
                Reward.DFF.(Reward.Names{j})(i,:)=DFF(Time>-0.01 & Time<2)-Reward.zero(i,j);            
            end
        end
    end
    for j=1:length(Cue.Names)
        if isfield(Analysis,Cue.Names{j})
            if Analysis.(Cue.Names{j}).nTrials
                Time=Analysis.(Cue.Names{j}).Photo_470.Time(1,:);
                DFF=Analysis.(Cue.Names{j}).Photo_470.DFFAVG;
                Cue.zero(i,j)=mean(DFF(Time>-1.51 & Time<-1.49));
                Cue.Time.(Cue.Names{j})(i,:)=Time(Time>-1.51 & Time<0);
                Cue.DFF.(Cue.Names{j})(i,:)=DFF(Time>-1.51 & Time<0)-Cue.zero(i,j);
                
                Cue.Max(i,j)=max(DFF(Time>-1.51 & Time<-0.9));
                Cue.MaxZ(i,j)=Cue.Max(i,j)-Cue.zero(i,j);
                Cue.Mean(i,j)=mean(DFF(Time>-1.51 & Time<-0.9));
                Cue.MeanZ(i,j)=Cue.Mean(i,j)-Cue.zero(i,j);
                
                Delay.Max(i,j)=max(DFF(Time>-0.9 & Time<0));
                Delay.MaxZ(i,j)=max(DFF(Time>-0.9 & Time<0));
                Delay.Mean(i,j)=mean(DFF(Time>-0.9 & Time<0));
            end
        end
    end
end
%% Metrics
Normalization=Reward.MaxZ(:,4)';
Reward.Time=Reward.Time.(Reward.Names{1})(1,:);
for i=1:length(Reward.Names)
    Reward.DFFNorm.(Reward.Names{i})=Reward.DFF.(Reward.Names{i})./Normalization';
    Reward.DFFAVG(i,:)=mean(Reward.DFFNorm.(Reward.Names{i}));
end
Normalization=Cue.Max(:,4)';
Cue.Time=Cue.Time.(Cue.Names{1})(1,:);
for i=1:length(Cue.Names)
    Cue.DFFNorm.(Cue.Names{i})=Cue.DFF.(Cue.Names{i})./Normalization';
    Cue.DFFAVG(i,:)=mean(Cue.DFFNorm.(Cue.Names{i}));
end

% ALR / UncuedReward
ALR_UR_Z=Reward.MaxZ(:,2)./Reward.MaxZ(:,4);
% NALR / UncuedReward
NALR_UR_Z=Reward.MaxZ(:,1)./Reward.MaxZ(:,4);
% CR / Uncued Reward
CR_UR_Z=Reward.MaxZ(:,3)./Reward.MaxZ(:,4);
% ALC / NALC
ALC_NALC=Cue.MaxZ(:,2)./Cue.MaxZ(:,1);
% CS+ / CS-
CSA_CSB=Cue.MaxZ(:,2)./Cue.MaxZ(:,4);


%% Plots
figure()
subplot(4,3,1); hold on;
title('Uncued Reward Responses')
plot(Reward.Time',Reward.DFFNorm.Uncued_Reward','-');
xlim([0 2]); ylim([-1 1.5]);
ylabel('Norm DFF');
subplot(4,3,4); hold on;
title('Cued Reward Responses')
plot(Reward.Time',Reward.DFFNorm.Cue_A_reward','-');
xlim([0 2]); ylim([-1 1.5]);
ylabel('Norm DFF');xlabel('Time (s)');
subplot(4,3,[2 5]); hold on;
title('Reward Responses')
plot(Reward.Time',Reward.DFFAVG','-');
xlim([0 2]); ylim([-0.5 1.5]);
ylabel('Norm DFF'); xlabel('Time (s)');
legend(Reward.Names);
subplot(4,3,3)
title('Reward Responses');
plot([1 2 3],Reward.MaxZ(:,[2 1 4]),'s-');
xlim([0.5 3.5]); ylim([0 10]);
ylabel('DFF');
xticks([1 2 3]); xticklabels({'Antic. Licks','No Antic. Licks','Uncued'});
xtickangle(15);
subplot(4,3,6)
boxplot([ALR_UR_Z NALR_UR_Z],'Labels',{'Antic. Licks','No Antic. Licks'});
ylim([0 1.5]);
xtickangle(15);
ylabel('Norm. DFF');
subplot(4,3,7); hold on;
title('CS+ Cue responses')
plot(Cue.Time',Cue.DFFNorm.AnticipLick_CueA','-');
xlim([-1.5 0]); ylim([-1 3]);
ylabel('DFF');
subplot(4,3,10); hold on;
title('CS- Cue responses')
plot(Cue.Time',Cue.DFFNorm.NoAnticipLick_CueB','-');
xlim([-1.5 0]); ylim([-1 3]);
ylabel('DFF');xlabel('Time (s)');
subplot(4,3,[8 11]); hold on;
title('Cue Responses')
plot(Cue.Time',Cue.DFFAVG','-');
xlim([-1.5 0]); ylim([-0.5 1.5]);
ylabel('DFF'); xlabel('Time (s)');
legend(Cue.Names);
subplot(4,3,9);
title('Cue Responses');
plot([1 2 3 4 5 6],Cue.MaxZ(:,[1 2 3 6 5 4]),'s-');
xlim([0.5 6.5]); ylim([0 10]);
ylabel('DFF');
xticks([1 2 3 4 5 6]); 
xticklabels({'Antic. Licks','No Antic. Licks','Total Cue A','Total Cue B','No Antic. Licks','Antic. Licks'});
xtickangle(15);
subplot(4,3,12)
boxplot([ALC_NALC CSA_CSB],{'Antic./No Antic. Licks','CS+/CS-'});
% xtickangle(15);
ylim([0 3]);
ylabel('Norm. DFF');