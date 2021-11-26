using QCDNUM
using Test

@testset "Initialisation" begin

    # Standard initialisation with banner
    QCDNUM.qcinit(6, "")

    # Check next logical unit number
    lun = QCDNUM.nxtlun(1)
    @test typeof(lun) == Int32

    # Store and retrieve
    QCDNUM.qstore("write", 1, 999.9)
    out = QCDNUM.qstore("read", 1)
    @test out == 999.9

    # Set QCDNUM params
    options = ["iter", "tlmc", "nopt", "edbg"]
    for opt in options
        @test QCDNUM.setint(opt, 1) == nothing
    end
    
end

@testset "Grids" begin

    # Initialisation
    QCDNUM.qcinit(-6, "")

    # x grid
    nx = QCDNUM.gxmake(Float64.([1.0e-4]), Int32.([1]), 1, 100, 3)
    @test nx == 100

    # qq grid
    nq = QCDNUM.gqmake(Float64.([2e0, 1e4]), Float64.([1e0, 1e0]), 2, 50)
    @test nq == 50

    # Indices <-> grid points
    ix = QCDNUM.ixfrmx(0.1)
    @test ix == 76

    x = QCDNUM.xfrmix(ix)
    @test x ≈ 0.1

    iq = QCDNUM.iqfrmq(1000.0)
    @test iq == 36

    q = QCDNUM.qfrmiq(iq)
    @test q == 877.3066621237417

    # Grid params
    out = QCDNUM.grpars()
    @test out[1] == 100
    @test out[2] ≈ 1e-4
    @test out[3] == 1
    @test out[4] == 50
    @test out[5] == 2.0
    @test out[6] ≈ 1e4
    @test out[7] == 3

    # Copying grids
    x_grid = QCDNUM.gxcopy(nx)
    @test x_grid[1] ≈ 1e-4
  
    qq_grid = QCDNUM.gqcopy(nq)
    @test qq_grid[1] ≈ 2e0

    # Weights
    for itype in [1, 2, 3]
        nw = QCDNUM.fillwt(itype)
        @test typeof(nw) == Int32
        @test QCDNUM.wtfile(itype, string("test", string(itype), ".wgt")) == nothing
        sleep(1)
    end

    for itype in [1, 2, 3]
        rm(string("test", string(itype), ".wgt"))
    end
    
end

@testset "Parameters" begin

    # Initialisation
    QCDNUM.qcinit(-6, "")

    # Order
    for iord in [1, 2, 3]
        @test QCDNUM.setord(iord) == nothing
    end

    @test QCDNUM.setalf(0.364, 2.0) == nothing

    @test QCDNUM.setabr(1.0, 0.0) == nothing 
    
end

