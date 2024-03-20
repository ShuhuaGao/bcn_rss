# the ara operon network definition and compute its ASSR 
# let the state variable of 9 nodes be x1, x2, ..., x9
# let the control variable be u: Ae, Aem, Ara-, Ge
# let the disruption variable be ξ

using BCNRSS

f1(x, u, ξ) = u[1] & x[9]
f2(x, u, ξ) = (u[2] & x[9]) | u[1]
f3(x, u, ξ) = (x[2] | x[1]) & u[3]
f4(x, u, ξ) = ~u[4]
f5(x, u, ξ) = x[7]
f6(x, u, ξ) = ~x[3] & u[3] & ξ[1]
f7(x, u, ξ) = x[3] & x[4] & ~x[6]
f8(x, u, ξ) = x[3] & x[4]
f9(x, u, ξ) = x[8] | ξ[2]

f = [f1, f2, f3, f4, f5, f6, f7, f8, f9]
bcn = calculate_ASSR(f, 4, 2; to_file="ara_operon_net.jld2");

L = bcn.L
# write L into a text file
open("./data/L.txt", "w") do io
    for i in L
        println(io, i)
    end
end
