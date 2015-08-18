--
--
-- 批量生成转换csv to lua
--
--

-- lua file system
require "lfs"

local Converter = require("Converter")

local function getCsvFilenames(filePath)
	local filenames = {}

	for filename in lfs.dir(filePath) do
		local fileAttr = lfs.attributes(filePath .. "/" .. filename)

		if fileAttr.mode == "file" and filename:find("\.csv$") then
			filenames[#filenames + 1] = filename
		end
	end

	return filenames
end

-- 1.获取csv文件列表
local csvFilePath = lfs.currentdir() .. "/csv"
local fileNames = getCsvFilenames(csvFilePath)

-- 2.转换csv to lua
for _, fileName in ipairs(fileNames) do
	Converter.converteCsvToLua(fileName)
end

print("---------all done----------")











