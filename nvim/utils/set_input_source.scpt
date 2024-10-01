-- Switch input source between English and Japanese
on set_input_source(lang)
	tell application "System Events"
		if lang = "en" then
			key code 102 -- English
		else if lang = "jp" then
			key code 104 -- Japanese
		end if
	end tell
end set_input_source

-- Call the function with the argument passed from the shell script
on run argv
	set lang to item 1 of argv
	set_input_source(lang)
end run

