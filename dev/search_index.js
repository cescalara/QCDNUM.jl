var documenterSearchIndex = {"docs":
[{"location":"functions/#Available-functions","page":"Available functions","title":"Available functions","text":"","category":"section"},{"location":"functions/","page":"Available functions","title":"Available functions","text":"The dcoumentation of all available functions is listed below in alphabetical order. Documentation can also be found using the search bar on the left, or via the Julia REPL, e.g:","category":"page"},{"location":"functions/","page":"Available functions","title":"Available functions","text":"julia> using QCDNUM\n\njulia> ?QCDNUM.evsgns","category":"page"},{"location":"functions/#Module-documentation","page":"Available functions","title":"Module documentation","text":"","category":"section"},{"location":"functions/","page":"Available functions","title":"Available functions","text":"Modules = [QCDNUM]","category":"page"},{"location":"functions/#QCDNUM.allfxq-Tuple{Integer, Float64, Float64, Integer, Integer}","page":"Available functions","title":"QCDNUM.allfxq","text":"allfxq(iset, x, qmu2, n, ichk)\n\nGet all flavour-pdf values for a given x and mu^2.\n\nArguments\n\niset::Integer: pdf set id (1-24).\nx::Float64: input value of x.\nqmu2::Float64: input value of qmu2.\nn::Integer: number of additional pdfs to be returned.\nichk::Integer: flag to steer error checking. See QCDNUM \n\ndocs. ichk = -1 makes code faster, at the risk of not  checking certain things.\n\nReturns\n\npdf::Array{Float64,2}: pdf values over flavours.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.asfunc-Tuple{Float64}","page":"Available functions","title":"QCDNUM.asfunc","text":"asfunc(r2)\n\nEvolve alpha_S(mu_R^2). Does not use mu^2 grid or weight tables.\n\nReturns\n\nalphas::FLoat64: alpha_S value.\nnf::Integer: number of flavours at scale r2.\nierr::Integer: error code\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.bvalij-NTuple{5, Integer}","page":"Available functions","title":"QCDNUM.bvalij","text":"bvalij(iset, id, ix, iq, ichk)\n\nGet the value of a basis pdf at a given point (ix, iq).\n\nArguments\n\niset::Integer: pdf set id (1-24)\nid::Integer: basis pdf identifier from 0 to 12+n, \n\nwhere n is the number of additional pdfs in iset.\n\nix::Integer: x index.\niq::Integer: qq index.\nichk::Integer: flag to steer error checking. \n\nSee allfxq().\n\nReturns\n\npdf::Float64: pdf values.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.bvalxq-Tuple{Integer, Integer, Float64, Float64, Integer}","page":"Available functions","title":"QCDNUM.bvalxq","text":"bvalxq(iset, id, x, qq, ichk)\n\nGet the value of a basis pdf at a given point (x, qq).\n\nArguments\n\niset::Integer: pdf set id (1-24)\nid::Integer: basis pdf identifier from 0 to 12+n, \n\nwhere n is the number of additional pdfs in iset.\n\nx::Float64: x value.\nqq::Float64: qq value.\nichk::Integer: flag to steer error checking. \n\nSee allfxq().\n\nReturns\n\npdf::Float64: pdf values.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.dmpwgt-Tuple{Integer, Integer, String}","page":"Available functions","title":"QCDNUM.dmpwgt","text":"dmpwgt(itype, lun, filename)\n\nDump weight tables of a given itype to filename.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.dsp_funs1-Tuple{Integer, Float64, Integer}","page":"Available functions","title":"QCDNUM.dsp_funs1","text":"dsp_funs1(ia, u, ichk)\n\nEvaluate function for 1D spline.\n\nPossible values of ichk:\n\n-1: extrapolate the spline\n0: return 0\n1: throw an error message\n\nArguments\n\nia::Integer: address of spline\nu::Float64: x or qq\nichk::Integer: defines behaviour when outside \n\nspline range\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.dsp_funs2-Tuple{Integer, Float64, Float64, Integer}","page":"Available functions","title":"QCDNUM.dsp_funs2","text":"dsp_funs2(ia, x, q, ichk)\n\nEvaluate function for 2D spline.\n\nPossible values of ichk:\n\n-1: extrapolate the spline\n0: return 0\n1: throw an error message\n\nArguments\n\nia::Integer: address of spline\nx::Float64: x value\nq::Float64: qq value\nichk::Integer: defines behaviour when outside \n\nspline range\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.dsp_ints1-Tuple{Integer, Float64, Float64}","page":"Available functions","title":"QCDNUM.dsp_ints1","text":"dsp_ints1(ia, u1, u2)\n\nEvaluate integral of spline between u1 and u2.\n\nThe integration limits must lie inside the  spline range. \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.dsp_ints2-Tuple{Integer, Float64, Float64, Float64, Float64, Float64, Integer}","page":"Available functions","title":"QCDNUM.dsp_ints2","text":"dsp_ints2(ia, x1, x2, q1, q2, rs, np)\n\nEvaluate integral of spline between x1, x2, q1 and q2. Also takes care of rscut and integrations makes use of N-point  Gauss quadrature, as defined by the choice of np.\n\nThe integration limits must lie inside the  spline range.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.dsp_uread-Tuple{Integer}","page":"Available functions","title":"QCDNUM.dsp_uread","text":"dsp_uread(i)\n\nRead something from the reserved user space.\n\nArguments\n\ni::Integer: where to read, from 1 to nuser\n\nReturns\n\nval::Float64: what is read\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.evolfg-Tuple{Integer, Any, Array{Float64, N} where N, Integer}","page":"Available functions","title":"QCDNUM.evolfg","text":"evolfg(itype, func, def, iq0)\n\nEvolve the flavour pdf set.\n\nArguments\n\nitype::Integer: select un-polarised (1), polarised (2) or \n\ntime-like (3) evolution.\n\nfunc: User-defined function that returns input x * f_j(x) \n\nat iq0. j is from 0 to 2 * nf.\n\ndef::Array{Float64}: input array containing the contribution of \n\nquark species i to the input distribution j.\n\niq0::Integer: grid index of the starting scale mu_0^2.\n\nReturns\n\nepsi::Float64: max deviation of the quadratic spline interpolation \n\nfrom linear interpolation mid-between grid points.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.evsgns-Tuple{Integer, Any, Vector{Int32}, Integer, Integer}","page":"Available functions","title":"QCDNUM.evsgns","text":"evsgns(itype, func, isns, n, iq0)\n\nEvolve an arbitrary set of single/non-singlet pdfs. The  evolution can only run in FFNS or MFNS mode, as it is not  possible to correctly match at the thresholds as in evolfg.\n\nArguments\n\nThe arguments are as for evolfg, expect def::Array{Float64} is replaced with:\n\nisns::Array{Int32,1}: Input int array specifing the \n\nevolution type. Entries can be (+1, -1, +-2) corresponding to  singlet, valence non-singlet and +/- q_ns singlets respectively. \n\nn::Integer: Number of singlet/non-singlet pdfs to evolve \n\nReturns\n\nepsi::Float64: Maximum deviation of the quadratic spline from \n\nlinear interpolation mid-between the grid points.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.evsgnsp-Tuple{Integer, Any, Vector{Int32}, Integer, Integer, Integer}","page":"Available functions","title":"QCDNUM.evsgnsp","text":"evsgnsp(itype, func, isns, n, iq0)\n\nPrototype parallel version on evsgns.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.fillwt-Tuple{Integer}","page":"Available functions","title":"QCDNUM.fillwt","text":"fillwt(itype)\n\nFill weight tables for all order and number of flavours. itype is used to select un-polarised pdfs (1), polarised  pdfs (2) or fragmentation functions (3).\n\nReturns\n\nnwds::Integer: number of words used in memory.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.fvalij-NTuple{5, Integer}","page":"Available functions","title":"QCDNUM.fvalij","text":"fvalij(iset, id, ix, iq, ichk)\n\nGet the value of a flavour momentum density  at a given point (ix, iq).\n\nArguments\n\niset::Integer: pdf set id (1-24)\nid::Integer: basis pdf identifier from -6 to 6+n, \n\nwhere n is the number of additional pdfs in iset.\n\nix::Integer: x index.\niq::Intger: qq index.\nichk::Integer: flag to steer error checking. \n\nSee allfxq().\n\nReturns\n\npdf::Float64: pdf values.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.fvalxq-Tuple{Integer, Integer, Float64, Float64, Integer}","page":"Available functions","title":"QCDNUM.fvalxq","text":"fvalxq(iset, id, x, qq, ichk)\n\nGet the value of a flavour momentum density at a given point (x, qq).\n\nArguments\n\niset::Integer: pdf set id (1-24)\nid::Integer: basis pdf identifier from -6 to 6+n, \n\nwhere n is the number of additional pdfs in iset.\n\nx::Float64: x value.\nqq::Float64: qq value.\nichk::Integer: flag to steer error checking. \n\nSee allfxq().\n\nReturns\n\npdf::Float64: pdf values.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.gqcopy-Tuple{Integer}","page":"Available functions","title":"QCDNUM.gqcopy","text":"gqcopy(n)\n\nCopy the current mu^2 grid into an array of length n. \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.gqmake-Tuple{Vector{Float64}, Vector{Float64}, Integer, Integer}","page":"Available functions","title":"QCDNUM.gqmake","text":"gqmake(qarr, wgt, n, nqin)\n\nDefine a logarithmically-spaced mu_F^2 grid on which the parton densities are evolved.\n\nArguments\n\nqarr::Array{Float64,1}: input array containing n values of mu^2\n\nin ascending order. The lower edge of the grid should be above 0.1 GeV^2.\n\nwgt::Array{Float64,1}: relative grip point density in each region\n\ndefined by qarr.\n\nn::Integer: number of values in qarr and wgt (n>=2).\nnqin::Integer: requested number of grid points.\n\nReturns\n\nnqout::Integer: number of generated grid points.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.grpars-Tuple{}","page":"Available functions","title":"QCDNUM.grpars","text":"grpars()\n\nGet the current grid definitions.\n\nReturns\n\nnx::Integer: number of points in x grid. xmi::Float64: lower boundary of x grid. xma::Float64: upper boundary of x grid. nq::Integer: number of points in qq grid. qmi::Float64: lower boundary of qq grid. qma::Float64: upper boundary of qq grid. iord::Integer: order of spline interpolation.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.gxcopy-Tuple{Integer}","page":"Available functions","title":"QCDNUM.gxcopy","text":"gxcopy(n)\n\nCopy the current x grid into an array of length n. \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.gxmake-Tuple{Vector{Float64}, Vector{Int32}, Integer, Integer, Integer}","page":"Available functions","title":"QCDNUM.gxmake","text":"gxmake(xmin, iwt, n, nxin, iord)\n\nDefine a logarithmically-spaced x grid.\n\nArguments\n\nxmin::Array{Float64,1}: an input array containitn n values \n\nof x in ascending order. xmin[1] defines the lower end of the grid  and other values define approx positions where the point density will change according to the values set in iwt.\n\niwt::Array{Int32,1}: input integer weights given in ascending order \n\nand must always be an integer multiple of the previous weight.\n\nn::Integer: number of values specified in xmin and iwt.\nnxin::Integer: Requested number of grid points.\niord::Integer: iord = 2(3) for linear(quadratic) spline interpolation.\n\nReturns\n\nnxout::Integer: the number of generated grid points. \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ievtyp-Tuple{Integer}","page":"Available functions","title":"QCDNUM.ievtyp","text":"ievtype(iset)\n\nGet the pdf evolution type for set iset::Integer.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.iqfrmq-Tuple{Float64}","page":"Available functions","title":"QCDNUM.iqfrmq","text":"iqfrmq(q2)\n\nGet grid point index of the closest grid point at or  below q2 value. \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.isp_s2make-Tuple{Integer, Integer}","page":"Available functions","title":"QCDNUM.isp_s2make","text":"isp_s2make(istepx, istepq)\n\nCreate a spline object in memory, and return the address. Every istep-th grid point is taken as a node point of the  spline and the grid boundaries are always included as node points.\n\nArguments\n\nistepx::Integer: steps taken in sampling the QCDNUM x grid\nistepq::Integer: steps taken in sampling the QCDNUM qq grid\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.isp_s2user-Tuple{Array{Float64, N} where N, Integer, Array{Float64, N} where N, Integer}","page":"Available functions","title":"QCDNUM.isp_s2user","text":"isp_s2user(xarr, nx, qarr, nq)\n\nSet your own node points in the spline in case the automatic sampling fails.\n\nThe routine will discard points outside the x-qq  evolution grid, round the remaining nodes down to  the nearest grid-point and then sort them in  ascending order, discarding equal values. Thus you are allowed to enter un-sorted scattered arrays.\n\nArguments\n\nxarr::Array{Float64}: array of x values\nnx::Integer: length of xarr\nqarr::Array{Float64}: array of qq values\nnq::Integer: length of qarr\n\nReturns\n\niasp::Integer: address of the spline object\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.isp_splinetype-Tuple{Integer}","page":"Available functions","title":"QCDNUM.isp_splinetype","text":"isp_splinetype(ia)\n\nGet the type of spline at address ia.\n\nPossible types are:\n\n-1: x spline\n0: not a spline\n1: qq spline\n2: x-qq spline \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.isp_sqmake-Tuple{Integer}","page":"Available functions","title":"QCDNUM.isp_sqmake","text":"isp_sqmake(istepq)\n\nCreate a 1D qq spline object in memory, and return the address. Every istep-th grid point is taken as a node point of the  spline and the grid boundaries are always included as node points.\n\nArguments\n\nistepq::Integer: steps taken in sampling the QCDNUM qq grid\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.isp_squser-Tuple{Array{Float64, N} where N, Integer}","page":"Available functions","title":"QCDNUM.isp_squser","text":"isp_squser(qarr, nq)\n\nSet your own node points in the 1D qq spline in case the automatic sampling fails.\n\nArguments\n\nqarr::Array{Float64}: array of qq values\nnq::Integer: length of qarr\n\nReturns\n\niasp::Integer: address of the spline object\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.isp_sxmake-Tuple{Integer}","page":"Available functions","title":"QCDNUM.isp_sxmake","text":"isp_sxmake(istepx)\n\nCreate a 1D x spline object in memory, and return the address. Every istep-th grid point is taken as a node point of the  spline and the grid boundaries are always included as node points.\n\nArguments\n\nistepx::Integer: steps taken in sampling the QCDNUM x grid\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.isp_sxuser-Tuple{Array{Float64, N} where N, Integer}","page":"Available functions","title":"QCDNUM.isp_sxuser","text":"isp_sxuser(xarr, nx)\n\nSet your own node points in the 1D x spline in case the automatic sampling fails.\n\nArguments\n\nxarr::Array{Float64}: array of x values\nnx::Integer: length of xarr\n\nReturns\n\niasp::Integer: address of the spline object\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ixfrmx-Tuple{Float64}","page":"Available functions","title":"QCDNUM.ixfrmx","text":"ixfrmx(x)\n\nGet grid point index of closest grid point at or  below x value.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.nptabs-Tuple{Integer}","page":"Available functions","title":"QCDNUM.nptabs","text":"nptabs(iset)\n\nGet the number of pdf tables in set iset::Integer.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.nxtlun-Tuple{Integer}","page":"Available functions","title":"QCDNUM.nxtlun","text":"nxtlun(lmin)\n\nGet next free logical unit number above max(lmin, 10).  Returns 0 if there is no free logical unit.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.qcinit-Tuple{Integer, String}","page":"Available functions","title":"QCDNUM.qcinit","text":"qcinit(lun, filename)\n\nInitialise QCDNUM - should be called before anything else. \n\nArguments\n\nlun::Integer: the output logical unit number. When set to 6, \n\nthe QCDNUM messages appear on the standard output. When set to -6,  the QCDNUM banner printout is suppressed.\n\nfilename::String: the output filename to store log.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.qfrmiq-Tuple{Integer}","page":"Available functions","title":"QCDNUM.qfrmiq","text":"qfrmiq(iq)\n\nGet q2 value at grid point iq.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.qstore-Tuple{String, Integer, Float64}","page":"Available functions","title":"QCDNUM.qstore","text":"qstore(action, i, val)\n\nQCDNUM reserves 500 words of memory for user use. \n\nArguments\n\naction::String: Can be \"write\", \"read\", \"lock\" or \"unlock\".\ni::Integer: Where to read/write in the store.\nval::Float64: What to write in the store.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.qstore-Tuple{String, Integer}","page":"Available functions","title":"QCDNUM.qstore","text":"qstore(action, i)\n\nQCDNUM reserves 500 words of memory for user use. \n\nArguments\n\naction::String: Can be \"write\", \"read\", \"lock\" or \"unlock\".\ni::Integer: Where to read/write in the store.\n\nReturns\n\nval::Float64: What is read from the store.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.readwt-Tuple{Integer, String}","page":"Available functions","title":"QCDNUM.readwt","text":"readwt(lun, filename)\n\nRead weight tables from filename. TODO: Fix implementation which currently crashes.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.setabr-Tuple{Float64, Float64}","page":"Available functions","title":"QCDNUM.setabr","text":"setabr(ar, br)\n\nDefine the relation between the factorisation scale muF^2 and the renormalisation scale muR^2.\n\nmuR^2 = aR muF^2 + bR.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.setalf-Tuple{Float64, Float64}","page":"Available functions","title":"QCDNUM.setalf","text":"setalf(alfs, r2)\n\nSet the starting value of alpha_S and the starting  renormalisation scale r2. By default alpha_S(m_Z^2) = 0.118.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.setcbt-NTuple{4, Integer}","page":"Available functions","title":"QCDNUM.setcbt","text":"setcbt(nfix, iqc, iqb, iqt)\n\nSelect FFNS or VFNS, and thresholds on mu_F^2 if necessary.\n\nArguments\n\nnfix::Integer: number of flavours in the FFNS. For VNFS set\n\nnfix = 0.\n\niqc/b/t::Integer: grid indices of the heavy flavour thresholds \n\nin the VFNS. Ignored if FFNS.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.setint-Tuple{String, Integer}","page":"Available functions","title":"QCDNUM.setint","text":"setint(param, val)\n\nSet or get QCDNUM integer parameters.\n\nArguments\n\nparam::String: Name of parameter. Can be \"iter\" (number of \n\nevolutions in backwardds iteration), \"tlmc\" (time-like matching  conditions), \"nopt\" (number of perturbative terms) or \"edbg\"  (evolution loop debug printout).\n\nval::Integer: Value to set.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.setord-Tuple{Integer}","page":"Available functions","title":"QCDNUM.setord","text":"setord(iord)\n\nSet order of perturbative QCD calculations. iord = 1, 2, 3 for LO, NLO and NNLO respectively. By default, iord = 2.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_erase-Tuple{Integer}","page":"Available functions","title":"QCDNUM.ssp_erase","text":"ssp_erase(ia)\n\nClear the memory from ia onwards. ia=0 can  also be used to erase all spline objects in  memory.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_extrapu-Tuple{Any, Any}","page":"Available functions","title":"QCDNUM.ssp_extrapu","text":"ssp_extrapu(ia, n)\n\nDefine the extrapolation at the kinematic limit for a spline at address ia.\n\nThe extrapolation index n can be:\n\n0: constant\n1: linear\n2: quadratic\n3: cubic\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_extrapv-Tuple{Any, Any}","page":"Available functions","title":"QCDNUM.ssp_extrapv","text":"ssp_extrapv(ia, n)\n\nDefine the extrapolation at the kinematic limit for a spline at address ia.\n\nThe extrapolation index n can be:\n\n0: constant\n1: linear\n2: quadratic\n3: cubic\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_nprint-Tuple{Integer}","page":"Available functions","title":"QCDNUM.ssp_nprint","text":"ssp_nprint(ia)\n\nPrint a list of nodes and grids for  the spline at address ia.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_s2f123-Tuple{Integer, Integer, Array{Float64, N} where N, Integer, Float64}","page":"Available functions","title":"QCDNUM.ssp_s2f123","text":"ssp_s2f123(ia, iset, def, istf, rs)\n\nFast structure function input for 2D  splines over x and qq.\n\nArguments\n\nia::Integer: address of the spline object\niset::Integer: QCDNUM pdf-set index\ndef::Array{Float64}: Array of (anti-)quark\n\ncoefficients \n\nistf::Integer: structure function index \n\n1<=>FL, 2<=>F2, 3<=>xF3, 4<=>FL'\n\nrs::Float64: sqrt(s) cut - 0 for no kinematic cut\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_s2fill-Tuple{Integer, Ptr{Nothing}, Float64}","page":"Available functions","title":"QCDNUM.ssp_s2fill","text":"ssp_s2fill(iasp, fun, rs)\n\nFill the spline object by passing a function. The function  must have the signature fun(ix::Integer, iq::Integer, first::Boolean).\n\nArguments\n\niasp::Integer: address of the spline object\nfun::Ptr{Nothing}: function to be splined\nrs::Float64: set a sqrt(s) cut - 0 for no kinematic cut \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_spinit-Tuple{Integer}","page":"Available functions","title":"QCDNUM.ssp_spinit","text":"ssp_spinit(nuser)\n\nInitialise SPLINT - should be called before other  SPLINT functions.\n\nArguments\n\nnuser::Integer: the number of words reserved for user storage \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_splims-Tuple{Any}","page":"Available functions","title":"QCDNUM.ssp_splims","text":"ssp_splims(ia)\n\nGet node limits of spline at address ia.\n\nHere, u and v refer to the x and qq  dimensions respectively.\n\nReturns tuple containing\n\nnu::Integer: number of nodes in u direction\nu1::Float64: lower u limit\nu2::Float64: upper u limit\nnv::Integer: number of nodes in v direction\nv1::Float64: lower v limit\nv2::Float64: upper v limit\nn::Integer: number of active nodes below kinematic limit \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_sqf123-Tuple{Integer, Integer, Array{Float64, N} where N, Integer, Integer}","page":"Available functions","title":"QCDNUM.ssp_sqf123","text":"ssp_sq123(ia, iset, def, istf, ix)\n\nFast structure function input for splines over qq.\n\nArguments\n\nia::Integer: address of the spline object\niset::Integer: QCDNUM pdf-set index\ndef::Array{Float64}: Array of (anti-)quark\n\ncoefficients \n\nistf::Integer: structure function index \n\n1<=>FL, 2<=>F2, 3<=>xF3, 4<=>FL'\n\nix::Integer: index of x value \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_sqfill-Tuple{Integer, Ptr{Nothing}, Integer}","page":"Available functions","title":"QCDNUM.ssp_sqfill","text":"ssp_sqfill(iasp, fun, ix)\n\nFill the 1D qq spline object by passing a function. The function  must have the signature fun(ix::Integer, iq::Integer, first::Boolean).\n\nArguments\n\niasp::Integer: address of the spline object\nfun::Ptr{Nothing}: function to be splined\nix::Integer: fixed ix value to pass to fun\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_sxf123-Tuple{Integer, Integer, Array{Float64, N} where N, Integer, Integer}","page":"Available functions","title":"QCDNUM.ssp_sxf123","text":"ssp_sxf123(ia, iset, def, istf, iq)\n\nFast structure function input for splines over x.\n\nArguments\n\nia::Integer: address of the spline object\niset::Integer: QCDNUM pdf-set index\ndef::Array{Float64}: Array of (anti-)quark\n\ncoefficients \n\nistf::Integer: structure function index \n\n1<=>FL, 2<=>F2, 3<=>xF3, 4<=>FL'\n\niq::Integer: index of qq value \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_sxfill-Tuple{Integer, Ptr{Nothing}, Integer}","page":"Available functions","title":"QCDNUM.ssp_sxfill","text":"ssp_sxfill(iasp, fun, iq)\n\nFill the 1D x spline object by passing a function. The function  must have the signature fun(ix::Integer, iq::Integer, first::Boolean).\n\nArguments\n\niasp::Integer: address of the spline object\nfun::Ptr{Nothing}: function to be splined\niq::Integer: fixed iq value to pass to fun\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_unodes-Tuple{Integer, Integer, Integer}","page":"Available functions","title":"QCDNUM.ssp_unodes","text":"ssp_unodes(ia, n, nu)\n\nCopy u-nodes from spline at address ia  to local array.\n\nArguments\n\nia::Integer: address of spline\nn::Integer: dimension of array to copy to\nnu::Integer: number of u-nodes copied\n\nReturns\n\narray::Array{Float64}: array of u-nodes\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_uwrite-Tuple{Integer, Float64}","page":"Available functions","title":"QCDNUM.ssp_uwrite","text":"ssp_uwrite(i, val)\n\nWrite something to the reserved user space.\n\nArguments\n\ni::Integer: where to write, from 1 to nuser\nval::Float: what to write\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.ssp_vnodes-Tuple{Integer, Integer, Integer}","page":"Available functions","title":"QCDNUM.ssp_vnodes","text":"ssp_vnodes(ia, n, nv)\n\nCopy v-nodes from spline at address ia  to local array.\n\nArguments\n\nia::Integer: address of spline\nn::Integer: dimension of array to copy to\nnv::Integer: number of v-nodes copied\n\nReturns\n\narray::Array{Float64}: array of v-nodes\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.sumfxq-Tuple{Integer, Array{Float64, N} where N, Integer, Float64, Float64, Integer}","page":"Available functions","title":"QCDNUM.sumfxq","text":"sumfxq(iset, c, isel, x, qmu2, ichk)\n\nReturn the gluon or a weighted sum of quark  densities, depending on the selection flag, isel.\n\nisel values:\n\n0: Gluon density |xg> 1: Linear combination c summed over active flavours 2-8: Specific singlet/non-singlet quark component 9: Intrinsic heavy flavours  12+i: Additional pdf |xf_i> in iset\n\nSee QCDNUM manual for more information.\n\nArguments\n\niset::Integer: pdf set id (1-24).\nc::Array{Float64}: Coefficients of quarks/anti-quarks\nisel::Integer: Selection flag\nx::Float64: input value of x.\nqmu2::Float64: input value of qmu2.\nn::Integer: number of additional pdfs to be returned.\nichk::Integer: flag to steer error checking. See QCDNUM \n\ndocs. ichk = -1 makes code faster, at the risk of not  checking certain things.\n\nReturns\n\npdf::Float64: pdf value.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.usrpdf-Tuple{Any, Integer, Integer, Float64}","page":"Available functions","title":"QCDNUM.usrpdf","text":"usrpdf(fun, iset, n, offset)\n\nCreate a user-defined type-5 pdfset (same type as the output  of evsgns). \n\nArguments\n\nfun: User-defined function with the signature \n\nfun(ipdf::Integer, x::Float64, qq::Float64, first::UInt8)::Float64 specifying the values at x and qq of pdfset ipdf.\n\niset::Integer: Pdfset identifier, between 1 and 24.\nn::Integer: Number of pdf tables in addition to gluon tables.\noffset::Float64: Relative offset at the thresholds mu_h^2, used \n\nto catch matching discontinuities.\n\nReturns\n\nepsi::Float64: Maximum deviation of the quadratic spline from \n\nlinear interpolation mid-between the grid points.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.wtfile-Tuple{Integer, String}","page":"Available functions","title":"QCDNUM.wtfile","text":"wtfile(itype, filename)\n\nMaintains an up-to-date weight table in filename.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.xfrmix-Tuple{Integer}","page":"Available functions","title":"QCDNUM.xfrmix","text":"xfrmix(ix)\n\nGet x value at grid point ix.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.zmfillw-Tuple{}","page":"Available functions","title":"QCDNUM.zmfillw","text":"zmfillw()\n\nFill weight tables for zero-mass structure function  calculations.\n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.zmstfun-Tuple{Integer, Array{Float64, N} where N, Array{Float64, N} where N, Array{Float64, N} where N, Integer, Integer}","page":"Available functions","title":"QCDNUM.zmstfun","text":"zmstfun()\n\nCalculate a structure function from a linear combination  of parton densities.\n\nArguments\n\nistf::Integer: structure function index \n\nwhere (1,2,3,4) = (FL, F2, xF3, fL^').\n\ndef::Array{Float64}: coeffs of the quark linear combination \n\nfor which the structure function is to be calculated.\n\nx::Array{Float64}: list of x values.\nQ2::Array{Float64}: list of Q2 values.\nn::Integer: number of items in x, Q2 and f.\nichk::Integer: flag for grid boundary checks. See QCDNUM docs.\n\nReturns\n\nf::Array{Float64}: list of structure functions. \n\n\n\n\n\n","category":"method"},{"location":"functions/#QCDNUM.zmwords-Tuple{}","page":"Available functions","title":"QCDNUM.zmwords","text":"zmwords()\n\nCheck the number of words available in the ZMSTF  workspace and the number of words used.\n\n\n\n\n\n","category":"method"},{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Here we show some simple examples based on the QCDNUM test jobs. These examples and more can be found in the examples directory of the GitHub repository in the form of Jupyter notebooks that can be opened directly with Jupytext.","category":"page"},{"location":"examples/#Basic-QCDNUM-job","page":"Examples","title":"Basic QCDNUM job","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"This example is based on example.f in the QCDNUM testjobs.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"using QCDNUM\nusing Printf","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Let's define some useful inputs","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"xmin = Float64.([1.0e-4])\niwt = Int32.([1])\nng = 1\nnxin = 100\niosp = 3\nnx = 10\n\nqq = Float64.([2e0, 1e4])\nwt = Float64.([1e0, 1e0])\nnq = 1\nnqin = 60\nngq = 2\nitype = 1\n\nas0 = 0.364\nr20 = 2.0\n\nq2c = 3.0\nq2b = 25.0\nq0 = 2.0\niqt = 999\n\ndef = Float64.([0., 0., 0., 0., 0.,-1., 0., 1., 0., 0., 0., 0., 0.,     \n      0., 0., 0., 0.,-1., 0., 0., 0., 1., 0., 0., 0., 0.,      \n      0., 0., 0.,-1., 0., 0., 0., 0., 0., 1., 0., 0., 0.,      \n      0., 0., 0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0.,      \n      0., 0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0.,      \n      0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      \n      0., 0.,-1., 0., 0., 0., 0., 0., 0., 0., 1., 0., 0.,      \n      0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      \n      0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      \n      0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      \n      0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      \n      0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]);\n\nnfin = 0\nx = 1.0e-3\nq = 1.0e3\npdf = Array{Float64}(undef, 13)\nqmz2 = 8315.25;","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Now, we can define the input PDF function for the PDF we would like to evolve. We also then have to use the Julia @cfunction macro so that we can pass it to QCDNUM through the wrapper.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"function func(ipdf, x)::Float64\n    i = ipdf[]\n    xb = x[]\n    adbar = 0.1939875\n    f = 0\n    if (i == 0) \n        ag = 1.7\n        f = ag * xb^-0.1 * (1.0-xb)^5.0\n    end\n    if (i == 1)\n        ad = 3.064320\n        f = ad * xb^0.8 * (1.0-xb)^4.0\n    end\n    if (i == 2)\n        au = 5.107200\n        f = au * xb^0.8 * (1.0-xb)^3.0\n    end\n    if (i == 3) \n        f = 0.0\n    end\n    if (i == 4)\n        f = adbar * xb^-0.1 * (1.0-xb)^6.0\n    end\n    if (i == 5) \n        f = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)\n    end\n    if (i == 6)\n        xdbar = adbar * xb^-0.1 * (1.0-xb)^6.0\n        xubar = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)\n        f = 0.2 * (xdbar + xubar)\n    end\n    if (i == 7)\n        f = 0.0\n    end\n    if (i == 8)\n        f = 0.0\n    end\n    if (i == 9)\n        f = 0.0\n    end\n    if (i == 10)\n        f = 0.0\n    end\n    if (i == 11)\n        f = 0.0\n    end\n    if (i == 12)\n        f = 0.0\n    end\n    return f\nend\n\nfunc_c = @cfunction(func, Float64, (Ref{Int32}, Ref{Float64}))","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Next, let's initialise QCDNUM and run QCDNUM to evolve the PDF.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"QCDNUM.qcinit(-6, \" \")\nnx = QCDNUM.gxmake(xmin, iwt, ng, nxin, iosp)\nnq = QCDNUM.gqmake(qq, wt, ngq, nqin)\nnw = QCDNUM.fillwt(itype)\nQCDNUM.setord(3)\nQCDNUM.setalf(as0, r20)\niqc = QCDNUM.iqfrmq(q2c)\niqb = QCDNUM.iqfrmq(q2b)\niqt = QCDNUM.iqfrmq(1e11)\nQCDNUM.setcbt(0, iqc, iqb, 0)\niq0 = QCDNUM.iqfrmq(q0)\neps = QCDNUM.evolfg(itype, func_c, def, iq0)\npdf = QCDNUM.allfxq(itype, x, q, 0, 1)\nasmz, a, b = QCDNUM.asfunc(qmz2)\ncsea = 2*pdf[3];","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Now, we can breifly check the results","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"@printf(\"x, q, CharmSea = %0.4e, %0.4e, %0.4e\\n\", x, q, csea)\n@printf(\"as(mz2) = %0.4e\", asmz)","category":"page"},{"location":"installation/#Installation","page":"Installation","title":"Installation","text":"","category":"section"},{"location":"installation/","page":"Installation","title":"Installation","text":"To use the QCDNUM.jl Julia interface to QCDNUM, you simply need to install QCDNUM.jl as described below. The compilation and linking of the original Fortran code is handled by BinaryBuilder and Yggdrasil.","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"The QCDNUM Julia wrapper can be installed either from the GitHub repository via using Julia's package manager (best if you just want to use the code) or cloned from GitHub and installed from a local directory (best if you want to develop and contribute to the source code).","category":"page"},{"location":"installation/#Simple-installation","page":"Installation","title":"Simple installation","text":"","category":"section"},{"location":"installation/","page":"Installation","title":"Installation","text":"In the Julia REPL:","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"using Pkg\nPkg.add(url=\"https://github.com/cescalara/QCDNUM.jl.git\")","category":"page"},{"location":"installation/#Development-installation","page":"Installation","title":"Development installation","text":"","category":"section"},{"location":"installation/","page":"Installation","title":"Installation","text":"Clone the github repository, e.g. via the command line:","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"git clone  https://github.com/cescalara/QCDNUM.jl.git","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"Enter the directory and start Julia interpreter","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"cd QCDNUM.jl\njulia","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"Open the Julia package management environment pressing .","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"julia> ]","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"Execute ","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"pkg> generate QCDNUM\n...... \npkg>  . dev","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"Exit the package manager using backspace or pressing Ctrl+C","category":"page"},{"location":"installation/#Checking-the-installation","page":"Installation","title":"Checking the installation","text":"","category":"section"},{"location":"installation/","page":"Installation","title":"Installation","text":"In both cases the QCDNUM package will be available via using QCDNUM. To show the available functions, execute:","category":"page"},{"location":"installation/","page":"Installation","title":"Installation","text":"using QCDNUM\n\nnames(QCDNUM, all=true)","category":"page"},{"location":"#Introduction","page":"Introduction","title":"Introduction","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"Fast QCD evolution and convolution.","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"QCDNUM.jl is a Julia wrapper for Michiel Botje's QCDNUM, written in Fortran77.  QCDNUM.jl is currently under development and more functionality and documentation will be added continuously. ","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"All implemented functions are based on the original Fortran implementation. Please see the relevant documentation for further information. ","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"If you use QCDNUM, please refer to M. Botje, Comput. Phys. Commun. 182(2011)490, arXiv:1005.1481. ","category":"page"}]
}
