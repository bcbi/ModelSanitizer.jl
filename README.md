# ModelSanitizer

<p>
<a
href="https://doi.org/10.5281/zenodo.1291209">
<img
src="https://zenodo.org/badge/109460252.svg"/>
</a>
</p>

<p>
<a
href="https://app.bors.tech/repositories/18923">
<img
src="https://bors.tech/images/badge_small.svg"
alt="Bors enabled">
</a>
<a
href="https://travis-ci.com/bcbi/ModelSanitizer.jl/branches">
<img
src="https://travis-ci.com/bcbi/ModelSanitizer.jl.svg?branch=master">
</a>
<a
href="https://codecov.io/gh/bcbi/ModelSanitizer.jl">
<img
src="https://codecov.io/gh/bcbi/ModelSanitizer.jl/branch/master/graph/badge.svg">
</a>
</p>

## Usage

ModelSanitizer exports the `sanitize!` function and the `Model`, `Data`, and
`ForceSanitize` structs.

If your model is stored in `m` and your data are stored in `x1`,
`x2`, `x3`, etc. then you can sanitize your model with:
```julia
sanitize!(Model(m), Data(x1), Data(x2), Data(x3), ...)
```

This will recursively search inside the model `m` for anything that resembles
your data and will delete the data that it finds.

If you happen to know exactly where inside a model the data are stored, you
can explicitly tell ModelSanitizer to delete those data. If your model is
stored in `m`, and you know that the fields `m.x1`, `m.x2`, `m.x3`, etc. contain
data that needs to be removed, you can force ModelSanitizer to delete those
data with:
```julia
sanitize!(ForceSanitize(m.x1), ForceSanitize(m.x2), ForceSanitize(m.x3), ...)
```

## Examples

### Example 1

