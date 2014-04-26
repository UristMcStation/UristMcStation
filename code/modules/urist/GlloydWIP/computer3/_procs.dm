//stuff

#define PROG_CRASH      1  // Generic crash
#define MISSING_PERIPHERAL  2  // Missing hardware
#define BUSTED_ASS_COMPUTER  4  // Self-perpetuating error.  BAC will continue to crash forever.
#define MISSING_PROGRAM    8  // Some files try to automatically launch a program.  This is that failing.
#define FILE_DRM      16  // Some files want to not be copied/moved.  This is them complaining that you tried.
#define NETWORK_FAILURE  32

/proc/topic_link(var/datum/D, var/arglist, var/content)
	if(istype(arglist,/list))
		arglist = list2params(arglist)
	return "<a href='?src=\ref[D];[arglist]'>[content]</a>"

/datum/browser/proc/set_title_buttons(ntitle_buttons)
	title_buttons = ntitle_buttons

/datum/browser/proc/set_title(ntitle)
	title = format_text(ntitle)