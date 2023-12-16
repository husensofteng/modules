#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { SAMTOOLS_PIPELINE as SAMTOOLS_PIPELINE_SORMADUP     } from '../../../../../modules/nf-core/samtools/pipeline/main.nf'
include { SAMTOOLS_PIPELINE as SAMTOOLS_PIPELINE_COLLFIXMSORT } from '../../../../../modules/nf-core/samtools/pipeline/main.nf'
include { SAMTOOLS_PIPELINE as SAMTOOLS_PIPELINE_COLLFIXM     } from '../../../../../modules/nf-core/samtools/pipeline/main.nf'
include { SAMTOOLS_PIPELINE as SAMTOOLS_PIPELINE_COLLFIXM_B2C } from '../../../../../modules/nf-core/samtools/pipeline/main.nf'
include { SAMTOOLS_PIPELINE as SAMTOOLS_PIPELINE_ALL          } from '../../../../../modules/nf-core/samtools/pipeline/main.nf'

workflow test_samtools_pipeline_sormadup {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]
    commands = ['collate', 'fixmate', 'sort', 'markdup']
    SAMTOOLS_PIPELINE_SORMADUP ( input, [[],[],[]], commands )
}

workflow test_samtools_pipeline_collate_fixmate_sort {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]
    commands = ['collate', 'fixmate', 'sort']
    SAMTOOLS_PIPELINE_COLLFIXMSORT ( input, [[],[],[]], commands )
}

workflow test_samtools_pipeline_collate_fixmate {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]
    commands = ['collate', 'fixmate']
    SAMTOOLS_PIPELINE_COLLFIXM ( input, [[],[],[]], commands )
}

workflow test_samtools_pipeline_all {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]
    commands = ['collate', 'addreplacerg', 'fixmate', 'reheader', 'sort', 'markdup', 'view']
    SAMTOOLS_PIPELINE_ALL ( input, [[],[],[]], commands )
}

workflow test_samtools_pipeline_collate_fixmate_cram {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['homo_sapiens']['illumina']['test_paired_end_sorted_cram'], checkIfExists: true)
    ]
    commands = ['collate', 'fixmate']
    SAMTOOLS_PIPELINE_COLLFIXM ( input, [[],[],[]], commands )
}

workflow test_samtools_pipeline_collate_fixmate_bam2cram {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]
    fasta = [
        [ id:'test' ], // meta map
        file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true),
        file(params.test_data['sarscov2']['genome']['genome_fasta_fai'], checkIfExists: true)
    ]
    commands = ['collate', 'fixmate']
    SAMTOOLS_PIPELINE_COLLFIXM_B2C ( input, fasta, commands )
}
