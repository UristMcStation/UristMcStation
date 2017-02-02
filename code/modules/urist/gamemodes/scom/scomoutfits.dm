/decl/hierarchy/outfit/scom
	hierarchy_type = /decl/hierarchy/outfit/scom //hidden
	name = "S-COM Member"
	l_ear = /obj/item/device/radio/headset
	pda_type = null
	uniform = /obj/item/clothing/under/urist/scom //assures they have SOME jumpsuit
	id_type = /obj/item/weapon/card/id/centcom //ditto, ID
	pda_slot = null

/decl/hierarchy/outfit/scom/pre_equip(mob/living/carbon/human/H)
	..(H)
	if(H.species == "Unathi")
		shoes = /obj/item/clothing/shoes/jackboots/unathi
	if(H.disabilities)
		glasses = /obj/item/clothing/glasses/regular

/decl/hierarchy/outfit/scom/scommander
	name = "S-COM Commander"
	uniform = /obj/item/clothing/under/rank/centcom
	suit = /obj/item/clothing/suit/captunic
	belt = /obj/item/weapon/storage/fancy/cigarettes
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/caphat/formal
	mask = /obj/item/clothing/mask/smokable/cigarette
	l_ear = /obj/item/device/radio/headset/heads/captain
	l_pocket = /obj/item/weapon/pen
	r_pocket = /obj/item/weapon/flame/lighter/zippo
	id_pda_assignment = "Commander"
	id_type = /obj/item/weapon/card/id/centcom

/decl/hierarchy/outfit/scom/scomscientist
	name = "S-COM Researcher"
	l_ear = /obj/item/device/radio/headset/heads/captain
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	gloves = /obj/item/clothing/gloves/latex
	back = /obj/item/weapon/storage/backpack/toxins
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	id_pda_assignment = "Researcher"
	r_pocket = null

/decl/hierarchy/outfit/scom/squaddie
	hierarchy_type = /decl/hierarchy/outfit/scom/squaddie
	var/team1uniform = /obj/item/clothing/under/urist/scom/s1
	var/team2uniform = /obj/item/clothing/under/urist/scom/s2
	var/team3uniform = /obj/item/clothing/under/urist/scom/s3
	var/team4uniform = /obj/item/clothing/under/urist/scom/s4

/decl/hierarchy/outfit/scom/squaddie/equip(mob/living/carbon/human/H, var/rank, var/assignment, var/teamnum)
	if(teamnum)
		if(teamnum == 1)
			uniform = team1uniform
		if(teamnum == 2)
			uniform = team2uniform
		if(teamnum == 3)
			uniform = team3uniform
		if(teamnum == 4)
			uniform = team4uniform
	else
		uniform = /obj/item/clothing/under/urist/scom
	..(H, null, null, null)

/decl/hierarchy/outfit/scom/squaddie/scomofficer
	name = "S-COM Officer"
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/swat
	belt = /obj/item/weapon/storage/belt/urist/military/scom
	head = /obj/item/clothing/head/beret/centcom/captain
	r_pocket = /obj/item/weapon/gun/projectile/silenced/knight
	suit = /obj/item/clothing/suit/armor/vest/deus_blueshield
	l_hand = /obj/item/weapon/gun/projectile/automatic/c20r
	r_hand = /obj/item/weapon/storage/box/c20ammo
	id_pda_assignment = "S-COM Officer"
	team1uniform = /obj/item/clothing/under/urist/scom/s1l
	team2uniform = /obj/item/clothing/under/urist/scom/s2l
	team3uniform = /obj/item/clothing/under/urist/scom/s3l
	team4uniform = /obj/item/clothing/under/urist/scom/s4l

/decl/hierarchy/outfit/scom/squaddie/scomgrunt
	name = "S-COM Operative"
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	belt = /obj/item/weapon/storage/belt/urist/military/scom
	head = /obj/item/clothing/head/beret/sec/navy/officer
	r_pocket = /obj/item/weapon/gun/projectile/silenced/knight
	id_pda_assignment = "S-COM Operative"

