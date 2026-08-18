# Comparison of methods using modified Example 3 of (Fornasini-Valcher 2014) 

(Fornasini-Valcher 2014): E. Fornasini and M. E. Valcher, Optimal Control of Boolean Control Networks, IEEE Transactions on Automatic Control, 59 (2014), pp. 1258–1270.

This example modifies the transition matrix so that the stabilization problem is infeasible from three states. The solvability assumptions required by the Fornasini--Valcher optimal-control construction are therefore not satisfied. A complete application of that method would first perform its separate reachability/stabilizability check; the value-iteration output below records only what happens if that pre-check is deliberately skipped.

## Files
- `bcn.jl`: contains the BCN model in Example 3 but with `L` modified such that the problem becomes infeasible
- `method_ours.jl`: solution using our method
- `method_Fornasini.jl`: solution using the method proposed by Fornasini and Valcher

The consolidated exact-arithmetic verification is in [`../example3_Fornasini/comparison_sweep.jl`](../example3_Fornasini/comparison_sweep.jl). Run it from the feasible-example directory with

```console
julia --project=.. comparison_sweep.jl
```

## Outputs
To facilitate the comparison, we provide the outputs of the two methods, i.e., copy the outputs of `method_ours.jl` and `method_Fornasini.jl` here.
- our method: 
  ```
    Number of iterations in RDP: 1
    Optimal objective value from each initial state : 
    4-element Vector{Float64}:
      Inf
      Inf
      Inf
      0.0
  ```

- Fornasini and Valcher's value recursion, run without the required solvability pre-check:
  - `T` represents the number of iterations in their algorithm
  - `m(0) = m(1)` indicates that the algorithm is converged
  ```
    - T = 1000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    1.0999  1.0998
    0.1     0.0999
    0.1     0.0999
    0.0     0.0

    - T = 2000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    1.1999  1.1998
    0.2     0.1999
    0.2     0.1999
    0.0     0.0

    - T = 3000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    1.2999  1.2998
    0.3     0.2999
    0.3     0.2999
    0.0     0.0

    - T = 4000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    1.3999  1.3998
    0.4     0.3999
    0.4     0.3999
    0.0     0.0

    - T = 5000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    1.4999  1.4998
    0.5     0.4999
    0.5     0.4999
    0.0     0.0

    - T = 6000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    1.5999  1.5998
    0.6     0.5999
    0.6     0.5999
    0.0     0.0

    - T = 7000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    1.6999  1.6998
    0.7     0.6999
    0.7     0.6999
    0.0     0.0

    - T = 8000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    1.7999  1.7998
    0.8     0.7999
    0.8     0.7999
    0.0     0.0

    - T = 9000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    1.8999  1.8998
    0.9     0.8999
    0.9     0.8999
    0.0     0.0

    - T = 10000:, [m(0), m(1)] =
    4×2 Matrix{Float64}:
    1.9999  1.9998
    1.0     0.9999
    1.0     0.9999
    0.0     0.0

    - T = 11000:, [m(0), m(1)] =
    4×2 Matrix{Float64}:
    2.0999  2.0998
    1.1     1.0999
    1.1     1.0999
    0.0     0.0

    - T = 12000:, [m(0), m(1)] =
    4×2 Matrix{Float64}:
    2.1999  2.1998
    1.2     1.1999
    1.2     1.1999
    0.0     0.0

    - T = 13000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    2.2999  2.2998
    1.3     1.2999
    1.3     1.2999
    0.0     0.0

    - T = 14000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    2.3999  2.3998
    1.4     1.3999
    1.4     1.3999
    0.0     0.0

    - T = 15000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    2.4999  2.4998
    1.5     1.4999
    1.5     1.4999
    0.0     0.0

    - T = 16000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    2.5999  2.5998
    1.6     1.5999
    1.6     1.5999
    0.0     0.0

    - T = 17000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    2.6999  2.6998
    1.7     1.6999
    1.7     1.6999
    0.0     0.0

    - T = 18000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    2.7999  2.7998
    1.8     1.7999
    1.8     1.7999
    0.0     0.0

    - T = 19000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    2.8999  2.8998
    1.9     1.8999
    1.9     1.8999
    0.0     0.0

    - T = 20000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    2.9999  2.9998
    2.0     1.9999
    2.0     1.9999
    0.0     0.0

    - T = 21000:, [m(0), m(1)] = 
    4×2 Matrix{Float64}:
    3.0999  3.0998
    2.1     2.0999
    2.1     2.0999
    0.0     0.0
  ```

Our RDP stops after **one** update with the extended-value vector $[\infty,\infty,\infty,0]$, identifying the three initial states from which the target cannot be reached. If the Fornasini--Valcher value recursion is run while omitting its required pre-check, two successive iterates are still unequal after **20,000** updates. This observation concerns that recurrence outside its solvability assumptions; it is not a claim that the complete Fornasini--Valcher method fails or lacks finite termination on its intended feasible problem class.
