# This file is a part of Julia. License is MIT: https://julialang.org/license

using TerminalMenus
using Test

function simulate_input_and_capture_output(menu::TerminalMenus.AbstractMenu, keys...; kwargs...)
    keydict =  Dict(:up => "\e[A",
                    :down => "\e[B",
                    :enter => "\r")

    new_stdin = Base.BufferStream()
    for key in keys
        if isa(key, Symbol)
            write(new_stdin, keydict[key])
        else
            write(new_stdin, "$key")
        end
    end

    out_buffer = IOBuffer()
    terminal = TerminalMenus.default_terminal(; in=new_stdin, out=out_buffer)

    request(terminal, menu; kwargs...)

    return String(take!(out_buffer))
end

@testset "Custom Header" begin
    with_logger(SimpleLogger(stderr, Logging.Error)) do
        header = "My Custom Header"
        menu = RadioMenu(["a", "b", "c"]; header=header)
        output = simulate_input_and_capture_output(menu, 'q')
        @test startswith(output, "\e[2K" * header)

        menu = MultiSelectMenu(["a", "b", "c"]; header=header)
        output = simulate_input_and_capture_output(menu, 'q')
        @test startswith(output, "\e[2K" * header)

        header = ""
        menu = RadioMenu(["1st", "b", "c"]; header=header)
        output = simulate_input_and_capture_output(menu, 'q')
        @test startswith(output, "\e[2K > 1st")

        menu = RadioMenu(["1st", "b", "c"]; header = false)
        output = simulate_input_and_capture_output(menu, 'q')
        @test startswith(output, "\e[2K > 1st")

        menu = MultiSelectMenu(["1st", "b", "c"]; header = false)
        output = simulate_input_and_capture_output(menu, 'q')
        @test startswith(output, "\e[2K > [ ] 1st")
        
        menu = RadioMenu(["1st", "b", "c"])
        output = simulate_input_and_capture_output(menu, 'q')
        @test startswith(output, "\e[2K > 1st")
        
        header = TerminalMenus.default_radio_header
        menu = RadioMenu(["1st", "b", "c"]; header = true)
        output = simulate_input_and_capture_output(menu, 'q')
        @test startswith(output, "\e[2K" * header)

        header = TerminalMenus.default_msm_header
        menu = MultiSelectMenu(["a", "b", "c"]; header=true)
        output = simulate_input_and_capture_output(menu, 'q')
        @test startswith(output, "\e[2K" * header)

        menu = MultiSelectMenu(["a", "b", "c"])
        output = simulate_input_and_capture_output(menu, 'q')
        @test startswith(output, "\e[2K" * header)
    end
end
