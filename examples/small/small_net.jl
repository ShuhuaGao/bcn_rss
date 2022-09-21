# build the ASSR for the small toy network in our examples 

# build the ASSR for TLGL network, which contains 16 states, 4 controls, and 3 disturbances
# source: 10.1371/journal.pcbi.1002267

using BCNRSS

f1(x, u, ξ) = x[2] | x[3]
f2(x, u, ξ) = x[1] & u[1]
f3(x, u, ξ) = u[1] | (ξ[1] & x[1])
f = [f1, f2, f3]


calculate_ASSR(f, 1, 1; to_file="net.jld2");