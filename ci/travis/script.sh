#!/bin/bash

set -ev

echo "COMPILED_MODULES=$COMPILED_MODULES"
export JULIA_FLAGS="--check-bounds=yes --code-coverage=all --color=yes --compiled-modules=$COMPILED_MODULES --inline=no -O0"
echo "JULIA_FLAGS=$JULIA_FLAGS"

julia $JULIA_FLAGS -e '
    import Pkg;
    Pkg.build("ModelSanitizer");
    '

julia $JULIA_FLAGS -e '
    import Pkg;
    Pkg.test("ModelSanitizer"; coverage=true);
    '

julia $JULIA_FLAGS -e '
    import Pkg;
    try Pkg.add("Coverage") catch end;
    '

julia $JULIA_FLAGS -e '
    import Coverage;
    import ModelSanitizer;
    cd(joinpath(dirname(pathof(ModelSanitizer)), "..",));
    Coverage.Codecov.submit(Coverage.Codecov.process_folder());
    '
