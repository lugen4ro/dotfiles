local M = {}

-----------------------------------------------------------------------------
-- String manipulation
-----------------------------------------------------------------------------

--- Split string by character
---@param str string string to split
---@param sep string seperator
---@return table tab Table of parts
M.split = function(str, sep)
	if sep == nil then
		sep = "%s"
	end
	local tab = {}
	for part in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(tab, part)
	end
	return tab
end

-----------------------------------------------------------------------------
-- Filesystem operation
-----------------------------------------------------------------------------

-- Check if directory exists
-- TODO: Probably also matches files... need tofix
M.directory_exists = function(path)
	-- Rename directory to itself. If it exists it should return True else False
	local success, error_message, error_code = os.rename(path, path)
	if not success then
		if error_code == 13 then
			-- Permission denied, but directory exists
			return true
		end
		-- Other error, directory does not exist
		return false
	end
	return true
end

-- Check if file exists
M.file_exists = function(path)
	local f = io.open(path, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

return M
