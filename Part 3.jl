using .WeightedGraphs
using Test

# Write a test suite for your module with the following:
     # (a) Test that creating a vertex works.
v1 = Vertex(:a)
v2 = Vertex(:b)
v3 = Vertex(:c)
   
    @testset "Vertex" begin
      @test isa(v1,Vertex)
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

    # (d) Test that adds a single vertex, a vector of vertices or any number of vertices.

    # (e) Tests that should throw and ArgumentError when addingvertices adds a vertex that already exists.