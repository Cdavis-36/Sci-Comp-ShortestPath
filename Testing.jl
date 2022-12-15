using .WeightedGraphs
using Test

# STAGE 1 - PART 3

# Write a test suite for your module with the following:
     # (a) Test that creating a vertex works.
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
v4 = Vertex(:d)
v5 = Vertex(:e)
v6 = Vertex(:f)
   
    @testset "Vertex" begin
      @test isa(v1, Vertex)
      @test isa(v2, Vertex)
      @test isa(v3, Vertex)
    end

# (b) Test that creating an edge works.
e1 = Edge(:a, :b, 7)
e2 = Edge(:a, :c, 4)
e3 = Edge(:b, :c, 5)
e4 = Edge(:d, :e, 2)
e5 = Edge(:e, :c, 3)
e6 = Edge(:a, :d, 6)


     @testset "Edge" begin
       @test isa(e1, Edge)
       @test isa(e2, Edge)
    end
            
# (c) Test that creating a basic weighted graph works.
g=WeightedGraph()

    @testset "Weighted Graph" begin
        @test isa(g, WeightedGraph)
    end

# (d) Test that adds a single vertex, a vector of vertices or any number of vertices.
    @testset "Add Vertex" begin
      addVertex!(g,v1)
      @test isa(g, WeightedGraph)
      @test v1 in g.vertices
    end

   @testset "Add Vector of Vertices" begin
    addVertices!(g, [v2,v3])
        @test isa(g, WeightedGraph)
        @test v2 in g.vertices
        @test v3 in g.vertices
   end
  
    @testset "Add Vertices" begin
    addVertices!(g, v4,v5)
        @test isa(g, WeightedGraph)
        @test v4 in g.vertices
        @test v5 in g.vertices
   end

# (e) Tests that should throw an ArgumentError when adding vertices adds a vertex that already exists.
   @testset "This vertex already exists" begin  
        @test_throws ArgumentError addVertex!(g,v1)
        @test_throws ArgumentError addVertices!(g, [v2,v3])
        @test_throws ArgumentError addVertices!(g, v4,v5)
    end

# (f) All other tests.
    @testset "Add edge" begin
    addEdge!(g, e1)
        @test isa(g, WeightedGraph)
        @test e1 in g.edges
    end

    @testset "Add vector of edges" begin
    addEdges!(g,[e2,e3])
        @test isa(g, WeightedGraph)
        @test e2 in g.edges
        @test e3 in g.edges
    end
    
    @testset "Add edges" begin
    addEdges!(g,e4,e5, e6)
        @test isa(g, WeightedGraph)
        @test e4 in g.edges
        @test e5 in g.edges
    end

    # @testset "Plot Weighted Graph" begin

p1 = Path([v2, v3, v5, v4], g)
p2 = Path([v2,v3, v5], g)
# p3 = Path([v1, v3, v6], g)
# p4 = Path([v1, v3, v4], g)
    @testset "Path" begin
        @test isa(p1, Path)
        @test isa(p2, Path)
    end

# arePathVerticesOnGraph (p::Vector{Vertex},g::WeightedGraph)
    @testset "Are path vertices on the graph" begin
        @test arePathVerticesOnGraph(p1.path,g)==true
        @test arePathVerticesOnGraph(p2.path,g)==true
        @test arePathVerticesOnGraph([v1, v3, v6], g)==false
    end

# doPathVerticesHaveEdgesOnGraph (p::Vector{Vertex},g::WeightedGraph)
    @testset "Do path vertices share edges?" begin
        @test doPathVerticesHaveEdgesOnGraph(p1.path,g)==true
        @test doPathVerticesHaveEdgesOnGraph(p2.path,g)==true
        @test doPathVerticesHaveEdgesOnGraph([v1, v3, v6],g)==false
        @test doPathVerticesHaveEdgesOnGraph([v1, v3, v4],g)==false
    end

# distance (P::Path)
    @testset "Distance" begin
        @test distance(p1)==(e3.weight+e5.weight+e4.weight)
        @test distance(p2)==(e3.weight+e5.weight)
    end
       
# solveTSP(g::WeightedGraph)
    @testset "Solve TSP" begin
        @test solveTSP(g)
    end


# findShortestPath

