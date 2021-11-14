# Installation

To use the QCDNUM.jl Julia interface to QCDNUM, both the original Fortran code and the Julia package must be installed and set up correctly. Instructions for each part are given below.

## QCDNUM (Original code)

The compilation and installation of QCDNUM follows from the instructions available on the [QCDNUM home page](https://www.nikhef.nl/~h24/qcdnum/). You can also find the downloads of the different QCDNUM versions here.

!!! tip

	For full access to all available features of QCDNUM.jl including the SPLINT library, we recommend to use the latest version of QCDNUM, which is currently v170183 available [here](https://www.nikhef.nl/~h24/download/). Certain features may work with other QCDNUM versions, but full compatibility is not otherwise guaranteed.
	
We review the main install steps below:

```
bash> gunzip qcdnumXXXXXX.tar.gz
bash> tar -xvf qcdnumXXXXXX.tar
bash> cd qcdnum-XX-XX-XX
bash> ./configure
bash> make                (or make -j8 on multiple processors)
bash> make install        (or sudo make install)
```
	
To check if your installation has been successful, try running some test jobs:

```
bash> cd qcdnum-XX-XX-XX/run
bash> ./runtest example      (without extension .f)
bash> ./runtest exampleCxx   (without extension .cc)
```

!!! tip

	If you encounter problems with your installation when using more recent gfortran/gcc versions, try adding the `-fallow-argument-mismatch` flag to the configure step, i.e.
	
	```
	bash> ./configure FCFLAGS="-O3 -Iinc -fallow-argument-mismatch"
	```

To work with the QCDNUM Julia wrapper, QCDNUM must be in your path. Depending on your install and system, you may need to add the path via the `PATH` and `LD_LIBRARY_PATH` environment variables.

---
**NOTE**

In future, we will simplify this process by making use of [BinaryBuilder](https://github.com/JuliaPackaging/BinaryBuilder.jl) and [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil), but this in currently a work in progress.

---

## QCDNUM.jl (wrapper)

The QCDNUM Julia wrapper can be installed either from the GitHub repository via using Julia's package manager (best if you just want to use the code) or cloned from GitHub and installed from a local directory (best if you want to develop and contribute to the source code).

### Simple installation

In the Julia REPL:

```@repl
using Pkg
Pkg.add(url="https://github.com/cescalara/QCDNUM.jl.git")
```

### Development installation 

- Clone the github repository, e.g. via the command line:
```
git clone  https://github.com/cescalara/QCDNUM.jl.git
```

- Enter the directory and start Julia interpreter
```
cd QCDNUM.jl
julia
```

-  Open the Julia package management environment pressing ``]``.

```
julia> ]
```

 - Execute 
```
pkg> generate QCDNUM
...... 
pkg>  . dev
```
 - Exit the package manager using backspace or pressing `Ctrl+C`

### Checking the installation

In both cases the QCDNUM package will be available via `using QCDNUM`.
To show the available functions, execute:
```@repl
using QCDNUM

names(QCDNUM, all=true)
```
