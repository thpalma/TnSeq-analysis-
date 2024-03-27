rule all:
    input:
        "anvi.genomes"


rule download:
    output:
        "genomes.downloaded"
    shell:
        """
        mkdir -p refseq && cd refseq
        ncbi-genome-download --genera "Haemophilus parainfluenzae" --assembly-levels complete --formats fasta bacteria
        touch genomes.downloaded
        """

rule get_core:
    input:
        el = "EL1.fna",
        atcc = "hpara.fna",
        el_g = "EL1_core.txt",
        atcc_g = "atcc_core.txt",
        genomes_downloaded = "genomes.downloaded"
    output:
        el_c = "refseq/bacteria/EL1_core.fna",
        atcc_c = "refseq/bacteria/atcc_core.fna"
    shell:
        """
        sed -i "s/|/_/g" {input.el_g}
        sed -i "s/|/_/g" {input.atcc_g}
        python scripts/get_seqs_effic.py --in {input.el} --seq {input.el_g} --out {output.el_c}
        python scripts/get_seqs_effic.py --in {input.atcc} --seq {input.atcc_g} --out {output.atcc_c}
        """

rule prep_genomes:
    input:
        g = "genomes.downloaded",
        el_c = "refseq/bacteria/EL1_core.fna"
    output:
        "refseq/bacteria/external-genomes.txt"
    shell:
        """
        cd refseq
        cd bacteria
        ls */*.gz > filenames.tsv
        while read p; do cp ${{p}} ./ ; done < filenames.tsv
        ls *.gz > filenames.tsv
        sed -i "s/\.gz//g" filenames.tsv
        while read p; do gunzip -c ${{p}}.gz > ${{p}}; done < filenames.tsv
        ls *.fna > filenames.tsv
        sed -i "s/\.fna//g" filenames.tsv
        while read p; do anvi-script-reformat-fasta ${{p}}.fna -o ${{p}}_pan; done < filenames.tsv
        while read p; do python ../../scripts/clean_deflines.py ${{p}}_pan; done < filenames.tsv
        while read p; do anvi-gen-contigs-database -f ${{p}}_pan -o ${{p}}_pan.db -n ${{p}}_pan -T 4; done < filenames.tsv
        while read p; do echo "<(sed "s/\./_/g" ${{p}}) ${{p}}_pan.db" >> external-genomes.txt; done < filenames.tsv
        gsed -i "s/\.1 /\t/g" external-genomes.txt
        gsed -i "s/\.2 /\t/g" external-genomes.txt
        """
        #manually do this
        #while read p; do echo "<(sed "s/\./_/g" ${{p}}) ${{p}}_pan.db" >> external-genomes.txt; done < filenames.tsv
        #sed -i "s/\.1 /\t/g" external-genomes.txt
        #sed -i "s/\.2 /\t/g" external-genomes.txt
        #"""

rule run_anvi:
    input:
        "refseq/bacteria/external-genomes.txt"
    output:
        "anvi.genomes"
    shell:
        """
        sed -i "s/ /\t/g" {input}
        echo 'name\tcontigs_db_path' > external_2.txt
        cat external_2.txt {input} > refseq/bacteria/external_3.txt
        anvi-gen-genomes-storage -e refseq/bacteria/external_3.txt -o haemophilus_p-GENOMES.db
        anvi-pan-genome -g haemophilus_i-GENOMES.db --project-name "haemophilus_i_pangenome" --output-dir haemophilus_i_output --num-threads 4
        
        touch anvi.genomes
        """

# convert the contigs databases to a genomes database
#anvi-gen-genomes-storage -e external-genomes.txt -o haemophilus_i-GENOMES.db
# run the pangenome pipeline
#anvi-pan-genome -g haemophilus_i-GENOMES.db --project-name "haemophilus_i_pangenome" --output-dir haemophilus_i_output --num-threads 4
#anvi-display-pan -p haemophilus_i_output/haemophilus_i_pangenome-PAN.db -g haemophilus_i-GENOMES.db


###
# To Launch ANVIO
###

# anvi-display-pan -p haemophilus_p_output/haemophilus_p_pangenome-PAN.db -g haemophilus_p-GENOMES.db
# Navigate to http://127.0.0.1:8080/
