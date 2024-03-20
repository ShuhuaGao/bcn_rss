# optimal robust set stabilization 
# return final arrays H and U in Algorithm 2
# H::Vector{Float64}, U::Vector{Vector{Int}}
function calculate_optimal_RSS(bcn::BCN, Z::Set{<:Integer}, g::Function; IcZ=nothing)
    if IcZ === nothing
        IcZ = calculate_LRCIS(bcn, Z)  # the LRCIS
    end
    (; M, N, Q) = bcn

    # initialize H
    H = fill(Inf, N)
    for x in IcZ
        H[x] = 0
    end
    d = 0
    S = Vector{eltype(Z)}()
    H_new = zeros(N)
    # no need to update H for states in IcZ because it is always 0
    𝕏 = [x for x = 1:N if x ∉ IcZ]

    # repeat
    changed = true
    values = zeros(M)  
    while changed
        changed = false 
        for x in 𝕏
            for u in 1:M
                calculate_S!(S, bcn, x, u)
                values[u] = g(x, u) + maximum(H[x′] for x′ in S)
            end
            H_new[x] = minimum(values)
            if !isapprox(H[x], H_new[x])  # actual update happened 
                changed = true
            end
        end
        H, H_new = H_new, H
        d += 1
    end
    println("Number of iterations in RDP: $d")
    
    # fetch the optimal control inputs
    U = Vector{Vector{Int}}(undef, N) # each state may have more than one feasible input
    for x in 1:N
        for u in 1:M
            calculate_S!(S, bcn, x, u)
            values[u] = g(x, u) + maximum(H[x′] for x′ in S)
        end
        min_val = minimum(values)
        U[x] = filter(u -> values[u] == min_val, 1:M)
    end
    return H, U
end


# compute the robust set stabilization domain, i.e., a set of initial states, from any of which 
# the BCN can be set stabilized robustly 
function calculate_RSSD(bcn::BCN, Z::Set{<:Integer})
    # any finite g is enough; we take the time-optimal one
    H, U = calculate_time_optimal_RSS(bcn, Z)
    return filter(x -> isfinite(H[x]), 1:bcn.N)
end


# time-optimal robust set stabilization (RSS)
function calculate_time_optimal_RSS(bcn::BCN, Z::Set{<:Integer})
    IcZ = calculate_LRCIS(bcn, Z)  # the LRCIS
    g(x, u) = x in IcZ ? 0.0 : 1.0
    H, U = calculate_optimal_RSS(bcn, Z, g; IcZ)
    return H, U
end