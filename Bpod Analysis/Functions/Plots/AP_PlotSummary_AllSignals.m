function AP_PlotSummary_AllSignals(Analysis,DefaultParam,idTrials)

figure('units','normalized','position',[.1 .1 .7 .7])
pearsonR_velocity=[];
matIP =reshape( 1:(5*length(idTrials)),5,length(idTrials))';
p90(1) = prctile(Analysis.AllData.Photo_470.DFF(:),90);p10(1) = prctile(Analysis.AllData.Photo_470.DFF(:),10);
velocity = abs(diff( Analysis.AllData.Wheel.Distance,[],2));
p90(2) = prctile(velocity(:),90);p10(2) = prctile(velocity(:),10);
p90(3) = max(Analysis.AllData.Licks.Rate(:));p10(3) = prctile(Analysis.AllData.Licks.Rate(:),10);

for tT = 1:length(idTrials)
    tType = idTrials(tT);
    tempPhoto_470 = Analysis.AllData.Photo_470.DFF(:,1:end-1);
    tempPhoto_470(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    tempWheel =diff( Analysis.AllData.Wheel.Distance,[],2);
    tempWheel(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    tempLick = Analysis.AllData.Licks.Rate;
    tempLick(Analysis.Filters.Logicals(:,tType)==0,:)=[];
    trialsNb =1:Analysis.AllData.nTrials;trialsNb(Analysis.Filters.Logicals(:,tType)==0)=[];
    tempWheel = cat(1,tempWheel,nan.*ones(1,size(tempWheel,2)));
    tempPhoto_470 = cat(1,tempPhoto_470,nan.*ones(1,size(tempPhoto_470,2)));
    tempLick = cat(1,tempLick,nan.*ones(1,size(tempLick,2)));

    subplot(5,length(idTrials),matIP(1,tT));%ip=ip+1;
    yyaxis right
    shadedErrorBar(Analysis.AllData.Photo_470.Time(1,1:end-1),nanmean(abs(tempWheel(:,1:end)),1),...
        nanstd(abs(tempWheel(:,1:end)))./(sqrt(size(tempWheel,1))),'-r',1)
    maxY = max(nanmean( (tempPhoto_470(:,1:end))))+max(0.5*nanstd( (tempPhoto_470(:,1:end)))./(sqrt(size(tempPhoto_470,1))))+1;

    ylabel('Velocity (cm/s)')
    yyaxis left
    shadedErrorBar(Analysis.AllData.Photo_470.Time(1,1:end-1),nanmean( (tempPhoto_470(:,1:end))),...
        nanstd((tempPhoto_470(:,1:end)))./(sqrt(size(tempPhoto_470,1))),'-b',1)
    ylabel('DF/F0')
    maxY = max(nanmean( (tempPhoto_470(:,1:end))))+max(0.5*nanstd( (tempPhoto_470(:,1:end)))./(sqrt(size(tempPhoto_470,1))))+1;
    hold on
    plot([0 0],[0 maxY],'Color',[.5 .5 .5]);
    plot(Analysis.AllData.CueTime(1,:),[maxY maxY],'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
    xlabel('Time (sec)')
    ax=gca;ax.XLim = [-5 5 ];
    box off  
     if tT==1 && tType>5
        title([ { strrep(DefaultParam.FileList(1:end-4),'_',' '); Analysis.Filters.Names{tType}}]);       
    elseif tType>5
        title(Analysis.Filters.Names{tType});
    elseif tT==1 && tType<=5
        title([ {strrep(DefaultParam.FileList(1:end-4),'_',' '); eval(['Analysis.type_' num2str(tType) '.Name'])}]);       
    else
        title(eval(['Analysis.type_' num2str(tType) '.Name']));
    end   
    
    subplot(5,length(idTrials),matIP(2,tT))
    shadedErrorBar(Analysis.AllData.Licks.Bin{1}(2:end) ,nanmean(tempLick,1),...
        nanstd(tempLick)./(sqrt(size(tempWheel,1))),'-g',1)
    xlabel('Time (sec)')
    ylabel('Lick Rate (Hz)')
    maxY = max(nanmean(abs(tempLick(:,1:end))))+max(0.5*nanstd( (tempLick(:,1:end)))./(sqrt(size(tempLick,1))))+1;
    hold on
    plot([0 0],[0 maxY],'Color',[.5 .5 .5]);
    plot(Analysis.AllData.CueTime(1,:),[maxY  maxY ],'Color',[.7 .7 .7],'LineWidth',2,'LineStyle','-');
    ax=gca;ax.YLim = [0 maxY+1];

    subplot(5,length(idTrials),matIP(3,tT))
    
    imagesc(tempPhoto_470);colorbar
    imagesc(Analysis.AllData.Photo_470.Time(1,:),trialsNb,tempPhoto_470,[p10(1) p90(1)]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside','position',[pos(1)+pos(3).*.9   pos(2) 0.005 pos(4)]);
    c.Label.String ='DF/F0';
    plot([0 0],[0 max(trialsNb)],'-r');
    if tT==1
        ylabel('Trial Nb')
    end
    
    subplot(5,length(idTrials),matIP(4,tT))
    imagesc(Analysis.AllData.Photo_470.Time(1,1:end-1),trialsNb,abs(tempWheel),[p10(2) p90(2)]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside','position',[pos(1)+pos(3).*.9   pos(2) 0.005 pos(4)]);    c.Label.String ='Velocity cm/s';
    plot([0 0],[0 max(trialsNb)],'-r');
    if tT==1
       ylabel('Trial Nb')
    end
    
    subplot(5,length(idTrials),matIP(5,tT))
    imagesc(Analysis.AllData.Licks.Bin{1}(2:end) ,trialsNb,tempLick,[p10(3)  max(p90(3),1)]);hold on
    pos=get(gca,'pos');
    c=colorbar('location','eastoutside','position',[pos(1)+pos(3).*.9   pos(2) 0.005 pos(4)]);    c.Label.String ='Lick Rate (Hz)';
    plot([0 0],[0 max(trialsNb)],'-r');
    xlabel('Time (sec)')
    if tT==1
       ylabel('Trial Nb')
    end
end

saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name 'summary_all' '.png']);
saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name 'summary_all' '.m']);

end
 