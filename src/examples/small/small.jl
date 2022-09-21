using StatsBase
using BCNRSS
using JLD2
using BCNRSS: Wang2022
using Random


# load the ASSR and target set
bcn = load("net.jld2", "bcn")
println(bcn.Q)

println("\nExample 1...")
Z = Set(1:3)
for x = 1:3
    println("Urb[$x] = ", calculate_Urb(bcn, x, Z))
end


# RSSD and time-optimal RSS
println("\nExample 2...")
Z = Set([2, 4, 5, 7])
IcZ = calculate_LRCIS(bcn, Z)
println("IcZ = ", IcZ)
H, RSSD, U = calculate_RSSD(bcn, Z; verbose=true)
@show H RSSD U[6]

# calculate RSSD with wang2022 method
println("\nCalculate RSSD with wang2022...")
@time H, RSSD = Wang2022.calculate_RSSD(bcn, Z; verbose=true)
println("H = $(H), RSSD = ", RSSD)

# optimal RSS
println("\nExample 3...")
Z = Set([2, 4, 5, 7])
g(x, u) = x + u
@time C, U = calculate_optimal_RSS(bcn, Z, g)
@show C U
;