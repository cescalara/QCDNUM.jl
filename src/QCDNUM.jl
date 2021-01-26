module QCDNUM

using Libdl

qcdnum = Libdl.dlopen("/usr/local/lib/libQCDNUM.dylib")


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

"""
    gxmake(xmin, iwt, n, nxin, iord)

Define a logarithmically-spaced `x` grid.

# Arguments
- `xmin::Array{Float64,1}`: an input array containitn `n` values 
of `x` in ascending order. `xmin[1]` defines the lower end of the grid 
and other values define approx positions where the point density
will change according to the values set in `iwt`.
- `iwt::Array{Int32,1}`: input integer weights given in ascending order 
and must always be an integer multiple of the previous weight.
- `n::Integer`: number of values specified in `xmin` and `iwt`.
- `nxin::Integer`: Requested number of grid points.
- `iord::Integer`: iord = 2(3) for linear(quadratic) spline interpolation.

# Returns
- `nxout::Integer`: the number of generated grid points. 
"""
function gxmake(xmin::Array{Float64,1}, iwt::Array{Int32,1}, n::Integer, nxin::Integer, iord::Integer)

    n = Ref{Int32}(n)
    nxin = Ref{Int32}(nxin)
    iord = Ref{Int32}(iord)
    nxout = Ref{Int32}()
    
    @ccall gxmake_(xmin::Ref{Float64}, iwt::Ref{Int32}, n::Ref{Int32},
                   nxin::Ref{Int32}, nxout::Ref{Int32}, iord::Ref{Int32})::Nothing
    
    nxout[]
end

"""
    gqmake(qarr, wgt, n, nqin)

Define a logarithmically-spaced `mu_F^2` grid on which the parton
densities are evolved.

# Arguments
- `qarr::Array{Float64,1}`: input array containing `n` values of `mu^2`
in ascending order. The lower edge of the grid should be above 0.1 GeV^2.
- `wgt::Array{Float64,1}`: relative grip point density in each region
defined by `qarr`.
- `n::Integer`: number of values in `qarr` and `wgt` (n>=2).
- `nqin::Integer`: requested number of grid points.

# Returns
- `nqout::Integer`: number of generated grid points.
"""
function gqmake(qarr::Array{Float64,1}, wgt::Array{Float64,1}, n::Integer, nqin::Integer)

    n = Ref{Int32}(n)
    nqin = Ref{Int32}(nqin)
    nqout = Ref{Int32}()
    
    @ccall gqmake_(qarr::Ref{Float64}, wgt::Ref{Float64}, n::Ref{Int32},
                   nqin::Ref{Int32}, nqout::Ref{Int32})::Nothing
    
    nqout[]
end

"""
    ixfrmx(x)

Get grid point index of closest grid point at or 
below `x` value.
"""
function ixfrmx(x::Float64)

    x = Ref{Float64}(x)

    ix = @ccall ixfrmx_(x::Ref{Float64})::Int32

    ix[]    
end

"""
    iqfrmq(q2)

Get grid point index of the closest grid point at or 
below `q2` value. 
"""
function iqfrmq(q2::Float64)

    q2 = Ref{Float64}(q2)
    
    iq = @ccall iqfrmq_(q2::Ref{Float64})::Int32
    
    iq
end

"""
    grpars()

Get the current grid definitions.

# Returns
`nx::Integer`: number of points in x grid.
`xmi::Float64`: lower boundary of x grid.
`xma::Float64`: upper boundary of x grid.
`nq::Integer`: number of points in qq grid.
`qmi::Float64`: lower boundary of qq grid.
`qma::Float64`: upper boundary of qq grid.
`iord::Integer`: order of spline interpolation.
"""
function grpars()

    nx = Ref{Int32}()
    xmi = Ref{Float64}()
    xma = Ref{Float64}()
    nq = Ref{Int32}()
    qmi = Ref{Float64}()
    qma = Ref{Float64}()
    iord = Ref{Int32}()

    @ccall grpars_(nx::Ref{Int32}, xmi::Ref{Float64}, xma::Ref{Float64},
                   nq::Ref{Int32}, qmi::Ref{Float64}, qma::Ref{Float64},
                   iord::Ref{Int32})::Nothing

    nx[], xmi[], xma[], nq[], qmi[], qma[], iord[]
