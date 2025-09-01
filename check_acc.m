
clear all

datares_lmeT=readtable('subject_data_all.xlsx','Sheet','data_raw');

% % datares_lmeT:
% #1: correct (1: correct; 2: incorrect)
% #2: rt
% #3: correct_PrevTrial
% #4: type_shift ([1:4,9], 1: cC; 2: iC; 3: cI; 4: iI; 9: 早期cI/iI，以及任务切换过程中的cI/iI)
% #5: type_shiftPrevTrial [1 2], 1: c; 2: i
% #6: type_shiftCurrTrial [1 2], 1: C; 2: I
% #7: type_rule ([1,2], 1: 颜色; 2: 箭头)
% #8: type_shiftprep ([0,1,2], 1: 规则稳定期；2：规则不稳定期（有提示）；0：规则转换期；3：连接trial)
% #9: info_blockCount ([1:12], 12个miniblock，长度/trial数范围9-14(6种)，每个长度2个block)
% #10: info_blockLenType ([1:6]，6种block长度类型)
% #11: info_sessionNum ([1:3], 当前序列的session编号，全列是一个值)
% #12: sti_color ([1:4], 4种颜色，红 绿 蓝 黄)
% #13: sti_arrow ([1:4], 4个箭头朝向，左上，右下 左下，右上)
% #14：sti_correctAns
% #15: type_cue [1,2], 1, with circle; 2, without circle
% #16: type_tDCS [1,2], 1: real; 2: sham
% #17: sbjID

sbjlist=unique(datares_lmeT.sbjID);

acclog=nan(length(sbjlist),2);
resmatall=cell(length(sbjlist),1);
for nnn=1:length(sbjlist)
    sbjid=sbjlist(nnn);
    selbase=datares_lmeT.sbjID==sbjid;          % sbjid

    resmat=[];
    for tDCS=1:2
        for shiftprep=1:2
            for rule=1:2
                for congprev=1:2
                    for congcurr=1:2
                        for cueblock=1:2
                            seltmp=...
                                datares_lmeT.type_rule==rule&...
                                datares_lmeT.type_shiftPrevTrial==congprev&...
                                datares_lmeT.type_shiftCurrTrial==congcurr&...
                                datares_lmeT.type_cue==cueblock&...
                                datares_lmeT.type_tDCS==tDCS&...
                                datares_lmeT.type_shiftprep==shiftprep;
        
                            tmpmat=datares_lmeT.correct(selbase&seltmp);
                            resmat=[resmat;sum(tmpmat==1)/sum(selbase&seltmp),sum(tmpmat==1),sum(selbase&seltmp),rule,congprev,congcurr,cueblock,tDCS,shiftprep];
                        end
                    end
                end
            end
        end
    end

    varlist={'acc','correctTrialNum','totalTrialNum','rule','congPrev','congCurr','BlockType','tDCS','shiftprep'};
    resmatall{nnn}=[varlist;num2cell(resmat)];
    acclog(nnn,:)=[sbjlist(nnn),min(resmat(:,1))];    % sbjID, min accuracy of all conditions
end


acclog_SortByMin=sortrows(acclog,[2,1]);

% acclog_SortByMin:
% 10	0.0833333333333333      % low accuracy
% 30	0.111111111111111       % low accuracy
% 36	0.166666666666667       % low accuracy
% 15	0.208333333333333       % low accuracy
% 20	0.250000000000000
% 21	0.250000000000000
% 14	0.291666666666667
% 3	    0.333333333333333
% 11	0.333333333333333
% 25	0.333333333333333
% 26	0.333333333333333
% 16	0.375000000000000
% 19	0.375000000000000
% 9	0.476190476190476
% 7	0.500000000000000
% 32	0.500000000000000
% 6	0.541666666666667
% 17	0.541666666666667
% 38	0.541666666666667
% 4	0.583333333333333
% 12	0.583333333333333
% 13	0.583333333333333
% 22	0.583333333333333
% 31	0.583333333333333
% 34	0.619047619047619
% 37	0.619047619047619
% 8	0.666666666666667
% 23	0.666666666666667
% 24	0.666666666666667
% 27	0.666666666666667
% 28	0.666666666666667
% 29	0.688888888888889
% 5	0.714285714285714
% 2	0.722222222222222
% 33	0.722222222222222
% 35	0.791666666666667
% 1	0.814814814814815
% 18	0.833333333333333