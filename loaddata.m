% calculate CSE

clear all


dataall=readtable('subject_data_all.xlsx','Sheet','data_raw');
outfname='sbject_data_proc.xlsx';

sbjlist=unique(dataall.sbjID);

datares=[];
datares_inte=[];
for nnn=1:size(sbjlist,1)             % sbjID
    sbjname=sbjlist(nnn);
    for ind_tDCS=1:2                       % tDCS_type        
        for ind_cue=1:2                     % Day/CueType

            tmpind=dataall.sbjID==sbjlist(nnn)&dataall.type_tDCS==ind_tDCS&dataall.type_cue==ind_cue;
            datasel=dataall(tmpind,:);

            info_session=[ind_cue,ind_tDCS,nnn];         % cue type (1: circle; 2: no circle); tDCS (1: real; 2: sham); sbjID
            alldata=loaddata_sbjcore(datasel);
            
            basemat=repmat(info_session,size(alldata.behres,1),1);
            datares=[datares;alldata.behres,basemat];

            basemat=repmat(info_session,size(alldata.behres_inte,1),1);
            datares_inte=[datares_inte;alldata.behres_inte,basemat];
            
        end
    end
end


% % datares:
% #1: acc
% #2: rt
% #3: acc/rt
% #4: acc raw (not considering the correctness of previous trial)
% #5: type_shift [1 2 3 4], 1: cC; 2: iC; 3: cI; 4: iI;
% #6: type_shift_PrevTrial [1 2], 1: c; 2: i
% #7: type_shift_CurrTrial [1 2], 1: C; 2: I
% #8: type_rule [1,2], 1: color; 2: arrow
% #9: type_shiftprep [1,2], 1: rule stable period; 2: rule unstable period (with cue)
% #10: type_cue [1,2], 1: with circle; 2: without circle
% #11: type_tDCS [1,2], 1: real; 2: sham
% #12: sbjID
datares_varmat={'acc','rt','RRAdj','accRaw','type_CongSeq','type_congPrevTrial','type_congCurrTrial',...
        'type_rule','type_shiftprep','type_cue','type_tDCS','sbjID'};
dataresT=array2table(datares,'VariableNames',datares_varmat);

% % datares_inte:
% #1: accConflict_PrevC
% #2: accConflict_PrevI
% #3: accCSE
% #4: rtConflict_PrevC
% #5: rtConflict_PrevI
% #6: rtCSE
% #7: acc/rt_Conflict_PrevC
% #8: acc/rt_Conflict_PrevI
% #9: acc/rt_CSE
% #10: type_rule [1,2], 1: color; 2: arrow
% #11: type_shiftprep [1,2], 1: rule stable period; 2: rule unstable period (with cue)
% #12: CueType [1,2], 1: with circle; 2: without circle
% #13: tDCS type [1,2], 1: real; 2: sham
% #14: sbjID
datares_inte_varmat={'accConflict_PrevC','accConflict_PrevI','accCSE',...
        'rtConflict_PrevC','rtConflict_PrevI','rtCSE',...
        'RRadjConflict_PrevC','RRadjConflict_PrevI','RRadjCSE',...
        'type_rule','type_shiftprep','type_cue','type_tDCS','sbjID'};
datares_inteT=array2table(datares_inte,'VariableNames',datares_inte_varmat);

writetable(dataresT,outfname,'Sheet','datares');
writetable(datares_inteT,outfname,'Sheet','datares_inte');

function alldata=loaddata_sbjcore(datasel)

