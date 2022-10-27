#!/usr/bin/env nextflow

nextflow.enable.dsl = 2
moduleDir = launchDir

include { ODGI_VIEW } from "$moduleDir/modules/nf-core/odgi/view/main.nf"

workflow test_odgi_view {

    input = [ [ id:'test' ],
              file(params.test_data['homo_sapiens']['pangenome']['pangenome_smoothxg_gfa'], checkIfExists: true),
            ]

    ODGI_VIEW ( input )
}