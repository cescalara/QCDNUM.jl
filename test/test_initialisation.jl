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
    int_options = ["iter", "tlmc", "nopt", "edbg"]
    for opt in int_options
        @test QCDNUM.setint(opt, 1) == nothing
    end

    val_options = ["epsi", "epsg", "elim", "alim"]
    for opt in val_options
        @test QCDNUM.setval(opt, 1.0e-4) == nothing
    end

    val_options = ["qmin", "qmax"]
    for opt in val_options
        @test QCDNUM.setval(opt, 1.0) == nothing
    end
    
end
