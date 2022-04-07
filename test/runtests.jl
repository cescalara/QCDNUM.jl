using QCDNUM
using Test
using Documenter

@testset "Docs" begin
    doctest(QCDNUM)
end

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

    val_options = ["epsi", "epsg", "elim", "alim", "qlim"]
    for opt in val_options
        @test QCDNUM.setval(opt, 1.0e-4)
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

# Define a test PDF function and mapping
function func(ipdf, x)::Float64

    i = ipdf[]
    xb = x[]
    adbar = 0.1939875
    f = 0
    if (i == 0) 
        ag = 1.7
        f = ag * xb^-0.1 * (1.0-xb)^5.0
    end
    if (i == 1)
        ad = 3.064320
        f = ad * xb^0.8 * (1.0-xb)^4.0
    end
    if (i == 2)
        au = 5.107200
        f = au * xb^0.8 * (1.0-xb)^3.0
    end
    if (i == 3) 
        f = 0.0
    end
    if (i == 4)
        f = adbar * xb^-0.1 * (1.0-xb)^6.0
    end
    if (i == 5) 
        f = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)
    end
    if (i == 6)
        xdbar = adbar * xb^-0.1 * (1.0-xb)^6.0
        xubar = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)
        f = 0.2 * (xdbar + xubar)
    end
    if (i >= 7)
        f = 0.0
    end

    return f
end

function func_sgns(ipdf, x)::Float64
    i = ipdf[]
    xb = x[]
    
    f = 0.0
    
    if (i == -1)
        iset = Int(QCDNUM.qstore("read", 1))
        iq0 = Int(QCDNUM.qstore("read", 2))
    else
        iset = Int(QCDNUM.qstore("read", 1))
        iq0 = Int(QCDNUM.qstore("read", 2))
        ix = QCDNUM.ixfrmx(xb)
        f = QCDNUM.bvalij(iset, i, ix, iq0, 1)
    end
    
    return f
end

def = Float64.([0., 0., 0., 0., 0.,-1., 0., 1., 0., 0., 0., 0., 0.,     
                0., 0., 0., 0.,-1., 0., 0., 0., 1., 0., 0., 0., 0.,      
                0., 0., 0.,-1., 0., 0., 0., 0., 0., 1., 0., 0., 0.,      
                0., 0., 0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0.,      
                0., 0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0.,      
                0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      
                0., 0.,-1., 0., 0., 0., 0., 0., 0., 0., 1., 0., 0.,      
                0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      
                0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      
                0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      
                0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      
                0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]);

@testset "Evolution & interpolation" begin

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
    @test eps < 0.1

    # For SGNS 
    QCDNUM.qstore("write", 1, float(1))
    QCDNUM.qstore("write", 2, float(iq0))

    # Interpolation
    x = 1e-3
    q = 1e3
    pdf = QCDNUM.allfxq(1, x, q, 0, 1)
    @test pdf[1] == 0.0
    @test size(pdf)[1] == 13

    ix = QCDNUM.ixfrmx(x)
    iq = QCDNUM.iqfrmq(q)
    
    for id in 0:12
        pdf_ij = QCDNUM.bvalij(1, id, ix, iq, 1)
        pdf_xq = QCDNUM.bvalxq(1, id, x, q, 1)
        @test isapprox(pdf_ij, pdf_xq, rtol=0.1)        
    end

    for id in -6:6
        pdf_ij = QCDNUM.fvalij(1, id, ix, iq, 1)
        pdf_xq = QCDNUM.fvalxq(1, id, x, q, 1)
        @test isapprox(pdf_ij, pdf_xq, rtol=0.1)
    end

    # Check number of PDF tables
    ntables = QCDNUM.nptabs(1)
    @test ntables == 13

    # Check evolution type
    type = QCDNUM.ievtyp(1)
    @test type == 1

    asmz, a, b = QCDNUM.asfunc(8315.25)
    @test asmz ≈ 0.1180167650168159
    @test a == 5
    @test b == 0
    
end

@testset "Structure functions" begin

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

    # ZMSTF
    ntot, nused_bf = QCDNUM.zmwords()
    nw = QCDNUM.zmfillw()
    ntot, nused_af = QCDNUM.zmwords()
    @test typeof(nw) == Int32
    @test nw == nused_af - nused_bf

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

    Au = 4.0/9.0 
    Ad = 1.0/9.0
    w = [0., Ad, Au, Ad, Au, Ad, 0., Ad, Au, Ad, Au, Ad, 0.]
    x = 1e-3
    q = 1e3
    
    for istf in 1:4
        f = QCDNUM.zmstfun(istf, w, [x], [q], 1, 0)
        @test typeof(f[1]) == Float64 
    end
    
end

# Define function to read from QCDNUM into spline
function func_sp(ix, iq, first)::Float64

    # deref ptrs
    ix = ix[] 
    iq = iq[]

    # Read iset and ipdf
    iset = Int32(QCDNUM.dsp_uread(1))
    ipdf = Int32(QCDNUM.dsp_uread(2))
    
    return QCDNUM.fvalij(iset, ipdf, ix, iq, 1)
end


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
