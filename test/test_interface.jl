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

    QCDNUM.save_params("test_qcdnum_params.h5", evolution_params)

    loaded_params = QCDNUM.load_params("test_qcdnum_params.h5")

    @test typeof(loaded_params) == QCDNUM.EvolutionParams

    rm("test_qcdnum_params.h5")
    
end

@testset "SPLINT interface" begin

    splint_params = QCDNUM.SPLINTParams()

    warn_string = "SPLINT is already initialised, skipping call to QCDNUM.ssp_spinit()"
    
    # Test calling init twice
    QCDNUM.splint_init(splint_params)
    
    @test_logs (:warn, warn_string) QCDNUM.splint_init(splint_params)

    QCDNUM.save_params("test_splint_params.h5", splint_params)

    loaded_params = QCDNUM.load_params("test_splint_params.h5")

    @test typeof(loaded_params) == QCDNUM.SPLINTParams

    rm("test_splint_params.h5")
    
end
