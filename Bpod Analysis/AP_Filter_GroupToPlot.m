function [GTP,GTPB]=AP_Filter_GroupToPlot(Analysis)
%
%
%function designed by Quentin 2017
GTP={};
GTPB={};
index=0;
switch Analysis.Properties.Behavior

%% For CuedReward Behavior
    case 'CuedReward'
switch Analysis.Properties.Phase
    case 'Training'  %'RewardA' 'Training'
GTP{1,1}='RewExp';
GTP{1,2}={'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
          'NoAnticipLick_CueA_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{2,1}='Cues';
GTP{2,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};
GTP{3,1}='Cues_Licks';
GTP{3,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
          'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
          'AnticipLick_CueB',               {'Cue B','LicksCue'};...
          'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};
GTPB{1,1}='Behavior';
GTPB{1,2}={'Cue_A_reward',                  {'Cue A','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','LicksOutcome'};...
          'Cue_A_omission',                 {'Cue A','Omission'}};
      
          case 'RewardA'  %'RewardA' 'Training'
GTP{1,1}='RewExp';
GTP{1,2}={'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
          'NoAnticipLick_CueA_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{2,1}='Cues';
GTP{2,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};
GTP{3,1}='Cues_Licks';
GTP{3,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
          'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
          'AnticipLick_CueB',               {'Cue B','LicksCue'};...
          'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};
GTPB{1,1}='Behavior';
GTPB{1,2}={'Cue_A_reward',                  {'Cue A','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','LicksOutcome'};...
          'Cue_A_omission',                 {'Cue A','Omission'}};
      
    case 'RewardB'
GTP{1,1}='RewExp';        
GTP{1,2}={'AnticipLick_CueB_Reward',        {'Cue B','LicksCue','Reward','LicksOutcome'};...
          'NoAnticipLick_CueB_Reward',      {'Cue B','LicksCueInv','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{2,1}='Cues';
GTP{2,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};
GTP{3,1}='Cues_Licks';
GTP{3,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
          'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
          'AnticipLick_CueB',               {'Cue B','LicksCue'};...
          'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};  
GTPB{1,1}='Behavior';
GTPB{1,2}={'Cue_B_reward',                  {'Cue B','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','LicksOutcome'};...
          'Cue_B_omission',                 {'Cue B','Omission'}};
    
    case 'RewardAPunishBValues'
GTP{1,1}='RewExp';
GTP{1,2}={'CueA_Reward',                    {'Cue A','Reward','LicksOutcome'};...
          'CueB_Reward',                    {'Cue B','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{2,1}='RewExp2';
GTP{2,2}={'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
          'NoAnticipLick_CueB_Reward',      {'Cue B','LicksCueInv','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{3,1}='PunExp';
GTP{3,2}={'AnticipLick_CueA_Punish',        {'Cue A','LicksCue','Punish'};...
          'NoAnticipLick_CueB_Punish',      {'Cue B','LicksCueInv','Punish'};...
          'Uncued_Punish',                  {'Uncued','Punish'}};  
GTP{4,1}='Cues';
GTP{4,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};
GTP{5,1}='Cues_Licks';
GTP{5,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
          'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
          'AnticipLick_CueB',               {'Cue B','LicksCue'};...
          'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};
GTPB{1,1}='Behavior_Reward';
GTPB{1,2}=GTP{1,2};
    
    case 'RewardBPunishAValues'
GTP{1,1}='RewExp';
GTP{1,2}={'CueA_Reward',                    {'Cue A','Reward','LicksOutcome'};...
          'CueB_Reward',                    {'Cue B','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{2,1}='RewExp2';
GTP{2,2}={'NoAnticipLick_CueA_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome'};...
          'AnticipLick_CueB_Reward',        {'Cue B','LicksCue','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{3,1}='PunExp';
GTP{3,2}={'NoAnticipLick_CueA_Punish',      {'Cue A','LicksCueInv','Punish'};... 
          'AnticipLick_CueB_Punish',        {'Cue B','LicksCue','Punish'};...
          'Uncued_Punish',                  {'Uncued','Punish'}};
GTP{4,1}='Cues';
GTP{4,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};
GTP{5,1}='Cues_Licks';
GTP{5,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
          'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
          'AnticipLick_CueB',               {'Cue B','LicksCue'};...
          'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};  
GTPB{1,1}='Behavior_Reward';
GTPB{1,2}=GTP{1,2};
      
    case 'RewardACBValues'
GTP{1,1}='Cues';
GTP{1,2}={'CueA',                           {'Cue A'};...
          'CueB',                           {'Cue B'};...
          'CueC',                           {'Cue C'}}; 
GTP{2,1}='Rewards';
GTP{2,2}={'CueA_Rew',                       {'Cue A','Reward','LicksOutcome'};...
          'CueB_Rew',                       {'Cue B','Reward','LicksOutcome'};...
          'CueC_Rew',                       {'Cue C','Reward','LicksOutcome'}};        

end

%% For GoNogo behavior
    case 'GoNogo'
index=index+1;
GTP{index,1}='CueAvsCueB_EasyTrials';
GTP{index,2}={'CueA_Go_Hit',                    {'type_1','Go'};...
          'CueA_Go_Miss',                   {'type_1','Nogo'};...
          'CueB_Nogo_CorrectRej',           {'type_2','Nogo'};...
          'CueB_Nogo_FalseAlarm',           {'type_2','Go'}}; 
index=index+1;
GTP{index,1}='CueA_Run';
GTP{index,2}={'CueA_Go_Hit_Run',            {'type_1','Go','Run'};...
          'CueA_Go_Hit_NoRun',            	{'type_1','Go','RunInv'};...
          'CueA_Go_Miss_Run',               {'type_1','Nogo','Run'};...
          'CueA_Go_Miss_NoRun',             {'type_1','Nogo','RunInv'}};
index=index+1;
GTP{index,1}='CueB_Run';
GTP{index,2}={'CueB_Nogo_FalseAlarm_Run',      	{'type_2','Go','Run'};...
          'CueB_Nogo_FalseAlarm_NoRun',    	{'type_2','Go','RunInv'};...
          'CueB_Nogo_CorrectRej_Run',       {'type_2','Nogo','Run'};...
          'CueB_Nogo_CorrectRej_NoRun',     {'type_2','Nogo','RunInv'}};
      index=index+1;
GTP{index,1}='CueA_Pupil';
GTP{index,2}={'CueA_Go_Hit_Pupil',          {'type_1','Go','Pupil','PupilNaN'};...
          'CueA_Go_Hit_noPupil',            {'type_1','Go','PupilInv','PupilNaN'};...
          'CueA_Go_Miss_Pupil',             {'type_1','Nogo','Pupil','PupilNaN'};...
          'CueA_Go_Miss_NoPupil',           {'type_1','Nogo','PupilInv','PupilNaN'}};
      index=index+1;
GTP{index,1}='CueB_Pupil';
GTP{index,2}={'CueB_Nogo_FalseAlarm_Pupil',      	{'type_2','Go','Pupil','PupilNaN'};...
          'CueB_Nogo_FalseAlarm_NoPupil',    	{'type_2','Go','PupilInv','PupilNaN'};...
          'CueB_Nogo_CorrectRej_Pupil',       {'type_2','Nogo','Pupil','PupilNaN'};...
          'CueB_Nogo_CorrectRej_NoPupil',     {'type_2','Nogo','PupilInv','PupilNaN'}};

if Analysis.Properties.nbOfTrialTypes==4
          index=index+1;
GTP{index,1}='CueCvsCueD_HardTrials';
GTP{index,2}={'CueC_Go_Hit',                    {'type_3','Go'};...
            'CueC_Go_Miss',                   {'type_3','Nogo'};...
            'CueD_Nogo_CorrectRej',           {'type_4','Nogo'};...
            'CueD_Nogo_FalseAlarm',           {'type_4','Go'}}; 
      index=index+1;
GTP{index,1}='CueC_Run';
GTP{index,2}={'CueC_Go_Hit_Run',                {'type_3','Go','Run'};...
            'CueC_Go_Hit_NoRun',              {'type_3','Go','RunInv'};
            'CueC_Go_Miss_Run',               {'type_3','Nogo','Run'};...
            'CueC_Go_Miss_NoRun',             {'type_3','Nogo','RunInv'}};
      index=index+1;
GTP{index,1}='CueD_Run';
GTP{index,2}={'CueD_Nogo_FalseAlarm_Run',      	{'type_4','Go','Run'};...
          'CueD_Nogo_FalseAlarm_NoRun',    	{'type_4','Go','RunInv'};
          'CueD_Nogo_CorrectRej_Run',       {'type_4','Nogo','Run'};...
          'CueD_Nogo_CorrectRej_NoRun',     {'type_4','Nogo','RunInv'}};
      index=index+1;
GTP{index,1}='CueC_Pupil';
GTP{index,2}={'CueC_Go_Hit_Pupil',                {'type_3','Go','Pupil','PupilNaN'};...
          'CueC_Go_Hit_NoPupil',              {'type_3','Go','PupilInv','PupilNaN'};
          'CueC_Go_Miss_Pupil',               {'type_3','Nogo','Pupil','PupilNaN'};...
          'CueC_Go_Miss_NoPupil',             {'type_3','Nogo','PupilInv','PupilNaN'}};
      index=index+1;
GTP{index,1}='CueD_Pupil';
GTP{index,2}={'CueD_Nogo_FalseAlarm_Pupil',       {'type_4','Go','Pupil','PupilNaN'};...
          'CueD_Nogo_FalseAlarm_NoPupil',     {'type_4','Go','PupilInv','PupilNaN'};
          'CueD_Nogo_CorrectRej_Pupil',       {'type_4','Nogo','Pupil','PupilNaN'};...
          'CueD_Nogo_CorrectRej_NoPupil',     {'type_4','Nogo','PupilInv','PupilNaN'}};
      
      index=index+1;
GTP{index,1}='CueAvsCueB_CleanPupil';
GTP{index,2}={'CueA_Go_Hit_OKPupil',         {'type_1','Go','PupilNaN'};...
          'CueA_Go_Miss_OKPupil',            {'type_1','Nogo','PupilNaN'};
          'CueB_Nogo_FalseAlarm_OKPupil',    {'type_2','Go','PupilNaN'};...
          'CueB_Nogo_CorrectRej_OKPupil',    {'type_2','Nogo','PupilNaN'}};
      index=index+1;
GTP{index,1}='CueCvsCueD_CleanPupil';
GTP{index,2}={'CueC_Go_Hit_OKPupil',         {'type_3','Go','PupilNaN'};...
          'CueC_Go_Miss_OKPupil',            {'type_3','Nogo','PupilNaN'};
          'CueD_Nogo_FalseAlarm_OKPupil',    {'type_4','Go','PupilNaN'};...
          'CueD_Nogo_CorrectRej_OKPupil',    {'type_4','Nogo','PupilNaN'}};    
end
end
end