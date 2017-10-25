# MAGpy
MAGpy is a Snakemake pipeline for annotating metagenome-assembled genomes (MAGs) (pronounced **mag-pie**)

MAGpy takes as input a directory of FASTA files (with the extension .fa).  Each FASTA file should contain contigs that make up a **M**etagenome-**A**ssembled **G**enome, or MAG.  MAGpy the runs a range of software tools that help annotate and characterise those genomes.  Specifically:

* CheckM is run to characterise genome completeness and contamination
* Sourmash is used to compare the genomes to RefSeq and GenBank genomes
* Prodigal is used to predict protein sequences
* Diamond is used to map the protein sequences against UniProt
* Scripts are run to generate reports from the diamond and sourmash outputs
* Ete3 scripts are used to update taxonomic annotations with full(er) lineages
* PhyloPhlAn is used to generate a tree from the genomes
* GraPhlAn is used to draw the tree using annotations previously generated [not yet implemented]


## Dependencies
* Snakemake (tested with 4.1.0)
* Python (tested with 2.7.5)
* Perl (tested with 5.16.3)
* BioPerl (tested with 1.6.924)
* Ete3 (tested with 3.0.0b36)
* CheckM (tested with 1.0.5)
* HMMER (tested with 3.1b2)
* pplacer (tested with 1.1)
* FastTree (tested with 2.1.10)
* Prodigal (tested with 2.6.3)
* Diamond (tested with 0.8.22)
* Sourmash (tested with 2.0.0a1)
* PhyloPhlAn (tested with 0.99)


## Requirements
* UniProt TrEMBL and/or Swiss-prot, formatted for searching by Diamond
* Sourmash indices for both RefSeq and GenBank genomes

