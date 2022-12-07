module WeightedGraphs

import Graphs: SimpleGraph, add_vertices!, add_edge!, a_star
import Plots
import GraphRecipes: graphplot
import Combinatorics: nthperm

export Vertex, Edge, WeightedGraph, addVertex!, addEdge!, addVertices!, addEdges!, Path, arePathVerticesOnGraph, doPathVerticesHaveEdgesOnGraph, distance, plotWeightedGraph, findShortestPath, solveTSP

"""
A vertex in a graph. Takes a symbol as an argument.

### Examples

```
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
```
"""
struct Vertex
  name::Symbol
end

function Base.show(io::IO, v::Vertex)
  print(io, string(v.name))
end

"""
An edge in a graph. The arguments are the starting vertex (as a symbol), the ending vertex (as a Symbol) and the third is the weight, a non-negative real number.

### Examples

```
e1 = WeightedGraphs.Edge(:a,:b,3)
e2 = WeightedGraphs.Edge(:a,:c,10)
```

"""
struct Edge
  start::Symbol
  finish::Symbol
  weight::Real
end

function Base.show(io::IO, e::Edge)
  print(io, string((e.start,e.finish,e.weight)))
end

"""
A weighted graph, that is a graph with edges that are weighted. 

### Examples
```
g = WeightedGraph()
```
makes a new Weighted Graph with no vertices or edges.
"""
struct WeightedGraph
  vertices::Vector{Vertex}
  edges::Vector{Edge}
  graph::SimpleGraph
  
  function WeightedGraph(v::Vector{Vertex}, e::Vector{Edge}, g::SimpleGraph)
    new(v,e,g)
  end
  
  function WeightedGraph()
    new([],[],SimpleGraph())
  end
end

function Base.show(io::IO, g::WeightedGraph)
  print(io, string(g.vertices),string(g.edges))
end

"""
Plots a `WeightedGraph` with the vertices and edges labelled

### Example
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertices!(g,v1,v2,v3)

e1 = WeightedGraphs.Edge(:a,:b,3)
e2 = WeightedGraphs.Edge(:a,:c,10)
addEdges!(g,e1,e2)

plotWeightedGraph(g)
```
"""
function plotWeightedGraph(g::WeightedGraph)
  names = []
  for i in 1:length(g.vertices)
    push!(names,string(g.vertices[i]))
  end
  edgelabel=Dict()
  for i in 1:length(g.edges)
      for s in 1:length(g.vertices)
          for f in 2:length(g.vertices)
              if g.edges[i].start == Symbol(g.vertices[s]) && g.edges[i].finish == Symbol(g.vertices[f])
                  push!(edgelabel,(s,f)=>g.edges[i].weight)
              end
          end
      end
  end
  graphplot(g.graph, names=names, edgelabel=edgelabel, curves=false)
end

"""
A path in a graph is a collection of vertices in a list describing a journey around the graph. Takes a vector of vertices and a 'Weighted Graph' as arguments.

### Examples
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertices!(g,v1,v2,v3)

e1 = WeightedGraphs.Edge(:a,:b,3)
e2 = WeightedGraphs.Edge(:a,:c,10)
addEdges!(g,e1,e2)

julia> P1 = Path([v2,v1,v3],g)
Vertex[a, b, c]
```
"""
struct Path
  path::Vector{Vertex}
  graph::WeightedGraph
  function Path(p::Vector{Vertex},g::WeightedGraph)
    arePathVerticesOnGraph(p,g) || throw(ArgumentError("One of the vertices in the path is not on the the graph"))
    doPathVerticesHaveEdgesOnGraph(p,g) || throw(ArgumentError("Two of the vertices in the path do not share an edge on the the graph"))
    new(p,g)
    #p
  end
end

function Base.show(io::IO, p::Path)
  print(io, string((p.path)))
end

