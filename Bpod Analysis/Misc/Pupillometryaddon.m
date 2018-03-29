[FileList,PathName]=uigetfile('*.mat','Select the pupil file(s)','MultiSelect', 'on');
cd(PathName)
for i=1:length(FileList)
    i
    load(FileList{i});
    
    Baseline=3.5:4.5;
    Baseline=Baseline*20;
    Pupillometry.PupilBaseline=nanmean(Pupillometry.Pupil(Baseline,:),1);
    Pupillometry.PupilDPP=100*(Pupillometry.Pupil-Pupillometry.PupilBaseline)./Pupillometry.PupilBaseline;   
    %Pupillometry.PupilBaselineNorm=Pupillometry.PupilBaseline/nanmean(Pupillometry.PupilBaseline);
    
    save(FileList{i},'Pupillometry');
end