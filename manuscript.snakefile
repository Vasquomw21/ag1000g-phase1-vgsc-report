# Manuscript
# ==========
#
# This snakefile has rules to build the main manuscript, including all artwork and tables.
#
# N.B., all rules in this file assume that all source files, including any data required,
# are present within the GitHub repository. Thus it should be possible to execute all rules
# within the CI environment.
#

# Setup
# -----
#
# Rules in this section include source and setup scripts, to ensure any changes in these will
# trigger a rebuild.
#

rule src:
    # Python sources.
    output:
        "src/python/zcache.py",
        "src/python/veff.py",
        "src/python/util.py",

rule setup:
    # Setup notebook.
    input:
        rules.src.output,
        "notebooks/setup.ipynb",
    output:
        "build/notebooks/setup.md",
    shell:
        "./nbexec.sh notebooks/setup.ipynb"

# Artwork
# -------
#
# Rules in this section build artwork (figures, figure components, etc.).
#

rule artwork_demo:
    # Example of how to include a Jupyter notebook in the artwork build.
    input:
        rules.setup.output,
        "notebooks/artwork_demo.ipynb",
    output:
        "build/notebooks/artwork_demo.md",
        "artwork/demo.png",
    shell:
        "./nbexec.sh notebooks/artwork_demo.ipynb"

rule artwork:
    # Build all artwork.
    input:
        rules.artwork_demo.output,
        # add more inputs here as required
    output:
        touch("build/manuscript.artwork.done")

# Tables
# ------
#
# Rules in this section build tables for the manuscript.
#

rule table_demo:
    # Demo of a notebook that builds a latex table.
    input:
        rules.setup.output,
        "notebooks/table_demo.ipynb",
    output:
        "build/notebooks/table_demo.md",
        "tables/demo.tex"
    shell:
        "./nbexec.sh notebooks/table_demo.ipynb"

rule table_variants_missense:
    # Build the LaTex table of missense variants in VGSC.
    input:
        rules.setup.output,
        "notebooks/table_variants_missense.ipynb",
        "data/tbl_variants_phase1.pkl",
    output:
        "build/notebooks/table_variants_missense.md",
        "tables/variants_missense.tex"
    shell:
        "./nbexec.sh notebooks/table_variants_missense.ipynb"

rule tables:
    # Build all tables.
    input:
        rules.table_demo.output,
        rules.table_variants_missense.output,
        # add more inputs here as required
    output:
        touch("build/manuscript.tables.done")

#
# Main manuscript
# ---------------
#

rule main:
    # Build the manuscript PDF file. This rule should depend on all artwork and tables.
    input:
        rules.artwork.output,
        rules.tables.output,
        "main.tex",
        "refs.bib",
        # add more inputs here as required
    output:
        "build/main.pdf",
        touch("build/manuscript.main.done")
    shell:
        "./latex.sh"

#
# Utilities
# ---------
#

rule all:
    # Build everything.
    input:
        rules.main.output,
    output:
        touch("build/manuscript.done")

rule clean:
    # Clean out the build folder.
    shell:
        "rm -rvf build/*"
