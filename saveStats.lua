print("hello world")


--Global Vals to be overwritten a lot
local round_ID = os.date("%m.%d.%Y_%H.%M.%S")
local unixTime = CurTime()
local globalDeathsOutput
local globalRoleDataOutput
local globalEquipmentOutput
--values for players and role changes given default values
local beginningRoundPlayerTable = player.GetAll()
local roundPlayerTable = player.GetAll()
local beginningRoundRoleTable = {}
for k ,v in pairs(beginningRoundPlayerTable) do
	table.insert(beginningRoundRoleTable, v:GetRoleString())
end


--Hooks needed 
--After Round starts Done
--After Round ends
--After Player Death Done
--After Player Buy done
--After Every team set done

--Example Hook
hook.Add("PlayerSay", "default", function()
	
	
end)
function roleChangeChecker()
	--PrintTable(beginningRoundPlayerTable)
	--PrintTable(player.GetAll())
	roundPlayerTable = player.GetAll()
	local roleTable = {}
	for k ,v in pairs(player.GetAll()) do
		table.insert(roleTable, v:GetRoleString())
	end

	if(table.Count(beginningRoundRoleTable) ~= table.Count(roleTable))then
		updateBeginningRoundRoleTable()
	end

	--PrintTable(roleTable)
	--PrintTable(beginningRoundRoleTable)
	if(GAMEMODE.round_state == 3) then
		for k ,v in pairs(beginningRoundRoleTable) do
			for t, s in pairs(roleTable) do
				if(k == t) then
					--print(tostring(v).." vs "..s)
					if(v ~= s) then
						print("yeet")
						print(roundPlayerTable[k])
						addRoleOutput(roundPlayerTable[k])
						updateBeginningRoundRoleTable()
					end
				end
			end
		end
	end
end


hook.Add("TTTOrderedEquipment", "EquipmentOrder", function(ply, id, is_item)
	print(ply)
	print(id) --number of an id, or name
	--PrintTable(DefaultEquipment[id])
	addOrderedEquipment(ply, id)
end)
hook.Add("DoPlayerDeath", "death", function(ply, attacker, dmg)
	print(ply)
	print(attacker)
	print(dmg:GetInflictor())
	print(dmg:GetInflictor():GetClass())
	--print(dmg:GetInflictor():GetName())
	-- if((attacker:GetActiveWeapon()) ~= nil or "worldspawn" == dmg:GetInflictor():GetClass()) then
	-- 	print("works")
	-- 	print((attacker:GetActiveWeapon()))
	-- 	print((attacker:GetActiveWeapon()):GetClass())
	-- 	print((attacker:GetActiveWeapon()):GetName())
	-- end
	print(dmg)
	addPlayerDeath(ply, attacker, dmg)
end)
hook.Add("tttbeginround", "begin", function()
	globalDeathsOutput = ""
	globalRoleDataOutput = ""
	globalEquipmentOutput = ""
	updateRoundInfo()
	printRoundAndSteamID()
	
end)
hook.Add("TTTEndRound", "end", function(result)
	printRoundInfo(result)
	printDeaths()
	printRoleData()
	printEquipment()
end) 
hook.Add("Tick", "TickRoleChange", function()

	roleChangeChecker()
end)

function updateBeginningRoundRoleTable()
	beginningRoundRoleTable = {}
	for k ,v in pairs(player.GetAll()) do
		table.insert(beginningRoundRoleTable, v:GetRoleString())
	end
end

function printDeaths()
	local name = round_ID.."_Deaths.txt"
	file.Write(name, globalDeathsOutput)
end	
function printRoleData()
	local name = round_ID.."_Role_Data.txt"
	file.Write(name, globalRoleDataOutput)
end
function printEquipment()
	local name = round_ID.."_Menu_Buys.txt"
	file.Write(name, globalEquipmentOutput)
end
	

function updateRoundInfo()
	roundPlayerTable = player.GetAll()
	updateBeginningRoundRoleTable()
	beginningRoundPlayerTable = player.GetAll()
	round_ID = os.date("%m.%d.%Y_%H.%M.%S")
	unixTime = CurTime()
end

