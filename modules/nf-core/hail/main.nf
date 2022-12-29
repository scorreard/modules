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
    path("*_frequ_only.vcf.bgz")	, emit: frequ_only_vcf	, optional: true
    path("*_frequ_only.vcf.bgz.tbi"), emit: frequ_only_index, optional: true
    path("*_with_geno.vcf.bgz")		, emit: with_geno_vcf	, optional: true
    path("*_with_geno.vcf.bgz.tbi")	, emit: with_geno_index , optional: true    
    path("*.tsv")		            , emit: tsv             , optional: true
    path("*.html")		            , emit: html            , optional: true
    path("*_QC_report.txt")         , emit: QC_report_txt   , optional: true
    path "versions.yml"             , emit: versions

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
