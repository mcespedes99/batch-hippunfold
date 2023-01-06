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
    output_files_folders.append(directory('hippunfold/sub-{subject}'))
    if '--keep_work' in config['opts']['hippunfold'] or '--keep-work' in  config['opts']['hippunfold']:
        output_files_folders.append(directory('work/sub-{subject}'))
    return output_files_folders

rule hippunfold:
    input:
        bids=config['bids_dir'],
    	container=config['singularity']['hippunfold']
    params:
        hippunfold_opts=lambda wildcards: config['opts']['hippunfold'],
        retain_outputs_from_tmp=lambda wildcards, resources, output: ' && '.join([f'cp -Rv {resources.tmpdir}/{out} {out}' for out in output])
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
        '{params.retain_outputs_from_tmp} '

