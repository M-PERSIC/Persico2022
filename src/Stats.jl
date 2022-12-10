"""
Set of functions for aiding with generating a Tukey-test for statistical comparison of compression performance
"""

using RCall
using DataFrames
using CSV

include("Tests.jl")

"""
Use The TukeyHSD R package to perform a Tukey's HSD (honestly significant difference) test
"""
function tukey_test_generate(df::DataFrame, filepath::String)
    df_types = robject(df[:,"type"])
    df_sizes = robject(df[:, "size"])
    @rput df_types
    @rput df_sizes
    R"""
    df <- do.call(rbind.data.frame, Map('c', df_types, df_sizes))
    colnames(df) <- c("type", "size")
    model <- aov(size ~ type, data=df)
    tukey_test <- TukeyHSD(model, conf.level=.95)
    library(broom)
    data <- tidy(tukey_test)
    write.csv(data, file="assets/data/results.csv")
    """
end

"""
Helper function to convert TukeyHSD test results, saved as a .csv file, into a DataFrame in order to plot as a table
"""
csv_to_df(filepath::String) = CSV.read(filepath, DataFrame)




