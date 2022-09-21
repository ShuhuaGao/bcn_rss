# calculation and algorithms related to Problem 1

# δNk, δMj, δQ
function calculate_Ds(L::AbstractVector{<:Integer}, k::Integer, N::Integer, j::Integer, M::Integer, Q::Integer)
    @assert length(L) == M * N * Q
    res = Set{Int64}()
    idx = L
    for i = 1:Q
        blk_i = @view idx[(i-1)*M*N+1:i*M*N]
        blk_j = @view blk_i[(j-1)*N+1:j*N]
        col_k = blk_j[k]  # an integer
        push!(res, col_k)
    end
    return res
end

function calculate_Ds(L::AbstractVector{<:Integer}, x::LV, u::LV, Q::Integer)
    j = index(u)
    k = index(x)
    M = length(u)
    N = length(x)
    return calculate_Ds(L, k, N, j, M, Q)
end

function calculate_Ds(bcn::BCN, x::Integer, u::Integer)::Vector
    res = Vector{typeof(x)}()
    sizehint!(res, bcn.Q)
    calculate_Ds!(res, bcn, x, u)
    return res
end

function calculate_Ds!(Ds::AbstractVector{T}, bcn::BCN, x::T, u::T) where {T<:Integer}
    Q = bcn.Q
    empty!(Ds)
    for ξ = 1:Q
        x′ = evolve(bcn, x, u, ξ)
        push!(Ds, x′)
    end
    return Ds
end


function is_RP(bcn::BCN, x::Integer, S::Set{<:Integer})
    for u = 1:bcn.M
        ds = calculate_Ds(bcn.L, x, bcn.N, u, bcn.M, bcn.Q)
        if issubset(ds, S)
            return true
        end
    end
    # no u is feasible here
    return false
end

function calculate_Urb(bcn::BCN, x::Integer, S::Set{<:Integer})::Vector
    Urb = typeof(x)[]
    calculate_Urb!(Urb, bcn, x, S)
    return Urb
end

function calculate_Urb!(Urb::AbstractVector{<:Integer}, bcn::BCN, x::Integer, S::Set{<:Integer})
    empty!(Urb)
    Ds = Vector{eltype(S)}()
    (; M, N, Q, L) = bcn
    @assert 1 <= x <= N
    for u = 1:M
        calculate_Ds!(Ds, bcn, x, u)
        if issubset(Ds, S)
            push!(Urb, u)
        end
    end
    return Urb
end

function is_RCIS(bcn::BCN, Z::Set{<:Integer})
    for x in Z
        if !is_RP(bcn, x, Z)
            return false
        end
    end
    return true
end


function calculate_Urb_for_RCIS(bcn::BCN, Z::Set{<:Integer})
    Urb = Dict()
    Urb_x = eltype(Z)[]
    for x in Z
        calculate_Urb!(Urb_x, bcn, x, Z)
        Urb[x] = copy(Urb_x)
    end
    return Urb
end