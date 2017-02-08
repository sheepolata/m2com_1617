#!/bin/bash
gcc -o markov_counters -O3 markov.c

exp='plan_expe/'

# if [ "$1" == "" ]; then
# 	echo "No file name !!"
# 	exit 150
# fi

# filein=$1
# infile_alg=$filein'.txt'
# book=$1
# rawtime=$book'_rawtime.txt'
# countersfile=$exp$book'_counters.txt'
# nbwordsraw=$exp$book'_nb_words_raw.txt'
# nbwordsprocessed=$exp$book'_nb_words.txt'
# datafile=$exp$book'_param.txt'
res_algo='resultat.txt'
if [ "$1" != "" ]; then
    it=$1
else
    it=100
fi

#k=3
#m=1000

truncate -s 0 "plan_expe/all_data.csv"


for name in "madame-bovary" "zadig" "don-quixote"
do
	for k in 2, 3, 4, 5, 6, 7
	do
		for m in 1000, 10000, 100000, 500000
		do
			rawtime=$name'_rawtime.txt'
			countersfile=$exp$name'_counters.txt'
			nbwordsraw=$exp$name'_nb_words_raw.txt'
			nbwordsprocessed=$exp$name'_nb_words.txt'
			datafile=$exp$name'_param.txt'

			truncate -s 0 $rawtime
			truncate -s 0 $countersfile
			truncate -s 0 $nbwordsraw

			echo "count1,count2,coutn3" &>> $countersfile
			echo "k,m" &>> $datafile

			for i in $(seq "$it")
			do
				echo "Iteration $i"
				(time ./markov_counters $k $m $countersfile <$name'.txt' >$res_algo) &>> $rawtime
				wc -w $name &>> $nbwordsraw
				echo "$k,$m" &>> $datafile
			done

			python script_count.py $rawtime $exp$name'_timetable.txt' $nbwordsraw $nbwordsprocessed
			rm $rawtime
			rm $nbwordsraw
		done
	done
done

tmp="*.txt"
python parse_data_files.py
rm $exp$tmp	
