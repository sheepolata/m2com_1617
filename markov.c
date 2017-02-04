/* Copyright (C) 1999 Lucent Technologies */
/* From 'Programming Pearls' by Jon Bentley */

/* markov.c -- generate random text from input document
	Usage: markov k m  <text.in  >text.out

        k: number of words per phrase
        m: number of words to print

	History
	  Original from 'Programming Pearls' by Jon Bentley
	  Modified 6 May 2005 by ccm
		Change k and m from compile time to command line inputs
		Change output from one word per line to many per line
	  Modified 15 August 2005 ccm
	         Add srand to initialize rng with system time
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

char inputchars[4500000];
char *word[800000];
int nword = 0, linelen = 0, k;
int m;
clock_t startingTime, endingTime;
unsigned long count1 = 0;
unsigned long count2 = 0;
unsigned long count3 = 0;

/* word comparison */
int wordncmp(char *p, char* q)
{
  int n = k;
  for ( ; *p == *q; p++, q++)
    if (*p == 0 && --n == 0)
      return 0;
  return *p - *q;
}

/* called by system qsort */
int sortcmp(const void * p, const void * q)
{
  char ** p1 = (char**) p;
  char ** q1 = (char**) q;
  count1++;
  return wordncmp(*p1, *q1);
}

/* skip over words in text */
char *skip(char *p, int n)
{
  for ( ; n > 0; p++)
    if (*p == 0)
      n--;
  return p;
}

/* print a word */
void writeword(char *s)
{
  int len = strlen(s);
  if (linelen + len > 70) {
    printf("\n");
    linelen = 0;
  } else {
    printf(" ");
  }
  linelen += len + 1;
  printf("%s", s);
}

int main(int argc, char* argv[])
{
  int i, wordsleft, lo, mid, up;
  char *phrase, *p;

  startingTime = clock();
  char* out_time_file = argv[3];
  k = atoi(argv[1]);
  m = atoi(argv[2]);
  wordsleft = m;

  srand((unsigned) time(0));

  word[0] = inputchars;
  while (scanf("%s", word[nword]) != EOF) {
    /* if(nword <= 50) printf("%s:", word[nword]); */
    word[nword+1] = word[nword] + strlen(word[nword]) + 1;
    nword++;
  }
  for (i = 0; i < k; i++)
    word[nword][i] = 0;
  for (i = 0; i < k; i++)
    printf("%s\n", word[i]);
  qsort(word, nword, sizeof(word[0]), sortcmp);
  phrase = inputchars;
  for ( ; wordsleft > 0; wordsleft--) {
    lo = -1;
    up = nword;
    while (lo+1 != up) {
      mid = (lo + up) / 2;
      count2++;
      if (wordncmp(word[mid], phrase) < 0)
        lo = mid;
      else
        up = mid;
    }
    for (i = 0; wordncmp(phrase, word[up+i]) == 0; i++) {
  		count3++;
	  	if (rand() % (i+1) == 0) p = word[up+i];
    }
    phrase = skip(p, 1);
    if (strlen(skip(phrase, k-1)) == 0)
      break;
    writeword(skip(phrase, k-1));
  }
  printf("\n");

  endingTime = clock();

  // fprintf(stderr, "Appel à wordncmp dans sortcmp (initialisation du tableau word) = %lu\n", count1);
  // fprintf(stderr, "Appel dans le main (recherche dichotomique)                    = %lu\n", count2);
  // fprintf(stderr, "Appel dans le main (choix aléatoire)                           = %lu\n", count3);
  // fprintf(stderr, "Total                                                          = %lu\n", (count1+count2+count3));
  FILE * fic;
  fic = fopen(out_time_file, "a");
  fprintf(fic, "%lu,%lu,%lu\n", count1, count2, count3);
  // fic.close();
  exit(EXIT_SUCCESS);
}



