"""
    ssp_spinit(nuser)

Initialise SPLINT - should be called before other 
SPLINT functions.

# Arguments
- `nuser::Integer`: the number of words reserved for user storage 
"""
function ssp_spinit(nuser::Integer)

    nuser = Ref{Int32}(nuser)

    @ccall ssp_spinit_(nuser::Ref{Int32})::Nothing
    
    nothing
end


"""
    isp_s2make(istepx, istepq)

Create a spline object in memory, and return the address.
Every istep-th grid point is taken as a node point of the 
spline and the grid boundaries are always included as node
points.

# Arguments
- `istepx::Integer`: steps taken in sampling the QCDNUM x grid
- `istepq::Integer`: steps taken in sampling the QCDNUM qq grid
"""
function isp_s2make(istepx::Integer, istepq::Integer)

    istepx = Ref{Int32}(istepx)
    istepq = Ref{Int32}(istepq)

    iasp = @ccall isp_s2make_(istepx::Ref{Int32}, istepq::Ref{Int32})::Int32
    
    iasp[]
end


"""
    isp_sxmake(istepx)

Create a 1D x spline object in memory, and return the address.
Every istep-th grid point is taken as a node point of the 
spline and the grid boundaries are always included as node
points.

# Arguments
- `istepx::Integer`: steps taken in sampling the QCDNUM x grid
"""
function isp_sxmake(istepx::Integer)

    istepx = Ref{Int32}(istepx)

    iasp = @ccall isp_sxmake_(istepx::Ref{Int32})::Int32
    
    iasp[]
end


"""
    isp_sqmake(istepq)

Create a 1D qq spline object in memory, and return the address.
Every istep-th grid point is taken as a node point of the 
spline and the grid boundaries are always included as node
points.

# Arguments
- `istepq::Integer`: steps taken in sampling the QCDNUM qq grid
"""
function isp_sqmake(istepq::Integer)

    istepq = Ref{Int32}(istepq)

    iasp = @ccall isp_sqmake_(istepq::Ref{Int32})::Int32
    
    iasp[]
end


"""
    ssp_uwrite(i, val)

Write something to the reserved user space.

# Arguments
- `i::Integer`: where to write, from 1 to nuser
- `val::Float`: what to write
"""
function ssp_uwrite(i::Integer, val::Float64)

    i = Ref{Int32}(i)
    val = Ref{Float64}(val)

    @ccall ssp_uwrite_(i::Ref{Int32}, val::Ref{Float64})::Nothing

    nothing
end

"""
    dsp_uread(i)

Read something from the reserved user space.

# Arguments
- `i::Integer`: where to read, from 1 to nuser

# Returns
- `val::Float64`: what is read
"""
function dsp_uread(i::Integer)

    i = Ref{Int32}(i)

    val = @ccall dsp_uread_(i::Ref{Int32})::Float64

    val[]
end

"""
    ssp_s2fill(iasp, fun, rs)

Fill the spline object by passing a function. The function 
must have the signature fun(ix::Integer, iq::Integer, first::Boolean).

# Arguments
- `iasp::Integer`: address of the spline object
- `fun::Ptr{Nothing}`: function to be splined
- `rs::Float64`: set a sqrt(s) cut - 0 for no kinematic cut 
"""
function ssp_s2fill(iasp::Integer, fun::Ptr{Nothing}, rs::Float64)

    iasp = Ref{Int32}(iasp)
    rs = Ref{Float64}(rs)

    @ccall ssp_s2fill_(iasp::Ref{Int32}, fun::Ptr{Cvoid},
                       rs::Ref{Float64})::Nothing

    nothing
end

"""
    ssp_sxfill(iasp, fun, iq)

Fill the 1D x spline object by passing a function. The function 
must have the signature fun(ix::Integer, iq::Integer, first::Boolean).

# Arguments
- `iasp::Integer`: address of the spline object
- `fun::Ptr{Nothing}`: function to be splined
- `iq::Integer`: fixed iq value to pass to fun
"""
function ssp_sxfill(iasp::Integer, fun::Ptr{Nothing}, iq::Integer)

    iasp = Ref{Int32}(iasp)
    iq = Ref{Int32}(iq)

    @ccall ssp_sxfill_(iasp::Ref{Int32}, fun::Ptr{Cvoid},
                       iq::Ref{Int32})::Nothing

    nothing
end

