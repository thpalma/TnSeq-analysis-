#!/usr/bin/env python
import csv
import argparse
import re

seq_parser = argparse.ArgumentParser(description='takes a gene call input and generates all possible missed UTRs from the sequence')
seq_parser.add_argument('--in', dest='input_file', type=str, help='enter the input gene calls')
seq_parser.add_argument('--seq', dest='seq', type=str, help='list genes you want to extract')
seq_parser.add_argument('--out', dest='output_file', type=str, help='enter the output file name')
seq_args = seq_parser.parse_args()

sequences = []
with open(seq_args.seq, 'r') as infile:
    for line in infile:
        key = re.split('\s', line)
        line=line.rstrip()
        sequences.append(key[0])

key=''
sequence=''
seqs={}
with open(seq_args.input_file, 'r') as seq_file:
    for line in seq_file:
        line = line.strip('\n')
        if line.startswith('>'):
            listall=re.split("\s", line)
            key=listall[0]
            sequence=''
        else:
            sequence+=line.rstrip()
        if key[1:] in sequences:
            seqs[key]=sequence
	
with open(seq_args.output_file, 'w') as file2:
    for i in seqs:
        file2.write(i + "\n" + seqs[i] + "\n")
        print("{}\t{}".format(i[1:], seqs[i]))