% % datasel:
% #1: correct (1: correct; 2: incorrect)
% #2: rt
% #3: correct_PrevTrial
% #4: type_shift ([1:4,9], 1: cC; 2: iC; 3: cI; 4: iI; 9: early cI/iI, and cI/iI during task switching)
% #5: type_shiftPrevTrial [1 2], 1: c; 2: i
% #6: type_shiftCurrTrial [1 2], 1: C; 2: I
% #7: type_rule ([1,2], 1: color; 2: arrow)
% #8: type_shiftprep ([0,1,2], 1: rule stable period; 2: rule unstable period (with cue); 0: rule transition period; 3: connection trial)
% #9: info_blockCount ([1:12], 12 miniblocks, length/trial number range 9-14 (6 types), 2 blocks for each length)
% #10: info_blockLenType ([1:6], 6 types of block length)
% #11: info_sessionNum ([1:3], session number of current sequence, entire column has one value)
% #12: sti_color ([1:4], 4 colors: red, green, blue, yellow)
% #13: sti_arrow ([1:4], 4 arrow directions: upper-left, lower-right, lower-left, upper-right)
% #14: sti_correctAns
% #15: type_cue [1,2], 1: with circle; 2: without circle
% #16: type_tDCS [1,2], 1: real; 2: sham
% #17: sbjID

    type_shift=[1 2 3 4];
    type_rule=[1,2];
    type_shiftprep=[1,2];
    
    behres=[];
    for ind_shift=1:length(type_shift)
        for ind_rule=1:length(type_rule)
            for ind_shiftprep=1:length(type_shiftprep)

                trialvalid0=datasel.type_shift==type_shift(ind_shift)&...
                            datasel.type_shiftprep==type_shiftprep(ind_shiftprep)&...
                            datasel.type_rule==type_rule(ind_rule);

                right=datasel.correct==1;
                rightpre=datasel.correct_PrevTrial==1;
                rtlim=datasel.rt>0.2|isnan(datasel.rt);
                trialvalid=trialvalid0&rightpre&rtlim;
                
                resacc=sum(trialvalid&right)/sum(trialvalid);
                resaccraw=sum(trialvalid0&rtlim&right)/sum(trialvalid0&rtlim);
                resrt=mean(datasel.rt(trialvalid&right));

                % RRAdj
                tmprt=datasel.rt;                   
                tmprt(isnan(datasel.rt))=1;     % duration of target, assumed RT for the missing trial
                tmprt_mean=mean(tmprt(trialvalid));

                RRAdj=resacc/tmprt_mean;

                switch type_shift(ind_shift)
                    case 1 % cC
                        shiftprecurr=[1 1];
                    case 2 % iC
                        shiftprecurr=[2 1];
                    case 3 % cI
                        shiftprecurr=[1 2];
                    case 4 % iI
                        shiftprecurr=[2 2];
                end

                behres=[behres;resacc,resrt,RRAdj,resaccraw,type_shift(ind_shift),shiftprecurr,type_rule(ind_rule),type_shiftprep(ind_shiftprep)];
                                % 1    2        3        4             5               6,  7            8                    9
            end
        end
    end

    behres_inte=[];
    for ind_rule=1:length(type_rule)
        for ind_shiftprep=1:length(type_shiftprep)
            indvalid=behres(:,8)==type_rule(ind_rule)&behres(:,9)==type_shiftprep(ind_shiftprep);

%             tmpmat: 4 (cC, iC, cI, iI) x 2 (acc, rt, RRadj)
            tmpmat=nan(length(type_shift),3);
            for ind_shift=1:length(type_shift)
                tmpmat(ind_shift,:)=behres(indvalid&behres(:,5)==type_shift(ind_shift),1:3);
            end

            accPrevC=tmpmat(1,1)-tmpmat(3,1);
            accPrevI=tmpmat(2,1)-tmpmat(4,1);
            accCSE=accPrevC-accPrevI;

            rtPrevC=tmpmat(3,2)-tmpmat(1,2);
            rtPrevI=tmpmat(4,2)-tmpmat(2,2);
            rtCSE=rtPrevC-rtPrevI;

            RRadjPrevC=tmpmat(1,3)-tmpmat(3,3);
            RRadjPrevI=tmpmat(2,3)-tmpmat(4,3);
            RRadjCSE=RRadjPrevC-RRadjPrevI;            

            behres_inte=[behres_inte;accPrevC,accPrevI,accCSE,rtPrevC,rtPrevI,rtCSE,RRadjPrevC,RRadjPrevI,RRadjCSE,type_rule(ind_rule),type_shiftprep(ind_shiftprep)];
            %                           1        2        3       4       5     6        7          8         9            10                 11
        end
    end
            
    alldata.behres=behres;
    alldata.behres_inte=behres_inte;

end
