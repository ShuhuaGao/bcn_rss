# play with a small toy network to validate implementation

using StatsBase
using Random
using JLD2
using Revise
using BCNRSS
using BCNRSS: Wang2022



# load the ASSR and target set
bcn = load("net.jld2", "bcn")
println(bcn.Q)

# RSSD and time-optimal RSS
Z = Set([2, 4, 5, 7])
IcZ = calculate_LRCIS(bcn, Z)
println("IcZ = ", IcZ)
RSSD = calculate_RSSD(bcn, Z)
println("RSSD = ", RSSD)
H, U = calculate_time_optimal_RSS(bcn, Z)
println("The T* of each state: ", H)

# calculate RSSD with wang2022 method
println("\nCalculate RSSD with wang2022...")
@time _, RSSD = Wang2022.calculate_RSSD(bcn, Z; verbose=true)
println("RSSD = ", RSSD)

# optimal RSS
println("\nOptimal robust set stabilization...")
Z = Set([2, 4, 5, 7])
g(x, u) = x in IcZ ? 0.0 : x + u
@time H, U = calculate_optimal_RSS(bcn, Z, g)
@show IcZ H U
;