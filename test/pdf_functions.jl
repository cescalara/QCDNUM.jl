using QCDNUM

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
