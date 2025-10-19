# Example 3 in "E. Fornasini and M. E. Valcher, Optimal Control of Boolean Control Networks, IEEE Transactions on Automatic Control, 59 (2014), pp. 1258–1270."

using Revise

# construct the ASSR of the BCN
N = 4
M = 2
Q = 1  # no disturbance
L = [2, 3, 2, 4, 1, 4, 2, 1]


# cost vector 
ϵ = 1e-4
c = [1, ϵ, ϵ, 0, 1, 1, 1, 2]  # cost vector
