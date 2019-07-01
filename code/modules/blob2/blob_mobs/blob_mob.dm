////////////////
// BASE TYPE //
////////////////

//Do not spawn
/mob/living/simple_animal/hostile/blob
	icon = 'icons/mob/blob.dmi'
	pass_flags = PASS_FLAG_BLOB | PASS_FLAG_TABLE
	faction = "blob"
	speak_emote = null //so we use verb_yell/verb_say/etc
	minbodytemp = 0
	maxbodytemp = 360

	var/mob/observer/blob/overmind = null
	var/obj/structure/blob/factory/factory = null

/mob/living/simple_animal/hostile/blob/update_icons()
	if(overmind)
		color = overmind.blob_type.complementary_color
	else
		color = null

/mob/living/simple_animal/hostile/blob/Destroy()
	if(overmind)
		overmind.blob_mobs -= src
	return ..()

/mob/living/simple_animal/hostile/blob/blob_act(obj/structure/blob/B)
	if(!overmind && B.overmind)
		overmind = B.overmind
		update_icon()

	if(stat != DEAD && health < maxHealth)
		adjustBruteLoss(-maxHealth*0.0125)
		adjustFireLoss(-maxHealth*0.0125)

/mob/living/simple_animal/hostile/blob/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/structure/blob)) // Don't block blobs from expanding onto a tile occupied by a blob mob.
		return TRUE
	return ..()
/*
/mob/living/simple_animal/hostile/blob/Process_Spacemove()
	for(var/obj/structure/blob/B in range(1, src))
		return TRUE
	return ..()
*/