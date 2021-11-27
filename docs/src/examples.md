# Examples

Here we show some simple examples based on the [QCDNUM test jobs](https://www.nikhef.nl/~h24/qcdnum-files/testjobs1701/). These examples and more can be found in the `examples` directory of the [GitHub repository](https://github.com/cescalara/QCDNUM.jl) in the form of Jupyter notebooks that can be opened directly with [Jupytext](https://jupytext.readthedocs.io/en/latest/).

{% include_relative example.md %}

## Testing QCDNUM evolution options

We can use [`QCDNUM.evolfg`](@ref) to evolve the PDF set for all flavours, or [`QCDNUM.evsgns`](@ref) to evolve an arbitrary set of singlet/non-singlet pdfs. The latter may offer potential for external parallelisation, but first we must verify that we can use it to recreate expected results.

We do this by recreating the `example.f` demo using [`QCDNUM.evsgns`](@ref). This is based on the `testsgns.f` test job.

```@example 2
using QCDNUM
using Printf
```

Again we start by defining inputs, as above.

```@example 2
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

Lets make an input PDF function:

```@example 2
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

And also a function that passes an input PDF as an output of another PDF.

```@example 2
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

Now we can set up QCDNUM and print a summary of our inputs.

```@example 2
QCDNUM.qcinit(-6, " ")
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
```

Let's evolve the PDF using both options:

```@example 2
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

Now we can compare the results from each case, by first defining a useful function.

```@example 2
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

```@example 2
for id in 0:12
    compare(iset1, iset2, id, 0, 1)
end
```

## Timing evolution and structure function evaluation

Based on the `timing.f` test job.

```@example 3
using QCDNUM
using Printf
```

Again, we start by defining the necessary inputs...

```@example 3
xmin = Float64.([1e-5, 0.2, 0.4, 0.6, 0.75])
iwt = Int32.([1, 2, 4, 8, 16])
ngx = 5
nxin = 100
iosp = 3
nx = 0
qlim = Float64.([2e0, 1e4])
wt = Float64.([1e0, 1e0])
ngq = 2
nqin = 50
nq = 1
itype = 1
filename = "weights/unpolarised.wgt"
iord = 3
as0 = 0.364
r20 = 2.0
q2c = 3.0
q2b = 25.0
q0 = 2.0
nfin = 0
iqt = 999;

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
```

```@example 3
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

```@example 3
proton = Float64.([4.,1.,4.,1.,4.,1.,0.,1.,4.,1.,4.,1.,4.])/9.0;
xx = Array{Float64}(undef, 1000)
q2 = Array{Float64}(undef, 1000)

roots = 300
shera = roots*roots
xlog1 = log(xmin[1])
xlog2 = log(0.99)
qlog1 = log(qlim[1])
qlog2 = log(qlim[ngq])
ntot = 1
while (ntot < 1001)
    rval = rand()
    xlog = xlog1 + rval*(xlog2-xlog1)
    xxxx = exp(xlog)
    rval = rand()
    qlog = qlog1 + rval*(qlog2-qlog1)
    qqqq = exp(qlog)
    if (qqqq <= xxxx*shera)
        xx[ntot] = xxxx
        q2[ntot] = qqqq
        global ntot += 1
    end
end
```

Now, we set up QCDNUM and time many evolution and structure function evaluations.

```@example 3
QCDNUM.qcinit(-6, " ")
nx = QCDNUM.gxmake(xmin, iwt, ngx, nxin, iosp)
nq = QCDNUM.gqmake(qlim, wt, ngq, nqin)
#QCDNUM.wtfile(itype, filename)
nw = QCDNUM.fillwt(1)
nw = QCDNUM.zmfillw()
QCDNUM.setord(iord)
QCDNUM.setalf(as0, r20)
iqc = QCDNUM.iqfrmq(q2c)
iqb = QCDNUM.iqfrmq(q2b)
QCDNUM.setcbt(nfin, iqc, iqb, iqt)
iq0 = QCDNUM.iqfrmq(q0)

@printf(" Wait: 1000 evols and 2.10^6 stfs will take ... ")
@time begin
    for iter in 1:1000
        eps = QCDNUM.evolfg(itype, func_c, def, iq0)
        ff = QCDNUM.zmstfun(1, proton, xx, q2, 1000, 1)
        ff = QCDNUM.zmstfun(2, proton, xx, q2, 1000, 1)
    end
end
```
