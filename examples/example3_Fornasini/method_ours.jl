# Solve Example 3 in (Fornasini-Valcher 2014) with our method 
# "E. Fornasini and M. E. Valcher, Optimal Control of Boolean Control Networks, IEEE Transactions on Automatic Control, 59 (2014), pp. 1258–1270."

include("bcn.jl")
using BCNRSS

bcn = BCN(M, N, Q, L)

Z = Set([4])  # target set， equivalent to stabilization to state 4 in Example 3
IcZ = calculate_LRCIS(bcn, Z)


# cost function
# turn the cost vector in (Fornasini-Valcher 2014) into a stage cost function
function g(x, u)
    cu = view(c, (u-1)*N+1:u*N)
    return cu[x]
end

H, U = calculate_optimal_RSS(bcn, Z, g; IcZ)
println("Optimal objective value from each initial state : ")
display(H)
