### This example shows how to calculate the robust set stabilization (RSS) of the Ara operon network
### using the generic method. 


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


# robust set stabilization: treat states 109 and 281 as more expensive states
function g(x, u)
    if x in IcZ
        return 0.0
    elseif x == 109
        return 1000.0
    # elseif x == 26
    #     return 1000.0
    elseif x == 23 && u == 2
        return 1000.0
    else 
        return 1.0
    end
end
println("\nCalculate robust set stabilization with stage cost function g...")
# g(x, u) = x in IcZ ? 0.0 : 1.0
@time H, U = calculate_optimal_RSS(bcn, Z, g; IcZ)
println("How many initial states are stabilizable? ", count(isfinite, H))
# we check arbitrarily three states 
println("G* for an arbitrary state in IcZ: ", H[rand(IcZ)])
println("G* for state 1: ", H[1])
println("G* for state 123: ", H[123])
Tmax = maximum(h for h in H if isfinite(h))
println("The largest G* except infinity: ", Tmax)
println("Which state has the largest G*? ", findfirst(isequal(Tmax), H))

# visualize 
include("visualize.jl")
visualize_rss(bcn, Z, 385, U)
println("G* for state 385: ", H[385])

