"""
    isp_spvers()

SPLINT version as a date.
"""
function isp_spvers()

    ver = @ccall isp_spvers_()::Int32

    ver[]
end

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
