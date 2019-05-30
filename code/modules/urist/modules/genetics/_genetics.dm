// Goon muts
#define M_OBESITY       200		// Decreased metabolism
#define M_STRONG        202		// (Nothing)
#define M_SOBER         203		// Increased alcohol metabolism
#define M_PSY_RESIST    204		// Block remoteview

// Disabilities
var/LISPBLOCK = 0
var/MUTEBLOCK = 0
var/RADBLOCK = 0
var/FATBLOCK = 0
var/CHAVBLOCK = 0
var/SWEDEBLOCK = 0
var/SCRAMBLEBLOCK = 0
//var/TOXICFARTBLOCK = 0
var/HORNSBLOCK = 0

// Powers
var/SOBERBLOCK = 0
var/PSYRESISTBLOCK = 0
var/SHADOWBLOCK = 0
//var/CHAMELEONBLOCK = 0
var/CRYOBLOCK = 0
var/EATBLOCK = 0
var/JUMPBLOCK = 0
//var/MELTBLOCK = 0
var/EMPATHBLOCK = 0
//var/SUPERFARTBLOCK = 0
//var/IMMOLATEBLOCK = 0
//var/POLYMORPHBLOCK = 0
var/NOIRBLOCK = 0

//////////////////////////////////////
//important from vg for shit to work//
//////////////////////////////////////

//Attaches each element of a list to a single string seperated by 'seperator'.
/proc/dd_list2text(var/list/the_list, separator)
	var/total = the_list.len
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