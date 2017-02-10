#!/bin/bash
#Pour lancer avec l'optimisation de gcc
gcc -o markov_counters -O3 markov.c
#Pour lancer sans l'optimisation de gcc
#gcc -o markov_counters markov.c

exp='plan_expe/'
res_algo='resultat.txt'
if [ "$1" != "" ]; then
    it=$1
else
    it=100
fi

truncate -s 0 "plan_expe/all_data.csv"

for name in "madame-bovary" "zadig" "don-quixote"
do
	for k in 2 3 4 5 6 7
	do
		for m in 1000 10000 100000 500000
		do
			prefix=$name$k$m
			rawtime=$prefix'_rawtime.txt'
			countersfile=$exp$prefix'_counters.txt'
			nbwordsraw=$exp$prefix'_nb_words_raw.txt'
			nbwordsprocessed=$exp$prefix'_nb_words.txt'
			datafile=$exp$prefix'_param.txt'

			truncate -s 0 $rawtime
			truncate -s 0 $countersfile
			truncate -s 0 $nbwordsraw

			# echo "count1,count2,coutn3" &>> $countersfile
			# echo "k,m" &>> $datafile

			for i in $(seq "$it")
			do
				echo "Iteration $i"
				(time ./markov_counters $k $m $countersfile <$name'.txt' >$res_algo) &>> $rawtime
				wc -w $name'.txt' &>> $nbwordsraw
				echo "$k,$m" &>> $datafile
			done
			#Script python qui traite les fichiers de temps et de "count" pour les rendre utilisable
			python script_count.py $rawtime $exp$prefix'_timetable.txt' $nbwordsraw $nbwordsprocessed
			#Nettoyage des dossiers
			rm $rawtime
			rm $nbwordsraw
			sleep 0.1
		done
	done
done

echo "Traitement Python en cours..."

#Script pyhton qui permet de construire le fichiers csv final contenant toutes les informations.
python parse_data_files.py

#Nettoyage des dossiers
tmp="*.txt"
tmp2="*_data.csv"
rm $exp$tmp
rm $exp$tmp2

echo "Traitement Python Terminé !"
