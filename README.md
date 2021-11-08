# QCDNUM.jl

Fast QCD evolution and convolution.

QCDNUM.jl is a Julia wrapper for Michiel Botje's [QCDNUM](https://www.nikhef.nl/~h24/qcdnum/), written in Fortran77. 
QCDNUM.jl is currently under development and more functionality and documentation will be added soon. 

## Installation

The QCDNUM package can be installed either from the github repository in a semi-automatic way or from the local derectory

### Installation from github

- Start Julia interpreter and the to open the Julia package management environment pressing ``]``.
```
julia> ]
```

 - Install from GitHub in Julia's [Pkg REPL](https://docs.julialang.org/en/v1.6/stdlib/Pkg/):
```
pkg> add https://github.com/cescalara/QCDNUM.jl.git
```

 - Exit the package manager using backspace or pressing `Ctrl+C`


### Installation from local directory

- Clone the github repository, e.g. 
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
(@v1.6) pkg> generate PartonDensity
...... 
(@v1.6) pkg>  . dev
```
 - Exit the package manager using backspace or pressing `Ctrl+C`


In both cases the QCDNUM package will be available via `using QCDNUM`.






