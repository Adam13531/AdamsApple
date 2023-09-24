on run {input, parameters}
	tell application "System Events"
		keystroke "("
		keystroke "r"
		keystroke "e"
		keystroke "f"
		keystroke "e"
		keystroke "r"
		keystroke "e"
		keystroke "n"
		keystroke "c"
		keystroke "e"
		keystroke ")"
		key code 123 -- send left arrow
		key code 123 using {option down, shift down} -- highlight last word
		keystroke "k" using command down -- open convert-to-link dialog
		delay 0.4
		keystroke "v" using command down -- paste
		delay 0.1
		key code 36 -- enter
		key code 124 -- send ?
		key code 124 -- send ? to go beyond the right paren
	end tell
	return input
end run
