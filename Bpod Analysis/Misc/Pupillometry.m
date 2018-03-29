function Pupillometry(action)
switch action
    case 'AP_Pupillometry'
        
    case 'AP_Pupillometry_Rescale'
        
    case 'FIJI_Reading'
Pupillometry_FIJI_Data_Reader('Single','Save');     

    case 'FIJI_Reading_Batch'
FoldDir=uigetdir();
DirContent=dir(FoldDir);
for i=1:size(DirContent,1)
%     try
        Pupillometry_FIJI_Data_Reader(DirContent(i).name,'Save');
%     catch
%         disp([i 'not analyzed'])
%     end
end   

end