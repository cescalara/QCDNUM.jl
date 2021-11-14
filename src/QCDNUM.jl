module QCDNUM

using QCDNUM_jll

include("initialisation.jl")
include("grid.jl")
include("weights.jl")
include("parameters.jl")
include("evolution.jl")
include("interpolation.jl")
include("zmstf.jl")
include("splint.jl")

end # QCDNUM
