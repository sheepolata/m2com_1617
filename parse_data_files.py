# coding: utf8
#!/usr/bin/env python

def getlines(list_file):
	res = []
	for f in list_file:
		line = f.readline()
		if line is None or line == "":
			return 0
		res.append(line)
	return res

def concat_all_files(all_files, file_out):
	res = open(file_out, "w")
	res.write("bookname,n,k,m,count1,count2,count3,user,sys,real\n")
	
	files_openned = []
	for name in all_files:
		files_openned.append(open(name, "r"))

	lines = getlines(files_openned)

	while True:
		lines = getlines(files_openned)
		if lines != 0:
			for i in lines:
				res.write(i)
		else:
			break
		


def concat_one_book(book, files_in, file_out):
	counters = open(files_in[0], "r")
	nbwords = open(files_in[1], "r")
	param = open(files_in[2], "r")
	time = open(files_in[3], "r")

	res = open(file_out, "w")

	res.write("bookname,n,k,m,count1,count2,count3,user,sys,real\n")

	c = counters.readline()
	nbw = nbwords.readline()
	p = param.readline()
	t = time.readline()

	while True:
		c = counters.readline()
		nbw = nbwords.readline()
		p = param.readline()
		t = time.readline()

		if c is None or c == "" or nbw is None or nbw == "" or p is None or p == "" or t is None or t == "": break

		res.write(book + "," + nbw[:-1] + "," + p[:-1] + "," + c[:-1] + "," + t[:-1] + '\n')

	counters.close()
	nbwords.close()
	param.close()
	time.close()

	return file_out


if __name__ == '__main__':
	pre = "plan_expe/"
	books = ["don-quixote", "madame-bovary", "zadig"]
	ext = ["_counters.txt", "_nb_words.txt", "_param.txt", "_timetable.txt"]
	files = []
	for i in range(len(books)):
		tmp = []
		for j in range(len(ext)):
			tmp.append(pre + books[i] + ext[j])
		res = concat_one_book(books[i], tmp, pre + books[i]+"_data.csv")
		files.append(res)
	concat_all_files(files, pre+"all_data.csv")
