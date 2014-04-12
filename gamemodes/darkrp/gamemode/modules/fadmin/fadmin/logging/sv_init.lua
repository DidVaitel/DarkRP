FAdmin.StartHooks["Logging"] = function()
	FAdmin.Access.AddPrivilege("Logging", 3)
	FAdmin.Commands.AddCommand("Logging", function(ply, cmd, args)
		if not FAdmin.Access.PlayerHasPrivilege(ply, "Logging") then FAdmin.Messages.SendMessage(ply, 5, "No access!") return end
		if not tonumber(args[1]) then return end

		local OnOff = (tobool(tonumber(args[1])) and "on") or "off"
		FAdmin.Messages.ActionMessage(ply, player.GetAll(), ply:Nick().." turned logging "..OnOff, "Logging has been turned "..OnOff, "Turned logging "..OnOff)

		RunConsoleCommand("FAdmin_logging", args[1])
	end)
end

local LogFile
function FAdmin.Log(text, preventServerLog)
	if not text or text == "" then return end
	if not tobool(GetConVarNumber("FAdmin_logging")) then return end
	if not preventServerLog then ServerLog(text .. "\n") end
	if not LogFile then -- The log file of this session, if it's not there then make it!
		if not file.IsDir("fadmin_logs", "DATA") then
			file.CreateDir("fadmin_logs")
		end
		LogFile = "fadmin_logs/"..os.date("%m_%d_%Y %I_%M %p")..".txt"
		file.Write(LogFile, os.date().. "\t".. text)
		return
	end
	file.Append(LogFile, "\n"..os.date().. "\t"..text)
end

hook.Add("PlayerGiveSWEP", "FAdmin_Log", function(ply, class)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Gave himself a "..(class or "Unknown"))
end)
hook.Add("PlayerSpawnedSENT", "FAdmin_Log", function(ply, ent)
	if not IsValid(ply) or not ply:IsPlayer() or not IsValid(ent) then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Spawned a "..(ent:GetClass() or "Unknown"))
end)
hook.Add("PlayerSpawnSWEP", "FAdmin_Log", function(ply, class)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Spawned a "..(class or "Unknown"))
end)
hook.Add("PlayerSpawnedProp", "FAdmin_Log", function(ply, model, ent)
	if not IsValid(ply) or not ply:IsPlayer() or not IsValid(ent) then return end
	for k,v in pairs(player.GetAll()) do
		if v:IsAdmin() then
			v:PrintMessage(HUD_PRINTCONSOLE, ply:Nick().." ("..ply:SteamID()..") Spawned a "..(model or "Unknown"))
		end
	end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Spawned a "..(model or "Unknown"))
end)
hook.Add("PlayerSpawnedNPC", "FAdmin_Log", function(ply, ent)
	if not IsValid(ply) or not ply:IsPlayer() or not IsValid(ent) then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Spawned a "..(ent or "Unknown"))
end)
hook.Add("PlayerSpawnedVehicle", "FAdmin_Log", function(ply, ent)
	if not IsValid(ply) or not ply:IsPlayer() or not IsValid(ent) then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Spawned a "..(ent:GetClass() or "Unknown"))
end)
hook.Add("PlayerSpawnedEffect", "FAdmin_Log", function(ply, model, ent)
	if not IsValid(ply) or not ply:IsPlayer() or not model then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Spawned a "..(model or "Unknown"))
end)
hook.Add("PlayerSpawnedRagdoll", "FAdmin_Log", function(ply, model, ent)
	if not IsValid(ply) or not ply:IsPlayer() or not IsValid(ent) then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Spawned a "..(model or "Unknown"))
end)
hook.Add("CanTool", "FAdmin_Log", function(ply, tr, toolclass)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Attempted to use tool "..(toolclass or "Unknown"))
end)


hook.Add("PlayerLeaveVehicle", "FAdmin_Log", function(ply, vehicle)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") exited a "..(IsValid(vehicle) and vehicle:GetClass() or "Unknown"))
end)
hook.Add("OnNPCKilled", "FAdmin_Log", function(NPC, Killer, Weapon)
	if not IsValid(NPC) then return end
	FAdmin.Log(NPC:GetClass().. " was killed by ".. (IsValid(Killer) and (Killer:IsPlayer() and Killer:Nick() or Killer:GetClass()) or "Unknown") .. " with a ".. (IsValid(Weapon) and Weapon:GetClass() or "Unknown"))
end)
hook.Add("OnPlayerChangedTeam", "FAdmin_Log", function(ply, oldteam, newteam)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") changed from "..team.GetName(oldteam).. " to ".. team.GetName(newteam))
end)
hook.Add("WeaponEquip", "FAdmin_Log", function(weapon)
		timer.Simple(0, function()
			if not IsValid(weapon) then return end
			local ply = weapon:GetOwner()
			if not IsValid(ply) or not ply:IsPlayer() then return end
			FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Attempted to pick up a "..weapon:GetClass())
		end)
end)

hook.Add("PlayerDeath", "FAdmin_Log", function(ply, inflictor, Killer)
	local Nick, SteamID, KillerName, InflictorName = (IsValid(ply) and ply:Nick() or "N/A"), (IsValid(ply) and ply:SteamID() or "N/A"),
		(IsValid(Killer) and (Killer:IsPlayer() and Killer:Nick() or Killer:GetClass()) or "N/A"),
		(IsValid(inflictor) and inflictor:GetClass() or "N/A")
	FAdmin.Log(Nick.." ("..SteamID..") Got killed by "..KillerName.." with a "..InflictorName)
end)
hook.Add("PlayerSilentDeath", "FAdmin_Log", function(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Got killed silently")
end)
hook.Add("PlayerDisconnected", "FAdmin_Log", function(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Disconnected")
end)
hook.Add("PlayerInitialSpawn", "FAdmin_Log", function(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Spawned for the first time")
end)
hook.Add("PlayerSay", "FAdmin_Log", function(ply, text, teamonly, dead)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") [".. (dead and "dead, " or "")..((not teamonly and "team only") or "all") .."] "..(text and text or ""), true)
end)
hook.Add("PlayerSpawn", "FAdmin_Log", function(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Spawned")
end)
hook.Add("PlayerSpray", "FAdmin_Log", function(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Sprayed his spray")
end)
hook.Add("PlayerEnteredVehicle", "FAdmin_Log", function(ply, vehicle)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Entered ".. (IsValid(vehicle) and vehicle:GetClass() or "Unknown"))
end)
hook.Add("EntityRemoved", "FAdmin_Log", function(ent) if IsValid(ent) and ent:GetClass() == "prop_physics" then FAdmin.Log(ent:GetClass().. "(" .. (ent:GetModel() or "<no model>") .. ") Got removed") end end)
hook.Add("PlayerAuthed", "FAdmin_Log", function(ply, SteamID, UniqueID)
	if not IsValid(ply) then return end
	FAdmin.Log(ply:Nick().." ("..(SteamID and SteamID or "Unknown Steam ID")..") is Authed")
end)
hook.Add("PlayerNoClip", "FAdmin_Log", function(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	FAdmin.Log(ply:Nick().." ("..ply:SteamID()..") Attempted to switch noclip")
end)
hook.Add("ShutDown", "FAdmin_Log", function() FAdmin.Log("Server succesfully shut down.") end)
