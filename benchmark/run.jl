import BenchmarkTools
import PkgBenchmark

function run_benchmarks()
    project_root = dirname(dirname(@__FILE__))

    proof_of_concept_dataframes = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-dataframes.jl")
    proof_of_concept_linearmodel = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-linearmodel.jl")
    proof_of_concept_mlj = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-mlj.jl")

    # run each of the scripts once to force compilation of all of the functions
    include(proof_of_concept_dataframes)
    include(proof_of_concept_linearmodel)
    include(proof_of_concept_mlj)

    fail_travis_ = true

    fail_travis_time_regression = true
    fail_travis_memory_regression = true

    judgement = BenchmarkTools.judge("ModelSanitizer", "HEAD", "origin/master-benchmark")

    judgement_suite = PkgBenchmark.benchmarkgroup(judgement)
    judgement_suite_data = judgement_suite.data

    this_judgement_was_failed_for_time = true
    this_judgement_was_failed_for_memory = true

    for i in ["integration-tests"]
        judgement_suite_data_i = judgement_suite_data[i]
        judgement_suite_data_i_data = judgement_suite_data_i.data
        for j in ["proof-of-concept-dataframes", "proof-of-concept-linearmodel", "proof-of-concept-mlj"]
            trial_judgement_i_j = judgement_suite_data_i_data[j]
            time = BenchmarkTools.time(trial_judgement_i_j)
            memory = BenchmarkTools.memory(trial_judgement_i_j)
            if time == :FAILURESYMBOL
                if fail_for_time_regression
                    @error("Fatal time regression detected in $(i)/$(j)")
                    this_judgement_was_failed_for_time = true
                else
                    @error("Non-fatal time regression detected in $(i)/$(j)")
                end
            end
            if memory == :FAILURESYMBOL
                if fail_for_memory_regression
                    @error("Fatal time regression detected in $(i)/$(j)")
                    this_judgement_was_failed_for_memory = true
                else
                    @error("Non-fatal time regression detected in $(i)/$(j)")
                end
            end
        end
    end

    if fail_for_time_regression || fail_for_memory_regression
        error("One or more fatal performance regressions were detected.")
    else
        @info("SUCCESS: No fatal performance regressions were detected.")
    end
end

run_benchmarks()
