"""
Generate plots for visualization of the compression trends and other information
"""

using VegaLite
using VegaDatasets
using StatsBase

include("Sequences.jl")

df = compression_tests(:AA, 100, 100000)

println()

p = df |>
@vlplot(
    mark={:boxplot, extent="min-max"},
    x="type:o",
    y={:size, axis={title="population"}}
)
save("figure.png", p)