```julia
julia> using ModelSanitizer

julia> using Statistics

julia> using Test

julia> mutable struct LinearModel{T}
           X::Matrix{T}
           y::Vector{T}
           beta::Vector{T}
           function LinearModel{T}()::LinearModel{T} where T
               m::LinearModel{T} = new()
               return m
           end
       end

julia> function fit!(m::LinearModel{T}, X::Matrix{T}, y::Vector{T})::LinearModel{T} where T
           m.X = deepcopy(X)
           m.y = deepcopy(y)
           m.beta = beta = (m.X'm.X)\(m.X'm.y)
           return m
       end
fit! (generic function with 1 method)

julia> function predict(m::LinearModel{T}, X::Matrix{T})::Vector{T} where T
           y_hat::Vector{T} = X * m.beta
           return y_hat
       end
predict (generic function with 1 method)

julia> function predict(m::LinearModel{T})::Vector{T} where T
           X::Matrix{T} = m.X
           y_hat::Vector{T} = predict(m, X)
           return y_hat
       end
predict (generic function with 2 methods)

julia> function mse(y::Vector{T}, y_hat::Vector{T})::T where T
           _mse::T = mean((y .- y_hat).^2)
           return _mse
       end
mse (generic function with 1 method)

julia> function mse(m::LinearModel{T}, X::Matrix{T}, y::Vector{T})::T where T
           y_hat::Vector{T} = predict(m, X)
           _mse::T = mse(y, y_hat)
           return _mse
       end
mse (generic function with 2 methods)

julia> function mse(m::LinearModel{T})::T where T
           X::Matrix{T} = m.X
           y::Vector{T} = m.y
           _mse::T = mse(m, X, y)
           return _mse
       end
mse (generic function with 3 methods)

julia> rmse(varargs...) = sqrt(mse(varargs...))
rmse (generic function with 1 method)

julia> function r2(y::Vector{T}, y_hat::Vector{T})::T where T
           y_bar::T = mean(y)
           SS_tot::T = sum((y .- y_bar).^2)
           SS_res::T = sum((y .- y_hat).^2)
           _r2::T = 1 - SS_res/SS_tot
           return _r2
       end
r2 (generic function with 1 method)

julia> function r2(m::LinearModel{T}, X::Matrix{T}, y::Vector{T})::T where T
           y_hat::Vector{T} = predict(m, X)
           _r2::T = r2(y, y_hat)
           return _r2
       end
r2 (generic function with 2 methods)

julia> function r2(m::LinearModel{T})::T where T
           X::Matrix{T} = m.X
           y::Vector{T} = m.y
           _r2::T = r2(m, X, y)
           return _r2
       end
r2 (generic function with 3 methods)

julia> X = randn(Float64, 5_000, 14)
5000×14 Array{Float64,2}:
  0.0956436    0.481324   -0.796437  …  -2.26483     1.57243    -1.65105
 -0.306527    -0.880146   -0.764714     -0.182449   -0.0767462  -0.939232
 -0.223116    -0.408068    0.728855      0.220045    0.785533    0.49013
 -0.336363     1.46187    -1.17633      -0.955872    0.699277    0.587961
  0.628275     0.208697   -0.522714      0.116233    0.47314     0.435968
 -0.12303     -0.964061    0.919518  …  -0.0230613  -1.12379    -0.439892
  1.06664      0.96542    -0.250164     -0.776266    1.70851    -1.08608
  0.957151     0.850486    1.31718       0.497219    1.01069    -0.558217
 -0.206168    -0.608305   -0.864631      0.969031    0.209796    1.28718
 -0.658039     1.20687     1.33288       1.54847     0.546286   -1.00404
 -0.598782    -0.193289    0.673134  …  -1.59742     0.410881   -1.61342
  0.31442      0.0199012   0.50533       1.0889     -0.0713841  -1.29933
  0.236585    -1.09804     0.945631     -0.729247   -1.10004    -0.339332
  0.122913     0.619345   -2.90947       1.09613    -0.662693   -1.03469
  1.52615      0.942471    0.262139      0.223064    0.665103    1.4081
 -0.474543     1.9466     -0.408505  …   1.01626    -0.297397   -0.0953909
  0.73664     -0.0796424  -1.84864       1.15935     0.0164378   1.32191
  0.24588      0.271068   -0.238212      0.596475    1.52617    -0.747777
  ⋮                                  ⋱
 -1.07141      0.194049   -0.350011     -0.666195    0.481406   -0.451329
 -0.00993413   0.33006    -0.985443     -0.0395822   2.36983    -0.793007
  0.610014    -0.509744   -1.06447   …   1.19769     1.129       0.397217
  0.785654    -0.361031    0.314127      0.192215    0.789262    0.725731
  0.258588    -2.06379     0.511611      0.0963516  -1.01919    -0.540021
  0.48671     -0.918205    0.264124      0.989929    2.45245    -1.39545
 -1.27085     -0.0617834   2.59491       0.291602    1.28642     0.236496
  1.4044      -1.24472    -0.205029  …   1.99366    -1.58951     0.963728
 -1.07691      0.44178    -0.602841      0.584759   -0.887116    1.36514
  1.13586      0.954756    0.44016      -2.21191    -1.14086    -0.585916
 -0.763031    -1.13348    -1.46696      -1.4121     -0.977694   -0.618883
  0.875367    -1.30925     0.183117      0.224709    0.0752964  -0.92173
  0.659502     0.71971    -1.05538   …  -0.912277   -0.736332    1.01404
 -0.809941     2.02362     1.29668       0.113623   -0.858281    0.0863472
 -1.6409       0.310551   -0.235102     -1.11232    -0.170224    0.404804
 -0.367908    -1.9062      0.245953     -0.751821   -0.794633    0.00894607
  0.380897     2.30871    -0.669909      0.282513   -0.114725   -0.253537

julia> y = X * randn(Float64, 14) + randn(5_000)
5000-element Array{Float64,1}:
 -4.418867382994752
  1.0721553534178543
  2.210545604666476
 -2.5053994409702094
  2.24399399066432
  0.5993702994926247
  2.2040361967638322
 -2.4902628750358193
  4.184644001244288
  1.7688752332135804
 -4.831550352023476
 -1.068149084362266
 -0.746260929030723
  0.032933800577055417
  2.878202216460962
  2.773804353610833
  1.0288912118472482
  3.7799578982964963
  ⋮
  3.1797791441997822
  5.830717537973503
 -0.8191545280972992
  4.649281267724443
  0.9470989605451162
  5.733118456044454
  3.057352206232011
  4.791267454465988
 -4.604222639675081
 -5.755448165821573
 -0.9804279159155482
  2.2904285226467276
  2.809999802793834
  0.7773010780323945
 -2.5205742651574
  3.8866539005621092
 -4.085889556008112

julia> m = LinearModel{Float64}()
LinearModel{Float64}(#undef, #undef, #undef)

julia> testing_rows = 1:2:5_000
1:2:4999

julia> training_rows = setdiff(1:5_000, testing_rows)
2500-element Array{Int64,1}:
    2
    4
    6
    8
   10
   12
   14
   16
   18
   20
   22
   24
   26
   28
   30
   32
   34
   36
    ⋮
 4968
 4970
 4972
 4974
 4976
 4978
 4980
 4982
 4984
 4986
 4988
 4990
 4992
 4994
 4996
 4998
 5000

julia> fit!(m, X[training_rows, :], y[training_rows])
LinearModel{Float64}([-0.306527 -0.880146 … -0.0767462 -0.939232; -0.336363 1.46187 … 0.699277 0.587961; … ; -1.6409 0.310551 … -0.170224 0.404804; 0.380897 2.30871 … -0.114725 -0.253537], [1.07216, -2.5054, 0.59937, -2.49026, 1.76888, -1.06815, 0.0329338, 2.7738, 3.77996, -4.06727  …  2.81088, 3.17978, -0.819155, 0.947099, 3.05735, -4.60422, -0.980428, 2.81, -2.52057, -4.08589], [-0.532213, -1.16489, -0.414974, -0.562536, -0.440432, 0.732505, -1.06754, 0.399485, -0.67281, -1.44599, 0.835625, 0.426459, 1.20088, 0.754435])

julia> @test m.X == X[training_rows, :]
Test Passed

julia> @test m.y == y[training_rows]
Test Passed

julia> @test all(m.X .== X[training_rows, :])
Test Passed

julia> @test all(m.y .== y[training_rows])
Test Passed

julia> @test !all(m.X .== 0)
Test Passed

julia> @test !all(m.y .== 0)
Test Passed

julia> # before sanitization, we can make predictions
       predict(m, X[testing_rows, :])
2500-element Array{Float64,1}:
 -4.513253714187381
  2.5689035333536605
  0.9939782906365846
  1.2513894159362184
  3.2007086601687353
 -5.387968774216589
 -0.1767892797746935
  3.4408813711668165
  0.4625821018811823
  1.649129884116436
 -0.8620887900500149
  0.6504970487658756
  4.287913533796443
 -2.5014166099065136
  1.1666979326633855
  0.2723098985354143
  3.2783930370766634
  2.250636815003683
  ⋮
  1.1999638265752477
  3.8377489399901084
  4.2805489451765935
 -0.5849048693472063
 -0.6574890049656816
  0.2606368302418087
 -4.197310605534758
 -3.5805273324146336
 -0.5244747588662737
  5.274904154193373
  2.7742388165636953
  5.883741172337488
  2.118699747786167
 -4.209943069147431
  2.262361580682631
 -0.5044151513387216
  4.443422779093501

julia> predict(m, X[training_rows, :])
2500-element Array{Float64,1}:
  2.943212508610099
 -0.8226863248850258
  1.031068845178503
 -3.3178919274576053
  0.587046578244962
 -0.032251634503744686
  1.9123819046207888
  3.555603804394087
  2.1728937544760307
 -1.9319447549669504
 -0.7592148524301295
 -7.250437603426189
  4.982277986708986
 -1.8660967909674548
  0.29423182806971415
  0.593840341165224
 -0.26314562641917977
  1.4340414682799685
  ⋮
  1.6038174714835796
  1.3091787016871341
  4.936123830680592
  1.9812183495287048
 -0.848632475032059
  3.1553721781769157
 -5.412240178264108
  1.406559298117795
  3.6433312336276646
  0.3408165307792135
  0.2882242203753349
  1.8120206189755343
 -3.299798877655878
 -0.8793971451160698
  2.3158119962568886
 -2.4598360012327265
 -4.810128269819875

julia> @show mse(m, X[training_rows, :], y[training_rows])
mse(m, X[training_rows, :], y[training_rows]) = 0.9856973993855034
0.9856973993855034

julia> @show rmse(m, X[training_rows, :], y[training_rows])
rmse(m, X[training_rows, :], y[training_rows]) = 0.9928229446308658
0.9928229446308658

julia> @show r2(m, X[training_rows, :], y[training_rows])
r2(m, X[training_rows, :], y[training_rows]) = 0.9044357103305194
0.9044357103305194

julia> @show mse(m, X[testing_rows, :], y[testing_rows])
mse(m, X[testing_rows, :], y[testing_rows]) = 0.9480778102674918
0.9480778102674918

julia> @show rmse(m, X[testing_rows, :], y[testing_rows])
rmse(m, X[testing_rows, :], y[testing_rows]) = 0.9736928726592856
0.9736928726592856

julia> @show r2(m, X[testing_rows, :], y[testing_rows])
r2(m, X[testing_rows, :], y[testing_rows]) = 0.9088387716983182
0.9088387716983182

julia> sanitize!(Model(m), Data(X), Data(y)) # sanitize the model with ModelSanitizer
Model{LinearModel{Float64}}(LinearModel{Float64}([0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [-0.532213, -1.16489, -0.414974, -0.562536, -0.440432, 0.732505, -1.06754, 0.399485, -0.67281, -1.44599, 0.835625, 0.426459, 1.20088, 0.754435]))

julia> @test m.X != X[training_rows, :]
Test Passed

julia> @test m.y != y[training_rows]
Test Passed

julia> @test !all(m.X .== X[training_rows, :])
Test Passed

julia> @test !all(m.y .== y[training_rows])
Test Passed

julia> @test all(m.X .== 0)
Test Passed

julia> @test all(m.y .== 0)
Test Passed

julia> # after sanitization, we are still able to make predictions
       predict(m, X[testing_rows, :])
2500-element Array{Float64,1}:
 -4.513253714187381
  2.5689035333536605
  0.9939782906365846
  1.2513894159362184
  3.2007086601687353
 -5.387968774216589
 -0.1767892797746935
  3.4408813711668165
  0.4625821018811823
  1.649129884116436
 -0.8620887900500149
  0.6504970487658756
  4.287913533796443
 -2.5014166099065136
  1.1666979326633855
  0.2723098985354143
  3.2783930370766634
  2.250636815003683
  ⋮
  1.1999638265752477
  3.8377489399901084
  4.2805489451765935
 -0.5849048693472063
 -0.6574890049656816
  0.2606368302418087
 -4.197310605534758
 -3.5805273324146336
 -0.5244747588662737
  5.274904154193373
  2.7742388165636953
  5.883741172337488
  2.118699747786167
 -4.209943069147431
  2.262361580682631
 -0.5044151513387216
  4.443422779093501

julia> predict(m, X[training_rows, :])
2500-element Array{Float64,1}:
  2.943212508610099
 -0.8226863248850258
  1.031068845178503
 -3.3178919274576053
  0.587046578244962
 -0.032251634503744686
  1.9123819046207888
  3.555603804394087
  2.1728937544760307
 -1.9319447549669504
 -0.7592148524301295
 -7.250437603426189
  4.982277986708986
 -1.8660967909674548
  0.29423182806971415
  0.593840341165224
 -0.26314562641917977
  1.4340414682799685
  ⋮
  1.6038174714835796
  1.3091787016871341
  4.936123830680592
  1.9812183495287048
 -0.848632475032059
  3.1553721781769157
 -5.412240178264108
  1.406559298117795
  3.6433312336276646
  0.3408165307792135
  0.2882242203753349
  1.8120206189755343
 -3.299798877655878
 -0.8793971451160698
  2.3158119962568886
 -2.4598360012327265
 -4.810128269819875

julia> @show mse(m, X[training_rows, :], y[training_rows])
mse(m, X[training_rows, :], y[training_rows]) = 0.9856973993855034
0.9856973993855034

julia> @show rmse(m, X[training_rows, :], y[training_rows])
rmse(m, X[training_rows, :], y[training_rows]) = 0.9928229446308658
0.9928229446308658

julia> @show r2(m, X[training_rows, :], y[training_rows])
r2(m, X[training_rows, :], y[training_rows]) = 0.9044357103305194
0.9044357103305194

julia> @show mse(m, X[testing_rows, :], y[testing_rows])
mse(m, X[testing_rows, :], y[testing_rows]) = 0.9480778102674918
0.9480778102674918

julia> @show rmse(m, X[testing_rows, :], y[testing_rows])
rmse(m, X[testing_rows, :], y[testing_rows]) = 0.9736928726592856
0.9736928726592856

julia> @show r2(m, X[testing_rows, :], y[testing_rows])
r2(m, X[testing_rows, :], y[testing_rows]) = 0.9088387716983182
0.9088387716983182

julia> # if you know exactly where the data are stored inside the model, you can
       # directly delete them with ForceSanitize:
       sanitize!(ForceSanitize(m.X), ForceSanitize(m.y))
(ForceSanitize{Array{Float64,2}}([0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0; … ; 0.0 0.0 … 0.0 0.0; 0.0 0.0 … 0.0 0.0]), ForceSanitize{Array{Float64,1}}([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]))

julia> # we can still make predictions even after using ForceSanitize
       predict(m, X[testing_rows, :])
2500-element Array{Float64,1}:
 -4.513253714187381
  2.5689035333536605
  0.9939782906365846
  1.2513894159362184
  3.2007086601687353
 -5.387968774216589
 -0.1767892797746935
  3.4408813711668165
  0.4625821018811823
  1.649129884116436
 -0.8620887900500149
  0.6504970487658756
  4.287913533796443
 -2.5014166099065136
  1.1666979326633855
  0.2723098985354143
  3.2783930370766634
  2.250636815003683
  ⋮
  1.1999638265752477
  3.8377489399901084
  4.2805489451765935
 -0.5849048693472063
 -0.6574890049656816
  0.2606368302418087
 -4.197310605534758
 -3.5805273324146336
 -0.5244747588662737
  5.274904154193373
  2.7742388165636953
  5.883741172337488
  2.118699747786167
 -4.209943069147431
  2.262361580682631
 -0.5044151513387216
  4.443422779093501

julia> predict(m, X[training_rows, :])
2500-element Array{Float64,1}:
  2.943212508610099
 -0.8226863248850258
  1.031068845178503
 -3.3178919274576053
  0.587046578244962
 -0.032251634503744686
  1.9123819046207888
  3.555603804394087
  2.1728937544760307
 -1.9319447549669504
 -0.7592148524301295
 -7.250437603426189
  4.982277986708986
 -1.8660967909674548
  0.29423182806971415
  0.593840341165224
 -0.26314562641917977
  1.4340414682799685
  ⋮
  1.6038174714835796
  1.3091787016871341
  4.936123830680592
  1.9812183495287048
 -0.848632475032059
  3.1553721781769157
 -5.412240178264108
  1.406559298117795
  3.6433312336276646
  0.3408165307792135
  0.2882242203753349
  1.8120206189755343
 -3.299798877655878
 -0.8793971451160698
  2.3158119962568886
 -2.4598360012327265
 -4.810128269819875

julia> @show mse(m, X[training_rows, :], y[training_rows])
mse(m, X[training_rows, :], y[training_rows]) = 0.9856973993855034
0.9856973993855034

julia> @show rmse(m, X[training_rows, :], y[training_rows])
rmse(m, X[training_rows, :], y[training_rows]) = 0.9928229446308658
0.9928229446308658

julia> @show r2(m, X[training_rows, :], y[training_rows])
r2(m, X[training_rows, :], y[training_rows]) = 0.9044357103305194
0.9044357103305194

julia> @show mse(m, X[testing_rows, :], y[testing_rows])
mse(m, X[testing_rows, :], y[testing_rows]) = 0.9480778102674918
0.9480778102674918

julia> @show rmse(m, X[testing_rows, :], y[testing_rows])
rmse(m, X[testing_rows, :], y[testing_rows]) = 0.9736928726592856
0.9736928726592856

julia> @show r2(m, X[testing_rows, :], y[testing_rows])
r2(m, X[testing_rows, :], y[testing_rows]) = 0.9088387716983182
0.9088387716983182
```

