#!/usr/bin/env python3

import sys, re, glob, math

count = {}
nWords = {}
logProb = {}
totProb = {}

for file in sorted(glob.glob("lyrics/*.txt")):
   name = re.sub('lyrics/', '', file)
   name = re.sub('\.txt', '', name)
   name = re.sub('_', ' ', name)

   count[name] = {}
   logProb[name] = {}

   for line in open(file):
      line = str.lower(line)
      words = re.split('[^a-zA-Z]+', line)
      for word in words:
         if word:
            nWords[name] = nWords.get(name, 0) + 1
            count[name][word] = count[name].get(word, 0) + 1

   for word in sorted(count[name]):
      logProb[name][word] = math.log((count[name][word]+1)/nWords[name])

   #print("%s %s %f" % (name,word,logProb[name][word]))

for song in sys.argv[1:]:
   for name in count:
      totProb[name] = 0

   for line in open(song):
      line = str.lower(line)
      words = re.split('[^a-zA-Z]+', line)
      for word in words:
         if word == '':
            #print("STOP")
            continue
         for name in logProb:
            if word in logProb[name]:
               totProb[name] = totProb.get(name,0) + logProb[name][word]
            else:
               totProb[name] = totProb.get(name,0) + math.log(1/nWords[name])

   
   for name in totProb:
      #print("%s: log_probability of %.1f for %s" % (song,totProb[name],name))

      if ('best' not in locals() or totProb[name] > totProb[best]):
         best = name

   print("%s most resembles the work of %s (log-probability=%.1f)" % (song,best,totProb[best]))

