# Example 3 in (Fornasini-Valcher 2014) 
# "E. Fornasini and M. E. Valcher, Optimal Control of Boolean Control Networks, IEEE Transactions on Automatic Control, 59 (2014), pp. 1258–1270."

using Revise
include("bcn.jl")

# # construct the ASSR of the BCN
# N = 4
# M = 2
# Q = 1  # no disturbance
# L = [2, 3, 2, 4, 1, 4, 2, 1]  # store \delta_N^i as an integer i 


# Implement the algorithm in Lemma 1 of Fornasini-Valcher 2014
# According to the analysis of Example 3, the value of \Delta is at least 1 / epsilon + 1

# we test different values of T here to see how the algorithm behaves
Ts = 1000:1000:21000
for T in Ts
    m = zeros(N, T+1)  # julia start its indexing from 1, the t-th column is m(t)
    for t in T:-1:1
        for j in 1:N
            min_mj = Inf
            for i in 1:M
                ci = view(c, (i-1)*N+1:i*N)  # cost vector for each control
                Li = view(L, (i-1)*N+1:i*N)
                mL = [m[k, t+1] for k in Li]  # m(t+1)ᵀLᵢ
                min_mj = min(min_mj, ci[j] + mL[j])
            end
            m[j, t] = min_mj
        end
    end
    # print the last two values of m to see whether it converges
    println("- T = $T:, [m(0), m(1)] = ")
    display(m[:, 1:2])   # julia start its indexing from 1
    println("")
end

