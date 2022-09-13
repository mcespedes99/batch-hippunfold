# batch-hippunfold

Simple wrapper snakemake workflow to submit jobs for running hippunfold on the cluster.
Writes data to /tmp during the job, and copies the hippunfold folder back for each subject.
Note: this does not retain the work folder at all.

## Instructions:

1. Update config file with options

2. Run `snakemake -np` for dry-run

3. Run `snakemake --profile cc-slurm` for submitting jobs (or use your chosen profile)


