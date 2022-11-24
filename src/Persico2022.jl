module Persico2022

using PyCall

zstd = pyimport_conda("pyzstd", "pyzstd=0.15.3")
println(zstd.zstd_version_info)

end # module FinalProjectBIOL480
