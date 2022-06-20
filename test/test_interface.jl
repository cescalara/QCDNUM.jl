using QCDNUM
using Test

include("pdf_functions.jl")

@testset "Initialisation" begin

    QCDNUM.init()

    QCDNUM.init(banner=true)

end

@testset "Grid interface" begin

    # Initialisation
    QCDNUM.init()

    # Grid interface with defaults
    grid_params = QCDNUM.GridParams()

    @test QCDNUM.make_grid(grid_params) == (grid_params.nx, grid_params.nq)

end

@testset "Evolution interface" begin

    # Initialisation
    QCDNUM.init()

    # Evolution params (including grid) with defaults
    evolution_params = QCDNUM.EvolutionParams()

    input_pdf = QCDNUM.InputPDF(func=func, map=def)

    @test typeof(input_pdf.cfunc) == Base.CFunction

    # Evolve    
    eps = QCDNUM.evolve(input_pdf, evolution_params)

    @test typeof(eps) == Float64
    @test eps < 0.1

end

@testset "SPLINT interface" begin

    splint_params = QCDNUM.SPLINTParams()

    # Initialisation
    @test_nowarn QCDNUM.splint_init(splint_params)

    # Test calling init twice
    @test_warn "SPLINT" QCDNUM.splint_init(splint_params)
    
end
