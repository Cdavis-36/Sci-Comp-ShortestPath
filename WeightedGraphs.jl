module WeightedGraphs

import Graphs: SimpleGraph, add_vertices!, add_edge!
import Plots
import GraphRecipes: graphplot

export Vertex, Edge, WeightedGraph, addVertex!, addEdge!, addVertices!, addEdges!, Path, arePathVerticesOnGraph, doPathVerticesHaveEdgesOnGraph, distance, plotWeightedGraph

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
  #print(io, join(v.name,","))
  print(io, string(v.name))
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

#= @recipe function f(g::WeightedGraph) 
    legend -->  false
    aspect_ratio --> :equal
    
end =#

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
    arePathVerticesOnGraph(p,g) || throw(ArgumentError("One of the vertices in the path is not on the the graph"))
    doPathVerticesHaveEdgesOnGraph(p,g) || throw(ArgumentError("Two of the vertices in the path do not share an edge on the the graph"))
    new(p,g)
    #p
  end
end

function Base.show(io::IO, p::Path)
  print(io, string((p.path)))
end

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

#= function UnweightedEdges(g::WeightedGraph)
UnweightedEdgesOnGraph=[]
for i in 1:length(g.edges)
    push!(UnweightedEdgesOnGraph,(Vertex(g.edges[i].start), Vertex(g.edges[i].finish)))
end
UnweightedEdgesOnGraph
end

function doPathVerticesHaveEdgesOnGraph(p::Vector{Vertex},g::WeightedGraph)
  x = 0
  for i in 2:length(p)
    #if (p[i-1],p[i]) in UnweightedEdges(g)
    #  return true
    #else return false
    #end
    if (p[i-1],p[i]) in UnweightedEdges(g) || (p[i],p[i-1]) in UnweightedEdges(g)
      x = x+1
    end
  end
  if x == length(p)-1
    true
  else false
  end
  #x
end =#

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

function distance(P::Path)
  TotalDistance = 0
  #j = 1
  if typeof(P) == Path
    #if (Path.path[i-1],Path.path[i]) in UnweightedEdges(Path.graph) || (Path.path[i],Path.path[i-1]) in UnweightedEdges(Path.graph) || break
    #if Path.path[i-1] == Vertex(Path.graph.edges[i-1].start) && Path.path[i] == Vertex(Path.graph.edges[i-1].finish) || Path.path[i] == Vertex(Path.graph.edges[i-1].start) && Path.path[i-1] == Vertex(Path.graph.edges[i-1].finish) || break
    #for i in 1:length(P.path)
    #  TotalDistance = TotalDistance + P.graph.edges[i].weight
    #  j = j + 1
    #end
    for i in 1:length(P.graph.edges)
    #for s in 1:(length(r.path)-1)
       for f in 2:length(P.path)
            if ((Symbol(P.path[f-1]) == P.graph.edges[i].start) && (Symbol(P.path[f]) == P.graph.edges[i].finish)) || ((Symbol(P.path[f]) == P.graph.edges[i].start) && (Symbol(P.path[f-1]) == P.graph.edges[i].finish))
                TotalDistance = TotalDistance + P.graph.edges[i].weight
                #j = j + 1
            end
        end
    end
    return TotalDistance
  else return Inf
  end
  #if j == length(P.path)
  #  return TotalDistance
  #else return Inf
  #end
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