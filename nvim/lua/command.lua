-- Move cwd to current buffer's directory
vim.api.nvim_create_user_command("Cdb", "cd %:p:h", {
	desc = "Change directory to current buffer's directory",
})

-------------------- Custom commands --------------------

-- Copy path to file from git root, including git root (if no git repo, copy full path)
vim.api.nvim_create_user_command("CopyPath", function()
	-- Get the absolute path of the current file
	local file_path = vim.fn.expand("%:p")
	-- Get the Git repository root
	local git_root_path = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	print(git_root_path)

	-- If we are not in a Git repo, default to full file path
	if git_root_path == nil or git_root_path == "" then
		vim.fn.setreg("+", file_path)
		return
	end

	local git_root_name = git_root_path:match("([^/]+)$")

	-- Get the relative path from the Git root (including git root)
	local relative_path = file_path:sub(#git_root_path + 2)
	local relative_path_including_git_root = git_root_name .. "/" .. relative_path

	-- Copy the modified path to the clipboard (surround with `` for notion & slack formatting)
	vim.fn.setreg("+", "`" .. relative_path_including_git_root .. "`")
end, {})

-- AtCoder - Save contest problem in appropriate folder with appropriate name
-- Ex) :Con BC321 A - Increasing Subsequence ----> contest/BC321_A_-_Increasing_Subsequence.cpp
vim.api.nvim_create_user_command("CON", function(args)
	-- args.args --> single string of all arguments
	-- args.fargs --> table of all arguments

	local utils = require("utils")

	-- Extract contest and problem from arguments
	local contest, problem = string.match(args.args, "([^ ]+) (.+)")

	-- Process problem string
	problem = string.gsub(problem, " ", "_")
	problem = string.gsub(problem, "/", "_")

	-- Create contest directory if it doesn't exist
	local dir_path = "/home/gen4ro/code/dsa/cpp/atcoder/contest/" .. contest
	if not utils.directory_exists(dir_path) then
		os.execute("mkdir " .. dir_path)
		print("Created directory -> " .. dir_path)
	end

	-- If file exists already, ask for confirmation
	local full_path = dir_path .. "/" .. problem .. ".cpp"
	if utils.file_exists(full_path) then
		local confirm = vim.fn.input("File already exists. Overwrite? (y/n) > ")
		if confirm ~= "y" then
			print("   ... Aborted")
			return
		end
	end

	-- Save file
	vim.cmd("silent write! " .. full_path)
	print("Saved --> " .. full_path)
end, {
	nargs = "*", -- By default doesn't accept any arguments. This changes that.
	desc = "Save current buffer in the contest folder with the right name",
})

-- Delta
vim.api.nvim_create_user_command("Delta", "tab Git -c pager.diff=delta diff", {
	desc = "Execute delta to show all diffs in current repo",
})
