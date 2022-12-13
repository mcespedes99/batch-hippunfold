# batch-hippunfold

Simple wrapper snakemake workflow to submit jobs for running hippunfold on the cluster.
Writes data to /tmp during the job, and copies the hippunfold folder back for each subject.

## Instructions:

1. Clone this repo (e.g. in a /scratch or /project folder on graham)

2. Edit and update the `config.yml` file with hippunfold CLI options

3. Run `snakemake -np` for dry-run (should be one job per subject)

4. Run `snakemake --profile cc-slurm` for submitting jobs (or use your chosen profile)
