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

def get_output_files_folders():
    """ This function is used to select what files to retain, since the 
    app is run on /tmp, and only files listed here will be copied over"""
    output_files_folders=[]
    output_files_folders.append('hippunfold/sub-{subject}')
    if '--keep_work' in config['opts']['hippunfold'] or '--keep-work' in  config['opts']['hippunfold']:
        output_files_folders.append('work/sub-{subject}')
    else:
        output_files_folders.append('work/sub-{subject}.tar.gz')
    return output_files_folders


rule hippunfold:
    input:
        bids=config['bids_dir'],
    	container=config['singularity']['hippunfold']
    params:
        hippunfold_opts=config['opts']['hippunfold'],

    output:
        get_output_files_folders()
    shadow: 'minimal'
    threads: config['resources']['cores']
    resources: 
        mem_mb=config['resources']['mem_mb'],
        time=config['resources']['time']
    shell: 
        'singularity run -e {input.container} {input.bids} {resources.tmpdir} participant --participant_label {wildcards.subject} '
        '--cores {threads}  {params.hippunfold_opts} && '
        'pushd {resources.tmpdir} && cp --parent -Rv {output} `dirs`' #pushd puts the current folder on stack, grabbed with `dirs`






