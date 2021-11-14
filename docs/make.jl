push!(LOAD_PATH,"../src/")

using Documenter, QCDNUM

About = "Introduction" => "index.md"

Installation = "Installation" => "installation.md"

Examples = "Examples" => "examples.md"

Functions = "Available functions" => "functions.md"

PAGES = [About, Installation, Examples, Functions]

makedocs(modules=[QCDNUM], sitename="QCDNUM.jl", pages=PAGES)

deploydocs(
    devbranch = "main",
    repo = "github.com/cescalara/QCDNUM.jl.git",
)
