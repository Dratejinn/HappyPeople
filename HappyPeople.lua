--lua code for Wow-addon
--Created by Dratéjinn
--Maintained by Dratéjinn


--local variables
local version = "0.7"
local name = ""
local rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile
local index = 0
local flag = 0 --guild roster update event
local debug = false
--end local variables

print("|cFF4169E1Happy People|r Version: |cFF4169E1".. version.. "|r loaded!")
local frame = CreateFrame("FRAME", "HappyPeopleFrame")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("GUILD_ROSTER_UPDATE")

local function eventHandler(self, event, ...)

	if event == "PLAYER_ENTERING_WORLD" then
		GuildRoster() --request data to make sure we are updating
		flag = 0
		HPDebugPrint("Player entered world update for guildroster requested!")
	elseif event == "GUILD_ROSTER_UPDATE" then
		if flag == 0 then
			flag = 1
			HPDebugPrint("Getting new Data!")
			HPgetPlayerData()
		end
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		if flag == 1 then
			HPDebugPrint("equipment changed requesting update!")
			HPgetPlayerData()
		else
			HPDebugPrint("equipment changed requesting new guildroster info!")
			GuildRoster()
		end
	end
end

frame:SetScript("OnEvent", eventHandler)


function HPgetPlayerData()

	if IsInGuild() then
		
		local playerName = UnitName("player")
		local dataValid = true
		index = 0
		name = nil
		while name ~= playerName and dataValid == true do
		  	index = index + 1
			name, rank, rankIndex, level, class, zone, note, 
		  	officernote, online, status, classFileName, 
		  	achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(index)
		  	if name ~= nil then
		  		name = HPtokenizer(name, "-")
		  		HPDebugPrint("Index= "..index)
		  	else
		  		dataValid = false
		  		flag = 0
		  		HPDebugPrint("No valid data!")
		  	end
		end
		if CanEditPublicNote() then
			if dataValid == true then
				local overall, equipped = GetAverageItemLevel()
				if (string.find(note, "[%d]+") ~= nil) then
					HPDebugPrint("updating ilvl data!")
					local saveString = string.gsub(note, "[%d]+", math.floor(overall))
					GuildRosterSetPublicNote(index, saveString)
				else
					HPDebugPrint("setting ilvl data! and index= "..index )
					if (string.len(note) < 22) then
						note = note .. " - ilvl:" .. math.floor(overall)
					elseif (string.len(note) < 29) then
						note = note .. " " .. math.floor(overall)
					else
						print("Can't update note because the note is too full!")
					end
					GuildRosterSetPublicNote(index, note)
				end
			else
				HPDebugPrint("Datavalid is false!")
			end
		else
			HPDebugPrint("cannot set public note!")
		end
	end

end


function HPtokenizer(string, delim)
	if (string ~= nil and delim ~= nil) then
		local i= string.find(string, delim)
		if i == nil then
			HPDebugPrint("Error : no delim char found!")
			return string
		else
			-- print(string.sub(string, 1, i - 1))
			return string.sub(string, 1, i - 1)
		end
	end
end

function HPDebugPrint(str)
	if debug == true then
		print(str)
	end
end