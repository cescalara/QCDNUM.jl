using QCDNUM
using Test

@testset "QCDNUM.jl" begin
    QCDNUM.qcinit(-6, " ")
    nx = QCDNUM.gxmake(Float64.([1.0e-4]), Int32.([1]), 1, 100, 3)
    @test nx == 100
end