function addOrderedEquipment(ply, id)
	local idName = "defaultName"
	local nextName = false
	print("DEBUGING EQUIPMENT LABEL")
	if(isnumber(id)) then
		for k,v in pairs(EquipmentItems) do
			
			--PrintTable(v,1)
			for t,s in pairs(v) do
				--PrintTable(s)
				
				for x,m in pairs(s) do
					--print("c")
					if(x == "id") then
						--print(x)
						--print("d")
						if(isnumber(m)) then
							--print("e")
							--print(m)
							if(m == id) then
								--print("f")
								nextName = true
							end
						end
					end
					if(nextName == true) then
						--print("g")
						if(x == "name") then
							--print("h")
							idName = m
							--print("ID_NAME = "..idName)
							nextName = false
						end
					end
					--print(x.." "..tostring(m))
				end	
			end
		end
	else
		idName = id
	end
	print("ID_NAME = "..idName)

	local plyID = ply:SteamID64()
	local time_in_round = getTimeInRound()

	if(globalEquipmentOutput == nil)then
		globalEquipmentOutput = round_ID..","..plyID..","..idName..","..time_in_round.."\n"
	else
		globalEquipmentOutput = globalEquipmentOutput..round_ID..","..plyID..","..idName..","..time_in_round.."\n"
	end
	
	--file.Write(name, output)
end

function addRoleOutput(ply)
	print("role added "..ply:GetName().." as "..ply:GetRoleString())
	local plyID = ply:SteamID64()
	local role = ply:GetRoleString()
	local time = getTimeInRound()
	if(globalRoleDataOutput == nil)then
		globalRoleDataOutput = round_ID..","..plyID..","..role..","..time.."\n"
	else
		globalRoleDataOutput = globalRoleDataOutput..round_ID..","..plyID..","..role..","..time.."\n"
	end
end

function addPlayerDeath(ply, attacker, dmg)
	local plyID = ply:SteamID64()
	local attackerID 
	local cause
	local time_in_round
	local weapon

	
	if(attacker:IsPlayer()) then
		attackerID = attacker:SteamID64()
		--PrintTable(attacker:GetTable())
	else
		attackerID = attacker:GetName()
	end
	
	
	--print(dmg:GetInflictor())
	cause = dmg:GetDamageType()

	if(cause == 0) then
		cause = "DMG_GENERIC"
	elseif(cause == 1) then
		cause = "DMG_CRUSH"
	elseif(cause == 2) then
		cause = "DMG_BULLET"
	elseif(cause == 4) then
		cause = "DMG_SLASH"
	elseif(cause == 8) then
		cause = "DMG_BURN"
	elseif(cause == 16) then
		cause = "DMG_VEHICLE"
	elseif(cause == 32) then
		cause = "DMG_FALL"
	elseif(cause == 64) then
		cause = "DMG_BLAST"
	elseif(cause == 128) then
		cause = "DMG_CLUB"
	elseif(cause == 256) then
		cause = "DMG_SHOCK"
	elseif(cause == 512) then
		cause = "DMG_SONIC"
	elseif(cause == 1024) then
		cause = "DMG_ENERGYBEAM"
	elseif(cause == 2048) then
		cause = "DMG_PREVENT_PHYSICS_FORCE"
	elseif(cause == 4096) then
		cause = "DMG_NEVERGIB"
	elseif(cause == 8192) then
		cause = "DMG_ALWAYSGIB"
	elseif(cause == 16384) then
		cause = "DMG_DROWN"
	elseif(cause == 32768) then
		cause = "DMG_PARALYZE"
	elseif(cause == 65536) then
		cause = "DMG_NERVEGAS"
	elseif(cause == 131072) then
		cause = "DMG_POISON"
	elseif(cause == 262144) then
		cause = "DMG_RADIATION"
	elseif(cause == 524288) then
		cause = "DMG_DROWNRECOVER"
	elseif(cause == 1048576) then
		cause = "DMG_ACID"
	elseif(cause == 2097152) then
		cause = "DMG_SLOWBURN"
	elseif(cause == 4194304) then
		cause = "DMG_REMOVENORAGDOLL"
	elseif(cause == 8388608) then
		cause = "DMG_PHYSGUN"
	elseif(cause == 16777216) then
		cause = "DMG_PLASMA"
	elseif(cause == 33554432) then
		cause = "DMG_AIRBOAT"
	elseif(cause == 67108864) then
		cause = "DMG_DISSOLVE"
	elseif(cause == 134217728) then
		cause = "DMG_BLAST_SURFACE"
	elseif(cause == 268435456) then
		cause = "DMG_DIRECT"
	elseif(cause == 536870912) then
		cause = "DMG_BUCKSHOT"
	elseif(cause == 1073741824) then
		cause = "DMG_SNIPER"
	elseif(cause == 2147483648) then
		cause = "DMG_MISSILEDEFENSE"
	else
		cause = "DMG_OTHER"
	end
	

	time_in_round = getTimeInRound()

	if(attacker:IsPlayer() == true) then
		if((attacker:GetActiveWeapon()) == nil) then
			weapon = attacker:GetActiveWeapon():GetClass()
		else
			weapon = dmg:GetInflictor():GetClass()
		end
		-- if((attacker:GetActiveWeapon()):GetClass() == nil) then
		-- 	weapon = "No_Weapon_Held"
		-- else
			
		-- end	
	else
		print("ELSE SINERIO")
		print(dmg:GetInflictor():GetClass())
		print(dmg:GetInflictor():GetName())
		if("worldspawn"==dmg:GetInflictor():GetClass())then
			weapon = dmg:GetInflictor():GetClass()
			else
				if (dmg:GetInflictor():IsWeapon() == true) then
				print("inflicter is weapon")
				weapon = inflicter:GetClass()
			elseif(dmg:GetInflictor():IsNPC() == true) then
				print("inflicter is NPC")
				weapon = (inflicter:GetName())
			elseif(dmg:GetInflictor():IsEntity() == true) then
				print("inflicter is NPC")
				weapon = (dmg:GetInflictor():GetClass())
			else
				weapon = dmg:GetInflictor():GetName()
				print("|Other option|")
			end
		end
	end
	
	
	
	print("#")
	print("DEBUGING DEATH RECORDING MARKER")
	print("#")
	-- print(inflicter)
	-- print(attacker)
	-- print(attackerID)
	-- print(cause)
	-- print(weapon)
	print(round_ID)
	print(attackerID)
	print(plyID)
	print(cause)
	print(time_in_round)
	print(weapon)

	if(globalDeathsOutput == nil)then
		globalDeathsOutput = round_ID..","..attackerID..","..plyID..","..cause..","..time_in_round..","..weapon.."\n"
	else
		globalDeathsOutput = globalDeathsOutput..round_ID..","..attackerID..","..plyID..","..cause..","..time_in_round..","..weapon.."\n"
	end
	--file.Write(name, output)
