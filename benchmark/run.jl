import PkgBenchmark

function run_benchmarks()
    fail_travis_for_time_regressions = false
    fail_travis_for_memory_regressions = false

    project_root = dirname(dirname(@__FILE__))

    proof_of_concept_dataframes = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-dataframes.jl")
    proof_of_concept_linearmodel = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-linearmodel.jl")
    proof_of_concept_mlj = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-mlj.jl")

    # run each of the scripts once to force compilation of all of the functions
    include(proof_of_concept_dataframes)
    include(proof_of_concept_linearmodel)
    include(proof_of_concept_mlj)

    judgement = PkgBenchmark.judge("ModelSanitizer", "HEAD", "origin/master-benchmark")

    this_judgement_was_failed_for_time = false
    this_judgement_was_failed_for_memory = false

    for i in ["integration-tests"]
        for j in ["proof-of-concept-dataframes", "proof-of-concept-linearmodel", "proof-of-concept-mlj"]
            trial_judgement = PkgBenchmark.benchmarkgroup(judgement).data[i].data[j]
            if PkgBenchmark.time(trial_judgement) == :regression
                if fail_travis_for_time_regressions
                    @error("Fatal time regression detected in $(i)/$(j)", trial_judgement)
                    this_judgement_was_failed_for_time = true
                else
                    @error("Non-fatal time regression detected in $(i)/$(j)", trial_judgement)
                end
            end
            if PkgBenchmark.memory(trial_judgement) == :regression
                if fail_travis_for_memory_regressions
                    @error("Fatal time regression detected in $(i)/$(j)", trial_judgement)
                    this_judgement_was_failed_for_memory = true
                else
                    @error("Non-fatal time regression detected in $(i)/$(j)", trial_judgement)
                end
            end
        end
    end

    if this_judgement_was_failed_for_time || this_judgement_was_failed_for_memory
        error("FAILURE: One or more fatal performance regressions were detected.")
    else
        @info("SUCCESS: No fatal performance regressions were detected.")
    end
end

run_benchmarks()
