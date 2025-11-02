# This file is a part of Julia. License is MIT: https://julialang.org/license

@testset "Quit Selection" begin
    # Menu called without any options (may) result in a warning, but in these tests we do not check it, 
    # just suppress warnings output, if any
    with_logger(SimpleLogger(stderr, Logging.Error)) do
        menu = RadioMenu(["a", "b", "c"])
        @test simulate_input(menu, 'q') == -1

        menu = MultiSelectMenu(["a", "b", "c"])
        @test simulate_input(menu, 'q') == Set{Int64}()
    end

    menu = RadioMenu(["a", "b", "c"]; charset=:ascii)
    @test simulate_input(menu, 'q') == -1

    menu = MultiSelectMenu(["a", "b", "c"]; charset=:ascii)
    @test simulate_input(menu, 'q') == Set{Int64}()

    menu = RadioMenu(["a", "b", "c"]; on_cancel=nothing)
    @test simulate_input(menu, 'q') |> isnothing

    menu = MultiSelectMenu(["a", "b", "c"]; on_cancel=nothing)
    @test simulate_input(menu, 'q') |> isnothing
end
