"""
    setord(iord)

Set order of perturbative QCD calculations.
iord = 1, 2, 3 for LO, NLO and NNLO respectively.
By default, `iord = 2`.
"""
function setord(iord::Integer)
    
    iord = Ref{Int32}(iord)
    
    @ccall setord_(iord::Ref{Int32})::Nothing

    nothing
end

"""
    setalf(alfs, r2)

Set the starting value of `alpha_S` and the starting 
renormalisation scale `r2`. By default `alpha_S(m_Z^2) = 0.118`.
"""
function setalf(alfs::Float64, r2::Float64)
    
    alfs = Ref{Float64}(alfs)
    r2 = Ref{Float64}(r2)
    
    @ccall setalf_(alfs::Ref{Float64}, r2::Ref{Float64})::Nothing
    
    nothing
end

"""
    setcbt(nfix, iqc, iqb, iqt)

Select FFNS or VFNS, and thresholds on `mu_F^2` if necessary.

# Arguments
- `nfix::Integer`: number of flavours in the FFNS. For VNFS set
`nfix = 0`.
- `iqc/b/t::Integer`: grid indices of the heavy flavour thresholds 
in the VFNS. Ignored if FFNS.
"""
function setcbt(nfix::Integer, iqc::Integer, iqb::Integer, iqt::Integer)

    nfix = Ref{Int32}(nfix)
    iqc = Ref{Int32}(iqc)
    iqb = Ref{Int32}(iqb)
    iqt = Ref{Int32}(iqt)
    
    @ccall setcbt_(nfix::Ref{Int32}, iqc::Ref{Int32},
                   iqb::Ref{Int32}, iqt::Ref{Int32})::Nothing
    
    nothing
end

"""
    setabr(ar, br)

Define the relation between the factorisation scale mu_F^2
and the renormalisation scale mu_R^2.

mu_R^2 = a_R mu_F^2 + b_R.
"""
function setabr(ar::Float64, br::Float64)

    ar = Ref{Float64}(ar)
    br = Ref{Float64}(br)

    @ccall setabr_(ar::Ref{Float64}, br::Ref{Float64})::Nothing

    nothing
end
