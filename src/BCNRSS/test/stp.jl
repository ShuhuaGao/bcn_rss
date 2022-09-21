@testset "STP" begin
    @testset "logical vector" begin
        lv1 = LogicalVector(1, 4)
        lv2 = LogicalVector(2, 2)
        @test length(lv1) == 4
        @test size(lv2) == (2,)
        lv3 = lv1 * lv2
        @test length(lv3) == 8
        @test index(lv3) == 2
        lv4 = LogicalVector(7, 8)
        lv5 = lv2 * lv4
        @test length(lv5) == 16
        @test index(lv5) == 15
        lv6 = lv4 * lv2
        @test size(lv6) == (16,)
        @test index(lv6) == 14
        # test unit logical vector 
        id = LogicalVector(1, 1)
        @test id * id == id
        @test id * lv6 == lv6
        @test lv6 * id == lv6
        @test isvalid(lv6)
    end

    @testset "bool -> lv" begin
        @test LogicalVector(false) == LogicalVector(2, 2)
        @test LogicalVector(true) == LogicalVector(1, 2)
        @test LogicalVector([1, 0]) == LogicalVector(2, 4)
        @test LogicalVector([false, true, false]) == LogicalVector(6, 8)
        @test LogicalVector([true, true, 0]) == LogicalVector(2, 8)
    end

    @testset "logical matrix" begin
        lm = LogicalMatrix(Int32[4, 1, 3], 4, 3)
        @test size(lm) == (4, 3)
        @test eltype(lm.i) == Int64
        lv = LogicalVector(1, 3)
        r = lm * lv
        @test index(r) == 4
        @test length(r) == 4
        lv = LogicalVector(3, 3)
        r = lm * lv
        @test index(r) == 3
        @test length(r) == 4
        @test isvalid(lm)
    end
end