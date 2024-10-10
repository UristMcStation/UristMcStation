//For Vactor //Payments go to Glloyd now

#define DONATE "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=TXECE4EB7E22G&source=url"
/client/verb/donate()
	set name = "Donate"
	set desc = "Donate to help with server costs."
	set hidden = 1

	if(alert("This will open the donate link in your browser. Are you sure?",,"Yes","No")=="No")
		return
	send_link(src, DONATE)
	return
#undef DONATE
