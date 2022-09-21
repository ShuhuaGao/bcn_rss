# calculation and algorithms related to Problem 3

# optimal robust set stabilization 
# return final arrays C and U in Algorithm 3
function calculate_optimal_RSS(bcn::BCN, Z::Set{<:Integer}, g::Function)
    IcZ = calculate_LRCIS(bcn, Z)
    H, Ωz, _ = calculate_RSSD(bcn, Z; IcZ)
    (; M, N, Q) = bcn
    C = fill(Inf, N)
    U = Dict{eltype(Z),Vector{eltype(Z)}}()
    if isempty(Ωz) # not stabilizable 
        return C, U
    end
    # init C
    for x in IcZ
        C[x] = 0.0
    end
    # dynamic programming
    C′ = copy(C)  # C_{k+1}
    S = setdiff(Ωz, IcZ)
    Ds = Vector{eltype(Z)}()
    for k = 0:N-2
        for x in S
            min_val = Inf
            for u = 1:M
                calculate_Ds!(Ds, bcn, x, u)
                val = g(x, u) + maximum(C[x′] for x′ in Ds)
                min_val = min(min_val, val)
            end
            C′[x] = min_val
        end
        C, C′ = C′, C
    end
    # last loop to build U
    min_u = eltype(Z)[]  # possibly multiple minimizers
    for x in S
        min_val = Inf
        empty!(min_u)
        for u = 1:M
            calculate_Ds!(Ds, bcn, x, u)
            val = g(x, u) + maximum(C[x′] for x′ in Ds)
            if val < min_val # a better minimizer found
                min_val = val
                empty!(min_u)
                push!(min_u, u)
            elseif val == min_val # an equivalent minimizer found
                push!(min_u, u)
            end
        end
        C′[x] = min_val
        U[x] = copy(min_u)
    end
    return C′, U
end