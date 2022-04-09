"""
    qcinit(lun, filename)

Initialise QCDNUM - should be called before anything else. 

# Arguments
- `lun::Integer`: the output logical unit number. When set to 6, 
the QCDNUM messages appear on the standard output. When set to -6, 
the QCDNUM banner printout is suppressed.
- `filename::String`: the output filename to store log.
"""
function qcinit(lun::Integer, output_file::String)

    qcdnum = Libdl.dlopen(libqcdnum, RTLD_NOW | RTLD_GLOBAL)

    lun = Ref{Int32}(lun)
 
    @ccall qcinit_(lun::Ref{Int32}, output_file::Ptr{UInt8},
                   sizeof(output_file)::Csize_t)::Nothing
    
    nothing
end

"""
    nxtlun(lmin)

Get next free logical unit number above `max(lmin, 10)`. 
Returns 0 if there is no free logical unit.
"""
function nxtlun(lmin::Integer)
    
    lmin = Ref{Int32}(lmin)

    lun = @ccall nxtlun_(lmin::Ref{Int32})::Int32
    
    lun[]
end

"""
    qstore(action, i, val)

QCDNUM reserves 500 words of memory for user use. 

# Arguments
- `action::String`: Can be "write", "read", "lock" or "unlock".
- `i::Integer`: Where to read/write in the store.
- `val::Float64`: What to write in the store.
"""
function qstore(action::String, i::Integer, val::Float64)

    i = Ref{Int32}(i)
    val = Ref{Float64}(val)
    
    @ccall qstore_(action::Ptr{UInt8}, i::Ref{Int32}, val::Ref{Float64},
                   sizeof(action)::Csize_t)::Nothing

    nothing
end

"""
    qstore(action, i)

QCDNUM reserves 500 words of memory for user use. 

# Arguments
- `action::String`: Can be "write", "read", "lock" or "unlock".
- `i::Integer`: Where to read/write in the store.

# Returns
- `val::Float64`: What is read from the store.
"""
function qstore(action::String, i::Integer)

    i = Ref{Int32}(i)
    val = Ref{Float64}()
    
    @ccall qstore_(action::Ptr{UInt8}, i::Ref{Int32}, val::Ref{Float64},
                   sizeof(action)::Csize_t)::Nothing

    val[]
end


"""
    setint(param, ival)

Set or get QCDNUM integer parameters.

# Arguments
- `param::String`: Name of parameter. Can be "iter" (number of 
evolutions in backwards iteration), "tlmc" (time-like matching 
conditions), "nopt" (number of perturbative terms) or "edbg" 
(evolution loop debug printout).
- `ival::Integer`: Value to set.
"""
function setint(param::String, ival::Integer)

    ival = Ref{Int32}(ival)

    @ccall setint_(param::Ptr{UInt8}, ival::Ref{Int32}, sizeof(param)::Csize_t)::Nothing

    nothing
end

"""
    setval(param, val)

Set or get QCDNUM parameters.

# Arguments
- `param::String`: Name of parameter. Can be "null" (result of 
calc that cannot be performed), "epsi" (tolerance level in float
comparison |x-y| < epsi), "epsg" (numerical accuracy of Gauss 
integration in weight table calc), "elim" (allowed diff between 
quadratic and linear spline interpolation mid-between x grid 
points - to disable, set elim<=0), "alim" (Max allowed value of 
alpha_s(mu^2)), "qmin" (smallest possible boundary of mu^2 grid)
"qmax" (largest possible boundary of mu^2 grid).
- `val::Float64`: Value to set.
"""
function setval(param::String, val::Float64)

    val = Ref{Float64}(val)

    @ccall setval_(param::Ptr{UInt8}, val::Ref{Float64}, sizeof(param)::Csize_t)::Nothing

    nothing
end

