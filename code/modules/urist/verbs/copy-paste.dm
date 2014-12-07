client/var/clipboard

atom/proc/copy() // Copy Proc
	set category = "Fun"
	set name = "Copy"
	set desc = "(target) Copy a instance of an atom"

	if(!check_rights(R_VAREDIT))	return // People who change variables should be able to make copies of their variables

	if(!src) // Returns if there is nothing in in the selection
		return

	if(usr.clipboard)
		switch(alert(usr, "You have something in your clipboard, would you like to continue?",,"Yes", "No"))
			if("No")
				return

	usr.clipboard = src

atom/proc/paste()
	set name = "Paste"
	set category = "Object"
	set src in oview()