rule hippunfold:
    input:
        bids='bids',
    output:
        directory('hippunfold/sub-{subject}'),
    container: config['singularity']['hippunfold']
    shadow: 'minimal'
    benchmark: 'benchmarks/hippunfold_sub-{subject}.tsv'
    log: 'logs/hippunfold_sub-{subject}.txt'
    threads: 8
    resources: 
        mem_mb=32000,
        time=90
    shell: 
        'hippunfold {input.bids} {resources.tmpdir} participant --participant_label {wildcards.subject} '
        '--cores {threads}  --modality T2w && '
        'cp -Rv {resources.tmpdir}/hippunfold/sub-{wildcards.subject} {output} ' 



