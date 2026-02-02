SWEP.PrintName = "Watermelon Gun"
SWEP.Author = "Noob20897"
SWEP.Purpose = "Its for fun!"
SWEP.Instructions = "It uses .357 Magnum bullets and turns NPCs into watermelons with a right-click!"
SWEP.Category = "Noob20897's Sweps"
SWEP.BounceWeaponIcon = false
SWEP.Base = "weapon_base"
SWEP.WepSelectIcon = "vgui/entities/weapon_watermelon.vmt"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"

SWEP.Secondary.Delay = 0.05
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.UseHands = true

SWEP.ShootSound = Sound("weapons/357/357_fire2.wav")

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    self:SetNextPrimaryFire(CurTime() + 0.75)
    self:ShootBullet(75, 1, 0.01)
    self:EmitSound(self.ShootSound)
    self:TakePrimaryAmmo(1)
end

if SERVER then
    util.AddNetworkString("MH")
end

function SWEP:SecondaryAttack()
		
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
		
	if SERVER then
        local ply = self:GetOwner()
        if not IsValid(ply) then return end
        
        local tr = ply:GetEyeTrace()
        
        -- NPC mi kontrol et
        if IsValid(tr.Entity) and tr.Entity:IsNPC() then
            local pos = tr.Entity:GetPos()
            tr.Entity:Remove()
        
            local melon = ents.Create("prop_physics")
            if IsValid(melon) then
                melon:SetModel("models/props_junk/watermelon01.mdl")
                melon:SetPos(pos + Vector(0, 0, 10))
                melon:Spawn()
            end
			
				net.Start("MH")
				net.WriteVector(pos)
				net.Send(ply)
			
			else
		
				ply:ChatPrint("It requires an NPC to work.")
			
			end
	end
end

if CLIENT then
	net.Receive("MH", function()
		local pos = net.ReadVector()
		
		local effectdata = EffectData()
		effectdata:SetOrigin(pos + Vector(0, 0, 10))
		effectdata:SetNormal(Vector(0, 0, 1))
		
		util.Effect("ManhackSparks", effectdata, true, true)
		
		surface.PlaySound("weapons/airboat/airboat_gun_lastshot1.wav", pos, 100, 100)
	end)
end

if CLIENT then
    function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
        surface.SetDrawColor(255, 255, 255, alpha)
        surface.SetMaterial(Material("vgui/entities/weapon_watermelon_alpha.vmt"))
        surface.DrawTexturedRect(x, y, w, h)
    end
end
