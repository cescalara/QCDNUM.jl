push!(LOAD_PATH,"../src/")

using Documenter, QCDNUM

makedocs(modules=[QCDNUM], sitename="QCDNUM.jl")

deploydocs(
    repo = "github.com/cescalara/QCDNUM.jl.git",
)
