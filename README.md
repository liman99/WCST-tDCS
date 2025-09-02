# WCST-tDCS
This repository contains the raw data and processing code for a revised version of the WCST paradigm. Thirty-eight participants were recruited, and both tDCS stimulation and sham stimulation were applied during the experiment, aiming to investigate adaptive cognitive control.

sbject_data_all.xlsx is the raw data.  
sbject_data_proc.xlsx is the cleaned dataset prepared for statistical analysis.
loaddata.m processes the raw data and generates the dataset saved as sbject_data_proc.xlsx.  
check_acc.m evaluates participants’ accuracy across all conditions to identify and exclude those performing below chance level.  
procdata_anova.m performs the statistical analyses.


Table1:The sheet1(data_raw) of column descriptions subject_data_all.xlsx 
| #  | Column               | Description                                                                                                 |
| -- | -------------------- | ----------------------------------------------------------------------------------------------------------- |
| 1  | correct              | Trial-level correctness: 1 = correct, 2 = incorrect                                                         |
| 2  | rt                   | Reaction time in seconds                                                                                    |
| 3  | correct\_PrevTrial   | Previous-trial correctness: 1 = correct, 2 = incorrect                                                      |
| 4  | type\_shift          | Conflict-sequence type: 1 = cC, 2 = iC, 3 = cI, 4 = iI, 9 = special case (early cI/iI or task-switch cI/iI) |
| 5  | type\_shiftPrevTrial | Previous-trial congruency: 1 = congruent (c), 2 = incongruent (i)                                           |
| 6  | type\_shiftCurrTrial | Current-trial congruency: 1 = congruent (C), 2 = incongruent (I)                                            |
| 7  | type\_rule           | Current task rule: 1 = color, 2 = arrow                                                                     |
| 8  | type\_shiftprep      | Rule-shift phase: 0 = rule-switch, 1 = rule-stable, 2 = rule-unstable (with cue), 3 = linking trial         |
| 9  | info\_blockCount     | Mini-block index (1–12); each mini-block contains 9–14 trials                                               |
| 10 | info\_blockLenType   | Block-length type (1–6); six predefined length patterns                                                     |
| 11 | info\_sessionNum     | Session number within the sequence (1–3)                                                                    |
| 12 | sti\_color           | Stimulus color: 1 = red, 2 = green, 3 = blue, 4 = yellow                                                    |
| 13 | sti\_arrow           | Arrow direction: 1 = top-left, 2 = bottom-right, 3 = bottom-left, 4 = top-right                             |
| 14 | sti\_correctAns      | Correct response code for the stimulus                                                                      |
| 15 | type\_cue            | Visual cue condition: 1 = with circle cue, 2 = without circle cue                                           |
| 16 | type\_tDCS           | Brain-stimulation condition: 1 = real tDCS, 2 = sham                                                        |
| 17 | sbjID                | Participant ID                                                                                              |


Table2:The sheet1(datares) of column descriptions subject_data_proc.xlsx 
| #  | Column                  | Description                                                                                                                                                                                                                                                                                                                                         |
| -- | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1  | **acc**                 | Accuracy for the current trial: **1** = correct, **0** = incorrect                                                                                                                                                                                                                                                                                  |
| 2  | **rt**                  | Reaction time for the current trial, in **seconds**                                                                                                                                                                                                                                                                                                 |
| 3  | **RRAdj**               | Speed-accuracy trade-off index                                                                                                                                                                                                                                                                                                                      |
| 4  | **acc\_raw**            | Raw accuracy (i.e., accuracy calculated regardless of the previous trial’s outcome)                                                                                                                                                                                                                                                                 |
| 5  | **type\_CongSeq**       | Conflict-sequence type for the current trial based on the combination of the previous and current trial congruency:  <br> 1 = cC (previous congruent → current congruent)  <br> 2 = iC (previous incongruent → current congruent)  <br> 3 = cI (previous congruent → current incongruent)  <br> 4 = iI (previous incongruent → current incongruent) |
| 6  | **type\_congPreTrial**  | Congruency of the **previous** trial:  <br> 1 = congruent (c)  <br> 2 = incongruent (i)                                                                                                                                                                                                                                                             |
| 7  | **type\_congCurrTrial** | Congruency of the **current** trial:  <br> 1 = congruent (C)  <br> 2 = incongruent (I)                                                                                                                                                                                                                                                              |
| 8  | **type\_rule**          | Task rule:  <br> 1 = color rule  <br> 2 = arrow rule                                                                                                                                                                                                                                                                                                |
| 9  | **type\_shiftprep**     | Rule-shift phase:  <br> 1 = rule-stable period  <br> 2 = rule-unstable period (with cue)                                                                                                                                                                                                                                                            |
| 10 | **type\_cue**           | Visual cue condition:  <br> 1 = with circle cue  <br> 2 = without circle cue                                                                                                                                                                                                                                                                        |
| 11 | **type\_tDCS**          | Brain stimulation condition:  <br> 1 = real stimulation  <br> 2 = sham (control)                                                                                                                                                                                                                                                                    |
| 12 | **sbjID**               | Participant ID                                                                                                                                                                                                                                                                                                                                      |


Table3:The sheet2(datares_inte) of column descriptions for subject_data_proc.xlsx 
| #  | Column               | Description                                                                                      |
| -- | -------------------- | ------------------------------------------------------------------------------------------------ |
| 1  | accConflict\_PrevC   | Conflict effect on accuracy when the previous trial was congruent: accuracy(cC) − accuracy(cI)   |
| 2  | accConflict\_PrevI   | Conflict effect on accuracy when the previous trial was incongruent: accuracy(iC) − accuracy(iI) |
| 3  | accCSE               | Accuracy-based conflict serial effect: accConflict\_PrevC − accConflict\_PrevI                   |
| 4  | rtConflict\_PrevC    | Conflict effect on RT when the previous trial was congruent: RT(cI) − RT(cC)                     |
| 5  | rtConflict\_PrevI    | Conflict effect on RT when the previous trial was incongruent: RT(iI) − RT(iC)                   |
| 6  | rtCSE                | RT-based conflict serial effect: rtConflict\_PrevC − rtConflict\_PrevI                           |
| 7  | RRadjConflict\_PrevC | Integrated-efficiency conflict effect when the previous trial was congruent                      |
| 8  | RRadjConflict\_PrevI | Integrated-efficiency conflict effect when the previous trial was incongruent                    |
| 9  | RRadjCSE             | Integrated-efficiency conflict serial effect: RRadjConflict\_PrevC − RRadjConflict\_PrevI        |
| 10 | type\_rule           | Task rule: 1 = color, 2 = arrow                                                                  |
| 11 | type\_shiftprep      | Rule phase: 1 = rule-stable, 2 = rule-unstable                                                   |
| 12 | type\_cue            | Visual cue: 1 = with circle, 2 = without circle                                                  |
| 13 | type\_tDCS           | Stimulation: 1 = real, 2 = sham                                                                  |
| 14 | sbjID                | Participant ID                                                                                   |