end

function printRoundAndSteamID()
	roundPlayerTable = player.GetAll()
	print(round_ID)
	local output
	local name = round_ID.."_Round_Players"..".txt"
	for k ,v in pairs(roundPlayerTable) do
		local plyID = v:SteamID64()
		addRoleOutput(v)
		if(output == nil) then
			output = round_ID..","..plyID.."\n"
		else
			output = output..round_ID..","..plyID.."\n"
		end
	end
	file.Write(name, output)
end

function getRole(ply)
	return ply.GetRoleString()
end

function printRoundInfo(result)
	local name = round_ID.."_Rounds_"..".txt"
	local resultName
	print("reeeeeeeeeeeeeeeee team "..result.." won")
	if(result == WIN_NONE) then
		resultName = "None"
	elseif(result == WIN_TRAITOR) then
		resultName = "Traitor"
	elseif(result == WIN_INNOCENT) then
		resultName = "Innocent"
	elseif(result == WIN_TIMELIMIT) then
		resultName = "TimeLimit"
	elseif(result == WIN_JESTER) then
		resultName = "Jester"
	elseif(result == WIN_KILLER) then
		resultName = "Killer"
	elseif(result == WIN_BEES) then
		resultName = "Bees"
	else
		resultName = "Other"
	end
	local output = round_ID..","..getTimeInRound()..","..game.GetMap()..","..resultName
	print(output)
	file.Write(name, output)
end

function setRoleTable(playerTbl)
	local roleTable = {}
	for k ,v in pairs(playerTbl) do
		table.insert(roleTable, v:GetRoleString())
	end
	return roleTable
end



function getTimeInRound()
	local time = os.date("%M:%S", os.difftime(CurTime(), unixTime))
	return time
end
updateRoundInfo()
printRoundAndSteamID()
print("end!")