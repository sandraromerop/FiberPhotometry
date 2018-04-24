function AP_PlotData_DFFvsVelocity(Analysis,DefaultParam,idTrials)

figure('units','normalized','position',[.1 .1 .7 .5])
pearsonR_velocity=[];
ip=1;
for tT = 1:length(idTrials)
    tType = idTrials(tT);
    tempPhoto_470 = Analysis.AllData.Photo_470.DFF(:,1:end-1);
    tempPhoto_470(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    tempWheel =diff( Analysis.AllData.Wheel.Distance,[],2);
    tempWheel(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    subplot(ceil(length(idTrials)/2),4,ip);ip=ip+1;
    timeV = Analysis.AllData.Photo_470.Time;
    cx = parula(size(tempWheel,1));
    idSt = find(timeV(1,:)>=0);idSt=idSt(1);
    idC1 = find(timeV(1,:)>=Analysis.AllData.CueTime(1,1));idC1=idC1(1);
    idC2 = find(timeV(1,:)<=Analysis.AllData.CueTime(1,2));idC2=idC2(end);
    for tt=1:size(tempWheel,1)
        plot(abs(tempWheel(tt,idSt:5:end)),tempPhoto_470(tt,idSt:5:end),'.','Color', cx(tt,:));hold on
        pearsonR_velocity(tt,tT)=corr(abs(tempWheel(tt,idSt:end))',tempPhoto_470(tt,idSt:end)'); 
        pearsonR_velocityCue(tt,tT)=corr(abs(tempWheel(tt,idC1:idC2))',tempPhoto_470(tt,idC1:idC2)'); 
    end
    if tT==1 && tType>5
        title([ { strrep(DefaultParam.FileList(1:end-4),'_',' '); Analysis.Filters.Names{tType}}]);       
    elseif tType>5
        title(Analysis.Filters.Names{tType});
    elseif tT==1 && tType<=5
        title([ {strrep(DefaultParam.FileList(1:end-4),'_',' '); eval(['Analysis.type_' num2str(tType) '.Name'])}]);       
    else
        title(eval(['Analysis.type_' num2str(tType) '.Name']));
    end
    xlabel('Velocity (cm/s)')
    ylabel('DF/F0')
    box off
    subplot(ceil(length(idTrials)/2),4,ip);ip=ip+1;
    yyaxis right
    tempWheel = cat(1,tempWheel,nan.*ones(1,size(tempWheel,2)));
    shadedErrorBar(Analysis.AllData.Photo_470.Time(1,1:end-1),nanmean(abs(tempWheel(:,1:end)),1),...
        nanstd(-(tempWheel(:,1:end)))./(sqrt(size(tempWheel,1))),'-r',1)
    ylabel('Velocity (cm/s)')
    yyaxis left
    tempPhoto_470 = cat(1,tempPhoto_470,nan.*ones(1,size(tempPhoto_470,2)));
    shadedErrorBar(Analysis.AllData.Photo_470.Time(1,1:end-1),nanmean( (tempPhoto_470(:,1:end))),...
        nanstd((tempPhoto_470(:,1:end)))./(sqrt(size(tempPhoto_470,1))),'-b',1)
    ylabel('DF/F0')
    maxY = max(nanmean(abs(tempPhoto_470(:,1:end))))+max(0.5*nanstd( (tempPhoto_470(:,1:end)))./(sqrt(size(tempPhoto_470,1))))+1;
    hold on
    plot([0 0],[0 maxY],'Color',[.5 .5 .5]);
    plot(Analysis.AllData.CueTime(1,:),[maxY maxY],'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
    xlabel('Time (sec)')
    ax=gca;ax.XLim = [-5 5 ];
    box off  
end
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name 'velocity_DFF0' '.png']);
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name 'velocity_DFF0' '.m']);
end