#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { HAIL } from '../../../../modules/nf-core/hail/main.nf'

workflow test_hail {
input = [
        [ id:'test' ], // meta map
        [
            file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf_gz'], checkIfExists: true),
        ]
    ]

hail_script = "/workspace/modules/hail_test.py"

    HAIL (input, hail_script)
}
