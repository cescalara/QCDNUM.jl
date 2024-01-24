```@meta
EditURL = "<unknown>/examples/quickstart.jl"
```

# Quick start

An overview of the functionality in QCDNUM.jl

````@example quickstart
using QCDNUM
````

Before we do anything with QCDNUM.jl, we need to initialise the QCDNUM workspace.

````@example quickstart
QCDNUM.init(banner=true)
````

Most likely we are using QCDNUM because we want to evolve a parton distribution function
(PDF) over different energy scales.

To do this, we will first need to specify the form of the input PDF at some initial
energy scale. The form of the input PDF can be specified by a function together with
a mapping array which tells QCDNUM the ordering of the quark species.

Let's take a look with an example PDF function:

````@example quickstart
function input_pdf_func(ipdf, x)::Float64

    # De-reference pointers
    i = ipdf[]
    xb = x[]

    adbar = 0.1939875
    f = 0

    if (i == 0) # gluon is always i=0
        ag = 1.7
        f = ag * xb^-0.1 * (1.0-xb)^5.0
    end
    if (i == 1) # down valence
        ad = 3.064320
        f = ad * xb^0.8 * (1.0-xb)^4.0
    end
    if (i == 2) # up valence
        au = 5.107200
        f = au * xb^0.8 * (1.0-xb)^3.0
    end
    if (i == 3) # strange
        f = 0.0
    end
    if (i == 4) # down sea, dbar
        f = adbar * xb^-0.1 * (1.0-xb)^6.0
    end
    if (i == 5) # up sea, ubar
        f = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)
    end
    if (i == 6) # anti-strange, sbar
        xdbar = adbar * xb^-0.1 * (1.0-xb)^6.0
        xubar = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)
        f = 0.2 * (xdbar + xubar)
    end
    if (i >= 7) # charm, anti-charm and heavier...
        f = 0.0
    end

    return f
end
````

The signature of this function is fixed by the QCDNUM interface. We also need
to define the ordering, and tell QCDNUM that `i=1` corresponds to the down valence
component, etc. We use the following map, where the rows represent the contribution from
the different quark species and the columns represent the `ipdf` value in the above
function, from 1 to 12.

````@example quickstart
#               tb  bb  cb  sb  ub  db  g   d   u   s   c   b   t
map = Float64.([0., 0., 0., 0., 0.,-1., 0., 1., 0., 0., 0., 0., 0.,   # 1
                0., 0., 0., 0.,-1., 0., 0., 0., 1., 0., 0., 0., 0.,   # 2
                0., 0., 0.,-1., 0., 0., 0., 0., 0., 1., 0., 0., 0.,   # 3
                0., 0., 0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0.,   # 4
                0., 0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0.,   # 5
                0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0.,   # 6
                0., 0.,-1., 0., 0., 0., 0., 0., 0., 0., 1., 0., 0.,   # 7
                0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,   # 8
                0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,   # 9
                0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,   # 10
                0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,   # 11
                0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]); # 12
nothing #hide
````

We can see that many possible PDF parametrisations are possible with this
framework. QCDNUM.jl provides a simple interface, `QCDNUM.InputPDF` to keep track of these two
components and handle the lower-level interface between julia and QCDNUM.

````@example quickstart
input_pdf = QCDNUM.InputPDF(func=input_pdf_func, map=map)
````

We can have a look at this input PDF with the built-in plotting:

````@example quickstart
#plot(input_pdf) - to be implemented...
````

To evolve this input scale, we need to define a number of evolution parameters,
handled by the `QCDNUM.EvolutionParams` interface.

````@example quickstart
fieldnames(QCDNUM.EvolutionParams)
````

We can check the documentation for more info on the different fields
and their default values, e.g.:

`?QCDNUM.EvolutionParams.order`

`?QCDNUM.EvolutionParams.α_S`

Here, let's work with the default values. This means that out input PDF is defined for
a starting scale of evolution_params.q0 with a coupling constant of evolution_params.α_S...

````@example quickstart
evolution_params = QCDNUM.EvolutionParams()
````

Another important aspect that needs to be defined is the grid of `x` (fractional momentum)
and `q2` (energy resolution scale) values. For this we have `QCDNUM.GridParams`, but the
default values have already been set up in `evolution_params.grid_params`.

````@example quickstart
evolution_params.grid_params
````

Let's just stick with these for now. More details on the other parameters can be found
in the documentation.

Now, we have everything we need to evolve the PDF over the specified grid. This is all
taken care of with the `QCDNUM.evolve` function.

````@example quickstart
ϵ = QCDNUM.evolve(input_pdf, evolution_params)
````

This function takes care of all the necessary steps and returns `ϵ`, which quantifies
the deviation due to the interpolation between grid points, and gives a sense of the
accuracy of the approximation. If `ϵ > 0.1`, QCDNUM will report an error.

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*
