push!(LOAD_PATH,"../src/")

using Documenter
using QCDNUM
using Literate

# Generate examples notebooks
gen_content_dir = joinpath(@__DIR__, "src")

quickstart_src = joinpath(@__DIR__, "..", "examples", "quickstart.jl")
example_src = joinpath(@__DIR__, "..", "examples", "example.jl")
testsgns_src = joinpath(@__DIR__, "..", "examples", "testsgns.jl")
timing_src = joinpath(@__DIR__, "..", "examples", "timing.jl")
splint_src = joinpath(@__DIR__, "..", "examples", "splint.jl")
     
Literate.markdown(quickstart_src, gen_content_dir, name="quickstart")
Literate.markdown(example_src, gen_content_dir, name="example")
Literate.markdown(testsgns_src, gen_content_dir, name="testsgns")
Literate.markdown(timing_src, gen_content_dir, name="timing")
Literate.markdown(splint_src, gen_content_dir, name="splint")

About = "Introduction" => "index.md"

Installation = "Installation" => "installation.md"

Quickstart = "Quick start" => "quickstart.md"

Examples1 = "QCDNUM example jobs" => ["example.md", "testsgns.md",
                                      "timing.md"]

Examples2 = "Further examples" => ["splint.md"]

Functions = "Available functions" => "functions.md"

Notebooks = "Notebook tutorial" => "notebook.md"

PAGES = [About, Installation, Notebooks, Quickstart, Examples1, Examples2, Functions]

makedocs(modules=[QCDNUM], sitename="QCDNUM.jl", pages=PAGES)

deploydocs(
    devbranch = "main",
    repo = "github.com/cescalara/QCDNUM.jl.git",
)
