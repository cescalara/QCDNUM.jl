push!(LOAD_PATH,"../src/")

using Documenter
using QCDNUM
using Literate

# Generate examples notebooks
gen_content_dir = joinpath(@__DIR__, "src")
example_src = joinpath(@__DIR__, "..", "examples", "example.jl")

Literate.markdown(example_src, gen_content_dir, name="example")

About = "Introduction" => "index.md"

Installation = "Installation" => "installation.md"

Examples = "Examples" => "examples.md"

Functions = "Available functions" => "functions.md"

Notebooks = "Notebook tutorial" => "notebook.md"

PAGES = [About, Installation, Notebooks, Examples, Functions]

makedocs(modules=[QCDNUM], sitename="QCDNUM.jl", pages=PAGES)

deploydocs(
    devbranch = "main",
    repo = "github.com/cescalara/QCDNUM.jl.git",
)
