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