//fuck it all, I'm just giving out presets in lockers for now, remove once equipping actually fucking works
/obj/structure/closet/secure_closet/personal/scom
	name = "S-COM personal closet"
	desc = "It's a secure locker for S-COM personnel."

/obj/structure/closet/secure_closet/personal/scom/grunt
	name = "S-COM personal closet (Operatives)"
	desc = "It's a secure locker for S-COM Operatives."

/obj/structure/closet/secure_closet/personal/scom/grunt/New()
	..()
	spawn(2)
		new /obj/item/device/radio/headset(src)
		new /obj/item/clothing/shoes/swat(src)
		new /obj/item/clothing/gloves/thick/swat(src)
		new /obj/item/weapon/storage/belt/urist/military/scom(src)
		new /obj/item/clothing/head/beret/sec/navy/officer(src)
		new /obj/item/weapon/gun/projectile/silenced/knight(src)
		new /obj/item/clothing/shoes/jackboots/unathi(src)
		new /obj/item/clothing/glasses/regular(src)
		new /obj/item/clothing/under/urist/scom(src)

	return

/obj/structure/closet/secure_closet/personal/scom/officer
	name = "S-COM personal closet (Officers)"
	desc = "It's a secure locker for S-COM Officers."

/obj/structure/closet/secure_closet/personal/scom/officer/New()
	..()
	spawn(2)
		new /obj/item/device/radio/headset(src)
		new /obj/item/clothing/shoes/swat(src)
		new /obj/item/clothing/gloves/thick/swat(src)
		new /obj/item/weapon/storage/belt/urist/military/scom(src)
		new /obj/item/clothing/head/beret/centcom/captain(src)
		new /obj/item/weapon/gun/projectile/silenced/knight(src)
		new /obj/item/clothing/suit/armor/vest/deus_blueshield(src)
		new /obj/item/weapon/gun/projectile/automatic/c20r(src)
		new /obj/item/weapon/storage/box/c20ammo(src)
		new /obj/item/clothing/shoes/jackboots/unathi(src)
		new /obj/item/clothing/glasses/regular(src)
		new /obj/item/clothing/under/urist/scom(src)
	return

/obj/structure/closet/secure_closet/personal/scom/researcher
	name = "S-COM personal closet (MedSci)"
	desc = "It's a secure locker for S-COM Researchers."

/obj/structure/closet/secure_closet/personal/scom/researcher/New()
	..()
	spawn(2)
		new /obj/item/device/radio/headset/heads/captain(src)
		new /obj/item/clothing/under/rank/scientist(src)
		new /obj/item/clothing/shoes/white(src)
		new /obj/item/weapon/storage/backpack/toxins(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat/science(src)
		new /obj/item/clothing/shoes/jackboots/unathi(src)
		new /obj/item/clothing/glasses/regular(src)

/obj/structure/closet/secure_closet/personal/scom/commander
	name = "S-COM personal closet (Commander)"
	desc = "It's a secure locker for the Commander. Bow before its Commandiness."
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

/obj/structure/closet/secure_closet/personal/scom/commander/New()
		new /obj/item/clothing/under/rank/centcom(src)
		new /obj/item/clothing/suit/captunic(src)
		new /obj/item/clothing/shoes/laceup(src)
		new /obj/item/weapon/pen(src)
		new /obj/item/device/radio/headset/heads/captain(src)
		new /obj/item/clothing/mask/smokable/cigarette(src)
		new /obj/item/clothing/head/caphat/formal(src)
		new /obj/item/weapon/storage/fancy/cigarettes(src)
		new /obj/item/weapon/flame/lighter/zippo(src)
		new /obj/item/clothing/shoes/jackboots/unathi(src)
		new /obj/item/clothing/glasses/regular(src)
