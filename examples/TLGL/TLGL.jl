using StatsBase
using JLD2
using Random
using Revise
using BCNRSS
using BCNRSS: Wang2022

# Random.seed!(123)

# load the ASSR and target set
bcn = load("net.jld2", "bcn")
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
println("T* for state 1234: ", H[1234])
println("The largest T* except infinity: ", maximum(h for h in H if isfinite(h)))

#NOTE: the following code may be very slow
# calculate LRCIS with wang2022 method
println("\nCalculate LRCIS with wang2022...")
@time IcZ = Wang2022.calculate_LRCIS(bcn, Z)
println("|IcZ| = ", length(IcZ))


# calculate RSSD with wang2022 method; this method requires a large memory
println("\nCalculate RSSD with wang2022...")
@warn("It requires large memory (at least 32 GB) and excessively long runtime!")
@time H, RSSD = Wang2022.calculate_RSSD(bcn, Z; verbose=true)
println("H = $(H), |RSSD| = $(length(RSSD))")


