using TerminalMenus

opts = ["a", "b", "C"]
menu = RadioMenu(opts)

rq = request(menu) # performing the dialog

if rq==-1
    println("Dialog aborted!")
else
    println("following item selected:")
    idxs = rq
    @show opts[idxs]
end
;
