# # Quick start
#
# An overview of the functionality in QCDNUM.jl

using QCDNUM

# Before we do anything with QCDNUM.jl, we need to initialise the QCDNUM workspace.

QCDNUM.init(banner=true)

# Most likely we are using QCDNUM because we want to evolve a parton distribution function
# (PDF) over different energy scales.
#
# To do this, we will first need to specify the form of the input PDF at some initial
# energy scale. The form of the input PDF can be specified by a function together with
# a mapping array which tells QCDNUM the ordering of the quark species.
#
# Let's take a look with an example PDF function:

function input_pdf_func(ipdf, x)::Float64

    ## De-reference pointers
    i = ipdf[]
    xb = x[]

    adbar = 0.1939875
    f = 0

    if (i == 0) # gluon is always i=0
        ag = 1.7
        f = ag * xb^-0.1 * (1.0 - xb)^5.0
    end
    if (i == 1) # down valence
        ad = 3.064320
        f = ad * xb^0.8 * (1.0 - xb)^4.0
    end
    if (i == 2) # up valence
        au = 5.107200
        f = au * xb^0.8 * (1.0 - xb)^3.0
    end
    if (i == 3) # strange 
        f = 0.0
    end
    if (i == 4) # down sea, dbar
        f = adbar * xb^-0.1 * (1.0 - xb)^6.0
    end
    if (i == 5) # up sea, ubar 
        f = adbar * xb^-0.1 * (1.0 - xb)^6.0 * (1.0 - xb)
    end
    if (i == 6) # anti-strange, sbar
        xdbar = adbar * xb^-0.1 * (1.0 - xb)^6.0
        xubar = adbar * xb^-0.1 * (1.0 - xb)^6.0 * (1.0 - xb)
        f = 0.2 * (xdbar + xubar)
    end
    if (i >= 7) # charm, anti-charm and heavier...
        f = 0.0
    end

    return f
end

# The signature of this function is fixed by the QCDNUM interface. We also need
# to define the ordering, and tell QCDNUM that `i=1` corresponds to the down valence
# component, etc. We use the following map, where the rows represent the contribution from
# the different quark species and the columns represent the `ipdf` value in the above
# function, from 1 to 12. 

map = Float64.([
    ##   tb  bb  cb  sb  ub  db   g   d   u   s   c   b   t
    0, 0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, 0, # 1 # U valence
    0, 0, 0, 0, 0, -1, 0, 1, 0, 0, 0, 0, 0, # 2 # D valence
    0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, # 3 # u sea
    0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, # 4 # d sea
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, # 5 # s
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, # 6 # sbar
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, # 7 # c
    0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, # 8 # cbar
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, # 9 # b
    0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, # 10 # bbar
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, # 11
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # 12
])

# We can see that many possible PDF parametrisations are possible with this
# framework. QCDNUM.jl provides a simple interface, `QCDNUM.InputPDF` to keep track of these two
# components and handle the lower-level interface between julia and QCDNUM.

input_pdf = QCDNUM.InputPDF(func=input_pdf_func, map=map)

# To evolve this input scale, we need to define a number of evolution parameters,
# handled by the `QCDNUM.EvolutionParams` interface. 

fieldnames(QCDNUM.EvolutionParams)

# We can check the documentation for more info on the different fields
# and their default values, e.g.:
#
# `?QCDNUM.EvolutionParams.order`
#
# `?QCDNUM.EvolutionParams.α_S`
#
# Here, let's work with the default values. This means that out input PDF is defined for
# a starting scale of `evolution_params.q0` with a coupling constant of `evolution_params.α_S`

evolution_params = QCDNUM.EvolutionParams()

# Another important aspect that needs to be defined is the grid of `x` (fractional momentum)
# and `q2` (energy resolution scale) values. For this we have `QCDNUM.GridParams`, but the
# default values have already been set up in `evolution_params.grid_params`.

evolution_params.grid_params

# Let's just stick with these for now. More details on the other parameters can be found
# in the documentation.

# Now, we have everything we need to evolve the PDF over the specified grid. This is all
# taken care of with the `QCDNUM.evolve` function.

ϵ = QCDNUM.evolve(input_pdf, evolution_params)

# This function takes care of all the necessary steps and returns `ϵ`, which quantifies
# the deviation due to the interpolation between grid points, and gives a sense of the
# accuracy of the approximation. If `ϵ > 0.1`, QCDNUM will report an error.

# We can now access and plot the evolved PDF at the scale of our choice.

q2 = 300.0 # GeV^2
n_additional_pdfs = 0
err_check_flag = 1 # Run with error checking

x_grid = range(1e-3, stop=1, length=100)
itype = evolution_params.output_pdf_loc

## Select pdf with index according to above definition
## NB -> in Julia indexing starts from 1
g_pdf = [QCDNUM.allfxq(itype, x, q2, n_additional_pdfs, err_check_flag)[1] for x in x_grid]
dv_pdf = [QCDNUM.allfxq(itype, x, q2, n_additional_pdfs, err_check_flag)[2] for x in x_grid]
uv_pdf = [QCDNUM.allfxq(itype, x, q2, n_additional_pdfs, err_check_flag)[3] for x in x_grid]

# Let's also compare these with those from the input PDFs at the starting scale

using Plots

q0 = evolution_params.q0
p1 = plot(x_grid, [input_pdf.func(0, x) for x in x_grid], label="x g(x) - Q2 = $q0",
    lw=3, linestyle=:dash, alpha=0.5, color=:black)
plot!(x_grid, [input_pdf.func(1, x) for x in x_grid], label="x dv(x) - Q2 = $q0",
    lw=3, linestyle=:dash, alpha=0.5, color=:red)
plot!(x_grid, [input_pdf.func(2, x) for x in x_grid], label="x uv(x) - Q2 = $q0",
    lw=3, linestyle=:dash, alpha=0.5, color=:green)

p2 = plot(x_grid, g_pdf, label="x g(x) - Q2 = $q2", lw=3, color=:black)
plot!(x_grid, dv_pdf, label="x dv(x) - Q2 = $q2", lw=3, color=:red)
plot!(x_grid, uv_pdf, label="x uv(x) - Q2 = $q2", lw=3, color=:green)

plot(p1, p2, layout=(1, 2), xlabel="x")

# We can also save the QCDNUM setup that we used here for later use:

QCDNUM.save_params("my_qcdnum_params.h5", evolution_params)

# Of course, these can be then be loaded back:

g = QCDNUM.load_params("my_qcdnum_params.h5")
g["evolution_params"]
