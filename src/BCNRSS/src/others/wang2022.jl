# methods from the paper: 10.1016/j.amc.2022.126992

module Wang2022
    using BCNRSS: LogicalVector, LogicalMatrix, BCN, index, evolve

    # Eq. (3.7). We treat a BCN as a special PBCN.
    function calculate_transition_probability_matrix(bcn::BCN, S::Set{<:Integer})
        (; M, N, Q, L) = bcn
        # from algorithms therein, we see that, only i, j ∈ S are used; no need to calculate i, j \in 1:N. 
        # Hence, instead of array indices, we use a dict to save memory
        # otherwise, a N × N array takes much memory once N = 2^n becomes large
        P = Matrix{Dict}(undef, Q, M)

        for k in 1:Q, l in 1:M
            d = Dict()
            # j -> i?
            for i in S, j in S
                i′ = evolve(bcn, j, l, k)
                d[(i, j)] = Int(i′ == i)
            end
            P[k, l] = d
        end

        return P
    end

    # Eq. (3.7). We treat a BCN as a special PBCN.
    # Take care! A bit array of size 2^(q+m+2n) will be built, which may take huge memory.
    function calculate_transition_probability_matrix(bcn::BCN)
        (; M, N, Q, L) = bcn
        # since this is a BCN, the possible value of P is either 0 or 1
        # use a bit array here to save memory space
        P = BitArray{4}(undef, Q, M, N, N)

        # println("compute P")
        for k in 1:Q, l in 1:M
            # j -> i?
            for i in 1:N, j in 1:N
                i′ = evolve(bcn, j, l, k)
                P[k, l, i, j] = i′ == i
            end
        end

        return P
    end


    # Algorithm 3.7 therein
    function calculate_LRCIS(bcn::BCN, Z::Set{<:Integer})::Set
        S = copy(Z)
        # compute P annoted by i, j, k, l
        (; M, N, Q, L) = bcn
        
        P = calculate_transition_probability_matrix(bcn, Z)
        # counter = 0
        while true
            # build truth table 
            T = Vector{Dict}(undef, M)
            for l in 1:M
                d = Dict()
                for j in S
                    v = 0
                    for i in S, k = 1:Q
                        v += P[k, l][(i, j)]
                    end
                    d[j] = Int(v == Q)
                end
                T[l] = d
            end

            # Compute the next S
            S′ = Set{Int64}()
            for j in S
                flag = all(d->d[j] == 0, T)
                if !flag
                    push!(S′, j)
                end
            end

            if isempty(S′) || issetequal(S, S′)
                return S′
            end
            S = S′
        end
    end

    # Algorithm 4.8
    # return H and RSSD, where H is the maximum transient period among RSSD
    function calculate_RSSD(bcn::BCN, S::Set{<:Integer}; verbose::Bool=false)
        (; M, N, Q, L) = bcn
        # in this problem, we need to examine i, j from 1 to 2^n, which differs from LRCIS calculation
        P = calculate_transition_probability_matrix(bcn)
        IcS = calculate_LRCIS(bcn, S)
        if isempty(IcS)
            return -1, IcS
        end
        ΔN = Set{eltype(S)}(1:N)
        t = 0
        W = IcS  # W_{t-1}
        T = BitMatrix(undef, M, N)
        verbose && println("|R≤0| = $(length(IcS))")
        Rt = empty(S)
        while true
            W′ = setdiff(ΔN, W)  # Wt
            if isempty(W′)
                break
            end
            # build the truth table
            for l = 1:M
                for j in W′
                    v = sum(P[k, l, i, j] for k = 1:Q for i in W)
                    T[l, j] = v == Q
                end
            end
            # compute Rt
            empty!(Rt)
            for j in W′
                if sum(T[l, j] for l = 1:M) != 0
                    push!(Rt, j)
                end
            end
            if isempty(Rt)
                break
            end
            t += 1
            verbose && println("|R≤$t| = $(length(Rt))")
            union!(W, Rt)
            if length(W) == N
                break
            end
        end
        return t, W
    end

end