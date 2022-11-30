process PRETEXTSNAPSHOT_ALL {
    tag "$meta.id"
    label 'process_single'

    conda (params.enable_conda ? "bioconda::pretextsnapshot=0.0.4" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pretextsnapshot:0.0.4--h7d875b9_0':
        'quay.io/biocontainers/pretextsnapshot:0.0.4--h7d875b9_0' }"

    input:
    tuple val(meta), path(pretext)

    output:git 
    tuple val(meta), path("*.png"), emit: picture
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    PretextSnapshot $args -m $pretext

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pretextsnapshot: \$(echo \$(PretextSnapshot--version 2>&1) | sed 's/^.PretextSnapshot //; s/Using.*\$//' ))
    END_VERSIONS
    """
}
