import BenchmarkTools
import PkgBenchmark

PkgBenchmark.benchmarkpkg("ModelSanitizer"; script="benchmark/benchmarks.jl", resultfile="resultfile.dilum", retune=true)
