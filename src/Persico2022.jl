module Persico2022

"""
Zstd custom dictionary compression model. A compression dictionary is generated with an E.coli dataset and then compression performance is compared across Bzip2, Xz, Zlib, Zstd (default parameters), and Zstd via the custom dictionary.
"""

using DataFrames

# Generate the E.coli *.fna (DNA sequence) NCBI dataset artifact
include("Dataset.jl")
artifact_generate("ecoli_MS_200", "https://ftp.ncbi.nih.gov/genomes/HUMAN_MICROBIOM/Bacteria/Escherichia_coli_MS_200_1_uid47275/NZ_ADUC00000000.scaffold.fna.tgz")


# Run the compression tests on randomized FASTA data containing DNA sequences, input the results in a DataFrame object
# The Zstd dictionary will be generated inside the compression_tests function
include("Tests.jl")
df = compression_tests(:DNA, 100, 100000, 150000, artifact"ecoli_MS_200")

# Generate plots of the data compression trends.
include("Plots.jl")

# Main result plot comparing compression performance of random DNA FASTA formatted data
compression_performance_whiskerplot_generate(df, 
"Data Compression Size Distributions (E.Coli dataset[24] training dataset, DNA length = 100 000 - 150 000)",
"Data compressor type", 
"Data size in bytes",
"/var/home/mpersico/distrobox/ubuntu-zstd/Persico2022/assets/plots/PlotOne.png")

# Plot the TukeyHSD statistical results in a table 
include("Stats.jl")
tukey_test_generate(df, "var/home/mpersico/distrobox/ubuntu-zstd/Persico2022/assets/data/results.csv")
tukey_results = csv_to_df("/var/home/mpersico/distrobox/ubuntu-zstd/Persico2022/assets/data/results.csv")
tukey_test_table_generate(tukey_results,"/var/home/mpersico/distrobox/ubuntu-zstd/Persico2022/assets/plots/TukeyTable.png")

# First supplementary plot with shorter, more variable DNA sequence FASTA formatted data
df_supplementary_one = compression_tests(:DNA, 100, 1000, 10000, artifact"ecoli_MS_200")
compression_performance_whiskerplot_generate(df_supplementary_one, 
"Data Compression Size Distributions (E.Coli dataset[24] training dataset, DNA length = 1000 - 10 000)",
"Data compressor type", 
"Data size in bytes",
"/var/home/mpersico/distrobox/ubuntu-zstd/Persico2022/assets/plots/SupplementaryPlotOne.png")

# Second supplementary plot with long RNA sequence FASTA formatted data. Same training dataset for Zstd dictionary compression
df_supplementary_two = compression_tests(:RNA, 100, 100000, 150000, artifact"ecoli_MS_200")
compression_performance_whiskerplot_generate(df_supplementary_two, 
"Data Compression Size Distributions (E.Coli dataset[24] training dataset, RNA length = 100 000 - 150 000)",
"Data compressor type", 
"Data size in bytes",
"/var/home/mpersico/distrobox/ubuntu-zstd/Persico2022/assets/plots/SupplementaryPlotTwo.png")

# Thid supplementary plot with long amino acid sequence FASTA formatted data. Same training dataset for Zstd dictionary compression
df_supplementary_three = compression_tests(:AA, 100, 100000, 150000, artifact"ecoli_MS_200")
compression_performance_whiskerplot_generate(df_supplementary_three, 
"Data Compression Size Distributions (E.Coli dataset[24] training dataset, amino acid length = 100 000 - 150 000)",
"Data compressor type", 
"Data size in bytes",
"/var/home/mpersico/distrobox/ubuntu-zstd/Persico2022/assets/plots/SupplementaryPlotThree.png")

end 
