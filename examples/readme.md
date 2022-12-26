# Examples

There are three subfolders: *small* for demonstrative examples, and *TLGL* for the 
biological network in benchmark studies.

## How to run

0. Install [Julia v1.7 or higher](https://julialang.org/downloads/) if not yet.
1. Launch Julia REPL
2. Change to the *examples* directory in REPL if not done yet (please use your actual path instead)

   ```julia
    julia> cd(raw"/home/shuhua/github/bcn_rss_p/src/examples")
   ```

3. Enter ] into package mode, and then activate the environment in *examples*

   ```
   julia> ]activate .
   ```

4. Instantiate the *examples* environment, which will install required packages automatically.

   ```
   (examples) pkg> instantiate
   ```

5. Press backspace to return to the normal REPL mode. Then, change to a specific subpath as you want, e.g., to *small*

   ```julia
   julia> cd("./small")
   ```

6. Run Julia scripts according to instructions in that specific folder, e.g., if we want to execute the "small.jl" script, just `include` it

   ```julia
   julia> include("./small.jl")
   ```
