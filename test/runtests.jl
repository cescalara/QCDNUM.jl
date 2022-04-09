using Test

@testset "QCDNUM" begin
    
    include("test_docs.jl")
    include("test_initialisation.jl")
    include("test_grids.jl")
    include("test_parameters.jl")
    include("test_evolution.jl")
    include("test_structure_functions.jl")
    include("test_splint.jl")
    
end

