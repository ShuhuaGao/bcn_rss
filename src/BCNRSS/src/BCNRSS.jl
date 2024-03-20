module BCNRSS

using Base.Iterators: product, repeated
using JLD2

include("logical.jl")
const LM = LogicalMatrix
const LV = LogicalVector

include("boolean_network.jl")
include("LRCIS.jl")
include("optimal_rss.jl")
include("others/wang2022.jl")

export calculate_Urb, calculate_S, calculate_LRCIS, calculate_RSSD, calculate_optimal_RSS,
    calculate_ASSR, calculate_time_optimal_RSS, BCN

end # module
