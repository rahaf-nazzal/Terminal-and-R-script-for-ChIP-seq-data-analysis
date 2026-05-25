#Terminal script
ssh yourname@login.nemo.thecrick.org
cd ~/home/users/yourname
mkdir nextflow
mkdir genome
cd genome
mkdir Saccharomyces_cerevisiae 
mkdir Candida_glabrata
cd Saccharomyces_cerevisiae
cp -r /nemo/lab/uhlmannf/home/users/xxxxxxx/genome/Saccharomyces_cerevisiae/Bowtie2 ~/home/users/yourname/genome/Saccharomyces_cerevisiae/
cd ~/home/users/yourname/genome/Candida_glabrata
cp -r /camp/home/uhlmannf/home/users/xxxxxxx/genome/Candida_glabrata/Bowtie2 ~/home/users/yourname/genome/Candida_glabrata/
# Nextflow Pipeline, need a samplesheet (CSV) in: /home/users/yourname/nextflow_chip/scripts/date  Samplesheet table with: sample name, fastq_1 file, fastq_2 file, antibody (Scc1-IP), input control sample name (leave blank last 2 columns for input samples)
#alignment

#Create script file:
nano Alignment1_Canglab.sh 
#! /bin/bash
#SBATCH -p ncpu
#SBATCH -c 1
#SBATCH --mem-per-cpu 7G
#SBATCH -t 3-00:00:00
#SBATCH -o nfcore_chip_Alignment1_Canglab_out.txt
#SBATCH -N 1
#SBATCH --mail-type END
#SBATCH --mail-user yourname@crick.ac.uk


#Define
folder='2025-10-20' 
data_output=/nemo/lab/uhlmannf/home/users/yourname/nextflow_chip 
samplesheet_name='SampleSheet_Alignment1.csv' 

if [[ ! -d ${data_output}/${folder} ]]; then
mkdir -p ${data_output}/${folder}/CohesinChIP/Saccharomyces_cerevisiae
mkdir -p ${data_output}/${folder}/CohesinChIP/Candida_glabrata
fi

cp ${data_output}/scripts/${folder}/${samplesheet_name} ${data_output}/${folder}/CohesinChIP/Saccharomyces_cerevisiae/
  cp ${data_output}/scripts/${folder}/${samplesheet_name} ${data_output}/${folder}/CohesinChIP/Candida_glabrata/
  
  #Load modules
  ml purge
ml Nextflow/22.10.3
ml Singularity/3.6.4

#Paths
GENOME_DIR=/nemo/lab/uhlmannf/home/users/yourname/genome/Candida_glabrata/Bowtie2
export NXF_WORK=/flask/scratch/uhlmannf/yourname
export NXF_SINGULARITY_CACHEDIR=/flask/apps/containers/chipseq/${PIPELINE_VERSION}/
  
  export NXF_HOME=/nemo/lab/uhlmannf/home/users/yourname/nextflow

#Run pipeline
nextflow run nf-core/chipseq --input ${data_output}/${folder}/CohesinChIP/Candida_glabrata/${samplesheet_name} --read_length 100 \
--outdir ${data_output}/${folder}/CohesinChIP/Candida_glabrata \
--fasta $GENOME_DIR/C_glabrata_CBS138_current_chromosomes.fasta \
--gff $GENOME_DIR/C_glabrata_CBS138_current_features_with_chromosome_sequences.gff \
-profile crick --email yourname@crick.ac.uk --save_unaligned --aligner bowtie2 -r 2.0.0

#To exit, press Ctrl + X, Now we can run the script.

sbatch Alignment1_Canglab.sh

#Create another script file:

nano Alignment1_Saccer.sh 

#! /bin/bash
#SBATCH -p ncpu
#SBATCH -c 1
#SBATCH --mem-per-cpu 7G
#SBATCH -t 3-00:00:00
#SBATCH -o nfcore_chip_Alignment1_Saccer_out.txt
#SBATCH -N 1
#SBATCH --mail-type END
#SBATCH --mail-user yourname@crick.ac.uk


