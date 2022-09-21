# the Ara Operon network

using BCNRSS


f1(x, u, ξ) = u[1] & x[9] | ξ[1]
f2(x, u, ξ) = (u[2] & x[9]) | u[1]
f3(x, u, ξ) = (x[2] | x[1]) & u[3]
f4(x, u, ξ) = ~u[4]
f5(x, u, ξ) = x[7] & ξ[2]
f6(x, u, ξ) = ~x[3] & u[3]
f7(x, u, ξ) = x[3] & x[4] & ~x[6]
f8(x, u, ξ) = x[3] & x[4]
f9(x, u, ξ) = x[8] | ξ[1] | ξ[2]
f = [f1, f2, f3, f4, f5, f6, f7, f8, f9]


calculate_ASSR(f, 4, 2; to_file="net.jld2");