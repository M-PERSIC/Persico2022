module Persico2022

include("GenerateArtifacts.jl")

# Generate the E.coli *.fna (DNA sequence) NCBI dataset 
artifact_generate("ecoli_MS_200", "https://ftp.ncbi.nih.gov/genomes/HUMAN_MICROBIOM/Bacteria/Escherichia_coli_MS_200_1_uid47275/NZ_ADUC00000000.scaffold.fna.tgz")


end 
