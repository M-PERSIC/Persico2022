"""
All-in-one function for running compression tests between the different Bzip2, Xz, Zlib, Zstd (default parameters), and Zstd via the custom dictionary compressors. 
"""

using DataFrames
using Pkg.Artifacts
using TranscodingStreams
using CodecXz
using CodecBzip2
using CodecZlib
using CodecZstd

include("Data.jl")

"""
Create the Zstd dictionary by running the Zstd CLI implementation
"""
function create_dictionary(artifact::String)
    run(Cmd(`sudo apt update`))
    run(Cmd(`sudo apt install -y zstd`))
    run(Cmd(`zstd --train -r "$artifact"`))
end


"""
Generate compression size information from randomly generated FASTA data
"""
function compression_tests(type::Symbol, files::Int, min_length::Int, max_length::Int, artifact::String)

    # DataFrame object to hold all of the compression data
    size_df = DataFrame(
        type = String[],
        size = Int64[],
    )

    # Generate Zstd custom dictionary
    create_dictionary(artifact"ecoli_MS_200")

    for i = 1:files
        # Can generate either DNA, RNA, or amino acid sequence data
        if type == :DNA 
            data = FASTA_DNA_generate(min_length, max_length) 
        elseif type ==:RNA
            data = FASTA_RNA_generate(min_length, max_length)
        elseif type ==:AA
            data = FASTA_AA_generate(min_length, max_length)
        else
            return error("Invalid sequence type!")
        end

        # Get uncompressed/compressed sizes (kilobytes) of the data and record in dataframe
        data_uncompressed_size = sizeof(data)
        push!(size_df, ["Uncompressed", data_uncompressed_size])
        data_bzip2_compressed = sizeof(transcode(Bzip2Compressor, data))
        push!(size_df, ["Bzip2", data_bzip2_compressed])
        data_xz_compressed = sizeof(transcode(XzCompressor, data))
        push!(size_df, ["Xz", data_xz_compressed])
        data_zlib_compressed = sizeof(transcode(ZlibCompressor, data))
        push!(size_df, ["Zlib", data_zlib_compressed])
        data_zstd_default_compressed = sizeof(transcode(ZstdCompressor, data))
        push!(size_df, ["Zstd_default", data_zstd_default_compressed])

        # Perform Zstd compression with the custom dictionary
        open("data.fna", "w") do io
            write(io, data)
        end
        run(Cmd(`zstd -D dictionary data.fna`))    
        push!(size_df, ["Zstd_dict", filesize("data.fna.zst")])
        rm("data.fna")
        rm("data.fna.zst")
    end

    #dictionary is no longer required
    rm("dictionary")
    
    return size_df
end