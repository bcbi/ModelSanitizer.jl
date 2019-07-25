import BenchmarkTools
import PkgBenchmark

function run_benchmarks(project_root = dirname(dirname(@__FILE__));
                        fail_travis_time_regression::Bool = true,
                        fail_travis_memory_regression::Bool = true)
    proof_of_concept_dataframes = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-dataframes.jl")
    proof_of_concept_linearmodel = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-linearmodel.jl")
    proof_of_concept_mlj = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-mlj.jl")

    # run each of the scripts once to force compilation of all of the functions
    include(proof_of_concept_dataframes)
    include(proof_of_concept_linearmodel)
    include(proof_of_concept_mlj)

    judgement = BenchmarkTools.judge("ModelSanitizer", "HEAD", "origin/master-benchmark")

    this_judgement_was_failed_for_time = true
    this_judgement_was_failed_for_memory = true

    for i in ["integration-tests"]
        for j in ["proof-of-concept-dataframes", "proof-of-concept-linearmodel", "proof-of-concept-mlj"]
            trial_judgement = PkgBenchmark.benchmarkgroup(judgement).data[i].data[j]
            if BenchmarkTools.time(trial_judgement) == :regression
                if fail_for_time_regression
                    @error("Fatal time regression detected in $(i)/$(j)")
                    this_judgement_was_failed_for_time = true
                else
                    @error("Non-fatal time regression detected in $(i)/$(j)")
                end
            end
            if BenchmarkTools.memory(trial_judgement) == :regression
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
        error("FAILURE: One or more fatal performance regressions were detected.")
    else
        @info("SUCCESS: No fatal performance regressions were detected.")
    end
end

run_benchmarks()
