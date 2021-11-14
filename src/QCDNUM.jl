module QCDNUM

using Libdl

# Get path to lib
qcdnum_path = chomp(read(`qcdnum-config --libdir`, String))

# Check OS
if Sys.islinux()
    qcdnum_lib = string(qcdnum_path, "/libQCDNUM.so")
elseif Sys.isapple()
    qcdnum_lib = string(qcdnum_path, "/libQCDNUM.dylib")
end

# Load
qcdnum = Libdl.dlopen(qcdnum_lib, RTLD_NOW | RTLD_GLOBAL)

include("initialisation.jl")
include("grid.jl")
include("weights.jl")
include("parameters.jl")
include("evolution.jl")
include("interpolation.jl")
include("zmstf.jl")
include("splint.jl")

end # QCDNUM
