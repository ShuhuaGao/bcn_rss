using Printf

const Rat = Rational{BigInt}
const N_STATES = 4
const N_INPUTS = 2
const TARGET_STATE = 4
const L_FEASIBLE = [2, 3, 2, 4, 1, 4, 2, 1]
const L_INFEASIBLE = [2, 3, 2, 4, 1, 3, 2, 1]
const EPSILONS = Rat[1 // 10, 1 // 100, 1 // 1000, 1 // 10000]

cost_vector(epsilon::Rat) = Rat[1, epsilon, epsilon, 0, 1, 1, 1, 2]

successor(L::Vector{Int}, x::Int, u::Int) = L[(u - 1) * N_STATES + x]

function minimum_extended(values::Vector{Union{Nothing,Rat}})
    finite_values = Rat[value for value in values if !isnothing(value)]
    return isempty(finite_values) ? nothing : minimum(finite_values)
end

function rdp_fixed_point(L::Vector{Int}, c::Vector{Rat}; max_updates::Int=N_STATES)
    values = Union{Nothing,Rat}[nothing, nothing, nothing, Rat(0)]
    for update in 1:max_updates
        next_values = copy(values)
        for x in 1:N_STATES
            if x == TARGET_STATE
                next_values[x] = Rat(0)
                continue
            end
            candidates = Union{Nothing,Rat}[]
            for u in 1:N_INPUTS
                next_value = values[successor(L, x, u)]
                push!(candidates, isnothing(next_value) ? nothing : c[(u - 1) * N_STATES + x] + next_value)
            end
            next_values[x] = minimum_extended(candidates)
        end
        if next_values == values
            return (converged=true, updates=update, values=next_values)
        end
        values = next_values
    end
    return (converged=false, updates=max_updates, values=values)
end

function fornasini_valcher_fixed_point(L::Vector{Int}, c::Vector{Rat}; max_updates::Int=100_000)
    values = fill(Rat(0), N_STATES)
    for update in 1:max_updates
        next_values = similar(values)
        for x in 1:N_STATES
            next_values[x] = minimum(
                c[(u - 1) * N_STATES + x] + values[successor(L, x, u)]
                for u in 1:N_INPUTS
            )
        end
        if next_values == values
            return (converged=true, updates=update, values=next_values)
        end
        values = next_values
    end
    return (converged=false, updates=max_updates, values=values)
end

function decimal_string(value::Rat)
    return @sprintf("%.10g", Float64(value))
end

function extended_vector_string(values)
    entries = [isnothing(value) ? "Inf" : decimal_string(value) for value in values]
    return "[" * join(entries, ", ") * "]"
end

output_path = joinpath(@__DIR__, "comparison_results.csv")
open(output_path, "w") do io
    println(io, "epsilon,rdp_updates,fv_updates,g1,g2,g3,g4")
    for epsilon in EPSILONS
        c = cost_vector(epsilon)
        rdp = rdp_fixed_point(L_FEASIBLE, c)
        fv = fornasini_valcher_fixed_point(L_FEASIBLE, c)
        expected_fv_updates = cld(denominator(epsilon), numerator(epsilon)) + 2
        @assert rdp.converged && rdp.updates == 3
        @assert fv.converged && fv.updates == expected_fv_updates
        @assert rdp.values == fv.values
        finite_values = Rat[value for value in rdp.values]
        println(
            io,
            join(
                [
                    @sprintf("%.0e", Float64(epsilon)),
                    string(rdp.updates),
                    string(fv.updates),
                    decimal_string(finite_values[1]),
                    decimal_string(finite_values[2]),
                    decimal_string(finite_values[3]),
                    decimal_string(finite_values[4]),
                ],
                ",",
            ),
        )
        println(
            "epsilon=$(Float64(epsilon)): RDP=$(rdp.updates), " *
            "Fornasini-Valcher=$(fv.updates), value=$(extended_vector_string(rdp.values))",
        )
    end
end

epsilon = Rat(1 // 10000)
c = cost_vector(epsilon)
rdp_infeasible = rdp_fixed_point(L_INFEASIBLE, c)
fv_infeasible = fornasini_valcher_fixed_point(L_INFEASIBLE, c; max_updates=20_000)
@assert rdp_infeasible.converged && rdp_infeasible.updates == 1
@assert rdp_infeasible.values == Union{Nothing,Rat}[nothing, nothing, nothing, Rat(0)]
@assert !fv_infeasible.converged

println("Wrote $(output_path)")
println(
    "Modified infeasible case: RDP=$(rdp_infeasible.updates), " *
    "value=$(extended_vector_string(rdp_infeasible.values)); " *
    "the Fornasini-Valcher recursion has no fixed point within $(fv_infeasible.updates) updates " *
    "when run without its solvability pre-check.",
)
