# Repository for my BSc Thesis

This repository contains the configuration files and scripts used in my thesis: *"In-depth analysis of various shotgun metagenomics bioinformatics methods and gut microbiome characterization in mother and neonatal sepsis patients."*. **[Presentation slide](https://github.com/tnmquann/thesis_bsc_hcmus2019/blob/main/%5BBScThesis%5D19180142%20-%20quantnm.pdf)**

> TL;DR: Among the tools evaluated, `yacht` provided the best results.
**
## Description

The tools I evaluated include:
* [Kraken 2 v2.1.1](https://github.com/DerrickWood/kraken2)
* [MetaPhlAn 3 v3.0.9](https://github.com/biobakery/MetaPhlAn)
* [mOTUs2 v2.6.1](https://github.com/motu-tool/mOTUs)
* [sourmash v4.8.6](https://github.com/sourmash-bio/sourmash)
* [yacht v1.2.2](https://github.com/KoslickiLab/YACHT)

This repository includes the following directories:
* `conda_config`: Contains YAML configuration files for creating conda environments for the evaluated tools.
* `data`: Contains the metadata for the Tourlousse dataset used in the thesis.
* `scripts`: Contains the scripts used in the thesis, organized into:
    * `analysis`: Quarto files (*.qmd) written in R v4.3.2 for analyzing and visualizing results from the evaluated tools and clinical data.
    * `benchmarking`: Written in Python 3.10 and bash, includes:
      * `classification`: Evaluates the performance of tools in classifying shotgun metagenomics data.
      * `process_taxo_results`: Processes taxonomic classification results.
      * `running`: Scripts for preprocessing, quality control, and running the evaluated tools.

Other tools and data used include:
* Data:
  * mOTUs2: db_mOTU_v2.6.1
  * MetaPhlAn 3: mpa_v31_CHOCOPhlAn_201901
  * Kraken 2: NCBI RefSeq Complete V205 100 GB
  * bracken: k2_standard_20210517
  * sourmash and yacht: gtdb-rs207.genomic-reps.dna.k31
* Supporting tools:
  * [KrakenTools](https://github.com/jenniferlu717/KrakenTools)
  * [BBMap](https://sourceforge.net/projects/bbmap/)

## Steps to Follow

### Download Tourlousse data and Reference Databases
- Download Tourlousse metadata from [here](https://0-www-ncbi-nlm-nih-gov.brum.beds.ac.uk/Traces/study/?acc=PRJNA747117&o=acc_s:a).
- Get Tourlousse sequence data from [here](https://www.ebi.ac.uk/ena/browser/view/PRJNA747117).
- Follow the respective tool instructions to obtain reference data.
> **Tip**: I used [ENAdatabase-Downloader](https://github.com/tnmquann/ENAdatabase-Downloader) version 2 to download data from ENA. It took approximately 5 hours to download the Tourlousse data.

## Create Conda Environment
* Use the YAML files in the `conda_config` directory. Two main configurations are used: `quantnm_sourmashv4` (for yacht and sourmash) and `quantnm_Tourlousse2022` (for other tools).
* Create a conda environment using the command:
```bash
conda env create -f <path_to_yaml_file>
```
> **Tip**: Use **mamba** instead of conda for creating and solving environment **faster** (It took me 4 months to find a faster way to solve the environment, trust me bro :) ).

### Install supporting tools (if necessary)
  * [KrakenTools v1.2](https://github.com/jenniferlu717/KrakenTools)
  * [BBMap v38.82](https://sourceforge.net/projects/bbmap/files/)

### Conduct evaluations
1. Use the scripts in `scripts/benchmarking/running` to run the evaluated tools.
2. Use the scripts in `scripts/benchmarking/process_taxo_results` to process the results.
3. Use the scripts in `scripts/benchmarking/classification` and `scripts/analysis` to evaluate and visualize the performance of the tools.

## How to Cite
```
@misc{tnmquann_bsc_thesis,
  author = {Minh-Quan Ton-Ngoc},
  title = {tnmquann/{{thesis_bsc_hcmus2019}}: Repository for BSc thesis},
  urldate = {2024-06-28},
  howpublished = {\url{https://github.com/tnmquann/thesis_bsc_hcmus2019}},
}
```

## Author Information
```
Ton Ngoc Minh Quan
minhquan.tdn.ct1619@gmail.com
Page updated on 28/06/2024
```
