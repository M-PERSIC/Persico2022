"""
Set of functions for creating the custom Zstd compression dictionary.
"""

using Pkg.Artifacts
using CodecZstd

"""
Create the Zstd dictionary by running the Zstd CLI implementation.
"""
function create_dictionary(artifact::String)
    run(Cmd(`sudo apt update`))
    run(Cmd(`sudo apt install -y zstd`))
    run(Cmd(`zstd --train -r "$artifact"`))
    return (CodecZstd.Dictionary(read("dictionary")))
end

"""
Generate Zstd Compressor Stream object
"""
create_cstream() = CodecZstd.CStream()

"""
Load the Zstd Dictionary for CodecZstd usage.
"""
function load_dictionary(cstream::CodecZstd.CStream, dict::CodecZstd.Dictionary)
    CodecZstd.loadDictionary(cstream, dict)
end

