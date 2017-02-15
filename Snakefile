rule all:
    input:
        "build/main.pdf"

rule manuscript:
    input:
        "manuscript/main.tex",
        "build/notebooks.done"
    output:
        "build/main.pdf"
    shell:
        "pdflatex --output-directory=build manuscript/main.tex"

rule notebooks:
    output:
        touch("build/notebooks.done")
    shell:
        "conda list"

        
