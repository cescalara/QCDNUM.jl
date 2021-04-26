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
- `rs::??`: set a sqrt(s) cut - 0 for no kinematic cut 
"""
function ssp_s2fill()

    a = 1
    
end
