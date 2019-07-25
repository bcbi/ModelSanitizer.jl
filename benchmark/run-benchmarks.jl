import BenchmarkTools
import PkgBenchmark

benchmark_result = PkgBenchmark.benchmarkpkg("ModelSanitizer"; retune=true)

const fail_travis_if_benchmarks_detect_performance_regression = true
const target = "HEAD"
const baseline = "origin/master-benchmark"

# BenchmarkTools.judge("ModelSanitizer", target, baseline)
