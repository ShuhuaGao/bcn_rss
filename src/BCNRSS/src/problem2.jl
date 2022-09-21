# calculation and algorithms related to Problem 1

# get the LRCIS
function calculate_LRCIS(bcn::BCN, Z::Set{<:Integer})::Set
    Φ = copy(Z)
    reduced = true
    while reduced
        reduced = false
        for x in Φ
            if !is_RP(bcn, x, Φ)
                delete!(Φ, x)
                reduced = true
            end
        end
    end
    return Φ
end


# return H, RSSD, and U
function calculate_RSSD(bcn::BCN, Z::Set{<:Integer}; verbose::Bool=false, IcZ=nothing)
    if isnothing(IcZ) # not provided 
        IcZ = calculate_LRCIS(bcn, Z)
    end
    TInt = eltype(Z)
    ΔΓ = Set{TInt}()
    ΔN = Set{TInt}(1:bcn.N)
    U = Dict{TInt,Vector{TInt}}()
    if isempty(IcZ)
        return -1, IcZ, U
    end

    t = 0
    Γ = copy(IcZ)
    updated = true
    verbose && println("|R≤0| = $(length(IcZ))")
    while updated
        updated = false
        empty!(ΔΓ)
        for x in setdiff(ΔN, Γ)
            Urb = calculate_Urb(bcn, x, Γ)
            if !isempty(Urb) # x is a RP of Γ
                push!(ΔΓ, x)
                U[x] = Urb
                updated = true
            end
        end
        union!(Γ, ΔΓ)
        t += 1
        if !isempty(ΔΓ)
            verbose && println("|R≤$t| = $(length(ΔΓ))")
        end
    end
    return t - 1, Γ, U
end