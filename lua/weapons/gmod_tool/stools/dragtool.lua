TOOL.Category		= "Constraints"
TOOL.Name			= "#Tool.dragtool.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if ( CLIENT ) then
    language.Add( "Tool.dragtool.name", "Drag Tool" )
    language.Add( "Tool.dragtool.desc", "Enable or Disable drag for entities" )
    language.Add( "Tool.dragtool.0", "Primary: Disable drag. Secondary: Enable drag" )
end

local function enabledrag(_ , Entity , Data )
	if SERVER then
		if Entity:IsValid() and !Entity:IsWorld() then
			local phys = Entity:GetPhysicsObject()
			phys:EnableDrag( Data.DragOnOff )

		end
		duplicator.StoreEntityModifier( Entity, "DragEnabled" , Data)
	end
	
end

duplicator.RegisterEntityModifier( "DragEnabled", enabledrag )


function TOOL:LeftClick(Trace)
	if CLIENT then return true end
	
	enabledrag( _ , Trace.Entity , {DragOnOff = false})

	self.LastEntity = nil
	return true
end

function TOOL:RightClick(Trace)
	if CLIENT then return true end

	enabledrag( _ , Trace.Entity , {DragOnOff = true})

	self.LastEntity = nil
	return true
end

function TOOL:Think()
	if CLIENT then return end
	local ent = self:GetOwner():GetEyeTrace().Entity

	if self.LastEntity == ent then return end

	if IsValid( ent ) then
		self.Weapon:SetNetworkedBool( "DragEnabled" , ent:GetPhysicsObject():IsDragEnabled() )
	end


	self.LastEntity = ent
end

function TOOL:DrawHUD()
	local ent = self:GetOwner():GetEyeTrace().Entity

	local text = "Drag: "

	if IsValid(ent) then

		if self.Weapon:GetNetworkedBool( "DragEnabled" ) == true then
			text = text .. "Enabled"
		else
			text = text .. "Disabled"
		end

		AddWorldTip( nil , text , nil , nil ,  ent )

	end

end
