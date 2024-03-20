using StatsBase
using JLD2
using Random
using Revise
using BCNRSS
using BCNRSS: Wang2022

# Random.seed!(123)

# load the ASSR and target set
bcn = load("ara_operon_net.jld2", "bcn")
Z = load("Z.jld2", "Z")

# calculate LRCIS
println("\nCalculate LRCIS...")
@time IcZ = calculate_LRCIS(bcn, Z)
println("Finished. |IcZ| = ", length(IcZ), " and |Z| = ", length(Z))


# time-optimal robust set stabilization
println("\nCalculate time-optimal robust set stabilization...")
# g(x, u) = x in IcZ ? 0.0 : 1.0
@time H, U = calculate_time_optimal_RSS(bcn, Z)
println("How many initial states are stabilizable? ", count(isfinite, H))
# we check arbitrarily three states 
println("T* for an arbitrary state in IcZ: ", H[rand(IcZ)])
println("T* for state 1: ", H[1])
println("T* for state 123: ", H[123])
Tmax = maximum(h for h in H if isfinite(h))
println("The largest T* except infinity: ", Tmax)
println("Which state has the largest T*? ", findfirst(isequal(Tmax), H))

# visualize 
include("visualize.jl")
visualize_rss(bcn, Z, 385, U)

