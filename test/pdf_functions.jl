using QCDNUM
"""
    func(ipdf, x)

A example input pdf function.
"""
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

"""
    func_sgns(ipdf, x)

Test function for use with QCDNUM.evsgns().
"""
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

"""
    Defintion of input PDF map.
"""
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

"""
    func_ext(ipdf, x, q, first)

Example function to test out QCDNUM.extpdf(). This is just a long
way of copying a PDF set.
"""
function func_ext(ipdf::Integer, x::Float64, q::Float64, first::UInt8)::Float64

    iset = Int32(QCDNUM.qstore("read", 1))
   
    return QCDNUM.fvalxq(iset, ipdf, x, q, 1)
end

"""
    func_usr(ipdf, x, q, first)

Example function to test out QCDNUM.usrpdf. This is just a long
way of copying a  PDF set.
"""
function func_usr(ipdf::Integer, x::Float64, q::Float64, first::UInt8)::Float64

    iset = Int32(QCDNUM.qstore("read", 1))

    return QCDNUM.bvalxq(iset, ipdf, x, q, 1)
end

"""
    func_sp(ix, iq, first)

Example function to read into SPLINT spline.
"""
function func_sp(ix::Integer, iq::Integer, first::UInt8)::Float64

    # deref ptrs
    ix = ix[] 
    iq = iq[]

    # Read iset and ipdf
    iset = Int32(QCDNUM.dsp_uread(1))
    ipdf = Int32(QCDNUM.dsp_uread(2))
    
    return QCDNUM.fvalij(iset, ipdf, ix, iq, 1)
end
