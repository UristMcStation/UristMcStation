//For Vactor

#define DONATE "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FP35B3S54PLEQ"
/client/verb/donate()
	set name = "Donate"
	set desc = "Donate to help with server costs."
	set hidden = 1

	if(alert("This will open the donate link in your browser. Are you sure?",,"Yes","No")=="No")
		return
	src << link(DONATE)
	return
#undef DONATE