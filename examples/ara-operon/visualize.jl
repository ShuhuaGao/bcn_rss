# visualize the RSS 

using BCNRSS

function visualize_rss(bcn::BCN, Z::Set{<:Integer}, x0::Integer, U::Vector{<:Vector{<:Integer}})
    M, N, Q = bcn.M, bcn.N, bcn.Q
    L = bcn.L
    IcZ = calculate_LRCIS(bcn, Z)
    # the relevant partial STG starting from x0
    graph = Dict{Int64,Vector{Int64}}()
    buf = [x0]
    visited = Set{Int64}(x0)
    while !isempty(buf)
        i = pop!(buf)
        S = calculate_S(bcn, i, U[i][1])  # all possible successors
        graph[i] = S
        for j in S
            if !(j in visited)
                push!(buf, j)
                push!(visited, j)
            end
        end
    end


    # produce the dot file: each line as a string 
    lines = String[]
    push!(lines, "digraph G {")
    # graph properties
    push!(lines, "rankdir=LR")
    append!(lines, ["ratio=compress", "size=\"10,3\""])
    # margin means the inner margin of the node
    push!(lines, "node [shape=circle, color=lightblue, style=filled, fontcolor=black, fontsize=18, margin=0.03]")
    # set up nodes
    for i in keys(graph)
        if i in IcZ
            push!(lines, "$i [label=\"$i/$(U[i][1])\", color=yellow]")
        elseif i == x0
            push!(lines, "$i [label=\"$i/$(U[i][1])\", color=green2]")
        else
            push!(lines, "$i [label=\"$i/$(U[i][1])\"]")
        end
    end

    # set up edges 
    for i in keys(graph), j in graph[i]
        push!(lines, "$i -> $j")
    end
    # the ending }
    push!(lines, "}")
    # write a dot file
    open("graph.dot", "w") do io
        for line in lines
            println(io, line)
        end
    end

    # graphviz must be installed: https://graphviz.org/download/ to draw a graph.
    command = `dot -Tpdf graph.dot -o graph.pdf`
    run(command)

end


