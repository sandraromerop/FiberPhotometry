function AP_PlotCorr_DFFvsVelocity(Analysis,DefaultParam,idTrials)
for tT = 1:length(idTrials)
    tType = idTrials(tT);
    tempPhoto_470 = Analysis.AllData.Photo_470.DFF(:,1:end-1);
    tempPhoto_470(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    tempWheel =diff( Analysis.AllData.Wheel.Distance,[],2);
    tempWheel(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    timeV = Analysis.AllData.Photo_470.Time;
    idSt = find(timeV(1,:)>=0);idSt=idSt(1);
    idC1 = find(timeV(1,:)>=Analysis.AllData.CueTime(1,1));idC1=idC1(1);
    idC2 = find(timeV(1,:)<=Analysis.AllData.CueTime(1,2));idC2=idC2(end);
    for tt=1:size(tempWheel,1)
        pearsonR_velocity(tt,tT)=corr(abs(tempWheel(tt,idSt:end))',tempPhoto_470(tt,idSt:end)'); 
        pearsonR_velocityCue(tt,tT)=corr(abs(tempWheel(tt,idC1:idC2))',tempPhoto_470(tt,idC1:idC2)'); 
    end
end
figure('units','normalized','position',[.1 .1 .7 .4])
subplot(1,3,1)
imagesc(pearsonR_velocityCue);c = colorbar;c.Label.String = 'Pearson Correlation at Cue';
ylabel('Nb Trials')
title(strrep(DefaultParam.FileList(1:end-4),'_',' '))
subplot(1,3,2)
lg=[];
imagesc(pearsonR_velocity);c = colorbar;c.Label.String = 'Pearson Correlation at Reward';
ylabel('Nb Trials')
title(strrep(DefaultParam.FileList(1:end-4),'_',' '))

subplot(1,3,3)
pearsonR_velocity(pearsonR_velocity==0)=nan;
cj = hsv(length(idTrials))
for tT = 1:length(idTrials)
    tType = idTrials(tT);
    plot(pearsonR_velocity(:,tT),'o','Color', cj(tT,:));hold on
    ylabel('Pearson Correlation Reward')
    xlabel('Nb Trials')
    if tType>5
        lg{tT} = Analysis.Filters.Names{tType};
    else
    lg{tT} = eval(['Analysis.type_' num2str(tT) '.Name']);
    end
end
legend(lg,'Location' ,'SouthEast')
subplot(1,3,1)
ax=gca;ax.XTick = [1:length(idTrials)];ax.XTickLabels = lg;ax.XTickLabelRotation =45;
subplot(1,3,2)
ax=gca;ax.XTick = [1:length(idTrials)];ax.XTickLabels = lg;ax.XTickLabelRotation =45;
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name 'correlationVelocityVSDFF0' '.png']);
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name 'correlationVelocityVSDFF0' '.m']);
end