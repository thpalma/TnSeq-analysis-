# TnSeq-analysis

Both scripts "TnSeq2.sh" and "Essentiality.R" are used for tranposon sequencing analysis. These scripts were inspired on scriptis generated by the Whitley Lab (https://github.com/WhiteleyLab/Tn-seq)

## TnSeq2
The script "TnSeq2.sh" uses as imput a FASTQ file containing single-end sequencing reads. The reads are originated from the end of the tranposon towards the genome.That way, it is possible to locate the position of the transposon in the genome.
In this script, bowtie2 is used to align the reads to the reference genome. Next, the number insertion sites the most frequent insertion sites are calculated.
Script was modified and inspired on the scripts generated by the Whiteley lab (https://github.com/WhiteleyLab/Tn-seq/blob/master/TnSeq2.sh)

Usage: ./TnSeq.sh [-g <ref. genome>] <prefix>
<ref. genome> - Indicates the directory where the files for the reference genome is located. The folder shoudl have bowtie2 references and genome annotation in GFF format. For instance, file Hp.gff and Hp.1.bt2, etc. should be inside the folder.
<prefix> - The prefix of the sequence files. If the sequence file is named Hp_1.fastq the prefix is "Hp_1". 

  ## Essentiality.R
  
The script "Essentiality.R" returns a table identifying essential genes using a Monte Carlo simulation-based approach for mariner transposons that insert at TA-sites. This script was inspired by the codes from the Whitley Lab (https://github.com/WhiteleyLab/Tn-seq/blob/master/TnSeqDESeq2Essential_mariner.R)

Date: June 7, 2023
Author: Thais Harder de Palma - University of Rhode Island, M. Ramsey lab.

# Anvio pangenome analysis

The Snakefile in this directory dictates running the anvio pangenome pipeline with standard settings.
Prior to the Anvi'o pipeline, steps are taken to download Haemophilus parainfluenzae genomes and 
organize them for analysis.

This Snakemake workflow follows the workflow seen here:
https://merenlab.org/2016/11/08/pangenomics-v2/

EL1.fa contains the genome for the EL1 strain
hpara.fa contains the fenome for the atcc strain
atcc_core.txt contains sequence names for the core genome of the atcc strain
EL1_core.txt contains sequence names for the core genome of the EL1 strain

