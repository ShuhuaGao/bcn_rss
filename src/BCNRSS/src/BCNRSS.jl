module BCNRSS

using Base.Iterators: product, repeated
using JLD2

include("logical.jl")
const LM = LogicalMatrix
const LV = LogicalVector

include("boolean_network.jl")
include("problem1.jl")
include("problem2.jl")
include("problem3.jl")
include("others/wang2022.jl")

export calculate_Urb, calculate_Ds, calculate_LRCIS, calculate_RSSD, calculate_optimal_RSS,
    calculate_ASSR, calculate_Urb_for_RCIS

end # module
