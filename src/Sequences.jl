"""
Set of functions that allow for generating FASTA formatted data for running compression
tests using Xz, Bzip2, Zlib, and Zstd compressors
"""

using FASTX
using BioSequences
using DataFrames
using TranscodingStreams
using CodecXz
using CodecBzip2
using CodecZlib
using CodecZstd
using StatsBase


"""
Generate a Random FASTA file with a random DNA sequence length from range 1 to length
"""
function FASTA_DNA_generate(min_length::Int, max_length::Int)
    # Generate random DNA sequence
    seq = BioSequences.randdnaseq(rand(min_length:max_length))
    # Convert DNA sequence to FASTA format
    rec = FASTA.Record("seq", seq)
    return rec.data
end

"""
Generate a Random FASTA file with a random RNA sequence length from range 1 to length
"""
function FASTA_RNA_generate(min_length::Int, max_length::Int)
    # Generate random DNA sequence
    seq = BioSequences.randrnaseq(rand(min_length:max_length))
    # Convert DNA sequence to FASTA format
    rec = FASTA.Record("seq", seq)
    return rec.data
end

"""
Generate a Random FASTA file with a random amino acid sequence length from range 1 to length
"""
function FASTA_AA_generate(min_length::Int, max_length::Int)
    # Generate random DNA sequence
    seq = BioSequences.randaaseq(rand(min_length:max_length))
    # Convert DNA sequence to FASTA format
    rec = FASTA.Record("seq", seq)
    return rec.data
end

"""
Generate compression size information from randomly generated FASTA data
"""
function compression_tests(type::Symbol, 
    files::Int, 
    min_length::Int, 
    max_length::Int,
    )

    size_df = DataFrame(
        type = Symbol[],
        size = Int64[],
    )
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

        # Get uncompressed/compressed sizes of the data and record in dataframe
        data_uncompressed_size = sizeof(data)
        push!(size_df, [:Uncompressed, data_uncompressed_size])
        data_bzip2_compressed = sizeof(transcode(Bzip2Compressor, data))
        push!(size_df, [:Bzip2, data_bzip2_compressed])
        data_xz_compressed = sizeof(transcode(XzCompressor, data))
        push!(size_df, [:Xz, data_xz_compressed])
        data_zlib_compressed = sizeof(transcode(ZlibCompressor, data))
        push!(size_df, [:Zlib, data_zlib_compressed])
        data_zstd_compressed = sizeof(transcode(ZstdCompressor, data))
        push!(size_df, [:Zstd_default, data_zstd_compressed])
    end
    return size_df
end
