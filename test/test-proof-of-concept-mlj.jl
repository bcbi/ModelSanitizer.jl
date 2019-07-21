import MLJ
import MLJBase
import MLJModels
import MultivariateStats
import PredictMDSanitizer
import Test

MLJ.@load RidgeRegressor

mutable struct WrappedRidge <: MLJBase.DeterministicNetwork
    ridge_model
end

WrappedRidge(; ridge_model=RidgeRegressor) = WrappedRidge(ridge_model)

function MLJ.fit(model::WrappedRidge, X, y)
    Xs = MLJ.source(X)
    ys = MLJ.source(y)

    stand_model = MLJ.Standardizer()
    stand = MLJ.machine(stand_model, Xs)
    W = MLJ.transform(stand, Xs)

    box_model = MLJ.UnivariateBoxCoxTransformer()
    box = MLJ.machine(box_model, ys)
    z = MLJ.transform(box, ys)

    ridge_model = model.ridge_model
    ridge = MLJ.machine(ridge_model, W, z)
    zhat = MLJ.predict(ridge, W)

    yhat = MLJ.inverse_transform(box, zhat)
    MLJ.fit!(yhat, verbosity=0)

    return yhat
end

boston_task = MLJBase.load_boston()

wrapped_model = WrappedRidge(ridge_model=RidgeRegressor(lambda=0.1))

mach = MLJ.machine(wrapped_model, boston_task)

MLJ.fit!(mach; rows = :)

Test.@test mach.fitresult.sources[1].data[1:10, :Crim] ≈ [0.00632, 0.02731, 0.02729, 0.03237, 0.06905, 0.02985,  0.08829, 0.14455, 0.21124, 0.17004]

Test.@test size(mach.fitresult.sources[1].data) == (506, 12)

PredictMDSanitizer.sanitize!(mach.fitresult)

Test.@test size(mach.fitresult.sources[1].data) == (0, 0)
