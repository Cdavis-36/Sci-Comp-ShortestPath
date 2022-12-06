using .WeightedGraphs
using Test

# Write a test suite for your module with the following:
     # (a) Test that creating a vertex works.
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
v4 = Vertex(:d)
v5 = Vertex(:e)
   
    @testset "Vertex" begin
      @test isa(v1, Vertex)
      @test isa(v2, Vertex)
      @test isa(v3, Vertex)
    end

    # (b) Test that creating an edge works.
e1=Edge(:a, :b, 7)
e2=Edge(:a, :c, 4)
e3=Edge(:b, :c, 5)

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