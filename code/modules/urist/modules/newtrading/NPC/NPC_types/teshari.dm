/mob/living/simple_animal/passive/npc/teshari
	name = "teshari"
	desc = "A teshari who decided to try their luck amongst the stars."
	icon = 'code/modules/urist/modules/newtrading/NPC/npc.dmi'
	icon_state = "Teshari_m"

	species_type = /datum/species/teshari
	say_list_type = /datum/say_list/teshari
	speech_triggers = list(/datum/npc_speech_trigger/teshari/teshari, /datum/npc_speech_trigger/teshari/skrell, /datum/npc_speech_trigger/teshari/qerrbalak)

/datum/say_list/teshari
	emote_hear = list("coughs","sneezes","sniffs","clears their throat","whistles tunelessly","sighs deeply","yawns", "chirps")
	emote_see = list("shifts from side to side.","scratches their arm.","flaps their wings casually.","stares at at the ground aimlessly.","looks bored.","places their hands in their pockets.","stares at you with a blank expression.","scratches their muzzle.")
	speak = list("Man, I could go for a meatpizza...", "Have you ever been to Qerr'balak? It's... Nice. It still bears the scars of the Galactic Crisis though.", "Wow, it's warm... I could take a nap.", "Someone was trying to pet me earlier so I bit their hand.",\
	"Fastest way to a Teshari's heart is through their stomach. We eat more than our stature would suggest.", "I see a lot of ship-board Teshari adults acting like children to drum up sympathy. We're pack hunters, not pets.")

/mob/living/simple_animal/passive/npc/teshari/New()
	desc = "This is [src]. [initial(desc)]."
	..()

/datum/npc_speech_trigger/teshari
	response_phrase = 1

/datum/npc_speech_trigger/teshari/get_response_phrase()
	return pick(responses)

/datum/npc_speech_trigger/teshari/teshari
	name = "Teshari"
	trigger_word  = "Teshari"

/datum/npc_speech_trigger/teshari/teshari/New()
	..()
	responses = list(\
		"We Teshari have exceptional hearing and low-light vision. Makes us perfect for working maintenance tunnels on ships.",\
		"Fastest way to a Teshari's heart is through their stomach. We eat more than our stature would suggest.",\
		"Teshari usually don't ask for much pay. We make do with less, it's just our way and it gets us work.",\
		"The savvy Teshari are usually quick thinkers, quick runners or quick on the draw. We have to play to our strengths.",\
		"Spaceborn Teshari returning to Qerr'balak are changing things. They're disruptive to the homeworld packs.",\
		"I see a lot of ship-board Teshari adults acting like children to drum up sympathy. We're pack hunters, not pets.",\
		"Teshari are small and frail compared to other species, we either make up the difference in skill, or in packs.",\
		"We rely far too much on the kindness of other species, the Skrell especially. A gilded cage is still a cage.")

/datum/npc_speech_trigger/teshari/skrell
	name = "Skrell"
	trigger_word  = "Skrell"

/datum/npc_speech_trigger/teshari/skrell/New()
	..()
	responses = list(\
		"The Skrell gave us a leg up into the galaxy. We're better off than we've ever been thanks to them.",\
		"I don't understand how the Skrell live in such small families, it must be lonely.",\
		"If the Crisis had come to Qerr'Balak without the Skrell by our side, we'd be extinct.",\
		"The Kanin-Katish Skrell understand Teshari packs the best. They put the whole above themselves.",\
		"The Skrell are coddling us, holding us back and that's not set to change. We're nothing but children to them.",\
		"Skrell talk of their society being open to progress, but they're helplessly set in their ways. Teshari don't fit among them.",\
		"The Teshari are ready to be given autonomy and settle the tundra worlds in Skrell space. Why haven't they let us?",\
		"No one will ever let us forget that the Skrell gave us everything. I wish we'd had the chance to get here ourselves.")

/datum/npc_speech_trigger/teshari/qerrbalak
	name = "Qerr'Balak"
	trigger_word  = "Qerr'Balak"

/datum/npc_speech_trigger/teshari/qerrbalak/New()
	..()
	responses = list(\
		"Ever been to Qerr'Balak? The Teshari ancestral homelands are in Xi'Krri'oal, the southern continent.",\
		"If you can stand a little cold, you should trek into Qerr'Balak's snowy regions. Well worth a visit.",\
		"Qerr'Balak cities near the climate borders are home to Skrell and Teshari alike. They're a gateway to both worlds.",\
		"As much as I like the comforts of the cities, the best part of Qerr'balak is the tundra. Good view of the stars and the aurora.",\
		"I went to Qorr'gloa once. Once. Hot, humid, and full of rich Skrell. The Skrell can keep it.",\
		"The Teshari evolved in the cold regions of Xi'Krri'oal long before the Skrell ever settled there.",\
		"The Qo'rria Sea is frigid near the polar regions, it's a harsh life out on the ice there.",\
		"Qerr'Balak is far too hot for Teshari in most places. We live mostly in the far southern regions.")
