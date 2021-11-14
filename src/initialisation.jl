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

    lun = Ref{Int32}(lun)
 
    @ccall qcinit_(lun::Ref{Int32}, output_file::Cstring)::Nothing
    
    nothing
end

"""
    nxtlun(lmin)

Get next free logical unit number above `max(lmin, 10)`. 
Returns 0 if there is no free logical unit.
"""
function nxtlun(lmin::Integer)

    qcdnum = Libdl.dlopen(libqcdnum, RTLD_NOW | RTLD_GLOBAL)
    
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
    
    @ccall qstore_(action::Cstring, i::Ref{Int32}, val::Ref{Float64})::Nothing

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
    
    @ccall qstore_(action::Cstring, i::Ref{Int32}, val::Ref{Float64})::Nothing

    val[]
end


"""
    setint(param, val)

Set or get QCDNUM integer parameters.

# Arguments
- `param::String`: Name of parameter. Can be "iter" (number of 
evolutions in backwardds iteration), "tlmc" (time-like matching 
conditions), "nopt" (number of perturbative terms) or "edbg" 
(evolution loop debug printout).
- `val::Integer`: Value to set.
"""
function setint(param::String, val::Integer)

    val = Ref{Int32}(val)

    @ccall setint_(param::Cstring, val::Ref{Int32})::Nothing

    nothing
end
