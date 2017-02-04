# coding: utf8
#!/usr/bin/env python

import sys

def format_count_words(filename, out_file):
	fic     = open(filename, "r")
	fic_res = open(out_file, "w")

	tmp = []
	for line in fic:
		nb = line.split(' ')[0]
		tmp.append(nb)

	fic_res.write("n\n")
	for i in range(len(tmp)):
		fic_res.write(tmp[i])
		fic_res.write('\n')

	fic.close()
	fic_res.close()

def count_sys_time(filename, out_file):
	fic     = open(filename, "r")
	fic_res = open(out_file, "w")

	user_time = []
	sys_time  = []
	real_time = []
	for line in fic:
		if line[0:3] == "sys":
			millisec = calcul_ms(line)
			sys_time.append(millisec)
		elif line[0:4] == "user":
			millisec = calcul_ms(line)
			user_time.append(millisec)
		elif line[0:4] == "real":
			millisec = calcul_ms(line)
			real_time.append(millisec)

	total_time = []
	for i in range(len(user_time)):
		total_time.append(user_time[i] + sys_time[i])

	avg = 0.
	nb  = 0.
	fic_res.write("user,sys,real\n")
	for i in range(len(total_time)):
		fic_res.write(str(user_time[i]) + "," + str(sys_time[i]) + "," + str(real_time[i]))
		fic_res.write('\n')
		avg += total_time[i]
	avg /= float(len(total_time))


	fic_res.close()
	fic.close()
	return avg

def calcul_ms(data):
	res           = data.split()
	processed     = res[1].split('m')
	processed[1]  = processed[1][0:-1]
	minute        = float(processed[0])
	seconde       = float(processed[1])

	return ((minute * 60) + seconde) * 1000


if __name__ == '__main__':
	infile1 = sys.argv[1]
	outfile1 = sys.argv[2]
	infile2 = sys.argv[3]
	outfile2 = sys.argv[4]
	res = count_sys_time(infile1, outfile1)
	format_count_words(infile2, outfile2)
	print "Avg time =", res, "ms"
