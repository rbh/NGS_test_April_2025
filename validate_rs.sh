#!/bin/bash

# This script generates synthethic data for a SNP and runs a variant
# calling pipeline to validate that the SNP is detected in the
# data. Only data for a region around the SNP is considered, limiting
# the resources needed.

# Variables for the data source and region
ENSEMBL="https://ftp.ensembl.org/pub/release-113"
REGION="7:44000000-44500000"

# Variables for reference files etc.
VARIANTS="homo_sapiens-chr$REGION.vcf.gz"
CHROMOSOME=$(printf "%s" "$REGION" | cut -f 1 -d :)
FASTA="Homo_sapiens.GRCh38.dna.chromosome.$CHROMOSOME.fa" 

# Ensure references and indices are in place.
if [ ! -f "$VARIANTS" ]; then
    printf "%s" "$REGION" | sed s'/[:-]/\t/g' > "$REGION.bed"
    curl -L "$ENSEMBL/variation/vcf/homo_sapiens/homo_sapiens-chr$CHROMOSOME.vcf.gz" |\
	zgrep -v 'HGMD-PUBLIC_20204' |\
	bgzip -@ 16 > "homo_sapiens-chr$CHROMOSOME.vcf.gz"  # Fix error about the tag in the previous line.
    bcftools index "homo_sapiens-chr$CHROMOSOME.vcf.gz"
    bcftools view -r "$REGION" -O z --write-index "homo_sapiens-chr$CHROMOSOME.vcf.gz" -o "$VARIANTS"
fi
if [ ! -f "$FASTA.gz.fai" ]; then
    curl -L "$ENSEMBL/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.$CHROMOSOME.fa.gz" |\
	gzip -d |\
	bgzip -@ 16 > "$FASTA.gz"
    samtools faidx "$FASTA.gz"
fi
if [ ! -f "$FASTA" ]; then
    gzip -cd "$FASTA.gz" > "$FASTA"
fi
if [ ! -f "$FASTA.sa" ]; then
    bwa index "$FASTA"
fi

# Get the RS number from the first command line argument.
RS="$1"
shift
mkdir -p "$RS"
# Generate the synthetic data.
bcftools view -i 'ID="'"$RS"'"' -O z -o "$RS/$RS.vcf.gz" --write-index "$VARIANTS"
samtools faidx "$FASTA.gz" 7:44000000-44500000 |\
    bcftools consensus -s - "$RS/$RS.vcf.gz" > "$RS/fasta"
mkfifo "$RS/read1.fq" "$RS/read2.fq"
wgsim -S 42 "$RS/fasta" "$RS/read1.fq" "$RS/read2.fq" > "$RS/random_polymorphisms.tsv" &
bgzip -@ 8 < "$RS/read1.fq" > "$RS/read1.fq.gz" &
bgzip -@ 8 < "$RS/read2.fq" > "$RS/read2.fq.gz" &
wait
rm "$RS/read1.fq" "$RS/read2.fq"
# Run variant calling on the synthetic data.
bwa mem -v 2 -t 16 "$FASTA" <(gzip -cd "$RS/read1.fq.gz") <(gzip -cd "$RS/read2.fq.gz") |\
    samtools sort -@ 16 -O bam |\
    tee "$RS/alignment.bam" |\
    bcftools mpileup -f "$FASTA" -O u - |\
    bcftools call -mv --ploidy 2 -O z -o "$RS/variants.vcf.gz" --threads 16 --write-index
bcftools annotate -c ID -a "$VARIANTS" -O z -o "$RS/annotated_variants.vcf.gz" --threads 16 --write-index "$RS/variants.vcf.gz"
# Check that the variant we introduced was found by the variant calling pipeline.
if [ x$(bcftools query -f'[%GT]' -i 'ID="'"$RS"'"' "$RS/annotated_variants.vcf.gz") == "x1/1" ]; then
    echo Success
else
    echo Failure
fi
