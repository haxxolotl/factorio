if mods["Redrawn-Space-Connections"] then

    if data.raw["space-location"]["shipyard"] ~= nil then
        data.raw["space-location"]["shipyard"].redrawn_connections_keep = true
    end

    if data.raw["space-location"]["ringworld"] ~= nil then
        data.raw["space-location"]["ringworld"].redrawn_connections_keep = true
    end

    if data.raw["space-location"]["mirandus"] ~= nil then
        data.raw["space-location"]["mirandus"].redrawn_connections_keep = true
    end

    if data.raw["space-location"]["nix"] ~= nil then
        data.raw["space-location"]["nix"].redrawn_connections_keep = true
    end

    if data.raw["space-location"]["calidus-senestella-gate-senestella"] ~= nil then
        data.raw["space-location"]["calidus-senestella-gate-senestella"].redrawn_connections_keep = true
    end

    if data.raw["space-location"]["calidus-senestella-gate-connection"] ~= nil then --just the route
        data.raw["space-location"]["calidus-senestella-gate-connection"].redrawn_connections_keep = true
    end

end
