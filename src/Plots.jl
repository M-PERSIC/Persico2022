"""
Generate plots for visualization of the compression trends and other trends
"""

using DataFrames
using PlotlyJS

"""
Generate whisker plot for a visual demonstration of the range of sizes for compressed FASTA data
"""
function compression_performance_whiskerplot_generate(df::DataFrame, title::String, x_title::String, y_title::String, filepath::String)
    uncompressed_data = df[(df.type .== "Uncompressed"), :size]
    uncompressed_trace = box(y = uncompressed_data, boxpoints = "all", kind = "box", name = "Uncompressed", marker_color = "rgb(105, 105, 105)", notched = true)
    
    bzip2_data = df[(df.type .== "Bzip2"), :size]
    bzip2_trace = box(y = bzip2_data, boxpoints = "all", kind = "box", name = "Bzip2", marker_color = "rgb(255, 0, 255)", notched = true)
    
    xz_data = df[(df.type .== "Xz"), :size]
    xz_trace = box(y = xz_data, boxpoints = "all", kind = "box", name = "Xz", marker_color = "rgb(0, 255, 255)", notched = true)
    
    zlib_data = df[(df.type .== "Zlib"), :size]
    zlib_trace = box(y = zlib_data, boxpoints = "all", kind = "box", name = "Zlib", marker_color = "rgb(0, 255, 0)", notched = true)
    
    zstd_default_data = df[(df.type .== "Zstd_default"), :size]
    zstd_default_trace = box(y = zstd_default_data, boxpoints = "all", kind = "box", name = "Zstd - default", marker_color = "rgb(255, 255, 0)", notched = true)
    
    zstd_dict_data = df[(df.type .== "Zstd_dict"), :size]
    zstd_dict_trace = box(y = zstd_dict_data, boxpoints = "all", kind = "box", name = "Zstd - custom dictionary", marker_color = "rgb(255, 102, 0)", notched = true)
    
    full_plot = plot([uncompressed_trace, bzip2_trace, xz_trace, zlib_trace, zstd_default_trace, zstd_dict_trace], Layout(title = attr(text = title, font_size = 11), xaxis_title = x_title, yaxis_title = y_title))
    savefig(full_plot, filepath)
end

"""
Convert TukeyHSD results to a table
"""
function tukey_test_table_generate(df::DataFrame, filepath::String)
   tukey_table =  plot(
        table(
            header = attr(
                values = ["Contrasts", "Adjusted p-value"],
                align = "middle"),
            cells = attr(
                values = [df[:, Symbol("contrast")], df[:, Symbol("adj.p.value")]], 
                align = "middle"),
            ),
        Layout(width=500, height=500)
        )
    savefig(tukey_table, filepath)
end
