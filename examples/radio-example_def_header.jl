using TerminalMenus

opts = ["a", "b", "C"]
menu = RadioMenu(opts; header=true, on_cancel=nothing)

rq = request(menu) # performing the dialog

if isnothing(rq)
    println("Dialog aborted!")
else
    println("following item selected:")
    idxs = rq
    @show opts[idxs]
end
;
