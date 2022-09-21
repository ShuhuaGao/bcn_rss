# It often happens that the LRCIS (i.e., IcZ) of a arbitrarily given Z is empty.
# To facilitate our subsequent analysis, we first get a non-empty IcZ by trying different Z's.
# Then, we combine the above IcZ with some other states to form a new target set Z. 

using StatsBase
using BCNRSS
using JLD2
using Random

Random.seed!(12)

function generate(min_IcZ_size=32, others_size=1000)
    num = 5000
    bcn = load("net.jld2", "bcn")

    while true
        Z = Set(sample(1:bcn.N, num; replace=false))
        IcZ = calculate_LRCIS(bcn, Z)
        if length(IcZ) >= min_IcZ_size # we want a IcZ of size at least 32
            others = Set(sample(1:bcn.N, others_size; replace=false))
            num_IcZ = length(IcZ)
            Z = IcZ
            union!(Z, others)
            jldsave("Z.jld2"; Z)
            println("Got Z with |Z| = $(length(Z)) and |IcZ| ≥ $(num_IcZ)")
            break
        end
        if num <= 40000
            num += 1000
        end
    end
end

generate(40)