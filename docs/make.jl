push!(LOAD_PATH,"../src/")

using Documenter, QCDNUM

makedocs(modules=[QCDNUM], sitename="QCDNUM.jl")

deploydocs(
    devbranch = "main",
    repo = "github.com/cescalara/QCDNUM.jl.git",
)
