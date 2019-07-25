const project_root = dirname(dirname(@__FILE__))
const run_benchmarks = joinpath(project_root, "benchmark", "run-benchmarks.jl")
include(run_benchmarks)