end

"""
    gxcopy(n)

Copy the current `x` grid into an array of length `n`. 
"""
function gxcopy(n::Integer)

    n = Ref{Int32}(n)
    array = Array{Float64}(undef, n[])
    nx = Ref{Int32}()

    @ccall gxcopy_(array::Ref{Float64}, n::Ref{Int32}, nx::Ref{Int32})::Nothing

    array
end

"""
    gqcopy(n)

Copy the current `mu^2` grid into an array of length `n`. 
"""
function gqcopy(n::Integer)

    n = Ref{Int32}(n)
    array = Array{Float64}(undef, n[])
    nx = Ref{Int32}()

    @ccall gqcopy_(array::Ref{Float64}, n::Ref{Int32}, nx::Ref{Int32})::Nothing

    array
end

"""
    fillwt(itype)

Fill weight tables for all order and number of flavours.
`itype` is used to select un-polarised pdfs (1), polarised 
pdfs (2) or fragmentation functions (3).

# Returns
- `nwds::Integer`: number of words used in memory.
"""
function fillwt(itype::Integer)

    itype = Ref{Int32}(itype)
    nwds = Ref{Int32}()

    # For now-obsolete integer id vars
    idnum1 = Ref{Int32}()
    idnum2 = Ref{Int32}()
    
    @ccall fillwt_(itype::Ref{Int32}, idnum1::Ref{Int32},
                   idnum2::Ref{Int32}, nwds::Ref{Int32})::Nothing
    
    nwds[]
end

"""
    dmpwgt(itype, lun, filename)

Dump weight tables of a given `itype` to `filename`.
"""
function dmpwgt(itype::Integer, lun::Integer, filename::String)

    itype = Ref{Int32}(itype)
    lun = Ref{Int32}(lun)
    
    @ccall dmpwgt_(itype::Ref{Int32}, lun::Ref{Int32}, filename::Cstring)::Nothing
    
    nothing
end

"""
    readwt(lun, filename)

Read weight tables from filename.
TODO: Fix implementation which currently crashes.
"""
function readwt(lun::Integer, filename::String)

    lun = Ref{Int32}(lun)
    ierr = Ref{Int32}()
    nwds = Ref{Int32}()

    # For now-obsolete integer id vars
    idnum1 = Ref{Int32}()
    idnum2 = Ref{Int32}()
    
    @ccall readwt_(lun::Ref{Int32}, filename::Cstring, idnum1::Ref{Int32},
                   idnum2::Ref{Int32}, nwds::Ref{Int32}, ierr::Ref{Int32})::Nothing
    
    nwds[], ierr[]
  
end

"""
    wtfile(itype, filename)

Maintains an up-to-date weight table in filename.
"""
function wtfile(itype::Integer, filename::String)

    itype = Ref{Int32}(itype)

    @ccall wtfile_(itype::Ref{Int32}, filename::Cstring)::Nothing
    
    nothing
end

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
- `func`: User-defined function that returns input `x * f_j(x)` 
at `iq0`. `j` is from `0` to `2 * nf`.
- `def::Array{Float64}`: input array containing the contribution of 
quark species `i` to the input distribution `j`.
- `iq0::Integer`: grid index of the starting scale `mu_0^2`.

# Returns 
- `epsi::Float64`: max deviation of the quadratic spline interpolation 
from linear interpolation mid-between grid points.
"""
function evolfg(itype::Integer, func, def::Array{Float64}, iq0::Integer)

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
"""
function evsgns(itype::Integer, func, isns::Array{Int32,1}, n::Integer, iq0::Integer)

    itype = Ref{Int32}(itype)
    n = Ref{Int32}(n)
    iq0 = Ref{Int32}(iq0)
    epsi = Ref{Float64}()
    
    @ccall evsgns_(itype::Ref{Int32}, func::Ptr{Cvoid}, isns::Ref{Int32},
                   n::Ref{Int32}, iq0::Ref{Int32}, epsi::Ref{Float64})::Nothing

    epsi[]
