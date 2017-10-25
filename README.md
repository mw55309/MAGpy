# MAGpy
MAGpy is a Snakemake pipeline for annotating metagenome-assembled genomes (MAGs) (pronounced **mag-pie**)

MAGpy takes as input a directory of FASTA files (with the extension .fa).  Each FASTA file should contain contigs that make up a **M**etagenome-**A**ssembled **G**enome, or MAG.  MAGpy then runs a range of software tools that help annotate and characterise those genomes.  Specifically:

* CheckM is run to characterise genome completeness and contamination
* Sourmash is used to compare the genomes to RefSeq and GenBank genomes
* Prodigal is used to predict protein sequences
* Diamond is used to map the protein sequences against UniProt
* Scripts are run to generate reports from the diamond and sourmash outputs
* Ete3 scripts are used to update taxonomic annotations with full(er) lineages
* PhyloPhlAn is used to generate a tree from the genomes
* GraPhlAn is used to draw the tree using annotations previously generated [not yet implemented]

## How to run

Snakemake can be run in basic mode by running:

```sh
snakemake -s /path/to/MAGpy
```

Outputs will be placed into the *current working directory*, so make sure you have write access.

To test which commands snakemake will run, you can try:

```sh
snakemake -np -s /path/to/MAGpy
```

However, on any serious number of MAGs, this basic operation will take a very long time as each job will be run in serial (i.e. one after the other).  However, snakemake has the ability to submit to most HPC clusters.  There are some instructions [here](http://snakemake.readthedocs.io/en/stable/tutorial/additional_features.html#cluster-execution).  

Here at Edinbugh, we run an SGE cluster and this is how we run MAGpy on the cluster:

```sh
snakemake --cluster-config MAGpy.json --cluster "qsub -cwd -pe sharedmem {cluster.core} -l h_vmem={cluster.vmem} -P {cluster.proj}" --jobs 1000
```

This mode looks into the MAGpy.json file for cluster configurations relating to each type of job; the jobs are "rules" within the MAGpy snakefile.


## The integration of PhyloPhlAn

OK, this is a bit complex.  Essentially, PhyloPhlAn has a few foibles, which are:

* input to PhyloPhlAn **has to be** placed in the input/ directory contains within the PhyloPhlAn install directory
* output from PhyloPhlAn is written to the output/ directory within the PhyloPhlAn install directory
* The PhyloPhlAn process **has to be run** from the root of the PhyloPhlAn install directory

Therefore, whatever user is running the MAGpy process, whether it be on a cluster or a single machine, must have read and write access to the input/ and output/ directories in the PhyloPhlAn install directory

Here is what MAGpy attempts to do:

* It attempts to create a symbolic link from the input/ directory to the newly created proteins directory using ```ln -s```
* It then attempts to ```cd``` into the PhyloPhlAn install directory
* From there, it runs PhyloPhlAn
* When finished, it attempts to ```mv``` the output folder back to the original directory
* MAGpy then changes back to the original working directory


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

