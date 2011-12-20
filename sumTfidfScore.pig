-- sumTfidfScore.pig

/*
Joins a list of user id, word, and score with a shorter list of user id.
For the subset of users on the smaller list, calculates the
sum of all the scores per word. That is, if a word appears on two user
list with a score of 1.2 and 1.5, the output will have that word scored
with 2.7

pig -p term=freq="<path to term freq>" -p user_id="<path to user id>" -p outpath="<outpath>" sumTfidfScore.pig

*/

A = LOAD '$term_freq' AS (id:int, word:chararray, score:float);
B = LOAD '$user_id' as (b_id:int);  
C = JOIN B BY b_id, A BY id;
D = GROUP C BY word;   
E = FOREACH D GENERATE group, FLATTEN(C);
F = FOREACH E GENERATE group, score;
G = GROUP F by group;
H = FOREACH G GENERATE group, SUM(F.A::score);                    
I = ORDER H BY $1 DESC;
STORE I INTO '$outpath';
