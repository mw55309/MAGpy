# MAGpy
MAGpy is a Snakemake pipeline for annotating metagenome-assembled genomes (MAGs) (pronounced **mag-pie**)

**NOTE MAGpy is in "alpha" status.  We like to release early and often.  MAGpy works on our system and was used in https://doi.org/10.1101/162578 but we cannot guarantee it will work on your system.  We may not have enough resource at present to help you get it to work on your system either, sorry, but we will try**

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
snakemake --cluster-config MAGpy.json --cluster "qsub -cwd -pe sharedmem {cluster.core} -l h_rt= {cluster.time} -l h_vmem={cluster.vmem} -P {cluster.proj}" --jobs 1000
```

This mode looks into the MAGpy.json file for cluster configurations relating to each type of job; the jobs are "rules" within the MAGpy snakefile.


## The integration of PhyloPhlAn

OK, this is a bit complex.  Essentially, PhyloPhlAn has a few foibles, which are:

* input to PhyloPhlAn **has to be** placed in the ```input/``` directory contains within the PhyloPhlAn install directory
* output from PhyloPhlAn is written to the ```output/``` directory within the PhyloPhlAn install directory
* The PhyloPhlAn process **has to be run** from the root of the PhyloPhlAn install directory

Therefore, whatever user is running the MAGpy process, whether it be on a cluster or a single machine, must have read and write access to the ```input/``` and ```output/``` directories in the PhyloPhlAn install directory

Here is what MAGpy attempts to do:

* It attempts to create a symbolic link from the ```input/``` directory to the newly created proteins directory using ```ln -s```
* It then attempts to ```cd``` into the PhyloPhlAn install directory
* From there, it runs PhyloPhlAn
* When finished, it attempts to ```mv``` the results folder back to the original directory (to folder ```tree```)
* MAGpy then changes back to the original working directory

Now obviously this is a bit, erm, hacky but as long as permissions are set on the PhyloPhlAn directory correctly, it should work.


## Abstraction of executables

Here in Edinburgh, access to software on the cluster nodes is controlled by the ```module``` command.  So, if you want to run Samtools it's

```sh
module load samtools

samtools view my.bam
```

This isn't easy to integrate into Snakemake for every command, so what we have done is created a shell script for each software tool we need to use.  The sole purpose of that shell script is to set the correct enviornment for the tool to run, and then to run the tool with the arguments passed to the shell script.

So our shell script for Samtools would be:

```sh
#!/bin/bash

module load samtools

samtools $@
```

(we don't use Samtools, this is just an example!)

So basically, what you need to do is edit the shell scripts such that they set the correct environment for the tool in question and then run the tool on your specific set up.  Then you need to but these in your PATH and MAGpy then runs these shell scripts, rather than the executables themselves. This allows a lot of flexibility for running MAGpy on a range of different set-ups


## Databases and data sources

MAGpy needs to know about the location of various diamond databases, Pfam etc.  You will also need to edit MAGpy to point to these resources.


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
* pfam_scan.pl (tested on 1.6)
* Color::Mix
* BioPython
* GraPhlAn


## Requirements
* UniProt TrEMBL and/or Swiss-prot, formatted for searching by Diamond
* Sourmash indices for both RefSeq and GenBank genomes
* Pfam - needs to be pressed with hmmpress, see pfam_scan.pl help

