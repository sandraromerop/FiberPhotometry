function Modulated_LED=AP_Modulation(Analysis,amp,freq)
%Generates a sin wave for LED amplitude modulation.

SamplingRate=Analysis.Properties.NidaqSamplingRate;
try
    Duration=SessionData.TrialSettings(1).GUI.NidaqDuration;
catch
    Duration=15;
end
    
DeltaT=1/SamplingRate;
Time=0:DeltaT:(Duration-DeltaT);

Modulated_LED=amp*(sin(2*pi*freq*Time)+1)/2;
Modulated_LED=Modulated_LED';

end