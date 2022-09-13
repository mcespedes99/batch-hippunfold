from snakemake.io import glob_wildcards
import os

configfile: 'config.yml'


glob_bids = glob_wildcards(os.path.join(config['bids_dir'],config['bids_subject_match']))

subjects = glob_bids.subject

test_subjects = list(set(config.get('test_subjects',[])) & set(subjects))
if len(test_subjects) > 0:
    subjects = test_subjects


rule all:
    input:
        expand('hippunfold/sub-{subject}',subject=subjects),

rule hippunfold:
    input:
        bids='bids',
    params:
        hippunfold_opts=config['opts']['hippunfold']
    output:
        directory('hippunfold/sub-{subject}'),
    container: config['singularity']['hippunfold']
    shadow: 'minimal'
    threads: 8
    resources: 
        mem_mb=32000,
        time=90
    shell: 
        'hippunfold {input.bids} {resources.tmpdir} participant --participant_label {wildcards.subject} '
        '--cores {threads}  {params.hippunfold_opts} && '
        'cp -Rv {resources.tmpdir}/hippunfold/sub-{wildcards.subject} {output} ' 






