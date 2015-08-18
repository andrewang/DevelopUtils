

local Utils = {}

function Utils.dump(t)
	for k,v in pairs(t) do
		print(k,"=",v)

		if type(v) == "table" then
			print("{")

			for k,v in pairs(v) do
				print("", k,"=",v)
			end

			print("}")
		end
	end
end

function Utils.split(str, pattern)
	local strs = {}

	local index = 0
	local preIndex = 0
	while true do
		index = str:find(pattern, index+1)
		
		if index ~= nil then
			local s = str:sub(preIndex+1, index-1)
			strs[#strs + 1] = s
			
			preIndex = index
		else
			local s = str:sub(preIndex+1)
			strs[#strs + 1] = s

			break
		end
	end

	return strs
end

function Utils.log(formatString, ...)
	print(string.format(formatString, ...))
end

function Utils.errorLog(formatString, ...)
	print("\n----------error-----------")
	Utils.log(formatString, ...)
	print("--------------------------\n")
end

return Utils