"""
Determines whether or not the vertices in a 'Path' are on the specified `WeightedGraph`. Takes a vector of vertices and a 'WeightedGraph' as arguments.

### Example
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertices!(g,v1,v2,v3)

e1 = WeightedGraphs.Edge(:a,:b,3)
e2 = WeightedGraphs.Edge(:a,:c,10)
addEdges!(g,e1,e2)

julia> arePathVerticesOnGraph([Vertex(:a), Vertex(:b)],g)
true

julia> arePathVerticesOnGraph([Vertex(:d)],g)
false
```
"""
function arePathVerticesOnGraph(p::Vector{Vertex},g::WeightedGraph)
  t = 0
  for i in 1:length(p)
    if p[i] in g.vertices
      t = t + 1
    end
  end
  if t == length(p)
    true
  else false
  end
end

"""
Determines whether or not the vertices in a 'Path' are on the specified `WeightedGraph` share an edge. Takes a vector of vertices and a 'WeightedGraph' as arguments.

### Example
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertices!(g,v1,v2,v3)

e1 = WeightedGraphs.Edge(:a,:b,3)
e2 = WeightedGraphs.Edge(:a,:c,10)
addEdges!(g,e1,e2)

julia> doPathVerticesHaveEdgesOnGraph([Vertex(:a), Vertex(:b)],g)
true

julia> doPathVerticesHaveEdgesOnGraph([Vertex(:b), Vertex(:c)],g)
false
```
"""
function doPathVerticesHaveEdgesOnGraph(p::Vector{Vertex},g::WeightedGraph)
  x = 0
  for i in 2:length(p)
    for j in 1:length(g.edges)
      if p[i-1] == Vertex(g.edges[j].start) && p[i] == Vertex(g.edges[j].finish) || p[i] == Vertex(g.edges[j].start) && p[i-1] == Vertex(g.edges[j].finish)
        x = x+1
      end
    end
  end
  if x == length(p)-1
    true
  else false
  end
end

"""
Determines the distance of a 'Path' on the specified `WeightedGraph`. Takes a 'Path' as an argument.

### Example
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertices!(g,v1,v2,v3)

e1 = WeightedGraphs.Edge(:a,:b,3)
e2 = WeightedGraphs.Edge(:a,:c,10)
addEdges!(g,e1,e2)

julia> distance(Path([v2,v1,v3],g)
13
```
"""
function distance(P::Path)
  TotalDistance = 0
  if typeof(P) == Path
    for i in 1:length(P.graph.edges)
      for f in 2:length(P.path)
        if ((Symbol(P.path[f-1]) == P.graph.edges[i].start) && (Symbol(P.path[f]) == P.graph.edges[i].finish)) || ((Symbol(P.path[f]) == P.graph.edges[i].start) && (Symbol(P.path[f-1]) == P.graph.edges[i].finish))
          TotalDistance = TotalDistance + P.graph.edges[i].weight
          end
      end
    end
    return TotalDistance
  else return Inf
  end
end

"""
Determines the shortest 'Path' around a complete graph to hit every vertex on the specified `WeightedGraph` and create a cycle to be able to start and stop at the same vertex. Takes a 'WeightedGraph' as an argument.

### Example
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertices!(g,v1,v2,v3)

e1 = WeightedGraphs.Edge(:a,:b,3)
e2 = WeightedGraphs.Edge(:a,:c,10)
e3 = WeightedGraphs.Edge(:b,:c,5)
addEdges!(g,e1,e2,e3)

julia> solveTSP(g)
4-element Vector{Vertex}:
 a
 b
 c
 a
```
"""
function solveTSP(g::WeightedGraph)
  perms = map(k->nthperm(g.vertices,k),1:factorial(length(g.vertices)))
  dists = []
  for i in 1:length(perms)
    push!(dists,distance(Path(perms[i],g)))
  end
  sol = nthperm(g.vertices,findmin(dists)[2])
  push!(sol,sol[1])
end

"""
Determines the shortest 'Path' around the specified `WeightedGraph` from a specified starting vertex to a specified ending vertex. Takes a 'Vertex" as a start, a 'Vertex' as a finish, and a 'WeightedGraph' as arguments.

### Example
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertices!(g,v1,v2,v3)

e1 = WeightedGraphs.Edge(:a,:b,3)
e2 = WeightedGraphs.Edge(:a,:c,10)
e3 = WeightedGraphs.Edge(:b,:c,5)
addEdges!(g,e1,e2,e3)

julia> findShortestPath(Vertex(:a),Vertex(:c),g)
(Path = Vertex[a, b, c], Distance = 8)
```
"""
function findShortestPath(start::Vertex,finish::Vertex,g::WeightedGraph)
edgelabel=Dict()
for i in 1:length(g.edges)
    for s in 1:length(g.vertices)
        for f in 2:length(g.vertices)
            if g.edges[i].start == Symbol(g.vertices[s]) && g.edges[i].finish == Symbol(g.vertices[f])
                push!(edgelabel,(s,f)=>g.edges[i].weight)
            end
        end
    end
