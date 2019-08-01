import HTTP
import JSON

const github_owner = "bcbi"
const github_repo = "ModelSanitizer.jl"

function _get_github_pull_request_title_unauthenticated(travis_pull_request::AbstractString)::String
    _travis_pull_request::String = lowercase(strip(travis_pull_request))
    if length(_travis_pull_request) == 0 || _travis_pull_request == "false"
        return ""
    else
        pull_request_json = HTTP.request("GET", "https://api.github.com/repos/$(github_owner)/$(github_repo)/pulls/$(_travis_pull_request)", ["User-Agent:" => "bcbi-bot"])
        pull_request_dict = JSON.parse(String(deepcopy(pull_request_json.body)))
        pull_request_title::String = strip(pull_request_dict["title"])
        return pull_request_title
    end
end

function get_github_pull_request_title_unauthenticated(d::AbstractDict)
    travis_pull_request::String = lowercase(strip(get(d, "TRAVIS_PULL_REQUEST", "false")))
    result = _get_github_pull_request_title_unauthenticated(travis_pull_request)
    return result
end

get_github_pull_request_title_unauthenticated() = get_github_pull_request_title_unauthenticated(ENV)