"""
    ssp_sqfill(iasp, fun, ix)

Fill the 1D qq spline object by passing a function. The function 
must have the signature fun(ix::Integer, iq::Integer, first::Boolean).

# Arguments
- `iasp::Integer`: address of the spline object
- `fun::Ptr{Nothing}`: function to be splined
- `ix::Integer`: fixed ix value to pass to fun
"""
function ssp_sqfill(iasp::Integer, fun::Ptr{Nothing}, ix::Integer)

    iasp = Ref{Int32}(iasp)
    ix = Ref{Int32}(ix)

    @ccall ssp_sqfill_(iasp::Ref{Int32}, fun::Ptr{Cvoid},
                       ix::Ref{Int32})::Nothing

    nothing
end


"""
    ssp_sxf123(ia, iset, def, istf, iq)

Fast structure function input for splines over x.

# Arguments
- `ia::Integer`: address of the spline object
- `iset::Integer`: QCDNUM pdf-set index
- `def::Array{Float64}`: Array of (anti-)quark
coefficients 
- `istf::Integer`: structure function index 
1<=>F_L, 2<=>F_2, 3<=>xF_3, 4<=>F_L'
- `iq::Integer`: index of qq value 
"""
function ssp_sxf123(ia::Integer, iset::Integer, def::Array{Float64},
                    istf::Integer, iq::Integer)

    ia = Ref{Int32}(ia)
    iset = Ref{Int32}(iset)
    istf = Ref{Int32}(istf)
    iq = Ref{Int32}(iq)

    @ccall ssp_sxf123_(ia::Ref{Int32}, iset::Ref{Int32},
                       def::Ref{Float64}, istf::Integer,
                       iq::Integer)::Nothing

    nothing
end

"""
    ssp_sq123(ia, iset, def, istf, ix)

Fast structure function input for splines over qq.

# Arguments
- `ia::Integer`: address of the spline object
- `iset::Integer`: QCDNUM pdf-set index
- `def::Array{Float64}`: Array of (anti-)quark
coefficients 
- `istf::Integer`: structure function index 
1<=>F_L, 2<=>F_2, 3<=>xF_3, 4<=>F_L'
- `ix::Integer`: index of x value 
"""
function ssp_sqf123(ia::Integer, iset::Integer, def::Array{Float64},
                    istf::Integer, ix::Integer)

    ia = Ref{Int32}(ia)
    iset = Ref{Int32}(iset)
    istf = Ref{Int32}(istf)
    ix = Ref{Int32}(ix)

    @ccall ssp_sqf123_(ia::Ref{Int32}, iset::Ref{Int32},
                       def::Ref{Float64}, istf::Integer,
                       ix::Integer)::Nothing

    nothing
end

"""
    ssp_s2f123(ia, iset, def, istf, rs)

Fast structure function input for 2D 
splines over x and qq.

# Arguments
- `ia::Integer`: address of the spline object
- `iset::Integer`: QCDNUM pdf-set index
- `def::Array{Float64}`: Array of (anti-)quark
coefficients 
- `istf::Integer`: structure function index 
1<=>F_L, 2<=>F_2, 3<=>xF_3, 4<=>F_L'
- `rs::Float64`: sqrt(s) cut - 0 for no kinematic cut

"""
function ssp_s2f123(ia::Integer, iset::Integer, def::Array{Float64},
                    istf::Integer, rs::Float64)

    ia = Ref{Int32}(ia)
    iset = Ref{Int32}(iset)
    istf = Ref{Int32}(istf)
    rs = Ref{Float64}(rs)

    @ccall ssp_sxf123_(ia::Ref{Int32}, iset::Ref{Int32},
                       def::Ref{Float64}, istf::Integer,
                       rs::Float64)::Nothing

    nothing
end

"""
    isp_s2user(xarr, nx, qarr, nq)

Set your own node points in the spline in case
the automatic sampling fails.

The routine will discard points outside the x-qq 
evolution grid, round the remaining nodes down to 
the nearest grid-point and then sort them in 
ascending order, discarding equal values. Thus you
are allowed to enter un-sorted scattered arrays.

# Arguments
- `xarr::Array{Float64}`: array of x values
- `nx::Integer`: length of xarr
- `qarr::Array{Float64}`: array of qq values
- `nq::Integer`: length of qarr

# Returns
- `iasp::Integer`: address of the spline object
"""
function isp_s2user(xarr::Array{Float64}, nx::Integer,
                    qarr::Array{Float64}, nq::Integer)

    nx = Ref{Int32}(nx)
    nq = Ref{Int32}(nq)

    iasp = @ccall isp_s2user_(xarr::Ref{Float64}, nx::Ref{Int32},
                              qarr::Ref{Float64}, nq::Ref{Int32})::Int32

    iasp[]