end

"""
    allfxq(iset, x, qmu2, n, ichk)

Get all flavour-pdf values for a given `x` and `mu^2`.

# Arguments
- `iset::Integer`: pdf set id (1-24).
- `x::Float64`: input value of `x`.
- `qmu2::Float64`: input value of `qmu2`.
- `n::Integer`: number of additional pdfs to be returned.
- `ichk::Integer`: flag to steer errror checking. See QCDNUM 
docs. `ichk = -1` makes code faster, at the risk of not 
checking certain things.

# Returns
- `pdf::Array{Float64,2}`: pdf values over flavours.
"""
function allfxq(iset::Integer, x::Float64, qmu2::Float64,
                n::Integer, ichk::Integer)

    iset = Ref{Int32}(iset)
    x = Ref{Float64}(x)
    qmu2 = Ref{Float64}(qmu2)
    n = Ref{Int32}(n)
    ichk = Ref{Int32}(ichk)

    if n[] == 0
        pdf = Array{Float64}(undef, 13)
    else
        pdf = Array{Float64}(undef, 13, n+1)
    end
    
    @ccall allfxq_(iset::Ref{Int32}, x::Ref{Float64}, qmu2::Ref{Float64},
                   pdf::Ref{Float64}, n::Ref{Int32}, ichk::Ref{Int32})::Nothing
    
    pdf
end

"""
    bvalij(iset, id, ix, iq, ichk)

Get the value of a pdf at a given point (`ix`, `iq`).

# Arguments
- `iset::Integer`: pdf set id (1-24)
- `id::Integer`: basis pdf identifier from 0 to 12+n, 
where n is the number of additional pdfs in iset.
- `ix::Integer`: x index.
- `iq::Intger`: qq index.
- `ichk::Integer`: flag to steer error checking. 
See allfxq().

# Returns
- `pdf::Float64`: pdf values.
"""
function bvalij(iset::Integer, id::Integer, ix::Integer, iq::Integer, ichk::Integer)

    iset = Ref{Int32}(iset)
    id = Ref{Int32}(id)
    ix = Ref{Int32}(ix)
    iq = Ref{Int32}(iq)
    ichk = Ref{Int32}(ichk)

    pdf = @ccall bvalij_(iset::Ref{Int32}, id::Ref{Int32}, ix::Ref{Int32},
                         iq::Ref{Int32}, ichk::Ref{Int32})::Float64

    pdf[]
end

"""
    zmfillw()

Fill weight tables for zero-mass structure function 
calculations.
"""
function zmfillw()

    nwords = Ref{Int32}()
    
    @ccall zmfillw_(nwords::Ref{Int32})::Nothing
    
    nwords[]
end

"""
    zmstfun()

Calculate a structure function from a linear combination 
of parton densities.

# Arguments
- `istf::Integer`: structure function index 
where (1,2,3,4) = (F_L, F_2, xF_3, f_L^').
- `def::Array{Float64}`: coeffs of the quark linear combination 
for which the structure function is to be calculated.
- `x::Array{Float64}`: list of `x` values.
- `Q2::Array{Float64}`: list of `Q2` values.
- `n::Integer`: number of items in `x`, `Q2` and `f`.
- `ichk::Integer`: flag for grid boundary checks. See QCDNUM docs.

# Returns
- `f::Array{Float64}`: list of structure functions. 
"""
function zmstfun(istf::Integer, def::Array{Float64}, x::Array{Float64},
                 Q2::Array{Float64}, n::Integer, ichk::Integer)

    istf = Ref{Int32}(istf)
    n = Ref{Int32}(n)
    ichk = Ref{Int32}(ichk)

    f = Array{Float64}(undef, n[])
    
    @ccall zmstfun_(istf::Ref{Int32}, def::Ref{Float64}, x::Ref{Float64},
                    Q2::Ref{Float64}, f::Ref{Float64}, n::Ref{Int32},
                    ichk::Ref{Int32})::Nothing 
    
    f
end



end # QCDNUM
