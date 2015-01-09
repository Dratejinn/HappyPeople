--lua code for Wow-addon
--Created by Dratéjinn
--Maintained by Dratéjinn


--local variabels
local name = ""
local rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile
local index = 0
--end local variabels

local frame = CreateFrame("FRAME", "HappyPeopleFrame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")


local function eventHandler(self, event, ...)

	print("Freek is Awesome!")
	print("als er fouten zijn in deze Add-on bel me ff!")
	local playerName = UnitName("player")
	while name ~= playerName do
	  	index = index + 1
		name, rank, rankIndex, level, class, zone, note, 
	  	officernote, online, status, classFileName, 
	  	achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(index);

	  	name = tokenizer(name, "-")
	end


	if CanEditPublicNote() then
		local overall, equipped = GetAverageItemLevel()
		if (string.find(note, "%d%d%d") ~= nil) then
			local saveString = string.gsub(note, "%d%d%d", math.floor(overall))
			GuildRosterSetPublicNote(index, saveString)
		else
			GuildRosterSetPublicNote(index, note .. " - iLvl:" .. math.floor(overall))
		end
	else
		print("cannot set public note!")
	end


end

frame:SetScript("OnEvent", eventHandler)



function tokenizer(string, delim)
	if (string ~= nil and delim ~= nil) then
		local i= string.find(string, delim)
		if i == nil then
			print("Error : no delim char found!")
			return string
		else
			return string.sub(string, 1, i - 1)
		end
	end
end
