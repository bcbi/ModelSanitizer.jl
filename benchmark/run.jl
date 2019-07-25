import PkgBenchmark

function _get_travis_git_commit_message(a::AbstractDict = ENV)::String
    result::String = strip(get(a, "TRAVIS_COMMIT_MESSAGE", ""))
    return result
end

function _travis_allow_regressions(commit_message::String)::Tuple{Bool, Bool}
    _commit_message::String = string("\n\n\n", commit_message, "\n\n\n")
    _regex_allow_onlytime_regressions = r"\n\d*: \[ALLOW_TIME_REGRESSIONS\]"
    _regex_allow_onlymemory_regressions = r"\n\d*: \[ALLOW_MEMORY_REGRESSIONS\]"
    _regex_allow_bothtimeandmemory_regressions = r"\n\d*: \[ALLOW_TIME\+MEMORY_REGRESSIONS\]"
    _allow_onlytime_regressions::Bool = occursin(_regex_allow_onlytime_regressions, _commit_message)
    _allow_onlymemory_regressions::Bool = occursin(_regex_allow_onlymemory_regressions, _commit_message)
    _allow_bothtimeandmemory_regressions::Bool = occursin(_regex_allow_bothtimeandmemory_regressions, _commit_message)
    allow_time_regressions::Bool = _allow_onlytime_regressions || _allow_bothtimeandmemory_regressions
    allow_memory_regressions::Bool = _allow_onlymemory_regressions || _allow_bothtimeandmemory_regressions
    return allow_time_regressions, allow_memory_regressions
end

function run_benchmarks()
    allow_time_regressions, allow_memory_regressions = _travis_allow_regressions(_get_travis_git_commit_message())
    @info("Allow time regressions: $(allow_time_regressions). Allow memory regressions: $(allow_memory_regressions).")

    project_root = dirname(dirname(@__FILE__))

    proof_of_concept_dataframes = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-dataframes.jl")
    proof_of_concept_linearmodel = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-linearmodel.jl")
    proof_of_concept_mlj = joinpath(project_root, "test", "integration-tests", "test-proof-of-concept-mlj.jl")

    # run each of the scripts once to force compilation of the functions
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
                if allow_time_regressions
                    @error("Time regression (allowed) detected in $(i)/$(j)", trial_judgement)
                else
                    this_judgement_was_failed_for_time = true
                    @error("Time regression detected in $(i)/$(j)", trial_judgement)
                end
            end
            if PkgBenchmark.memory(trial_judgement) == :regression
                if allow_memory_regressions
                    @error("Memory regression (allowed) detected in $(i)/$(j)", trial_judgement)
                else
                    this_judgement_was_failed_for_memory = true
                    @error("Memory regression regression detected in $(i)/$(j)", trial_judgement)
                end
            end
        end
    end

    if this_judgement_was_failed_for_time || this_judgement_was_failed_for_memory
        error(
            string(
                "FAILURE: One or more fatal performance regressions were detected.\n",
                "To ignore only time regressions, begin your pull request title with ",
                "\"[ALLOW_TIME_REGRESSIONS]\".\n",
                "To ignore only memory regressions, begin your pull request title with ",
                "\"[ALLOW_MEMORY_REGRESSIONS]\".\n",
                "To ignore both time and memory regressions, begin your pull request title with ",
                "\"[ALLOW_TIME+MEMORY_REGRESSIONS]\".\n",
                )
            )
    else
        @info("SUCCESS: No fatal performance regressions were detected.")
    end
end

run_benchmarks()
