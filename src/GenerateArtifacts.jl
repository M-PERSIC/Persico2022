"""
Generate Julia artifacts, which represent fixed, immutable containers for data, in 
this instance any dataset utilized for creating Zstd dictionaries. Major advantages include 
better reproducibility, and automatic tarball unpacking. Each entry is listed in the 
Artifacts.toml file. Docs: https://pkgdocs.julialang.org/v1/artifacts/
"""

using Pkg.Artifacts
using ArtifactUtils

function artifact_generate(name::String, url::String)
    add_artifact!(Artifacts.find_artifacts_toml(@__DIR__), name , url, lazy = false, force = true)
    ensure_artifact_installed(name, Artifacts.find_artifacts_toml(@__DIR__))
end
