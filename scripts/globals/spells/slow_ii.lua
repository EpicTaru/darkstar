-----------------------------------------
-- Spell: Slow II
-- Spell accuracy is most highly affected by Enfeebling Magic Skill, Magic Accuracy, and MND.
-- caster:getMerit() returns a value which is equal to the number of merit points TIMES the value of each point
-- Slow II value per point is '1' This is a constant set in the table 'merits'
-----------------------------------------

require("scripts/globals/status");
require("scripts/globals/magic");

-----------------------------------------
-- OnSpellCast
-----------------------------------------

function OnMagicCastingCheck(caster,target,spell)
    return 0;
end;

function onSpellCast(caster,target,spell)
    local dMND = (caster:getStat(MOD_MND) - target:getStat(MOD_MND));
    --local bonus = AffinityBonus(caster, spell:getElement()); Removed: affinity bonus is added in applyResistance

    local potency = 230 + math.floor(dMND * 1.6);

    -- ([230] + [y * 10] + [floor(dMND * 1.6)])/1024

    if(potency > 350) then
        potency = 350;
    end

    local merits = caster:getMerit(MERIT_SLOW_II);

    if (merits == 0) then --if caster has the spell but no merits in it, they are either a mob or we assume they are GM or otherwise gifted with max duration and effect
        merits = 5;
    end

    --Power.
    local power = (potency  + (merits * 10));

    --Duration, including resistance.
    local duration = 180 * applyResistanceEffect(caster,spell,target,dMND,35,merits*2,EFFECT_SLOW);

    if(duration >= 60) then --Do it!

        if(target:addStatusEffect(EFFECT_SLOW,power,0,duration)) then
            spell:setMsg(236);
        else
            spell:setMsg(75);
        end

    else
        spell:setMsg(85);
    end

    return EFFECT_SLOW;
end;