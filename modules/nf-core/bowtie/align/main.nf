process BOWTIE_ALIGN {
    tag "$meta.id"
    label 'process_high'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'nf-core/modules/bowtie_align/singularity:bowtie_align--42e8f624908e260f' :
        'nf-core/modules/bowtie_align:bowtie_align--dd5b3a544b28c5c3' }"

    input:
    tuple val(meta), path(reads)
    path  index

    output:
    tuple val(meta), path('*.bam'), emit: bam
    tuple val(meta), path('*.out'), emit: log
    path  "versions.yml"          , emit: versions
    tuple val(meta), path('*fastq.gz'), optional:true, emit: fastq

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def unaligned = params.save_unaligned ? "--un ${prefix}.unmapped.fastq" : ''
    def endedness = meta.single_end ? "$reads" : "-1 ${reads[0]} -2 ${reads[1]}"
    """
    INDEX=`find -L ./ -name "*.3.ebwt" | sed 's/\\.3.ebwt\$//'`
    bowtie \\
        --threads $task.cpus \\
        --sam \\
        -x \$INDEX \\
        -q \\
        $unaligned \\
        $args \\
        $endedness \\
        2> ${prefix}.out \\
        | samtools view $args2 -@ $task.cpus -bS -o ${prefix}.bam -

    if [ -f ${prefix}.unmapped.fastq ]; then
        gzip ${prefix}.unmapped.fastq
    fi
    if [ -f ${prefix}.unmapped_1.fastq ]; then
        gzip ${prefix}.unmapped_1.fastq
        gzip ${prefix}.unmapped_2.fastq
    fi

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bowtie: \$(echo \$(bowtie --version 2>&1) | sed 's/^.*bowtie-align-s version //; s/ .*\$//')
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
}
