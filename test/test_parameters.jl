using QCDNUM
using Test

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
