using QCDNUM
using Test

include("pdf_functions.jl")

@testset "Evolution & interpolation" begin

    # C-pointer to func
    func_c = @cfunction(func, Float64, (Ref{Int32}, Ref{Float64}))
    func_ext_c = @cfunction(func_ext, Float64, (Ref{Int32}, Ref{Float64}, Ref{Float64}, Ref{UInt8}))
    func_usr_c = @cfunction(func_usr, Float64, (Ref{Int32}, Ref{Float64}, Ref{Float64}, Ref{UInt8}))

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

    # alpha_S
    asmz, nf, ierr = QCDNUM.asfunc(8315.25)
    @test asmz ≈ 0.1180167650168159
    @test nf == 5
    @test ierr == 0

    for n in -2:20
        for iq in 1:nq
            asn, ierr = QCDNUM.altabn(1, iq, n)
            @test asn > 0
            @test ierr == 0
        end
    end

    # PDF copy
    QCDNUM.pdfcpy(1, 2)
    
    ntables = QCDNUM.nptabs(2)
    @test ntables == 13

    type = QCDNUM.ievtyp(2)
    @test type == 1

    for id in -6:6
        pdf_ij_1 = QCDNUM.fvalij(1, id, ix, iq, 1)
        pdf_ij_2 = QCDNUM.fvalij(2, id, ix, iq, 1)
        @test pdf_ij_1 == pdf_ij_2
    end

    # PDF copy via extpdf
    epsi = QCDNUM.extpdf(func_ext_c, 3, 0, 0.0)
    @test epsi < 0.05

    ntables = QCDNUM.nptabs(3)
    @test ntables == 13

    type = QCDNUM.ievtyp(3)
    @test type == 4

    for id in -6:6
        pdf_ij_1 = QCDNUM.fvalij(1, id, ix, iq, 1)
        pdf_ij_3 = QCDNUM.fvalij(3, id, ix, iq, 1)
        @test isapprox(pdf_ij_1, pdf_ij_3, rtol=0.001)
    end

    # PDF copy via usrpdf
    epsi = QCDNUM.usrpdf(func_usr_c, 4, 12, 0.0)
    @test epsi < 0.05
    
    ntables = QCDNUM.nptabs(4)
    @test ntables == 13

    type = QCDNUM.ievtyp(4)
    @test type == 5
    
    for id in 0:12
        pdf_ij_1 = QCDNUM.bvalij(1, id, ix, iq, 1)
        pdf_ij_4 = QCDNUM.bvalij(4, id, ix, iq, 1)
        @test isapprox(pdf_ij_1, pdf_ij_4, rtol=0.001)        
    end
   

end
