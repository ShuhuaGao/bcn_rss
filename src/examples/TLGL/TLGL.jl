using StatsBase
using BCNRSS
using BCNRSS: Wang2022
using JLD2
using Random

# Random.seed!(123)

# load the ASSR and target set
bcn = load("net.jld2", "bcn")
Z = load("Z.jld2", "Z")

# calculate LRCIS
# Z = Set(sample(1:bcn.N, 500; replace=false))
println("\nCalculate LRCIS...")
@time IcZ = calculate_LRCIS(bcn, Z)
println("Finished. |IcZ| = ", length(IcZ), " and |Z| = ", length(Z))

# time-optimal robust set stabilization
println("\nCalculate RSSD...")
@time H, RSSD, U = calculate_RSSD(bcn, Z; verbose=true)
println("Finished. H = $(H), |RSSD| = $(length(RSSD))")

# optimal robust set stabilization
println("\nCalculate optimal RSS...")
g(x, u) = 1
@time C, U = calculate_optimal_RSS(bcn, Z, g)
println(Set(C))
println("Finished. H = $(maximum(filter(isfinite, C))) by g = 1")
println("\tTry another g...")
g(x, u) = 0.01 * x + u
@time C, U = calculate_optimal_RSS(bcn, Z, g)


#NOTE: the following code may be very slow
# calculate LRCIS with wang2022 method
println("\nCalculate LRCIS with wang2022...")
@time IcZ = Wang2022.calculate_LRCIS(bcn, Z)
println("|IcZ| = ", length(IcZ))


# calculate RSSD with wang2022 method; this method requires a large memory
println("\nCalculate RSSD with wang2022...")
# @time H, RSSD = Wang2022.calculate_RSSD(bcn, Z; verbose=true)
println("H = $(H), |RSSD| = $(length(RSSD))")


