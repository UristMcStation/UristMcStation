/*
 *	disintegratable.dm - modules/urist/modules/organs
 *
 * 	can_disintegrate is used in _external.dm in modules/organs/external
 *
 * 	can_disintegrate is defined in this file returns 1 by default
 *
 * 	Currently used mainly to nerf disintegration of certain essential player organs like;
 *		* Neural lace					(modules/organs/internal/stack.dm)
 *		* MMI holders for FBPs			(modules/organs/internal/species/fbp.dm)
 *		* Synthetic brains for IPCs		(modules/organs/internal/species/ipc.dm)
 *
 * 	Created in 2019-05-25 by Irra
 */

/obj/item/organ/proc/can_disintegrate()
	return 1

#define URIST_ESSENTIAL_ORGAN_DISINTEGRATABLE 0

/obj/item/organ/internal/posibrain/can_disintegrate()
	return URIST_ESSENTIAL_ORGAN_DISINTEGRATABLE

/obj/item/organ/internal/mmi_holder/can_disintegrate()
	return URIST_ESSENTIAL_ORGAN_DISINTEGRATABLE

/obj/item/organ/internal/stack/can_disintegrate()
	return URIST_ESSENTIAL_ORGAN_DISINTEGRATABLE

#undef URIST_ESSENTIAL_ORGAN_DISINTEGRATABLE