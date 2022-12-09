"""
Generate plots for visualization of the compression trends and other trends
"""

using VegaLite
using VegaDatasets
using StatsBase

include("Sequences.jl")

df = compression_tests(:DNA, 100, 100000, 150000)

df |>
@vlplot(
    width=240,
    height=135,
    mark={:boxplot, extent="min-max"},
    title="muow",
    x={"type:o", axis={title="maow"}},
    y={:size, axis={title="meuw"}},
)

"""
Generate whisker plot for a visual demonstration of the range of sizes for compressed FASTA data
"""
function compression_performance_plot_generate(df::DataFrame, 
    title::String,
    xtitle::String,
    ytitle::String,
    filepath::String)
whiskerplot = df |>
@vlplot(
    width=240,
    height=135,
    mark={:boxplot, extent="min-max"},
    title=title,
    x={"type:o", axis={title=xtitle}},
    y={:size, axis={title=ytitle}},
)
save(filepath, whiskerplot)
end

"""
Generate bar plot for a visual demonstration of the total size of all files following compression
"""
function total_filesize_plot_generate(df::DataFrame,
    title::String,
    xtitle::String,
    ytitle::String,
    filepath::String
    )
barplot = df |>
@vlplot(
    width=240,
    height=135,
    mark={:boxplot, extent="min-max"},
    title=title,
    x={"type:o", axis={title=xtitle}},
    y={:size, aggregate="sum", axis={title=title}},
)
save(filepath, barplot)
end

function 
