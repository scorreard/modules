process HAIL {
    tag "$meta.id"
    label 'process_medium'

    // WARN: Version information not provided by tool on CLI. Please update version string below when bumping container versions.
    conda "bioconda::hail=0.2.58"
//    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
//        'quay.io/lifebitai/hail-spark-utils' }"

    input:
    tuple val(meta), path(vcf)
    path (hail_script)

    output:
    path("*.vcf.bgz")		, emit: vcf	    , optional: true
    path("*.vcf.bgz.tbi")	, emit: index   , optional: true
    path("*.tsv")		    , emit: tsv     , optional: true
    path "versions.yml"     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def VERSION = '0.2.58' // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.
    """
    python $hail_script $vcf $args
#/workspace/modules/hail_test.py

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        hail: $VERSION
    END_VERSIONS
    """
}
