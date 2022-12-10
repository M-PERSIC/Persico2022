"""
Set of functions for randomly generating FASTA-formatted data containing either DNA, RNA, or amino acid sequences
"""

using FASTX
using BioSequences

"""
Generate FASTA formatted record with a random DNA sequence with a random length between two bounds
"""
function FASTA_DNA_generate(min_length::Int, max_length::Int)
    # Generate random DNA sequence
    seq = BioSequences.randdnaseq(rand(min_length:max_length))
    # Convert DNA sequence to FASTA format
    rec = FASTA.Record("seq", seq)
    return rec.data
end

"""
Generate FASTA formatted record with a random RNA sequence with a random length between two bounds
"""
function FASTA_RNA_generate(min_length::Int, max_length::Int)
    # Generate random RNA sequence
    seq = BioSequences.randrnaseq(rand(min_length:max_length))
    # Convert RNA sequence to FASTA format
    rec = FASTA.Record("seq", seq)
    return rec.data
end

"""
Generate FASTA formatted record with a random amino acid sequence with a random length between two bounds
"""
function FASTA_AA_generate(min_length::Int, max_length::Int)
    # Generate random AA sequence
    seq = BioSequences.randaaseq(rand(min_length:max_length))
    # Convert AA sequence to FASTA format
    rec = FASTA.Record("seq", seq)
    return rec.data
end
