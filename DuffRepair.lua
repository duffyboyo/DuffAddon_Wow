function DuffAddon:MERCHANT_SHOW()
    local enabled = self.db.profile.repairEnabled
    
    if enabled <= 0 then
        return
    end

    UIErrorsFrame:AddMessage("LOOKS LIKE WE ARE ENABLED",1,0,0);


    local repairAllCost, needRepair = GetRepairAllCost();

    if not needRepair then
        return
    end

    UIErrorsFrame:AddMessage("Insufficent Repair Funds",1,0,0);


    local currentGold = GetMoney()
    local canAfford = currentGold >= repairAllCost

    if not canAfford then
        self:Print("Insufficent Funds to repair.")
        UIErrorsFrame:AddMessage("Insufficent Repair Funds",1,0,0);
        UIErrorsFrame:AddMessage("You need another: ".. GetCoinText(repairAllCost - currentGold),1,1,1);
        return
    end

    if enabled == 2 then
        if( IsInGuild() and CanGuildBankRepair()) then
            RepairAllItems(true)
            UIErrorsFrame:AddMessage("Repaired Using Guild Funds",0,1,0);
            UIErrorsFrame:AddMessage("Cost: "..GetCoinText(repairAllCost),0,1,0);
            self:Print("Repair Cost: "..GetCoinText(repairAllCost),0,1,0)
            return
        end
    end

    RepairAllItems(false)
    UIErrorsFrame:AddMessage("Repaired Using Own Funds",0,1,0);
    UIErrorsFrame:AddMessage("Cost: "..GetCoinText(repairAllCost),0,1,0);
    self:Print("Repair Cost: "..GetCoinText(repairAllCost),0,1,0)
end


function DuffAddon:GetRepairEnabled(info)
    return self.db.profile.repairEnabled
end

function DuffAddon:SetRepairEnabled(info, value)
    self:Print("Changed Repair: " ..value)
    self.db.profile.repairEnabled = value
end