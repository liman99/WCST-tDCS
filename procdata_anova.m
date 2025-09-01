
clear all

currpath=pwd;

sbjexclude=[10 36 15 30];
outfolder='process_250901_final';

mkdir(outfolder);

datafname='subject_data_proc.xlsx';
datares=table2array(readtable(datafname,'Sheet','datares'));
datares_inte=table2array(readtable(datafname,'Sheet','datares_inte'));
% load sbjdata datares datares_inte

% % datares:
% #1: acc
% #2: rt
% #3: RRAdj
% #4: acc raw (not considering the correctness of previous trial)
% #5: type_shift [1 2 3 4], 1: cC; 2: iC; 3: cI; 4: iI;
% #6: type_shift_PrevTrial [1 2], 1: c; 2: i                        **
% #7: type_shift_CurrTrial [1 2], 1: C; 2: I                        **
% #8: type_rule [1,2], 1: 颜色; 2: 箭头                             # separate
% #9: type_shiftprep [1,2], 1: 规则稳定期；2：规则不稳定期（有提示）   # separate
% #10: CueType [1,2], 1, with circle; 2, without circle             **
% #11: tDCS type [1,2], 1: real; 2: sham                            **
% #12: sbjID                                                        ** random

pos.congprev=6;
pos.congcurr=7;
pos.rule=8;     % separate
pos.period=9;   % separate
pos.cue=10;
pos.tDCS=11;
pos.sbj=12;
varmat={'CongPrev','CongCurr','BlockCue','tDCS','sbj';
        pos.congprev,pos.congcurr,pos.cue,pos.tDCS,pos.sbj};
ymat={'acc','rt','RRAdj'};
[res_4way,res_3way_tDCS,res_3way_sham]=procanova(datares,pos,varmat,ymat,sbjexclude);

% % datares_inte:
% #1: accConflict_PrevC
% #2: accConflict_PrevI
% #3: accCSE
% #4: rtConflict_PrevC
% #5: rtConflict_PrevI
% #6: rtCSE
% #7: RRadjPrevC
% #8: RRadjPrevI
% #9: RRadjCSE
% #10: type_rule [1,2], 1: 颜色; 2: 箭头                             # separate
% #11: type_shiftprep [1,2], 1: 规则稳定期；2：规则不稳定期（有提示）  # separate
% #12: CueType [1,2], 1, with circle; 2, without circle             * cue
% #13: tDCS type [1,2], 1: real; 2: sham                            * tDCS
% #14: sbjID                                                        * random

pos.rule=10;     % separate
pos.period=11;   % separate
pos.cue=12;
pos.tDCS=13;
pos.sbj=14;
varmat={'BlockCue','tDCS','sbj';
        pos.cue,pos.tDCS,pos.sbj};
ymat={  'accConflict_PrevC','accConflict_PrevI','accCSE',...
        'rtConflict_PrevC','rtConflict_PrevI','rtCSE',...
        'RRAdjConflict_PrevC','RRAdjConflict_PrevI','RRAdjCSE'};
[resInte_2way,resInte_1way_tDCS,resInte_1way_sham]=procanova(datares_inte,pos,varmat,ymat,sbjexclude);


cd(outfolder)
save statres res_* resInte_* sbjexclude datares datares_inte
cd(currpath)



function [res_all,res_tDCS,res_sham]=procanova(datain,pos,varmat,ymat,sbjexclude)
    sbjsel=all(datain(:,pos.sbj)~=sbjexclude,2);
    
    res_all=struct;
    res_sham=struct;
    res_tDCS=struct;
    for color_arrow=1:2
        for type_shiftprep=1:2
            validcond=datain(:,pos.rule)==color_arrow&datain(:,pos.period)==type_shiftprep;
            res_all(color_arrow,type_shiftprep).data=anova_self(datain(sbjsel&validcond,:),varmat,ymat);
            res_all(color_arrow,type_shiftprep).info=sprintf('color_arrow: %d; type_shiftprep: %d',color_arrow,type_shiftprep);
    
            validcond=datain(:,pos.rule)==color_arrow&datain(:,pos.period)==type_shiftprep&datain(:,pos.tDCS)==1;
            res_tDCS(color_arrow,type_shiftprep).data=anova_self(datain(sbjsel&validcond,:),varmat(:,[1:end-2,end]),ymat);
            res_tDCS(color_arrow,type_shiftprep).info=sprintf('color_arrow: %d; type_shiftprep: %d',color_arrow,type_shiftprep);

            validcond=datain(:,pos.rule)==color_arrow&datain(:,pos.period)==type_shiftprep&datain(:,pos.tDCS)==2;
            res_sham(color_arrow,type_shiftprep).data=anova_self(datain(sbjsel&validcond,:),varmat(:,[1:end-2,end]),ymat);
            res_sham(color_arrow,type_shiftprep).info=sprintf('color_arrow: %d; type_shiftprep: %d',color_arrow,type_shiftprep);
        end
    end
end

function tblres=anova_self(datatmp,varmat,ymat)
    tblres=cell(length(ymat),2);
    for yind=1:length(ymat)
        yvar=datatmp(:,yind);
        xvar=cell(1,size(varmat,2));
        for nn=1:length(xvar)
            xvar{nn}=datatmp(:,varmat{2,nn});
        end
        [~,tbl]=anovan(yvar,xvar,'random',length(xvar),'model','full','varnames',varmat(1,:),'display','off');

        tblnew=cell(0);
        for nn=2:size(tbl,1)
            if strcmp(tbl{nn,8},'fixed')
                tblnew=[tblnew;tbl(nn,:)];
            end
        end
        etamat=nan(size(tblnew,1),1);
        for nn=1:size(tblnew,1)
            etamat(nn)=tblnew{nn,5}*tblnew{nn,3}/(tblnew{nn,10}*tblnew{nn,11}+tblnew{nn,5}*tblnew{nn,3});
        end
        titlevar=[tbl(1,[1,3,11,6,7]),{'partial eta squared'}];
        tblfin=[titlevar;tblnew(:,[1,3,11,6,7]),num2cell(etamat)];

        tblres{yind,1}=tblfin;
        tblres{yind,2}=ymat{yind};
    end
end