#Define
folder='2025-10-20' 
data_output=/nemo/lab/uhlmannf/home/users/yourname/nextflow_chip 
samplesheet_name='SampleSheet_Alignment1.csv' 

#Load modules
ml purge
ml Nextflow/22.10.3
ml Singularity/3.6.4

#Paths
GENOME_DIR=/nemo/lab/uhlmannf/home/users/yourname/genome/Saccharomyces_cerevisiae/Bowtie2
export NXF_WORK=/flask/scratch/uhlmannf/yourname
export NXF_SINGULARITY_CACHEDIR=/flask/apps/containers/chipseq/${PIPELINE_VERSION}/
  
  export NXF_HOME=/nemo/lab/uhlmannf/home/users/yourname/nextflow

#Run pipeline
nextflow run nf-core/chipseq --input ${data_output}/${folder}/CohesinChIP/Saccharomyces_cerevisiae/${samplesheet_name} --read_length 100 \
--outdir ${data_output}/${folder}/CohesinChIP/Saccharomyces_cerevisiae \
--fasta $GENOME_DIR/Saccharomyces_cerevisiae.R64-1-1.dna_sm.toplevel.fa \
--gtf $GENOME_DIR/Saccharomyces_cerevisiae.R64-1-1.95.gtf \
-profile crick --email quililk@crick.ac.uk --save_unaligned --aligner bowtie2 -r 2.0.0


#save file and exit, then run script

sbatch Alignment1_Saccer.sh

#view bigwig files in /nemo/lab/uhlmannf/home/users/yourname/genome/Saccharomyces_cerevisiae/Bowtie2/mergedlibrary/bigwig

#Second alignment, rename unmapped filed from: XXXXX_T1.Lb.unmapped_1.fastq.gz to New:  XXXXX_120min_R1.fastq.gz, and create a sample sheet for the next allignment using output unmapped files as fastq files
# to fill the fastq files in the unmapped Canglab ise the code below, change for unmapped Saccer sheet

search_dir=/nemo/lab/uhlmannf/home/users/quililk/nextflow_chip/DATE/CohesinChIP/Candida_glabrata/bowtie2/library/unmapped