end


"""
    isp_sxuser(xarr, nx)

Set your own node points in the 1D x spline in case
the automatic sampling fails.

# Arguments
- `xarr::Array{Float64}`: array of x values
- `nx::Integer`: length of xarr

# Returns
- `iasp::Integer`: address of the spline object
"""
function isp_sxuser(xarr::Array{Float64}, nx::Integer)

    nx = Ref{Int32}(nx)

    iasp = @ccall isp_sxuser_(xarr::Ref{Float64}, nx::Ref{Int32})::Int32

    iasp[]
end

"""
    isp_squser(qarr, nq)

Set your own node points in the 1D qq spline in case
the automatic sampling fails.

# Arguments
- `qarr::Array{Float64}`: array of qq values
- `nq::Integer`: length of qarr

# Returns
- `iasp::Integer`: address of the spline object
"""
function isp_squser(qarr::Array{Float64}, nq::Integer)

    nq = Ref{Int32}(nq)

    iasp = @ccall isp_squser_(qarr::Ref{Float64}, nq::Ref{Int32})::Int32

    iasp[]
end


"""
    isp_splinetype(ia)

Get the type of spline at address `ia`.

Possible types are:
- `-1`: x spline
- `0`: not a spline
- `1`: qq spline
- `2`: x-qq spline 
"""
function isp_splinetype(ia::Integer)

    ia = Ref{Int32}(ia)

    type = @ccall isp_splinetype_(ia::Ref{Int32})::Int32

    type[]
end


"""
    ssp_splims(ia)

Get node limits of spline at address `ia`.

Here, u and v refer to the x and qq 
dimensions respectively.

# Returns tuple containing
- `nu::Integer`: number of nodes in u direction
- `u1::Float64`: lower u limit
- `u2::Float64`: upper u limit
- `nv::Integer`: number of nodes in v direction
- `v1::Float64`: lower v limit
- `v2::Float64`: upper v limit
- `n::Integer`: number of active nodes below kinematic limit 
"""
function ssp_splims(ia)

    ia = Ref{Int32}(ia)

    nu = Ref{Int32}()
    u1 = Ref{Float64}()
    u2 = Ref{Float64}()

    nv = Ref{Int32}()
    v1 = Ref{Float64}()
    v2 = Ref{Float64}()

    n = Ref{Int32}()

    @ccall ssp_splims_(ia::Ref{Int32}, nu::Ref{Int32}, u1::Ref{Float64},
                       u2::Ref{Float64}, nv::Ref{Int32}, v1::Ref{Float64},
                       v2::Ref{Float64}, n::Ref{Int32})::Nothing

    nu[], u1[], u2[], nv[], v1[], v2[], n[]
end


"""
    ssp_unodes(ia, n, nu)

Copy u-nodes from spline at address `ia` 
to local array.

# Arguments
- `ia::Integer`: address of spline
- `n::Integer`: dimension of array to copy to
- `nu::Integer`: number of u-nodes copied

# Returns
- `array::Array{Float64}`: array of u-nodes
"""
function ssp_unodes(ia::Integer, n::Integer, nu::Integer)

    ia = Ref{Int32}(ia)
    n = Ref{Int32}(n)
    nu = Ref{Int32}(nu)

    array = Array{Float64}(undef, n[])

    @ccall ssp_unodes_(ia::Ref{Int32}, array::Ref{Float64},
                       n::Ref{Int32}, nu::Ref{Int32})::Nothing

    array
end


"""
    ssp_vnodes(ia, n, nv)

Copy v-nodes from spline at address `ia` 
to local array.

# Arguments
- `ia::Integer`: address of spline
- `n::Integer`: dimension of array to copy to
- `nv::Integer`: number of v-nodes copied

# Returns
- `array::Array{Float64}`: array of v-nodes
"""
function ssp_vnodes(ia::Integer, n::Integer, nv::Integer)

    ia = Ref{Int32}(ia)
    n = Ref{Int32}(n)
    nv = Ref{Int32}(nv)

    array = Array{Float64}(undef, n[])

    @ccall ssp_vnodes_(ia::Ref{Int32}, array::Ref{Float64},
                       n::Ref{Int32}, nv::Ref{Int32})::Nothing

    array
end


