---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.11.0
  kernelspec:
    display_name: Julia 1.6.1
    language: julia
    name: julia-1.6
---

# Test QCDNUM evolution options

We can use `evolfg` to evolve the pdf set for all flavours, or `evsgns` to evolve an arbitrary set of singlet/non-singlet pdfs. The latter may offer potential for external parallelisation, but first we must verify that we can use it to recreate expected results.

We do this the recreating the `example.f` demo using `evsgns`.

```julia
using QCDNUM
using Printf
```

## Define inputs

```julia
xmin = Float64.([1.0e-5, 0.2, 0.4, 0.6, 0.75])
iwt = Int32.([1, 2, 4, 8, 16])
nxsubg = 5
nxin = 100
iosp = 3

qq = Float64.([2e0, 1e4])
wt = Float64.([1e0, 1e0])
nqin = 60
itype = 1
as0 = 0.364
r20 = 2.0

q2c = 3.0
q2b = 25.0
q2t = 1e11
q0 = 2.0

def = Float64.([0., 0., 0., 0., 0.,-1., 0., 1., 0., 0., 0., 0., 0.,   
                0., 0., 0., 0.,-1., 0., 0., 0., 1., 0., 0., 0., 0.,   
                0., 0., 0.,-1., 0., 0., 0., 0., 0., 1., 0., 0., 0.,   
                0., 0., 0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0.,   
                0., 0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0.,   
                0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0.,   
                0., 0.,-1., 0., 0., 0., 0., 0., 0., 0., 1., 0., 0.,   
                0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,   
                0.,-1., 0., 0., 0., 0., 0., 0., 0., 0., 0., 1., 0.,   
                0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,   
                -1., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 1.,   
                1., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0. ])

isns =  Int32.([1,  2,  2,  2,  2,  2, -1, -2, -2, -2, -2, -2])

nfix = 6
aar = 1.0
bbr = 0.0;
```

```julia code_folding=[0]
function func1(ipdf, x)::Float64
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
    if (i == 7)
        f = 0.0
    end
    if (i == 8)
        xdbar = adbar * xb^-0.1 * (1.0-xb)^6.0
        xubar = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)
        f = 0.2 * (xdbar + xubar)
    end
    if (i == 9)
        f = 0.0
    end
    if (i == 10)
        xdbar = adbar * xb^-0.1 * (1.0-xb)^6.0
        xubar = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)
        f = 0.2 * (xdbar + xubar)
    end
    if (i == 11)
        f = 0.0
    end
    if (i == 12)
        xdbar = adbar * xb^-0.1 * (1.0-xb)^6.0
        xubar = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)
        f = 0.2 * (xdbar + xubar)
    end
    return f
end

func1_c = @cfunction(func1, Float64, (Ref{Int32}, Ref{Float64}));
```

```julia
function func2(ipdf, x)::Float64
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

func2_c = @cfunction(func2, Float64, (Ref{Int32}, Ref{Float64}));
```

## Run QCDNUM

```julia
QCDNUM.qcinit("/usr/local/lib/libQCDNUM.dylib", -6, " ")
nx = QCDNUM.gxmake(xmin, iwt, nxsubg, nxin, iosp) # make x grid
nq = QCDNUM.gqmake(qq, wt, 2, nqin) # make qq grid
nw = QCDNUM.fillwt(itype) # fill weight tables
QCDNUM.setord(3) # NLO in pQCD
QCDNUM.setalf(as0, r20) # alpha and scale
iqc = QCDNUM.iqfrmq(q2c) 
iqb = QCDNUM.iqfrmq(q2b)
iqt = QCDNUM.iqfrmq(q2t)
QCDNUM.setcbt(nfix, iqc, iqb, iqt) # FFNS and thresholds
QCDNUM.setabr(aar, bbr) # Relationship between mu_F^2 and mu_R^2
iq0 = QCDNUM.iqfrmq(q0)

# Print summary
@printf("xmin = %0.2e, \t subgrids = %i\n", xmin[1], nxsubg)
@printf("qmin = %0.2e, \t qmax = %0.2e\n", qq[1], qq[2])
@printf("nfix = %i, \t\t q2c, b, t = %0.2e, %0.2e, %0.2e\n", nfix, q2c, q2b, q2t)
@printf("alpha = %0.2e, \t r20 = %0.2e\n", as0, r20)
@printf("aar = %0.2e, \t bbr = %0.2e\n", aar, bbr)
@printf("q20 = %0.2e\n", q0)

# EVOLFG
iset1 = 1                                       
jtype = 10*iset1+itype
eps = QCDNUM.evolfg(jtype, func1_c, def, iq0)
QCDNUM.qstore("write", 1, float(iset1))
QCDNUM.qstore("write", 2, float(iq0))

# EVSGNS
iset2 = 2
jtype = 10*iset2+itype
QCDNUM.setint("edbg", 0) # turn off debug
eps = QCDNUM.evsgns(jtype, func2_c, isns, 12, iq0);
```

## Compare evolfg and evsgns

```julia
function compare(jset1, jset2, id, jq, ixmin)

    nx, xmi, xma, nq, qmi, qma, iord = QCDNUM.grpars()
    
    if (jq == 0)
        iq1 = 1
        iq2 = nq
        jxmin = 0
    else
        iq1 = jq
        iq2 = jq
        jxmin = ixmin
    end
    
    dif = 0.0
    for iq in [iq1, iq2]
        for ix in 1:nx
            val1 = QCDNUM.bvalij(jset1, id, ix, iq, 1)
            val2 = QCDNUM.bvalij(jset2, id, ix, iq, 1)
            difi = val1-val2
            dif = max(difi, abs(difi))
            if (ix < jxmin)
                println("(2I3,2F10.4,E13.3,2X,3I3)")
            end
        end
    end
        
    if (jxmin == 0)
        @printf("id = %i, \t dif = %0.5e\n", id, dif)
    end
    
end
```

```julia
for id in 0:12
    compare(iset1, iset2, id, 0, 1)
end
```

```julia

```
