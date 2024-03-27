import re
import sys

key = ''
seq = ''
seqdict = {}
with open(sys.argv[1], "r") as infile:
    for line in infile:
        if line.startswith(">"):
            if key != '':
                key = listall[0].rstrip()
            else:
                seqdict[key] = seq
                seq = ''
                listall = re.split("\s", line)
                key = listall[0].rstrip()
        else:
            seq += line.rstrip()
    seqdict[key] = seq
print(seqdict)

with open(sys.argv[1], "w") as outfile:
    for i in seqdict:
        if i != '':
            outfile.write("{}\n{}\n".format(i, seqdict[i]))
