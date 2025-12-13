local surface = game.surfaces["igrys"]
if (surface) then
    storage.chunks = {}
    for chunk in surface.get_chunks() do
        table.insert(storage.chunks, chunk)
    end
end