end
w = zeros(Int,length(g.vertices),length(g.vertices))
for i=1:length(g.vertices)
  for j=1:length(g.vertices)
    if haskey(edgelabel,(i,j))
      w[i,j] = edgelabel[(i,j)]
      w[j,i] = edgelabel[(i,j)]
    end
  end
end
ShortestPath = a_star(g.graph, findfirst(isequal(start),g.vertices),findfirst(isequal(finish),g.vertices), w)
path = Vector{Vertex}(undef,length(ShortestPath)+1)
for i in 1:(length(ShortestPath))
    path[i] = g.vertices[ShortestPath[i].src]
end
path[length(ShortestPath)+1] = g.vertices[ShortestPath[length(ShortestPath)].dst]
named_tuple = (Path = path,Distance = distance(Path(path,g)))
end

"""
Adds an `Edge` to the `WeightedGraph`

### Example
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertex!(g,v1)
addVertex!(g,v2)
addVertex!(g,v3)

e1 = WeightedGraphs.Edge(:a,:b,3)
e2 = WeightedGraphs.Edge(:a,:c,10)
addEdge!(g,e1)
addEdge!(g,e2)
```
"""
function addEdge!(g::WeightedGraph, e::Edge)
  i = findfirst(n -> n.name == e.start, g.vertices)
  i != nothing || throw(ArgumentError("The node with name $(e.start) does not exist.")) #node with name whatever error
  j = findfirst(n -> n.name == e.finish, g.vertices)
  j != nothing || throw(ArgumentError("The node with name $(e.finish) does not exist."))
  e.weight >0 || throw(ArgumentError("The weight of $(e.weight) must be positive"))
  push!(g.edges,e)
  add_edge!(g.graph,i,j)
end
function addEdges!(g::WeightedGraph, vect::Vector{Edge}) #makes edge out of vector
  for i in 1:length(vect)
    addEdge!(g, vect[i])
  end
end
function addEdges!(g::WeightedGraph, e::Edge...) #variable number of edges in arguement
  for i in 1:length(e)
    addEdge!(g, e[i])
  end
end
#=
function addEdges!(g::WeightedGraph, s::String) #makes edges from string (skip)
  C = split(s, ", ")
  for k in 1:3:length(C)
    v1 = Vertex(Symbol(C[k]))
    v2 = Vertex(Symbol(C[k+1]))
    w = parse(Int64, C[k+2])
    e = WeightedGraphs.Edge(v1, v2, w)
    addEdge!(g, e)
  end
end
=#
"""
Adds a `Vertex` to the `WeightedGraph`

### Example
```
g = WeightedGraph()
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
addVertex!(g,v1)
addVertex!(g,v2)
addVertex!(g,v3)
```
"""
function addVertex!(g::WeightedGraph, v::Vertex) #adds one vertex
  i = findfirst(n -> n.name == v.name, g.vertices)
  if i == nothing #checks if vertex already exists
    add_vertices!(g.graph,1)
    push!(g.vertices,v)
  else
    throw(ArgumentError("The vertex with name $(v.name) already exists."))
  end
end
function addVertices!(g::WeightedGraph, vect::Vector{Vertex}) #adds multiple vertices from a vector
  for i in 1:length(vect)
    addVertex!(g, vect[i])
  end
end #insert Base.show to make it look nicer
function addVertices!(g::WeightedGraph, v::Vertex...) #variable number of vertices in arguement
  for i in 1:length(v)
    addVertex!(g, v[i])
  end
end
function addVertices!(g::WeightedGraph, s::String) #takes strings and add verticies
  B = split(s, ", ")
  for i in 1:length(B)
    v = Vertex(Symbol(B[i]))
    addVertex!(g, v)
  end
end

end #end of module