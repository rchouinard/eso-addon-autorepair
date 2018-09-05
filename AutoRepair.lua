--[[
  * Placid's Auto Repair
]]--

local AutoRepair = {}

AutoRepair.name = "AutoRepair"

function AutoRepair.Print(msg)
    CHAT_SYSTEM:AddMessage("|cBDBDBD"..tostring(msg).."|r")
end

function AutoRepair:Initialize()
    EVENT_MANAGER:RegisterForEvent(AutoRepair.name, EVENT_OPEN_STORE, AutoRepair.HandleRepairs)
end

function AutoRepair.OnAddOnLoaded(event, addonName)
    if addonName == AutoRepair.name then
        AutoRepair:Initialize()
    end
end

function AutoRepair.HandleRepairs()
    local totalCost = 0
    -- Loop over bags; 0 = worn items, 1 = inventory items
    for bag = 0, 0, 1 do
        -- Loop over items in current bag
        for slot = 0, GetBagSize(bag) do
            local itemName, itemCondition = GetItemName(bag, slot), GetItemCondition(bag, slot)
            -- Check if item needs repair
            if itemName ~= "" and itemCondition < 100 then
                local repairCost = GetItemrepairCost(bag, slot)
                totalCost = totalCost + repairCost
                RepairItem(bag, slot)
            end
        end
    end
    if totalCost == 0 then
        AutoRepair.Print("Nothing to repair!")
    else
        AutoRepair.Print("Total repair cost: "..tostring(totalCost))
    end
end

EVENT_MANAGER:RegisterForEvent(AutoRepair.name, EVENT_ADD_ON_LOADED, AutoRepair.OnAddOnLoaded)
