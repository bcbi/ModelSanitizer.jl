import BenchmarkTools
import PkgBenchmark

function run_benchmarks()
    const project_root = dirname(dirname(@__FILE__))

    const proof_of_concept_dataframes = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-dataframes.jl")
    const proof_of_concept_linearmodel = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-linearmodel.jl")
    const proof_of_concept_mlj = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-mlj.jl")

    # run each of the scripts once to force compilation of all of the functions
    include(proof_of_concept_dataframes)
    include(proof_of_concept_linearmodel)
    include(proof_of_concept_mlj)

    const fail_travis_ = true

    const fail_travis_time_regression = true
    const fail_travis_memory_regression = true
    const target = "HEAD"
    const baseline = "origin/master-benchmark"

    judgement = BenchmarkTools.judge("ModelSanitizer", target, baseline)

    judgement_suite = PkgBenchmark.benchmarkgroup(judgement)
    judgement_suite_data = judgement_suite.data

    fail_for_time_regression = false
    fail_for_memory_regression = false

    for i in ["integration-tests"]
        judgement_suite_data_i = judgement_suite_data[i]
        judgement_suite_data_i_data = judgement_suite_data_i.data
        for j in ["proof-of-concept-dataframes", "proof-of-concept-linearmodel", "proof-of-concept-mlj"]
            trial_judgement_i_j = judgement_suite_data_i_data[j]
        end
    end

    if fail_for_time_regression || fail_for_memory_regression
    else
    end
end

run_benchmarks()
