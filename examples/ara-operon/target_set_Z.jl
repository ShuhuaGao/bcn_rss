# It often happens that the LRCIS (i.e., IcZ) of a arbitrarily given Z is empty.
# To facilitate our subsequent analysis, we first get a non-empty IcZ by trying different Z's.
# Then, we combine the above IcZ with some other states to form a new target set Z. 

using StatsBase
using BCNRSS
using JLD2
using Random

Random.seed!(1234)

function generate(min_IcZ_size=10, others_size=20)
    num = 10
    bcn = load("ara_operon_net.jld2", "bcn")

    while true
        Z = Set(sample(1:bcn.N, num; replace=false))
        IcZ = calculate_LRCIS(bcn, Z)
        if length(IcZ) >= min_IcZ_size # we want a IcZ of size at least 32
            others = Set(sample(1:bcn.N, others_size; replace=false))
            num_IcZ = length(IcZ)
            Z = IcZ
            union!(Z, others)
            # write Z into a text file
            open("./data/Z.txt", "w") do io
                for i in Z
                    println(io, i)
                end
            end
            # save it also to JLD2
            jldsave("Z.jld2"; Z)
            println("Got Z with |Z| = $(length(Z)) and |IcZ| ≥ $(num_IcZ)")
            break
        end
        if num <= 500
            num += 10
        end
    end
end

generate(10)