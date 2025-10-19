# Comparison of methods using Example 3 of (Fornasini-Valcher 2014) 

(Fornasini-Valcher 2014): E. Fornasini and M. E. Valcher, Optimal Control of Boolean Control Networks, IEEE Transactions on Automatic Control, 59 (2014), pp. 1258–1270.

This example is used to demonstrate the two methods' different characters regarding the upper bound of the number of iterations needed to find a solution.

## Files
- `bcn.jl`: contains the BCN model in Example 3
- `method_ours.jl`: solution using our method
- `method_Fornasini.jl`: solution using the method proposed by Fornasini and Valcher

## Outputs
To facilitate the comparison, we provide the outputs of the two methods, i.e., copy the outputs of `method_ours.jl` and `method_Fornasini.jl` here.
- our method: 
  ```
    Number of iterations in RDP: 3
    Optimal objective value from each initial state : 
    4-element Vector{Float64}:
    2.0
    1.0
    1.0001
    0.0
  ```

- Fornasini and Valcher's method:
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
    2.0     2.0
    1.0     1.0
    1.0001  1.0001
    0.0     0.0
  ```

We see clearly that 
 - the optimal objective values in both methods are the same: `m* = [2.0, 1.0, 1.0001, 0.0]`
 - our method only needs 3 iterations to get the result, while Fornasini and Valcher's method needs more than 10000 iterations (until convergence implied by `m(0) = m(1)`).
  
Interested readers may try other values of `ϵ` in `bcn.jl`, and the same pattern will be observed.