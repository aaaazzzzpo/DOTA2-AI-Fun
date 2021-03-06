﻿function TelekeneticBlobGetMarkedTarget(caster)
	local ability = caster:FindAbilityByName("telekenetic_blob_mark_target")
	if ability ~= nil then
		return ability.lastCastTaget
	end
	return nil
end

function TelekeneticBlobFlySetup(modifier, fixedSpeed)
    if modifier:ApplyHorizontalMotionController() == false or modifier:ApplyVerticalMotionController() == false then
        modifier:Destroy()
        return
    end

    modifier.vStartPosition    = GetGroundPosition( modifier:GetParent():GetOrigin(), modifier:GetParent() )
    modifier.vTargetPosition   = modifier:GetAbility():GetCursorPosition()
	modifier.flStartHeight = GetGroundHeight( modifier.vStartPosition, modifier:GetParent())
	modifier.flTargetHeight = GetGroundHeight( modifier.vTargetPosition, modifier:GetParent())
    modifier.flHeight          = modifier:GetAbility():GetSpecialValueFor("fly_height")
    modifier.vDirection        = (modifier.vTargetPosition - modifier.vStartPosition):Normalized()
    modifier.flDistance        = (modifier.vTargetPosition - modifier.vStartPosition):Length2D()
	if fixedSpeed then
		modifier.flHorizontalSpeed = modifier:GetAbility():GetSpecialValueFor("fly_speed")
		modifier.fDuration = modifier.flDistance / modifier:GetAbility():GetSpecialValueFor("fly_speed")
	else
		modifier.flHorizontalSpeed = modifier.flDistance / modifier:GetAbility():GetSpecialValueFor("fly_duration")
		modifier.fDuration = modifier:GetAbility():GetSpecialValueFor("fly_duration")
	end
    EmitSoundOnLocationWithCaster(modifier.vStartPosition, "Ability.TossThrow", modifier:GetParent())
end

function TelekeneticBlobFlyTearDown(modifier)
    if IsServer() then
        modifier:GetParent():RemoveHorizontalMotionController(modifier)
        modifier:GetParent():RemoveVerticalMotionController(modifier)
    end
end

function TelekeneticBlobFlyUpdateHorizontal(me, dt, modifier)
	if IsServer() then
        local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + modifier.vDirection * modifier.flHorizontalSpeed * dt
        me:SetOrigin(vNewPos)
    end
end

function TelekeneticBlobFlyUpdateVertical(me, dt, modifier, landingCallback)
    if IsServer() then
        local vOrigin        = me:GetOrigin()
        local vDistance      = (vOrigin - modifier.vStartPosition):Length2D()
        local vZ             = (2*modifier.flTargetHeight-2*modifier.flStartHeight-4*modifier.flHeight)/(modifier.fDuration*modifier.fDuration) * (modifier:GetElapsedTime()*modifier:GetElapsedTime()) + (4*modifier.flHeight+modifier.flStartHeight-modifier.flTargetHeight) / modifier.fDuration * modifier:GetElapsedTime() + modifier.flStartHeight
        vOrigin.z            = vZ
        local flGroundHeight = GetGroundHeight( vOrigin, modifier:GetParent() )
        local bLanded        = false
        if (modifier:GetElapsedTime() >= modifier.fDuration) then
            vOrigin.z = flGroundHeight
            bLanded   = true
        end

        me:SetOrigin(vOrigin)
        if bLanded == true then
			if landingCallback ~= nil then
				landingCallback(modifier)
			end
            local pid = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf", PATTACH_ABSORIGIN, modifier:GetParent())
            ParticleManager:SetParticleControl(pid, 0, me:GetOrigin())
            ParticleManager:ReleaseParticleIndex(pid)
            EmitSoundOnLocationWithCaster(modifier:GetParent():GetOrigin(), "Ability.TossImpact", modifier:GetParent())
            modifier:GetParent():RemoveHorizontalMotionController(modifier)
            modifier:GetParent():RemoveVerticalMotionController(modifier)
            modifier:SetDuration(0.01, true)
        end
    end
end


modifier_telekenetic_blob = class({})
function modifier_telekenetic_blob:IsPurgable() return false end
function modifier_telekenetic_blob:IsHidden() return true end
function modifier_telekenetic_blob:RemoveOnDeath() return false end
function modifier_telekenetic_blob:DeclareFunctions() return {MODIFIER_PROPERTY_DISABLE_AUTOATTACK} end
function modifier_telekenetic_blob:GetDisableAutoAttack() return 1 end
function modifier_telekenetic_blob:CheckState()
	return {[MODIFIER_STATE_DISARMED] = true}
end


