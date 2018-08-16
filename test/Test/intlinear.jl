@testset "Integer Linear" begin
    # The objective bound is not computed with dual values for IP
    mock = MOIU.MockOptimizer(Model{Float64}(), eval_objective_bound = false)
    config = MOIT.TestConfig()

    MOIU.set_mock_optimize!(mock,
        (mock::MOIU.MockOptimizer) -> begin
            MOI.set!(mock, MOI.ObjectiveBound(), 19.4)
            MOIU.mock_optimize!(mock, [4, 5, 1])
        end)
    MOIT.int1test(mock, config)

    MOIU.set_mock_optimize!(mock,
        (mock::MOIU.MockOptimizer) -> MOIU.mock_optimize!(mock, [0, 1, 2]),
        (mock::MOIU.MockOptimizer) -> MOIU.mock_optimize!(mock, [1, 1, 2]),
        (mock::MOIU.MockOptimizer) -> MOIU.mock_optimize!(mock, [0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 3.0, 12.0]),
        (mock::MOIU.MockOptimizer) -> MOIU.mock_optimize!(mock, [0.0, 0.0, 2.0, 2.0, 0.0, 2.0, 0.0, 0.0, 6.0, 24.0]))
    MOIT.int2test(mock, config)

    # FIXME [1, 0...] is not the correct optimal solution but it passes the test
    MOIU.set_mock_optimize!(mock,
        (mock::MOIU.MockOptimizer) -> MOIU.mock_optimize!(mock, [1.0; zeros(10)]))
    MOIT.int3test(mock, config)

    MOIU.set_mock_optimize!(mock,
        (mock::MOIU.MockOptimizer) -> MOIU.mock_optimize!(mock, [1, 0, 0, 1, 1]))
    MOIT.knapsacktest(mock, config)
end
