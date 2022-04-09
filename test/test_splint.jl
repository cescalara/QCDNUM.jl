using QCDNUM
using Test

include("pdf_functions.jl")

@testset "SPLINT" begin

        # Initialise
    QCDNUM.qcinit(-6, "")
    
    # C-pointer to func
    func_c = @cfunction(func, Float64, (Ref{Int32}, Ref{Float64}))

    # Initialise
    QCDNUM.qcinit(-6, "")

    # Grids and weights
    nx = QCDNUM.gxmake(Float64.([1.0e-4]), Int32.([1]), 1, 100, 3)
    nq = QCDNUM.gqmake(Float64.([2e0, 1e4]), Float64.([1e0, 1e0]), 2, 50)
    nw = QCDNUM.fillwt(1)

    # Set parameters
    QCDNUM.setord(3)
    QCDNUM.setalf(0.364, 2.0)

    # VFNS
    iqc = QCDNUM.iqfrmq(3.0)
    iqb = QCDNUM.iqfrmq(25.0)
    QCDNUM.setcbt(0, iqc, iqb, 0)

    # Evolution
    iq0 = QCDNUM.iqfrmq(2.0)
    eps = QCDNUM.evolfg(1, func_c, def, iq0)
    @test typeof(eps) == Float64

    # SPLINT
    func_sp_c = @cfunction(func_sp, Float64, (Ref{Int32}, Ref{Int32}, Ref{UInt8}))
    
    iset = 1
    ipdf = 1

    # Initialise
    QCDNUM.ssp_spinit(100)

    # Store iset and ipdf
    QCDNUM.ssp_uwrite(1, Float64(iset))
    QCDNUM.ssp_uwrite(2, Float64(ipdf))

    # Make spline object
    iasp = QCDNUM.isp_s2make(5, 5)
    @test typeof(iasp) == Int32

    # Fill the spline and set no kinematic limit
    QCDNUM.ssp_s2fill(iasp, func_sp_c, 0.0)

    # Check spline type
    type = QCDNUM.isp_splinetype(iasp)
    @test type == 2

    # Check limits
    nu, u1, u2, nv, v1, v2, n = QCDNUM.ssp_splims(iasp)
    @test nu == 22
    @test u1 ≈ 1e-4
    @test u2 == 1.0
    @test nv == 12
    @test v1 == 2.0
    @test v2 ≈ 1e4
    @test n == nu * nv

    # Evalute function and integral
    x = 0.1
    q = 100.0
    f = QCDNUM.dsp_funs2(iasp, x, q, 1)
    @test isapprox(f, 0.408, rtol=0.01)

    x1 = 0.01
    x2 = 0.1
    q1 = 10.0
    q2 = 100.0
    rs = 370.0
    np = 4
    integral = QCDNUM.dsp_ints2(iasp, x1, x2, q1, q2, rs, np)
    @test isapprox(integral, 3.709, rtol = 0.01)

    # Copy nodes
    u_nodes = QCDNUM.ssp_unodes(iasp, nu, nu)
    v_nodes = QCDNUM.ssp_vnodes(iasp, nv, nv)
    @test size(u_nodes)[1] == nu
    @test size(v_nodes)[1] == nv

    @test QCDNUM.ssp_nprint(iasp) == nothing

    for i in 1:3
        @test QCDNUM.ssp_extrapu(iasp, i) == nothing
        @test QCDNUM.ssp_extrapv(iasp, i) == nothing
    end

    @test QCDNUM.ssp_erase(iasp) == nothing
    
    # 1D spline
    iasp = QCDNUM.isp_sxmake(5)
    @test typeof(iasp) == Int32
    
    iasp = QCDNUM.isp_sqmake(5)
    @test typeof(iasp) == Int32
    
    
end
