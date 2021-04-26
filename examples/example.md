---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.11.0
  kernelspec:
    display_name: Julia 1.6.0
    language: julia
    name: julia-1.6
---

## QCDNUM example program

Based on ``example.f`` detailed [here](https://www.nikhef.nl/~h24/qcdnum-files/testjobs1701/example.f).

```julia
using QCDNUM
using Printf
```

```julia
xmin = Float64.([1.0e-4])
iwt = Int32.([1])
ng = 1
nxin = 100
iosp = 3
nx = 10

qq = Float64.([2e0, 1e4])
wt = Float64.([1e0, 1e0])
nq = 1
nqin = 60
ngq = 2
itype = 1

as0 = 0.364
r20 = 2.0

q2c = 3.0
q2b = 25.0
q0 = 2.0
iqt = 999

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

nfin = 0
x = 1.0e-3
q = 1.0e3
pdf = Array{Float64}(undef, 13)
qmz2 = 8315.25;
```

```julia code_folding=[0]
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
    if (i == 7)
        f = 0.0
    end
    if (i == 8)
        f = 0.0
    end
    if (i == 9)
        f = 0.0
    end
    if (i == 10)
        f = 0.0
    end
    if (i == 11)
        f = 0.0
    end
    if (i == 12)
        f = 0.0
    end
    return f
end

func_c = @cfunction(func, Float64, (Ref{Int32}, Ref{Float64}))
```

```julia
QCDNUM.qcinit("/usr/local/lib/libQCDNUM.dylib", -6, " ")
nx = QCDNUM.gxmake(xmin, iwt, ng, nxin, iosp)
nq = QCDNUM.gqmake(qq, wt, ngq, nqin)
nw = QCDNUM.fillwt(itype)
#QCDNUM.wtfile(1, "weights/unpolarised.wgt")
QCDNUM.setord(3)
QCDNUM.setalf(as0, r20)
iqc = QCDNUM.iqfrmq(q2c)
iqb = QCDNUM.iqfrmq(q2b)
iqt = QCDNUM.iqfrmq(1e11)
QCDNUM.setcbt(0, iqc, iqb, 0)
iq0 = QCDNUM.iqfrmq(q0)
eps = QCDNUM.evolfg(itype, func_c, def, iq0)
pdf = QCDNUM.allfxq(itype, x, q, 0, 1)
asmz, a, b = QCDNUM.asfunc(qmz2)
csea = 2*pdf[3];
```

```julia
@printf("x, q, CharmSea = %0.4e, %0.4e, %0.4e\n", x, q, csea)
@printf("as(mz2) = %0.4e", asmz)
```

```julia

```