"""
    ssp_nprint(ia)

Print a list of nodes and grids for 
the spline at address `ia`.
"""
function ssp_nprint(ia::Integer)

    ia = Ref{Int32}(ia)

    @ccall ssp_nprint_(ia::Ref{Int32})::Nothing

    nothing
end


"""
    ssp_extrapu(ia, n)

Define the extrapolation at the kinematic
limit for a spline at address `ia`.

The extrapolation index `n` can be:
- `0`: constant
- `1`: linear
- `2`: quadratic
- `3`: cubic
"""
function ssp_extrapu(ia, n)

    ia = Ref{Int32}(ia)
    n = Ref{Int32}(n)

    @ccall ssp_extrapu_(ia::Ref{Int32}, n::Ref{Int32})::Nothing

    nothing
end

"""
    ssp_extrapv(ia, n)

Define the extrapolation at the kinematic
limit for a spline at address `ia`.

The extrapolation index `n` can be:
- `0`: constant
- `1`: linear
- `2`: quadratic
- `3`: cubic
"""
function ssp_extrapv(ia, n)

    ia = Ref{Int32}(ia)
    n = Ref{Int32}(n)

    @ccall ssp_extrapv_(ia::Ref{Int32}, n::Ref{Int32})::Nothing

    nothing
end


"""
    dsp_funs1(ia, u, ichk)

Evaluate function for 1D spline.

Possible values of `ichk`:
- `-1`: extrapolate the spline
- `0`: return 0
- `1`: throw an error message

# Arguments
- `ia::Integer`: address of spline
- `u::Float64`: x or qq
- `ichk::Integer`: defines behaviour when outside 
spline range
"""
function dsp_funs1(ia::Integer, u::Float64, ichk::Integer)

    ia = Ref{Int32}(ia)
    u = Ref{Float64}(u)
    ichk = Ref{Int32}(ichk)

    val = @ccall dsp_funs1_(ia::Ref{Int32}, u::Ref{Float64},
                            ichk::Ref{Int32})::Float64

    val[]
end


"""
    dsp_funs2(ia, x, q, ichk)

Evaluate function for 2D spline.

Possible values of `ichk`:
- `-1`: extrapolate the spline
- `0`: return 0
- `1`: throw an error message

# Arguments
- `ia::Integer`: address of spline
- `x::Float64`: x value
- `q::Float64`: qq value
- `ichk::Integer`: defines behaviour when outside 
spline range
"""
function dsp_funs2(ia::Integer, x::Float64, q::Float64, ichk::Integer)

    ia = Ref{Int32}(ia)
    x = Ref{Float64}(x)
    q = Ref{Float64}(q)
    ichk = Ref{Int32}(ichk)

    val = @ccall dsp_funs2_(ia::Ref{Int32}, x::Ref{Float64},
                            q::Ref{Float64}, ichk::Ref{Int32})::Float64

    val[]
end


"""
    dsp_ints1(ia, u1, u2)

Evaluate integral of spline between u1 and u2.

The integration limits must lie inside the 
spline range. 
"""
function dsp_ints1(ia::Integer, u1::Float64, u2::Float64)

    ia = Ref{Int32}(ia)
    u1 = Ref{Float64}(u1)
    u2 = Ref{Float64}(u2)

    val = @ccall dsp_ints1_(ia::Ref{Int32}, u1::Ref{Float64},
                            u2::Ref{Float64})::Float64

    val[]
end


"""
    dsp_ints2(ia, x1, x2, q1, q2)

Evaluate integral of spline between x1, x2, q1 and q2.

The integration limits must lie inside the 
spline range.
"""
function dsp_ints2(ia::Integer, x1::Float64, x2::Float64,
                   q1::Float64, q2::Float64)

    ia = Ref{Int32}(ia)
    x1 = Ref{Float64}(x1)
    x2 = Ref{Float64}(x2)
    q1 = Ref{Float64}(q1)
    q2 = Ref{Float64}(q2)

    val = @ccall dsp_ints2_(ia::Ref{Int32}, x1::Ref{Float64},
                            x2::Ref{Float64}, q1::Ref{Float64},
                            q2::Ref{Float64})::Float64

    val[]
end

"""
    ssp_erase(ia)

Clear the memory from `ia` onwards. `ia`=0 can 
also be used to erase all spline objects in 
memory.
"""
function ssp_erase(ia::Integer)

    ia  = Ref{Int32}(ia)

    @ccall ssp_erase_(ia::Ref{Int32})::Nothing

    nothing
end
