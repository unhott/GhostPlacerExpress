--control.lua
--For some reason global.ghost_place_enabled starts out as true, despite this line of code. 
global.ghost_place_enabled = false
--game.print("Ghost Place is currently disabled. Press Y to enable.")

script.on_event({"ghostPlaceToggle"}, function (event)
    
    global.ghost_place_enabled = not global.ghost_place_enabled
    if global.ghost_place_enabled == true then 
        game.print("Ghost Place Express is currently enabled. Press SHIFT Y to disable.")
    else
        game.print("Ghost Place Express is currently disabled. Press SHIFT Y to enable.")
    end
end)





-- local function on_init()
    -- add_GUI()
-- end

-- function add_GUI()
    -- for idx, player in pairs(game.connected_players) do
    
        -- game.print(1)
        -- game.player.gui.top.add{type="radio-button", name="ghostPlacerExpress", caption="GPE"}
    -- end
-- end

--

-- script.on_init(on_init)

script.on_event({defines.events.on_tick}, function (event)
    -- game.print(global.ghost_place_enabled)
    if global.ghost_place_enabled then 
        
        for index, player in pairs(game.connected_players) do
            
            ent_var = player.selected
            if not(ent_var) or player.cursor_stack.valid_for_read then -- v0.1.1! 
                break
            end
            if ent_var.name ~= "entity-ghost" then
                break
            end
            
            --game.print(player.can_place_entity{name = ent_var.ghost_name, position = ent_var.position, direction = ent_var.direction})
            --** This works!
            
            if not(player.can_place_entity{name = ent_var.ghost_name, position = ent_var.position, direction = ent_var.direction}) then break end
            
            --game.print ("yay")
            
            player_quickbar_inventory = player.get_inventory(defines.inventory.player_quickbar)
            items_quickbar = player_quickbar_inventory.get_contents()
            player_main_inventory = player.get_inventory(defines.inventory.player_main)
            items_main = player_main_inventory.get_contents()
            breakout = false
            for item_name, count in pairs(items_quickbar) do
                if item_name == ent_var.ghost_name and count > 0 then
                    breakout = true
                    player_quickbar_inventory.remove{name = item_name, count=1}
                    ent_var.revive()
                    break
                end
            end
            if breakout then break end
            for item_name, count in pairs(items_main) do
                if item_name == ent_var.ghost_name and count > 0 then
                    breakout = true
                    player_main_inventory.remove{name = item_name, count=1}
                    ent_var.revive()
                    break
                end
            end
            if breakout then break end
        end 
    end
end)