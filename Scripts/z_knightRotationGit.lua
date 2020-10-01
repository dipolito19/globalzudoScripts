setDefaultTab("Main")
local pvp = false
local Spells = {
    {name = "utito tempo", cast = true, amount = 1, distance = 1, safe = true, buffSpell = true, manaCost = 0, level = 0},
    {name = "exori gran", cast = true, amount = 1, distance = 1, manaCost = 0, level = 0},
    {name = "exori", cast = true, amount = 1, distance = 1, manaCost = 0, level = 0},
    {name = "exori gran", cast = true, amount = 1, distance = 1, manaCost = 0, level = 0},
    {name = "exori", cast = true, amount = 1, distance = 1, manaCost = 0, level = 0},
}

macro(500, "EK Spell Rotation", function()
    local isSafe = true;
    local target = g_game.getAttackingCreature()
    local direct
    local whitelistMonsters = {"Emberwing", "Skullfrost", "Groovebeast", "Thundergiant"}

if not g_game.isAttacking() then
    return
end

if player:getPosition().z == target:getPosition().z then
    if  player:getPosition().x > target:getPosition().x then direct = 3 -- west
    elseif  player:getPosition().x < target:getPosition().x then direct = 1 -- east
    elseif player:getPosition().y > target:getPosition().y then direct = 0 -- north
    elseif  player:getPosition().y < target:getPosition().y then direct = 2 -- south
    end
end

for _, spell in ipairs(Spells) do
    local specAmount = 0
    for i,mob in ipairs(getSpectators()) do
        if (getDistanceBetween(player:getPosition(), mob:getPosition())  <= spell.distance and mob:isMonster())  then
            if table.find(whitelistMonsters, mob:getName()) then
                specAmount = specAmount
            else
                specAmount = specAmount + 1
            end
        end
        if (mob:isPlayer() and player:getName() ~= mob:getName()) then
            isSafe = false;
        end
    end

    if (spell.cast) and (specAmount >= spell.amount) and (mana() >= spell.manaCost) and (lvl() >= spell.level) then
        if not spell.buffSpell or not hasPartyBuff() then
            if pvp then
                if isSafe then
                    if player:getDirection() ~= direct and (getDistanceBetween(player:getPosition(), target:getPosition())  <= spell.distance) and spell.turning then
                        turn(direct)
                    end
                    say(spell.name)
             elseif not isSafe and spell.safe then
                    say(spell.name)        
                end
            else
                if player:getDirection() ~= direct and (getDistanceBetween(player:getPosition(), target:getPosition())  <= spell.distance) and spell.turning then
                    turn(direct)
                end
                say(spell.name)
            end
        end
    end
end

end)