### Example 2

```julia
julia> using DataFrames

julia> using ModelSanitizer

julia> using Statistics

julia> using StatsBase

julia> using StatsModels

julia> using Test

julia> mutable struct DataFrameLinearModel{T}
           formula::F where F <: AbstractTerm
           sch::S where S <: StatsModels.Schema
           X::DataFrame
           y::Vector{T}
           beta::Vector{T}
           function DataFrameLinearModel{T}()::DataFrameLinearModel{T} where T
               m::DataFrameLinearModel{T} = new()
               return m
           end
       end

julia> function fit!(m::DataFrameLinearModel{T}, X::DataFrame, y::Vector{T})::DataFrameLinearModel{T} where T
           m.X = deepcopy(X)
           m.y = deepcopy(y)
           formula = Term(first(names(m.X))) ~ sum(Term.(names(m.X)))
           sch = schema(formula, m.X)
           formula = apply_schema(formula, sch)
           m.formula = formula
           m.sch = sch
           _, Xmatrix = modelcols(m.formula, X)
           m.beta = (Xmatrix'Xmatrix)\(Xmatrix'm.y)
           return m
       end
fit! (generic function with 1 method)

julia> function predict(m::DataFrameLinearModel{T}, X::DataFrame)::Vector{T} where T
           formula = m.formula
           sch = m.sch
           formula = apply_schema(formula, sch)
           _, Xmatrix = modelcols(formula, X)
           y_hat::Vector{T} = Xmatrix * m.beta
           return y_hat
       end
predict (generic function with 1 method)

julia> function predict(m::DataFrameLinearModel{T})::Vector{T} where T
           y_hat::Vector{T} = predict(m, m.X)
           return y_hat
       end
predict (generic function with 2 methods)

julia> function mse(y::Vector{T}, y_hat::Vector{T})::T where T
           _mse::T = mean((y .- y_hat).^2)
           return _mse
       end
mse (generic function with 1 method)

julia> function mse(m::DataFrameLinearModel{T}, X::DataFrame, y::Vector{T})::T where T
           y_hat::Vector{T} = predict(m, X)
           _mse::T = mse(y, y_hat)
           return _mse
       end
mse (generic function with 2 methods)

julia> function mse(m::DataFrameLinearModel{T})::T where T
           X::DataFrame = m.X
           y::Vector{T} = m.y
           _mse::T = mse(m, X, y)
           return _mse
       end
mse (generic function with 3 methods)

julia> rmse(varargs...) = sqrt(mse(varargs...))
rmse (generic function with 1 method)

julia> function r2(y::Vector{T}, y_hat::Vector{T})::T where T
           y_bar::T = mean(y)
           SS_tot::T = sum((y .- y_bar).^2)
           SS_res::T = sum((y .- y_hat).^2)
           _r2::T = 1 - SS_res/SS_tot
           return _r2
       end
r2 (generic function with 1 method)

julia> function r2(m::DataFrameLinearModel{T}, X::DataFrame, y::Vector{T})::T where T
           y_hat::Vector{T} = predict(m, X)
           _r2::T = r2(y, y_hat)
           return _r2
       end
r2 (generic function with 2 methods)

julia> function r2(m::DataFrameLinearModel{T})::T where T
           X::DataFrame = m.X
           y::Vector{T} = m.y
           _r2::T = r2(m, X, y)
           return _r2
       end
r2 (generic function with 3 methods)

julia> X = DataFrame()
0×0 DataFrame


julia> X[:x1] = randn(1_000)
1000-element Array{Float64,1}:
 -0.5818767960311586
  0.705555863147982
  0.5017393864481525
  0.47705383793617456
  1.7934386436100354
  0.9525478168482215
  0.5373518796774817
 -0.23647165445502377
  0.5763997581138901
  1.3150129271588997
 -0.8403991830475339
  0.4629412933263757
  0.855083458924943
  0.5899702490200159
 -0.3634448743953238
 -0.6750652924539244
  0.1795134578045623
 -2.0985501639567103
  ⋮
 -0.7524377631387302
  0.6164717214134044
  1.2337337108221478
 -1.3560556658381988
 -1.7668545732707879
 -1.0451944521149417
 -0.2761540541830101
  0.1890447048022495
  1.5204527507270156
  0.3170561501250305
  0.1124984558686949
 -0.5306800610876763
  2.3091252268804148
 -2.1454971650791648
 -1.788401084138892
  0.6093975820097418
  0.8046898236850084

julia> X[:x2] = randn(1_000)
1000-element Array{Float64,1}:
  0.5210125169305888
  0.1604789123302876
 -1.8774045446318965
  2.2574560663691425
 -0.08953468984266613
 -0.35257311461824126
 -1.0747205466643106
  0.187986528080311
 -1.5245636875796211
  0.4103690630884523
  0.2890179229784967
 -0.8568224614720799
 -1.7999103678650095
 -2.4303699896100976
 -0.0353489816007211
 -0.34228871124952115
 -0.45004030216272095
  0.25974720830792086
  ⋮
  0.6411253878131493
  1.8671214858870193
  0.4665486505646983
 -1.3742415709587072
  0.6179194731438259
  0.4175429051826107
  2.1794755369306418
 -0.0566462670369727
  0.4297792967687606
  2.201182615430426
 -0.8849264712432697
 -0.785864608283383
  1.416234673288603
  0.570827750115626
 -0.4119172040341764
  0.5442356973324847
  0.06314705856309913

julia> X[:x3] = randn(1_000)
1000-element Array{Float64,1}:
 -0.2946406161501418
  0.062317762748493974
  0.7683140650393792
 -0.768828641597393
 -0.2443978388213774
  0.002856159030316715
 -0.2993668817250485
  1.8253038981353276
 -1.4153826612824145
 -0.5198406630145318
 -1.321588289343639
  0.4806535119533075
  0.20771380490353533
 -0.017093515589255388
  1.0469621482002949
 -1.356595221793112
 -0.29958131070996347
  0.041866558755236906
  ⋮
  0.887270995483125
  0.6588192711508932
 -0.9933989100732001
 -0.05815631917850255
  0.4167432652856391
 -1.3435386432917713
  0.961320602899486
 -0.4227829208482669
 -0.08915614377658465
  0.5042988247262304
 -0.4150178624934699
  1.767381588141923
  1.070811291984891
  0.6371694336498673
 -0.35593006413375555
 -0.2122338884363464
 -0.036882920788743785

julia> X[:x4] = sample([1,2,3], pweights([0.005, 0.99, 0.005]), 1_000; replace=true)
1000-element Array{Int64,1}:
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 ⋮
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2

julia> X[:x5] = sample([1,2,3], pweights([0.005, 0.99, 0.005]), 1_000; replace=true)
1000-element Array{Int64,1}:
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 ⋮
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2

julia> X[:x6] = sample([1,2,3], pweights([0.005, 0.99, 0.005]), 1_000; replace=true)
1000-element Array{Int64,1}:
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 ⋮
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2
 2

julia> X[:x7] = sample(["foo", "bar"], pweights([0.3, 0.7]), 1_000; replace=true)
1000-element Array{String,1}:
 "foo"
 "bar"
 "bar"
 "bar"
 "bar"
 "bar"
 "bar"
 "bar"
 "bar"
 "bar"
 "bar"
 "bar"
 "bar"
 "foo"
 "bar"
 "bar"
 "foo"
 "foo"
 ⋮
 "bar"
 "bar"
 "bar"
 "bar"
 "foo"
 "bar"
 "bar"
 "foo"
 "foo"
 "bar"
 "bar"
 "bar"
 "foo"
 "foo"
 "bar"
 "bar"
 "bar"

julia> X[:x8] = sample(["apple", "banana", "carrot"], pweights([0.1, 0.7, 0.2]), 1_000; replace=true)
1000-element Array{String,1}:
 "banana"
 "apple"
 "carrot"
 "banana"
 "banana"
 "banana"
 "banana"
 "banana"
 "carrot"
 "banana"
 "banana"
 "banana"
 "apple"
 "banana"
 "banana"
 "carrot"
 "banana"
 "apple"
 ⋮
 "carrot"
 "banana"
 "carrot"
 "carrot"
 "banana"
 "carrot"
 "banana"
 "banana"
 "carrot"
 "banana"
 "banana"
 "carrot"
 "banana"
 "carrot"
 "carrot"
 "apple"
 "banana"

julia> X[:x9] = sample(["red", "green", "yellow", "blue"], pweights([0.2, 0.3, 0.15, 0.35]), 1_000; replace=true)
1000-element Array{String,1}:
 "red"
 "green"
 "yellow"
 "blue"
 "blue"
 "green"
 "blue"
 "green"
 "blue"
 "yellow"
 "yellow"
 "yellow"
 "blue"
 "yellow"
 "red"
 "blue"
 "blue"
 "blue"
 ⋮
 "blue"
 "red"
 "yellow"
 "blue"
 "blue"
 "green"
 "red"
 "red"
 "blue"
 "green"
 "red"
 "green"
 "green"
 "green"
 "blue"
 "blue"
 "blue"

julia> formula = Term(first(names(X))) ~ sum(Term.(names(X)))
FormulaTerm
Response:
  x1(unknown)
Predictors:
  x1(unknown)
  x2(unknown)
  x3(unknown)
  x4(unknown)
  x5(unknown)
  x6(unknown)
  x7(unknown)
  x8(unknown)
  x9(unknown)

julia> sch = schema(formula, X)
StatsModels.Schema with 9 entries:
  x1 => x1
  x2 => x2
  x3 => x3
  x5 => x5
  x4 => x4
  x7 => x7
  x8 => x8
  x9 => x9
  x6 => x6


julia> formula = apply_schema(formula, sch)
FormulaTerm
Response:
  x1(continuous)
Predictors:
  x1(continuous)
  x2(continuous)
  x3(continuous)
  x4(continuous)
  x5(continuous)
  x6(continuous)
  x7(DummyCoding:2→1)
  x8(DummyCoding:3→2)
  x9(DummyCoding:4→3)

julia> _, Xmatrix = modelcols(formula, X)
([-0.581877, 0.705556, 0.501739, 0.477054, 1.79344, 0.952548, 0.537352, -0.236472, 0.5764, 1.31501  …  0.189045, 1.52045, 0.317056, 0.112498, -0.53068, 2.30913, -2.1455, -1.7884, 0.609398, 0.80469], [-0.581877 0.521013 … 1.0 0.0; 0.705556 0.160479 … 0.0 0.0; … ; 0.609398 0.544236 … 0.0 0.0; 0.80469 0.0631471 … 0.0 0.0])

julia> y = Xmatrix * randn(Float64, 12) + randn(1_000)/2
1000-element Array{Float64,1}:
  3.7545141636489467
 -1.4245432342861886
 -0.7216353042246839
  3.9548296711846893
  2.444386357715284
  0.13741720827198745
  1.169256369128247
 -0.3668451338870879
 -1.8560649715981734
  2.2922068682808296
  2.9687097510173848
  1.785093096362889
 -0.7057208227314551
  1.3788046647431667
  1.816079232736133
  0.16646533186960022
  2.273722892276245
  1.3265212479200137
  ⋮
  0.02630488769573608
  4.23843053212255
  1.1664716652433127
 -1.8327041958455355
  3.207543871561666
 -2.187594028038199
  3.454628220356616
  2.8092182627304645
  1.472064531289221
  1.8190221408375216
  1.8627716421976266
 -3.2163415695684234
  2.153753193132236
 -1.2882551029447917
 -0.5521237124281526
  2.3657302480863738
  3.096065098097796

julia> m = DataFrameLinearModel{Float64}()
DataFrameLinearModel{Float64}(#undef, #undef, #undef, #undef, #undef)

julia> testing_rows = 1:2:1_000
1:2:999

julia> training_rows = setdiff(1:1_000, testing_rows)
500-element Array{Int64,1}:
    2
    4
    6
    8
   10
   12
   14
   16
   18
   20
   22
   24
   26
   28
   30
   32
   34
   36
    ⋮
  968
  970
  972
  974
  976
  978
  980
  982
  984
  986
  988
  990
  992
  994
  996
  998
 1000

julia> fit!(m, X[training_rows, :], y[training_rows])
DataFrameLinearModel{Float64}(x1 ~ x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9, StatsModels.Schema with 9 entries:
  x1 => x1
  x2 => x2
  x3 => x3
  x5 => x5
  x4 => x4
  x7 => x7
  x8 => x8
  x9 => x9
  x6 => x6
, 500×9 DataFrame. Omitted printing of 1 columns
│ Row │ x1         │ x2        │ x3         │ x4    │ x5    │ x6    │ x7     │ x8     │
│     │ Float64    │ Float64   │ Float64    │ Int64 │ Int64 │ Int64 │ String │ String │
├─────┼────────────┼───────────┼────────────┼───────┼───────┼───────┼────────┼────────┤
│ 1   │ 0.705556   │ 0.160479  │ 0.0623178  │ 2     │ 2     │ 2     │ bar    │ apple  │
│ 2   │ 0.477054   │ 2.25746   │ -0.768829  │ 2     │ 2     │ 2     │ bar    │ banana │
│ 3   │ 0.952548   │ -0.352573 │ 0.00285616 │ 2     │ 2     │ 2     │ bar    │ banana │
│ 4   │ -0.236472  │ 0.187987  │ 1.8253     │ 2     │ 2     │ 2     │ bar    │ banana │
│ 5   │ 1.31501    │ 0.410369  │ -0.519841  │ 2     │ 2     │ 2     │ bar    │ banana │
│ 6   │ 0.462941   │ -0.856822 │ 0.480654   │ 2     │ 2     │ 2     │ bar    │ banana │
│ 7   │ 0.58997    │ -2.43037  │ -0.0170935 │ 2     │ 2     │ 2     │ foo    │ banana │
│ 8   │ -0.675065  │ -0.342289 │ -1.3566    │ 2     │ 2     │ 2     │ bar    │ carrot │
│ 9   │ -2.09855   │ 0.259747  │ 0.0418666  │ 2     │ 2     │ 2     │ foo    │ apple  │
│ 10  │ -0.0395247 │ -0.593736 │ 0.630714   │ 2     │ 2     │ 1     │ bar    │ banana │
│ 11  │ 0.473064   │ 0.124434  │ -0.055512  │ 2     │ 2     │ 2     │ foo    │ carrot │
│ 12  │ 0.108456   │ -0.464747 │ 1.65022    │ 2     │ 2     │ 2     │ bar    │ banana │
│ 13  │ 0.0304978  │ -1.23429  │ 0.0170209  │ 2     │ 2     │ 2     │ foo    │ carrot │
│ 14  │ 0.720277   │ 0.530643  │ 1.27218    │ 2     │ 2     │ 2     │ foo    │ banana │
│ 15  │ 1.92828    │ -0.270579 │ -0.061732  │ 2     │ 2     │ 2     │ bar    │ banana │
⋮
│ 485 │ 0.959865   │ -0.910423 │ 1.4849     │ 2     │ 2     │ 2     │ bar    │ apple  │
│ 486 │ 0.504138   │ 0.473006  │ 0.0272198  │ 2     │ 2     │ 2     │ bar    │ carrot │
│ 487 │ 0.551188   │ -0.275658 │ 1.0774     │ 2     │ 2     │ 2     │ bar    │ banana │
│ 488 │ 1.2597     │ 0.533564  │ 0.314357   │ 2     │ 2     │ 2     │ bar    │ banana │
│ 489 │ 0.0199473  │ -1.29973  │ 1.30439    │ 2     │ 2     │ 2     │ bar    │ banana │
│ 490 │ 2.09196    │ 0.494092  │ -0.582569  │ 2     │ 2     │ 2     │ foo    │ banana │
│ 491 │ 0.88194    │ 0.847261  │ -0.241934  │ 2     │ 2     │ 2     │ bar    │ banana │
│ 492 │ -0.752438  │ 0.641125  │ 0.887271   │ 2     │ 2     │ 2     │ bar    │ carrot │
│ 493 │ 1.23373    │ 0.466549  │ -0.993399  │ 2     │ 2     │ 2     │ bar    │ carrot │
│ 494 │ -1.76685   │ 0.617919  │ 0.416743   │ 2     │ 2     │ 2     │ foo    │ banana │
│ 495 │ -0.276154  │ 2.17948   │ 0.961321   │ 2     │ 2     │ 2     │ bar    │ banana │
│ 496 │ 1.52045    │ 0.429779  │ -0.0891561 │ 2     │ 2     │ 2     │ foo    │ carrot │
│ 497 │ 0.112498   │ -0.884926 │ -0.415018  │ 2     │ 2     │ 2     │ bar    │ banana │
│ 498 │ 2.30913    │ 1.41623   │ 1.07081    │ 2     │ 2     │ 2     │ foo    │ banana │
│ 499 │ -1.7884    │ -0.411917 │ -0.35593   │ 2     │ 2     │ 2     │ bar    │ carrot │
│ 500 │ 0.80469    │ 0.0631471 │ -0.0368829 │ 2     │ 2     │ 2     │ bar    │ banana │, [-1.42454, 3.95483, 0.137417, -0.366845, 2.29221, 1.78509, 1.3788, 0.166465, 1.32652, 1.67417  …  0.272215, 0.0263049, 1.16647, 3.20754, 3.45463, 1.47206, 1.86277, 2.15375, -0.552124, 3.09607], [0.260817, 0.853327, 0.124494, 0.656037, -0.405156, 0.231267, 0.768485, 1.04682, -1.1145, -2.69298, 0.177767, 0.225324])

julia> @test m.X == X[training_rows, :]
Test Passed

julia> @test all(convert(Matrix, m.X) .== convert(Matrix, X[training_rows, :]))
Test Passed

julia> for column in names(m.X)
           for i = 1:size(m.X, 2)
               @test m.X[i, column] != 0 && m.X[i, column] != ""
           end
       end

julia> @test m.y == y[training_rows]
Test Passed

julia> @test all(m.y .== y[training_rows])
Test Passed

julia> @test !all(m.y .== 0)
Test Passed

julia> # before sanitization, we can make predictions
       predict(m, X[testing_rows, :])
500-element Array{Float64,1}:
  3.2135144100862076
 -1.3004027281962736
  2.372044232732118
  1.1969062420207879
 -1.4770217571060602
  2.099343519755945
 -0.32273678777220116
  2.1942627541146407
  2.405090699384065
  0.0660890526122806
  2.8339401905500834
  1.6281836338537685
 -0.1524463144680066
  0.22617974275972585
  2.455813644376235
 -1.6674956060860153
  0.8446380197789152
  2.888529212078204
  ⋮
  1.5391901982346619
  3.1628069118251223
  1.8744072017169606
 -0.4109936234369398
  3.4096142076924014
 -1.2008396847863074
  2.5880234624523895
  2.6779465317542472
 -2.2708941251807993
  4.024949708407326
 -1.6837998301652477
 -2.926749455008225
  2.9056995152270346
  1.3419329275241374
 -3.4321654665628567
 -2.0678547749318588
  1.5612258913309716

julia> predict(m, X[training_rows, :])
500-element Array{Float64,1}:
 -1.3999678495235524
  3.96617002586148
 -0.7339343503165021
 -0.35589422288905537
  2.8648770040791267
  1.685868565613832
  1.0827686207586869
 -0.7872400074731705
  1.4123035938918131
  1.3414063559130498
 -1.8520431729733078
 -0.8447226392156921
 -3.117878298112723
  3.7564152393152805
 -0.41752035260541387
  3.0157226873960017
 -0.14689229839591889
 -1.0889920248181073
  ⋮
  0.06102298637283443
 -2.070366790189574
  0.3883053203137967
  2.2315421055508704
  2.8341040232398402
  1.0696087205036906
  3.6743123183831767
  0.24102580574603483
  0.3111004056496869
  0.6713501851598899
  2.897940614671811
  4.096336961151502
  1.3704887616177122
  1.4114227046772203
  2.0306944180434208
 -1.0124567840508658
  2.2702830783890997

julia> @show mse(m, X[training_rows, :], y[training_rows])
mse(m, X[training_rows, :], y[training_rows]) = 0.2415977846558122
0.2415977846558122

julia> @show rmse(m, X[training_rows, :], y[training_rows])
rmse(m, X[training_rows, :], y[training_rows]) = 0.49152597556569905
0.49152597556569905

julia> @show r2(m, X[training_rows, :], y[training_rows])
r2(m, X[training_rows, :], y[training_rows]) = 0.9303330360441512
0.9303330360441512

julia> @show mse(m, X[testing_rows, :], y[testing_rows])
mse(m, X[testing_rows, :], y[testing_rows]) = 0.2628430402481022
0.2628430402481022

julia> @show rmse(m, X[testing_rows, :], y[testing_rows])
rmse(m, X[testing_rows, :], y[testing_rows]) = 0.5126822020005202
0.5126822020005202

julia> @show r2(m, X[testing_rows, :], y[testing_rows])
r2(m, X[testing_rows, :], y[testing_rows]) = 0.9309236698440744
0.9309236698440744

julia> sanitize!(Model(m), Data(X), Data(y)) # sanitize the model with ModelSanitizer
Model{DataFrameLinearModel{Float64}}(DataFrameLinearModel{Float64}(x1 ~ x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9, StatsModels.Schema with 9 entries:
  x1 => x1
  x2 => x2
  x3 => x3
  x5 => x5
  x4 => x4
  x7 => x7
  x8 => x8
  x9 => x9
  x6 => x6
, 500×9 DataFrame
│ Row │ x1      │ x2      │ x3      │ x4    │ x5    │ x6    │ x7     │ x8     │ x9     │
│     │ Float64 │ Float64 │ Float64 │ Int64 │ Int64 │ Int64 │ String │ String │ String │
├─────┼─────────┼─────────┼─────────┼───────┼───────┼───────┼────────┼────────┼────────┤
│ 1   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 2   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 3   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 4   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 5   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 6   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 7   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 8   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 9   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 10  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 11  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 12  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 13  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 14  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 15  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
⋮
│ 485 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 486 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 487 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 488 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 489 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 490 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 491 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 492 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 493 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 494 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 495 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 496 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 497 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 498 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 499 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 500 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.260817, 0.853327, 0.124494, 0.656037, -0.405156, 0.231267, 0.768485, 1.04682, -1.1145, -2.69298, 0.177767, 0.225324]))

julia> @test m.X != X[training_rows, :]
Test Passed

julia> @test !all(convert(Matrix, m.X) .== convert(Matrix, X[training_rows, :]))
Test Passed

julia> for column in names(m.X)
           for i = 1:size(m.X, 2)
               @test m.X[i, column] == 0 || m.X[i, column] == ""
           end
       end

julia> @test m.y != y[training_rows]
Test Passed

julia> @test !all(m.y .== y[training_rows])
Test Passed

julia> @test all(m.y .== 0)
Test Passed

julia> # after sanitization, we are still able to make predictions
       predict(m, X[testing_rows, :])
500-element Array{Float64,1}:
  3.2135144100862076
 -1.3004027281962736
  2.372044232732118
  1.1969062420207879
 -1.4770217571060602
  2.099343519755945
 -0.32273678777220116
  2.1942627541146407
  2.405090699384065
  0.0660890526122806
  2.8339401905500834
  1.6281836338537685
 -0.1524463144680066
  0.22617974275972585
  2.455813644376235
 -1.6674956060860153
  0.8446380197789152
  2.888529212078204
  ⋮
  1.5391901982346619
  3.1628069118251223
  1.8744072017169606
 -0.4109936234369398
  3.4096142076924014
 -1.2008396847863074
  2.5880234624523895
  2.6779465317542472
 -2.2708941251807993
  4.024949708407326
 -1.6837998301652477
 -2.926749455008225
  2.9056995152270346
  1.3419329275241374
 -3.4321654665628567
 -2.0678547749318588
  1.5612258913309716

julia> predict(m, X[training_rows, :])
500-element Array{Float64,1}:
 -1.3999678495235524
  3.96617002586148
 -0.7339343503165021
 -0.35589422288905537
  2.8648770040791267
  1.685868565613832
  1.0827686207586869
 -0.7872400074731705
  1.4123035938918131
  1.3414063559130498
 -1.8520431729733078
 -0.8447226392156921
 -3.117878298112723
  3.7564152393152805
 -0.41752035260541387
  3.0157226873960017
 -0.14689229839591889
 -1.0889920248181073
  ⋮
  0.06102298637283443
 -2.070366790189574
  0.3883053203137967
  2.2315421055508704
  2.8341040232398402
  1.0696087205036906
  3.6743123183831767
  0.24102580574603483
  0.3111004056496869
  0.6713501851598899
  2.897940614671811
  4.096336961151502
  1.3704887616177122
  1.4114227046772203
  2.0306944180434208
 -1.0124567840508658
  2.2702830783890997

julia> @show mse(m, X[training_rows, :], y[training_rows])
mse(m, X[training_rows, :], y[training_rows]) = 0.2415977846558122
0.2415977846558122

julia> @show rmse(m, X[training_rows, :], y[training_rows])
rmse(m, X[training_rows, :], y[training_rows]) = 0.49152597556569905
0.49152597556569905

julia> @show r2(m, X[training_rows, :], y[training_rows])
r2(m, X[training_rows, :], y[training_rows]) = 0.9303330360441512
0.9303330360441512

julia> @show mse(m, X[testing_rows, :], y[testing_rows])
mse(m, X[testing_rows, :], y[testing_rows]) = 0.2628430402481022
0.2628430402481022

julia> @show rmse(m, X[testing_rows, :], y[testing_rows])
rmse(m, X[testing_rows, :], y[testing_rows]) = 0.5126822020005202
0.5126822020005202

julia> @show r2(m, X[testing_rows, :], y[testing_rows])
r2(m, X[testing_rows, :], y[testing_rows]) = 0.9309236698440744
0.9309236698440744

julia> # if you know exactly where the data are stored inside the model, you can
       # directly delete them with ForceSanitize:
       sanitize!(ForceSanitize(m.X), ForceSanitize(m.y))
(ForceSanitize{DataFrame}(500×9 DataFrame
│ Row │ x1      │ x2      │ x3      │ x4    │ x5    │ x6    │ x7     │ x8     │ x9     │
│     │ Float64 │ Float64 │ Float64 │ Int64 │ Int64 │ Int64 │ String │ String │ String │
├─────┼─────────┼─────────┼─────────┼───────┼───────┼───────┼────────┼────────┼────────┤
│ 1   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 2   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 3   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 4   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 5   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 6   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 7   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 8   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 9   │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 10  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 11  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 12  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 13  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 14  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 15  │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
⋮
│ 485 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 486 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 487 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 488 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 489 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 490 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 491 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 492 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 493 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 494 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 495 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 496 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 497 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 498 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 499 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │
│ 500 │ 0.0     │ 0.0     │ 0.0     │ 0     │ 0     │ 0     │        │        │        │), ForceSanitize{Array{Float64,1}}([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]))

julia> # we can still make predictions even after using ForceSanitize
       predict(m, X[testing_rows, :])
500-element Array{Float64,1}:
  3.2135144100862076
 -1.3004027281962736
  2.372044232732118
  1.1969062420207879
 -1.4770217571060602
  2.099343519755945
 -0.32273678777220116
  2.1942627541146407
  2.405090699384065
  0.0660890526122806
  2.8339401905500834
  1.6281836338537685
 -0.1524463144680066
  0.22617974275972585
  2.455813644376235
 -1.6674956060860153
  0.8446380197789152
  2.888529212078204
  ⋮
  1.5391901982346619
  3.1628069118251223
  1.8744072017169606
 -0.4109936234369398
  3.4096142076924014
 -1.2008396847863074
  2.5880234624523895
  2.6779465317542472
 -2.2708941251807993
  4.024949708407326
 -1.6837998301652477
 -2.926749455008225
  2.9056995152270346
  1.3419329275241374
 -3.4321654665628567
 -2.0678547749318588
  1.5612258913309716

julia> predict(m, X[training_rows, :])
500-element Array{Float64,1}:
 -1.3999678495235524
  3.96617002586148
 -0.7339343503165021
 -0.35589422288905537
  2.8648770040791267
  1.685868565613832
  1.0827686207586869
 -0.7872400074731705
  1.4123035938918131
  1.3414063559130498
 -1.8520431729733078
 -0.8447226392156921
 -3.117878298112723
  3.7564152393152805
 -0.41752035260541387
  3.0157226873960017
 -0.14689229839591889
 -1.0889920248181073
  ⋮
  0.06102298637283443
 -2.070366790189574
  0.3883053203137967
  2.2315421055508704
  2.8341040232398402
  1.0696087205036906
  3.6743123183831767
  0.24102580574603483
  0.3111004056496869
  0.6713501851598899
  2.897940614671811
  4.096336961151502
  1.3704887616177122
  1.4114227046772203
  2.0306944180434208
 -1.0124567840508658
  2.2702830783890997

julia> @show mse(m, X[training_rows, :], y[training_rows])
mse(m, X[training_rows, :], y[training_rows]) = 0.2415977846558122
0.2415977846558122

julia> @show rmse(m, X[training_rows, :], y[training_rows])
rmse(m, X[training_rows, :], y[training_rows]) = 0.49152597556569905
0.49152597556569905

julia> @show r2(m, X[training_rows, :], y[training_rows])
r2(m, X[training_rows, :], y[training_rows]) = 0.9303330360441512
0.9303330360441512

julia> @show mse(m, X[testing_rows, :], y[testing_rows])
mse(m, X[testing_rows, :], y[testing_rows]) = 0.2628430402481022
0.2628430402481022

julia> @show rmse(m, X[testing_rows, :], y[testing_rows])
rmse(m, X[testing_rows, :], y[testing_rows]) = 0.5126822020005202
0.5126822020005202

julia> @show r2(m, X[testing_rows, :], y[testing_rows])
r2(m, X[testing_rows, :], y[testing_rows]) = 0.9309236698440744
0.9309236698440744
```
