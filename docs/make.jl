push!(LOAD_PATH,"../src/")

using Documenter
using QCDNUM
using Literate

# Generate examples notebooks
gen_content_dir = joinpath(@__DIR__, "src")

example_src = joinpath(@__DIR__, "..", "examples", "example.jl")
testsgns_src = joinpath(@__DIR__, "..", "examples", "testsgns.jl")
timing_src = joinpath(@__DIR__, "..", "examples", "timing.jl")
    
Literate.markdown(example_src, gen_content_dir, name="example")
Literate.markdown(testsgns_src, gen_content_dir, name="testsgns")
Literate.markdown(timing_src, gen_content_dir, name="timing")

About = "Introduction" => "index.md"

Installation = "Installation" => "installation.md"

Examples = "Examples" => ["examples.md", "example.md", "testsgns.md", "timing.md"]

Functions = "Available functions" => "functions.md"

Notebooks = "Notebook tutorial" => "notebook.md"

PAGES = [About, Installation, Notebooks, Examples, Functions]

makedocs(modules=[QCDNUM], sitename="QCDNUM.jl", pages=PAGES)

deploydocs(
    devbranch = "main",
    repo = "github.com/cescalara/QCDNUM.jl.git",
)
