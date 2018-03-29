figure();
% Get the filter
FilterName='PupilNaN';
counter=0;
    for j=1:length(Analysis.Filters.Names)
        counter=counter+1;
        if strcmp(Analysis.Filters.Names{j},FilterName)
            Filter=Analysis.Filters.Logicals(:,counter);
        end
    end
Filter=logical(Analysis.Filters.Logicals(:,11)); 
% Data
Time=Analysis.AllData.Pupil.Time(1,:);
GoodPupil=Analysis.AllData.Pupil.Pupil(Filter,:);
BadPupil=Analysis.AllData.Pupil.Pupil(~Filter,:);
GoodPupilDPP=Analysis.AllData.Pupil.PupilDPP(Filter,:);
BadPupilDPP=Analysis.AllData.Pupil.PupilDPP(~Filter,:);
yGoodPupil=1:size(GoodPupil,1);
yBadPupil=1:size(BadPupil,1);

% Plot
Range=[0 100];
subplot(2,2,1)
imagesc(Time,yGoodPupil,GoodPupil,Range);
subplot(2,2,2)
imagesc(Time,yBadPupil,BadPupil,Range);
subplot(2,2,3)
imagesc(Time,yGoodPupil,GoodPupilDPP,[-10 20]);
subplot(2,2,4)
imagesc(Time,yBadPupil,BadPupilDPP,[-10 20]);
