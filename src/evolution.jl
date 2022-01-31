
"""
    asfunc(r2)

Evolve `alpha_S(mu_R^2)`. Does not use `mu^2` grid or weight tables.

# Returns
- `alphas::FLoat64`: `alpha_S` value.
- `nf::Integer`: number of flavours at scale r2.
- `ierr::Integer`: error code
"""
function asfunc(r2::Float64)

    r2 = Ref{Float64}(r2)
    nf = Ref{Int32}()
    ierr = Ref{Int32}()

    alphas = @ccall asfunc_(r2::Ref{Float64}, nf::Ref{Int32},
                          ierr::Ref{Int32})::Float64
    
    alphas, nf[], ierr[] 
end

"""
    evolfg(itype, func, def, iq0)

Evolve the flavour pdf set.

# Arguments
- `itype::Integer`: select un-polarised (1), polarised (2) or 
time-like (3) evolution.
- `func::Base.CFunction`: User-defined function that returns input `x * f_j(x)` 
at `iq0`. `j` is from `0` to `2 * nf`.
- `def::Array{Float64}`: input array containing the contribution of 
quark species `i` to the input distribution `j`.
- `iq0::Integer`: grid index of the starting scale `mu_0^2`.

# Returns 
- `epsi::Float64`: max deviation of the quadratic spline interpolation 
from linear interpolation mid-between grid points.
"""
function evolfg(itype::Integer, func::Base.CFunction, def::Array{Float64}, iq0::Integer)

    itype = Ref{Int32}(itype)
    iq0 = Ref{Int32}(iq0)
    epsi = Ref{Float64}()
    
    @ccall evolfg_(itype::Ref{Int32}, func::Ptr{Cvoid}, def::Ref{Float64},
                   iq0::Ref{Int32}, epsi::Ref{Float64})::Nothing

    epsi[]
end

"""
    evsgns(itype, func, isns, n, iq0)

Evolve an arbitrary set of single/non-singlet pdfs. The 
evolution can only run in FFNS or MFNS mode, as it is not 
possible to correctly match at the thresholds as in evolfg.

# Arguments
The arguments are as for evolfg, expect def::Array{Float64}
is replaced with:
- `isns::Array{Int32,1}`: Input int array specifing the 
evolution type. Entries can be (+1, -1, +-2) corresponding to 
singlet, valence non-singlet and +/- q_ns singlets respectively. 
- `n::Integer`: Number of singlet/non-singlet pdfs to evolve 

# Returns
- `epsi::Float64`: Maximum deviation of the quadratic spline from 
linear interpolation mid-between the grid points.
"""
function evsgns(itype::Integer, func::Base.CFunction, isns::Array{Int32,1}, n::Integer, iq0::Integer)

    itype = Ref{Int32}(itype)
    n = Ref{Int32}(n)
    iq0 = Ref{Int32}(iq0)
    epsi = Ref{Float64}()
    
    @ccall evsgns_(itype::Ref{Int32}, func::Ptr{Cvoid}, isns::Ref{Int32},
                   n::Ref{Int32}, iq0::Ref{Int32}, epsi::Ref{Float64})::Nothing

    epsi[]
end

"""
    evsgnsp(itype, func, isns, n, iq0)

Prototype parallel version on evsgns.
"""
function evsgnsp(itype::Integer, func, isns::Array{Int32,1}, n::Integer, iq0::Integer, jrun::Integer)

    itype = Ref{Int32}(itype)
    n = Ref{Int32}(n)
    iq0 = Ref{Int32}(iq0)
    jrun = Ref{Int32}(jrun)
    epsi = Ref{Float64}()
    
    @ccall evsgnsp_(itype::Ref{Int32}, func::Ptr{Cvoid}, isns::Ref{Int32},
                   n::Ref{Int32}, iq0::Ref{Int32}, epsi::Ref{Float64}, jrun::Ref{Int32})::Nothing

    epsi[]
end

"""
    usrpdf(fun, iset, n, offset)

Create a user-defined type-5 pdfset (same type as the output 
of evsgns). 

# Arguments
- `fun`: User-defined function with the signature 
fun(ipdf::Integer, x::Float64, qq::Float64, first::UInt8)::Float64
specifying the values at x and qq of pdfset ipdf.
- `iset::Integer`: Pdfset identifier, between 1 and 24.
- `n::Integer`: Number of pdf tables in addition to gluon tables.
- `offset::Float64`: Relative offset at the thresholds mu_h^2, used 
to catch matching discontinuities.

# Returns
- `epsi::Float64`: Maximum deviation of the quadratic spline from 
linear interpolation mid-between the grid points.
"""
function usrpdf(fun, iset::Integer, n::Integer, offset::Float64)

    iset = Ref{Int32}(iset)
    n = Ref{Int32}(n)
    offset = Ref{Float64}(offset)
    epsi = Ref{Float64}()
    
    @ccall usrpdf_(fun::Ptr{Cvoid}, iset::Ref{Int32}, n::Ref{Int32}, 
        offset::Ref{Float64}, epsi::Ref{Float64})::Nothing
    
    epsi[]
end

"""
    nptabs(iset)

Get the number of pdf tables in set `iset::Integer`.
"""
function nptabs(iset::Integer)

    iset = Ref{Int32}(iset)
    
    ntabs = @ccall nptabs_(iset::Ref{Int32})::Int32

    ntabs[]
end

"""
    ievtype(iset)

Get the pdf evolution type for set `iset::Integer`.
"""
function ievtyp(iset::Integer)

    iset = Ref{Int32}(iset)
    
    ityp = @ccall ievtyp_(iset::Ref{Int32})::Int32

    ityp[]
end
