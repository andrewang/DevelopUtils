--
-- converter config file from csv to lua
--
--
--

require("lc")
--print(lc.help())

local Utils = require("Utils")

local Converter = {}


local LINE_NUM_KEY     = 1
local LINE_NUM_EXPLAIN = 2
local LINE_NUM_VALUE   = 3

local PATTERN = ","

local JOINT_MODE_NOT_JOINT = 1
local JOINT_MODE_JOINT     = 2

local strTab = "	"

local KEY_MODE_NUM    = "[%s] = "
local KEY_MODE_STRING = "[\"%s\"] = "

local LINE_BREAK = "\n"


function Converter.readCsv(filename)
	local lines = {}

	-- read file
	local file = io.open("csv/" .. filename .. ".csv", 'r')
	if not file then
		Utils.errorLog("can not open csv/%s.csv", filename)

		return lines
	end

	-- 处理记录每行字符
	for line in file:lines() do
		-- 将读取到的ansi字符串转换为utf8格式
		local line = lc.a2u(line)

		-- 删除多余的"\0"结尾
		local index = line:find("\0")
	 	line = line:sub(1, index-1)

		lines[#lines + 1] = line
	end

	file:close()
	return lines
end

-- 将过度切分的Value加回来
local function jointOverSplitValues(strs, patternBegan, patternEnd)
	local values = {}
	local mode = JOINT_MODE_NOT_JOINT
	local appendStrs = nil

	for _, str in ipairs(strs) do
		if mode == JOINT_MODE_NOT_JOINT then
			if not str:find("^" .. patternBegan) then
				values[#values + 1] = str
			else
				mode = JOINT_MODE_JOINT
				appendStrs = {}
				appendStrs[#appendStrs + 1] = str
			end
		else
			if not str:find(patternEnd .. "$") then
				appendStrs[#appendStrs + 1] = str
			else
				appendStrs[#appendStrs + 1] = str
				mode = JOINT_MODE_NOT_JOINT

				local value = table.concat(appendStrs, ",")

				if patternBegan == "\"" then
					value = value:sub(2, -2)
				end

				values[#values + 1] = value
			end
		end
	end

	return values
end

function Converter.convertLinesToTable(lines)
	local config = {}
	local keys   = nil

	-- 读取keys
	local lineKey = lines[LINE_NUM_KEY]
	if lineKey then
		keys = Utils.split(lineKey, PATTERN)
	else
		Utils.errorLog("can not get key line")

		return config
	end
	
	-- 读取values
	for n=LINE_NUM_VALUE, #lines do
		local lineValue = lines[n]
		if lineValue then
			local strs = Utils.split(lineValue, PATTERN)

			local values = jointOverSplitValues(strs, "\"", "\"")

			local entity = {}
			for i, value in ipairs(values) do
				local key = keys[i]

				if key then
					entity[key] = value
				end
			end

			if entity.id then
				config[entity.id] = entity
			end
		end
	end

	return config
end

local function writeFileMsg(file, filename)
	if file and file.write then
		local programmerName = "Carl"
		local projectName    = "csv2lua"
		local createTime     = os.date("%x")
		local copyrightYear  = os.date("%Y")

		file:write("--\n")
		file:write("-- ", filename,".lua\n")
		file:write("-- ", projectName,"\n")
		file:write("--\n")
		file:write("-- ", "Created by ", programmerName, " on ", createTime, ".\n")
		file:write("-- ", "Copyright (c) ", copyrightYear, " ", programmerName, ". All rights reserved.\n")
		file:write("--\n\n")
	end
end

function Converter.writeKeyValue(file, config, compressed, tabNum)
	for key, value in pairs(config) do
		local keyPart = ""
		local valuePart = ""

		if tonumber(key) then
			keyPart = string.format(KEY_MODE_NUM, key)
		else
			keyPart = string.format(KEY_MODE_STRING, key)
		end

		file:write(strTab:rep(tabNum), keyPart)

		if tonumber(value) then
			valuePart = value

		elseif type(value) == "table" then
			Converter.writeTable(file, value, compressed, tabNum + 1)

		elseif type(value) == "string" then
			local firstChar = value:sub(1, 1)

			if firstChar == "[" then
				local str  = value:sub(2, -2)
				local strs = Utils.split(str, PATTERN)

				if str:find("%[") then
					strs = jointOverSplitValues(strs, "%[", "]")
				elseif str:find("{") then
					strs = jointOverSplitValues(strs, "{", "}")
				end

				Converter.writeTable(file, strs, compressed, tabNum + 1)

			elseif firstChar == "{" then
				local str = value:sub(2, -2)
				local strs = Utils.split(str, PATTERN)

				if str:find("%[") then
					strs = jointOverSplitValues(strs, "%[", "]")
				elseif str:find("{") then
					strs = jointOverSplitValues(strs, "{", "}")
				end

				local t = {}
				for _, valueStr in ipairs(strs) do
					local keyValue = Utils.split(valueStr, "=")
					if #keyValue == 2 then
						t[keyValue[1]] = keyValue[2]
					end
				end

				local t = jointOverSplitValues(strs, "{", "}")
				Converter.writeTable(file, t, compressed, tabNum + 1)

			else
				valuePart = "\"" .. value .. "\""

			end
		end

		file:write(valuePart, ",", LINE_BREAK)
	end
end

function Converter.writeTable(file, config, compressed, tabNum)
	file:write("{", LINE_BREAK)

	if compressed ~= true then
		tabNum = tabNum or 1
	else
		tabNum = 0
	end

	Converter.writeKeyValue(file, config, compressed, tabNum)

	file:write(strTab:rep(tabNum - 1), "}")
end

function Converter.writeTableToLuaFile(config, filename, compressed)
	local file = io.open("lua/" .. filename .. ".lua", 'w')

	if not file then
		Utils.errorLog("can not open lua/%s.lua", filename)

		return
	end

	-- write File Msg
	if compressed ~= true then
		writeFileMsg(file, filename)
		LINE_BREAK = "\n"
	else
		LINE_BREAK = ""
	end

	-- write config
	-- begin
	file:write("local ", filename, " = ")

	-- config
	Converter.writeTable(file, config, compressed)
	
	-- end
	file:write(LINE_BREAK, LINE_BREAK)
	file:write("return ", filename, LINE_BREAK)
	file:write(LINE_BREAK)

	file:close()
end

function Converter.converteCsvToLua(filename, compressed)
	-- filename
	if type(filename) ~= "string" then
		Utils.errorLog("bad argument #1 to 'Converter.converteCsvToLua' (string expected, got %s)",
			type(filename))

		return
	end

	-- filename Without Postfix
	local postfixBeginIndex = filename:find("\.csv$")
	local filenameWithoutPostfix = nil

	if postfixBeginIndex then
		filenameWithoutPostfix = filename:sub(1, postfixBeginIndex - 1)
	else
		filenameWithoutPostfix = filename
	end

	-- Converte
	if filenameWithoutPostfix then
		local lines = Converter.readCsv(filenameWithoutPostfix)

		local config = Converter.convertLinesToTable(lines)

		Converter.writeTableToLuaFile(config, filenameWithoutPostfix, compressed)

		Utils.log("%s.csv done", filenameWithoutPostfix)

	else
		Utils.log("filename:%s error", filename)
	end
end

local file = io.open("lua/registry.lua", "w")
local config = {
	["sign_in.days_3"] = {
		["type"] = 2,
		["id"] = "sign_in.days_3",
		["value"] = "[[1,10,0],[2,100000,0]]", --"[{a=1,b=10,c=0},{a=2,b=100000,c=0}]",
		["group"] = "",
		["desc"] = "",
	}
}

Converter.writeTable(file, config)
file:close()
return Converter

