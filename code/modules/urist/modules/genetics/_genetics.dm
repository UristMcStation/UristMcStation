// Goon muts
#define M_OBESITY       200		// Decreased metabolism
#define M_STRONG        202		// (Nothing)
#define M_SOBER         203		// Increased alcohol metabolism
#define M_PSY_RESIST    204		// Block remoteview

// Disabilities
GLOBAL_VAR(LISPBLOCK)
GLOBAL_VAR(MUTEBLOCK)
GLOBAL_VAR(RADBLOCK)
GLOBAL_VAR(FATBLOCK)
GLOBAL_VAR(CHAVBLOCK)
GLOBAL_VAR(SWEDEBLOCK)
GLOBAL_VAR(SCRAMBLEBLOCK)
//var/TOXICFARTBLOCK
GLOBAL_VAR(HORNSBLOCK)

// Powers
GLOBAL_VAR(SOBERBLOCK)
GLOBAL_VAR(PSYRESISTBLOCK)
GLOBAL_VAR(SHADOWBLOCK)
//var/CHAMELEONBLOCK
GLOBAL_VAR(CRYOBLOCK)
GLOBAL_VAR(EATBLOCK)
GLOBAL_VAR(JUMPBLOCK)
//var/MELTBLOCK
GLOBAL_VAR(EMPATHBLOCK)
//var/SUPERFARTBLOCK
//var/IMMOLATEBLOCK
//var/POLYMORPHBLOCK
GLOBAL_VAR(NOIRBLOCK)

//////////////////////////////////////
//important from vg for shit to work//
//////////////////////////////////////

//Attaches each element of a list to a single string seperated by 'seperator'.
/proc/dd_list2text(list/the_list, separator)
	var/total = length(the_list)
	if(!total)
		return
	var/count = 2
	var/newText = "[the_list[1]]"
	while(count <= total)
		if(separator)
			newText += separator
		newText += "[the_list[count]]"
		count++
	return newText

//more important shit

var/global/list/good_blocks[0]
var/global/list/bad_blocks[0]
