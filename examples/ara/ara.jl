using StatsBase
using BCNRSS
using BCNRSS: Wang2022
using JLD2
using Random
using BenchmarkTools


# load the ASSR and target set
bcn = load("net.jld2", "bcn")
Z = load("Z.jld2", "Z")

# calculate LRCIS
println("\nCalculate LRCIS...")
@time IcZ = calculate_LRCIS(bcn, Z)
println("Finished. |IcZ| = ", length(IcZ))

# calculate LRCIS with wang2022 method
println("Calculate LRCIS with wang2022...")
@time IcZ = Wang2022.calculate_LRCIS(bcn, Z)
println("|IcZ| = ", length(IcZ))

# time-optimal robust set stabilization
println("\nCalculate RSSD...")
@time H, RSSD, U = calculate_RSSD(bcn, Z; verbose=true)
println("Finished. H = $(H), |RSSD| = $(length(RSSD))")

# calculate RSSD with wang2022 method
println("\nCalculate RSSD with wang2022...")
@time H, RSSD = Wang2022.calculate_RSSD(bcn, Z; verbose=true)
println("H = $(H), |RSSD| = $(length(RSSD))")


# optimal robust set stabilization
println("\nCalculate optimal RSS...")
g(x, u) = 1
@time C, U = calculate_optimal_RSS(bcn, Z, g)
println("H = ", maximum(filter(isfinite, C))) # should equal to H 
# try a different cost function
println("\tTry a different g...")
g(x, u) = 0.01 * x + u
@time C, U = calculate_optimal_RSS(bcn, Z, g)
;

# since the runtime is relatively short here, we use `BenchmarkTools` for more accurate measurement.
println("\nRun benchmark tools to measure time...")
bcn = load("net.jld2", "bcn")
Z = load("Z.jld2", "Z")
# @btime BCNRSS.is_RCIS(bcn, Z)
@btime calculate_Urb_for_RCIS(bcn, Z)  # though Z is not a RCIS; simply for time measurement.
@btime calculate_LRCIS(bcn, Z)
@btime Wang2022.calculate_LRCIS(bcn, Z)
@btime calculate_RSSD(bcn, Z; verbose=false)
@btime Wang2022.calculate_RSSD(bcn, Z; verbose=false)
g(x, u) = 1
@btime calculate_optimal_RSS(bcn, Z, g)
# test a different g for general optimal RSS
g(x, u) = 0.01 * x + u
@btime calculate_optimal_RSS(bcn, Z, g)
;

