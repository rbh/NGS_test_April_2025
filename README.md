# NGS test

## Introduction

Next Generation Sequencing technologies can be applied to study many
different diseases.  One such disease is maturity-onset diabetes of
the young (also called "MODY").  In this interview test we imagine
that you are a bioinformatics consultant that has been approached by a
scientist from a small company that has some promising ideas for how
to improve life for MODY patients.  The scenario is described below,
and at the interview we'll pretend you're meeting with people from the
company.  Before the interview, you can send emails with questions to
the company.


## Scenario

The company plans to offer better treatments to patients based on the
patients' NGS data.  For this to be successful, they need a robust
workflow for analysing the NGS data, and there are certain rare, but
important, genetic variants that they need to document will be found
by their workflow.  As such patient data is not only rare, but also
highly sensitive, the company struggles to find real data that can be
used for this documentation/validation.  They are therefore exploring
to generate synthetic data for this.

To begin with, they are interested in certain variants of the *GCK*
gene encoding glucokinase.  Variants in *GCK* are known to cause both
hyper- and hypoglycaemia.  Heterozygous inactivating mutations in *GCK*
may cause MODY, while homozygous inactivating mutations in *GCK* may
result in more severe phenotypes.  An example of a rare variant of
interest for this project is [rs193922259][1] that results in a codon
being changed to a stop codon, leading to shortened transcription.

[1]: https://www.ncbi.nlm.nih.gov/snp/rs193922259

Your contact person used to work with a bioinformatician at a
university.  This bioinformatician left to work for a big pharma
company, but managed to make a small proof-of-concept script in Bash
before leaving.  You have been suggested for taking over and finding
out what next steps are needed for establishing a good bioinformatics
workflow.  You've been told that the bioinformatician who worked on
the proof-of-concept is willing to answer a few questions in his spare
time, as there's no conflict of interest with the new employer.

You expect your contact person to ask many questions, driven by his
inquisitive, scientific personality.  Some of them may be very basic,
as your contact person does not know a lot about bioinformatics.  One
such question you know about, is why the proof-of-concept fails for the
variant [rs2135819583][2] in the *HNF1A* gene, another gene relevant
for MODY.

[2]: https://www.ncbi.nlm.nih.gov/snp/rs2135819583

The samples will be collected in many small batches and should be
processed as soon as the raw data are available.  The processing of
the samples will include looking for certain types of variants as well
as computing genomic risk scores.


## Materials

In addition to this document, the Bash script `validate_rs.sh` is
provided together with some files derived from publicly available
reference files.  You don't need to download these reference files, as
they're essentially just "more of the same" compared to the files that
are provided.  However, the script knows how to download the necessary
reference files and derive the provided files as well as some
additional files that are not provided, but only made the first time
the script is run.


## Suggested tasks

### 1. Familiarise yourself with the script and the provided files.

Look at the `validate_rs.sh` script and the provided files to get a
high-level overview of how they relate to each other and what purposes
they serve.

### 2. Prepare for questions you expect at the meeting.

Try to figure out why the variant in *HNF1A* doesn't give "success" as
output.  It may also be a good idea to know exactly which
bioinformatics tools are used, and to understand some of the more
exotic Bash features used.  Also, the Bash script generates data with
homozygous variants; what would be needed for it to generate test data
with heterozygous variants?

### 3. Try to learn a bit more about the company's situation.

You have the option of asking a few questions before the meeting so
it's more likely to be a success. These could be to your contact
person (the scientist), or to the bioinformatician who made the
proof-of-concept.

### 4. Consider the right solutions to replace the script.

This is clearly a proof-of-concept script, and a more robust workflow
will be needed.  You're expected to outline what needs to be done and
get closer to an estimate of how much time it will take.  Compared to
the proof-of-concept Bash script, other types of bioinformatics tools
will also be needed.


## Notes

The provided code only uses a few bioinformatics tools and does not
require a lot of resources, so it should be possible to run on a small
computer.  However, with the right understanding of the tools used, it
should be possible to prepare *without running any code at all*.

We will not go into details about the biology behind MODY. The meeting
will focus on the bioinformatics and establishing a good workflow.

***You are not expected to code the bioinformatics workflow.***
