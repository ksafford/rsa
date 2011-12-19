-- topNwords.pig

/* Loads files with a format id, {(word1, score1), . . . (wordN, scoreN)}, finds the
 * average score for each word, and generates a relation with the top N scoring words.
 * Output is stored as id, {(word1, score1) . . . (wordN, scoreN)}
 * in /<outpath>/top-N-words/part-r-xxxxx
 *
 * pig -p files="<files to read in>" -p outpath="<path to output>" -p N="<number of top words>" topNwords.pig
*/

A = LOAD '$files' AS (id:int, tfidf: {T: tuple(word:chararray, score:float)});
B = FOREACH A GENERATE id, TOP($N, 1, tfidf) as topwords;
STORE B INTO '$outpath/top_$N';