for entry in "$search_dir"/*R1* #change the read
  do
echo "$entry"
done

#Alignment 2 unmapped Canglab to Saccer, create script below and run


#! /bin/bash
#SBATCH -p ncpu
#SBATCH -c 1
#SBATCH --mem-per-cpu 7G
#SBATCH -t 3-00:00:00
#SBATCH -o Alignment2_unmapped-Canglab-to-Saccer_out.txt
#SBATCH -N 1
#SBATCH --mail-type END
#SBATCH --mail-user EMAIL

#Define
folder=’DATE’
data_output=/nemo/lab/uhlmannf/home/users/quililk/nextflow_chip
samplesheet_name=’Samplesheet_Alignment2_unmappedCanglab.csv’

if [[ ! -d ${data_output}/${folder}/CohesinChIP/Candida_glabrata/unmapped-Saccer-to-Canglab ]]; then
mkdir -p ${data_output}/${folder}/CohesinChIP/Candida_glabrata/unmapped-Saccer-to-Canglab 
fi

if [[ ! -d ${data_output}/${folder}/CohesinChIP/Saccharomyces_cerevisiae/unmapped-Canglab-to-Saccer ]]; then
mkdir -p ${data_output}/${folder}/CohesinChIP/Saccharomyces_cerevisiae/unmapped-Canglab-to-Saccer 
fi


cp ${data_output}/scripts/${folder}/${samplesheet_name} ${data_output}/${folder}/CohesinChIP/Saccharomyces_cerevisiae/unmapped-Canglab-to-Saccer

#Load modules
ml purge
ml Nextflow/22.10.3
ml Singularity/3.6.4

#Paths
GENOME_DIR=/nemo/lab/uhlmannf/home/users/quililk/genome/Saccharomyces_cerevisiae/Bowtie2
export NXF_WORK=/flask/scratch/uhlmannf/quililk
export NXF_SINGULARITY_CACHEDIR=/flask/apps/containers/chipseq/2.0.0/
  export NXF_HOME=/nemo/lab/uhlmannf/home/users/quililk/nextflow

#Run pipeline
nextflow run nf-core/chipseq --input ${data_output}/${folder}/CohesinChIP/Saccharomyces_cerevisiae/unmapped-Canglab-to-Saccer/${samplesheet_name} --read_length 100 \
--outdir ${data_output}/${folder}/CohesinChIP/Saccharomyces_cerevisiae/unmapped-Canglab-to-Saccer \
--fasta $GENOME_DIR/Saccharomyces_cerevisiae.R64-1-1.dna_sm.toplevel.fa \
--gtf $GENOME_DIR/Saccharomyces_cerevisiae.R64-1-1.95.gtf  \
-profile crick --email quililk@crick.ac.uk --aligner bowtie2 --narrow_peak -r 2.0.0


# create the Alignment2 unmapped Saccer to Canglab.sh and run 

#Normalising IP over INPUT
module avail deeptools
module load deepTools/3.5.1-foss-2021b
load package BEDTools/2.30.0-GCC-12.2.0

# use command bamCompare to normalise 

bam1="Scc1_XXX.mLb.clN.sorted.bam"
bam2="INPUT_XXX.mLb.clN.sorted.bam"
output="XXX_ratio_noscale.bed"

bamCompare -b1 "$bam1" -b2 "$bam2" --scaleFactorsMethod readCount --operation ratio --binSize 50 --smoothLength 250 -o "$output" -of bedgraph

#repeat for all samples 

#Normalise with the Spike-in
#determine number of reads from number of reads txt file: /nemo/lab-uhlmannf/home/users/yourname/nextflow_chip/2025_11_10/CohesinChIP/Candida_glabrata/unmapped-Saccer-to-Canglab/multiqc/narrowPeak/multiqc_data
#take Input over IP for occupancy ratio 

#R studio: 

nemoDir <- "/Volumes/lab-uhlmannf/home/users/yourname/nextflow_chip/2025_11_10/CohesinChIP/Saccharomyces_cerevisiae/unmapped-Canglab-to-Saccer/bowtie2/mergedLibrary/"
files_and_scales <- list(
  "NoGal_120min" = 2.023628272,
  "NoGal_60min" = 2.301687298,
  "WithGal_120min" = 1.291078083,
)

# Loop through each file and apply the scale factor
for (file_prefix in names(files_and_scales)) {
  scale_factor <- files_and_scales[[file_prefix]]
  
  # Construct full file path
  input_file <- paste0(nemoDir, file_prefix, "_ratio_noscale.bed")
  
  # Load the BED file
  bed_data <- read.table(input_file, header = FALSE, stringsAsFactors = FALSE)
  
  # Multiply score column by the scale factor
  bed_data[,5] <- bed_data[,4] * scale_factor
  bed_data <- bed_data[,c(1:3,5)]
  
  # Write the scaled BED file
  output_file <- paste0(nemoDir, file_prefix, "_scaled.bed")
  write.table(bed_data, output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)
}

#Back to Terminal 
#Need to 'Sort' the files 

sort -k1,1 -k2,2n noc_0_scaled.bed -o noc_0_scaled_sorted.bed

#Repeat for all conditions 

#Convert scaled BED file to BIGWIG file for viewing on IGV
#use bedGraphToBigWig package

GENOME_SIZE_DIR=~/home/users/yourname/genome/Saccharomyces_cerevisiae/Saccharomyces_cerevisiae.R64-1-1.dna_sm.toplevel.fa.sizes

PATH_RAHAF=~/home/users/yourname/nextflow_chip/2026-02-09/CohesinCHIP/Saccharomyces_cerevisiae/unmapped-Canglab-to-Saccer/bowtie2/mergedLibrary

cd ~/home/users/yourname/filename/2026-02-09/
  
  for condition in noc_0 DMSO_noGal Thiolutin_noGal DMSO_Gal Thiolutin_Gal; do
bedGraphToBigWig ${PATH_RAHAF}/${condition}_scaled_sorted.bed ${GENOME_SIZE_DIR} ${condition}_scaled.bw
done

#Repeat for all files

