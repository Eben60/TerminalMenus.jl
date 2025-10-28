using TerminalMenus

opts = ["a", "b", "C"]
menu = MultiSelectMenu(opts; checked="[Z]", on_cancel=nothing)

rq = request(menu) # performing the dialog

if isnothing(rq)
    println("Dialog aborted!")
else
    println("following items selected:")
    idxs = rq |> collect |> sort!
    @show opts[idxs]
end
;
