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

ModelSanitizer exports the `sanitize!` function and the `Model` and `Data`
structs. If your model is stored in `m` and your data are stored in `x1`,
`x2`, `x3`, etc. then you can sanitize your model with:
```julia
sanitize!(Model(m), Data(x1), Data(x2), Data(x3), ...)
```

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
```

### Example 2

```julia
```
