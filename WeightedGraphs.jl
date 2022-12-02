module WeightedGraphs

import Graphs: SimpleGraph, add_vertices!, add_edge!

export Vertex, Edge, WeightedGraph, addVertex!, addEdge!, addVertices!, addEdges!

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

"""
An edge in a graph. The arguments are the starting vertex (as a symbol), the ending vertex (as a Symbol) and the third is the weight, a non-negative real number.

### Examples

```
e1 = Edge(:a,:b,3)
e2 = Edge(:a,:c,10)
```

"""
struct Edge
  start::Symbol
  finish::Symbol
  weight::Real
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

"""
A path in a graph is a collection of vertices in a list describing a journey around the graph. Takes a vector as an argument.

### Examples
```
p1 = Vertex((:a,:b,:c,:d))
```
"""
struct Path
  path::Vector{Vertex}
  graph::WeightedGraph
  function Path(p::Vector{Vertex},g::WeightedGraph)
    isPathVerticesOnGraph(p,g) || throw(ArgumentError("One of the vertices in the path is not on the the graph"))
    doPathVerticesHaveEdgesOnGraph(p,g) || throw(ArgumentError("Two of the vertices in the path do not share an edge on the the graph"))
    #new(p)
    p
  end
end

function arePathVerticesOnGraph(p::Vector{Vertex},g::WeightedGraph)
  for i in 1:length(p)
    if p[i] in g.vertices
      true
    else false
    end
  end
end

function UnweightedEdges(g::WeightedGraph)
UnweightedEdges=[]
for i in 1:length(g.edges)
    push!(UnweightedEdges,(g.edges[i].start, g.edges[i].finish))
end
end

function doPathVerticesHaveEdgesOnGraph(p::Vector{Vertex},g::WeightedGraph)
  for i in 2:length(p)
    if (p[i-1],p[i]) in UnweightedEdges
      true
    else false
    end
  end
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

e1 = Edge(:a,:b,3)
e2 = Edge(:a,:c,10)
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