-- aboveAveScore.pig

/* Loads files with a format id, {(word1, score1), . . . (wordN, scoreN)}, finds the average score for each word,
 * and generates a relation with only the words with above average scores for each id.
 * Output is stored as id, {(id, word1) . . . (id, wordN)}
 * in /<outpath>/above_ave_score/part-r-xxxxx
 *
 * pig -p files="<files to read in>" -p outpath="<path to output>" aboveAveScore.pig
*/

A = LOAD '$files' AS (id:int, tfidf: {T: tuple(word:chararray, score:float)}); 
B = FOREACH A GENERATE id, AVG(tfidf.score) AS ave_score;
D = FOREACH A GENERATE id, FLATTEN(tfidf);
E = JOIN B BY id, D BY id;
F = FILTER E BY score > ave_score;
G = FOREACH F GENERATE B::id AS id, D::tfidf::word as word;
H = GROUP G by id;
STORE H INTO '$outpath/above_ave_score';
