/mob/living/simple_animal/passive/npc/colonist
	name = "colonist"
	desc = "A human who decided to try their luck amongst the stars."
	icon = 'code/modules/urist/modules/newtrading/NPC/npc.dmi'
	icon_state = "body_m_s"
	faction = "nanotrasen"
	ai_holder = /datum/ai_holder/simple_animal/passive/nowandering/talkative
	say_list_type = /datum/say_list/colonist
	angryprob = 15
	jumpsuits = list(\
		/obj/item/clothing/under/color/black,\
		/obj/item/clothing/under/color/blue,\
		/obj/item/clothing/under/color/brown,\
		/obj/item/clothing/under/color/green,\
		/obj/item/clothing/under/color/grey,\
		/obj/item/clothing/under/color/lightpurple,\
		/obj/item/clothing/under/color/orange,\
		/obj/item/clothing/under/color/pink,\
		/obj/item/clothing/under/color/red,\
		/obj/item/clothing/under/color/white,\
		/obj/item/clothing/under/color/yellow\
		)
	shoes = list(\
		/obj/item/clothing/shoes/black,\
		/obj/item/clothing/shoes/brown,\
		/obj/item/clothing/shoes/white,\
		/obj/item/clothing/shoes/red,\
		/obj/item/clothing/shoes/orange,\
		/obj/item/clothing/shoes/yellow,\
		/obj/item/clothing/shoes/purple,\
		/obj/item/clothing/shoes/green,\
		/obj/item/clothing/shoes/blue\
		)
	hats = list(\
		/obj/item/clothing/head/bandana,\
		/obj/item/clothing/head/beret,\
		/obj/item/clothing/head/beret/purple,\
		/obj/item/clothing/head/beret/plaincolor,\
		/obj/item/clothing/head/cowboy_hat,\
		/obj/item/clothing/head/det,\
		/obj/item/clothing/head/det/grey,\
		/obj/item/clothing/head/flatcap,\
		/obj/item/clothing/head/ushanka,\
		/obj/item/clothing/head/soft,\
		/obj/item/clothing/head/soft/black,\
		/obj/item/clothing/head/soft/blue,\
		/obj/item/clothing/head/soft/green,\
		/obj/item/clothing/head/soft/grey,\
		/obj/item/clothing/head/soft/mbill,\
		/obj/item/clothing/head/soft/mime,\
		/obj/item/clothing/head/soft/orange,\
		/obj/item/clothing/head/soft/purple,\
		/obj/item/clothing/head/soft/red,\
		/obj/item/clothing/head/soft/yellow\
		)
	gloves = list(\
		/obj/item/clothing/gloves/thick/duty,\
		/obj/item/clothing/gloves/thick\
	)
	suits = list(\
		/obj/item/clothing/suit/leathercoat,\
		/obj/item/clothing/suit/wizrobe/gentlecoat,\
		/obj/item/clothing/suit/chaplain_hoodie,\
		/obj/item/clothing/suit/apron,\
		/obj/item/clothing/suit/apron/overalls\
	)

/datum/ai_holder/simple_animal/passive/nowandering/talkative
	speak_chance = 5

/datum/say_list/colonist
	emote_hear = list("coughs","sneezes","sniffs","clears their throat","whistles tunelessly","sighs deeply","yawns")
	emote_see = list("shifts from side to side.","scratches their arm.","examines their nails.","stares at at the ground aimlessly.","looks bored.","places their hands in their pockets.","stares at you with a blank expression.","scratches their nose.")
	speak = list("Have you heard the latest news from Mars?",
		"I'd love to visit Luna one day.",
		"If you ever want to visit a frontier world, check out the Draetheus V colony.",
		"I hope we don't get hit by pirates again...",
		"The price of starship fuel is insane right now.",
		"Did you hear the rioting worsened on Ryclies I yesterday?",
		"Have you heard the plans for the spaceport upgrade?",
		"Let me tell you, Ryclies made means low quality knockoffs.",
		"I have relatives on Procyon. I should really go visit them.",
		"I hope this damn civil war ends soon.",
		"It'd be nice to visit Mars again without worrying about getting blown up by some UHA terrorists.",
		"Have you heard about the rebellions in the mining colonies?",
		"I thought NanoTrasen would be safe from terrorist violence. After the recent attacks by those rebel miners, nowhere feels safe anymore.",
		"I really need a drink right now.",
		"Anyone here got a smoke?",
		"Fuck, I could use a smoke.",
		"I used to be a spacefarer like you, until I took an EMP to my artificial leg.",
		"I heard there was another Lactera attack in this sector. They tell us the Galactic Crisis is over, but some days, it feels like it's still going on out here.",
		"There's nothing like coffee in the morning, let me tell you, that stuff brings you back from the dead.",
		"Did you hear about those Terran Confederacy marines who murdered those civilians on a Vey-Med ship? With the Confederacy as it is now, I doubt they'll ever see justice.",
		"I've been meaning to visit my uncle on Mars, but the Terran Confederacy scares me these days. Too much power in the hands of the Terran Navy I tell ya.",
		"Have you been following the Terran Confederacy presidential campaign?",
		"Have you heard anything about the rioting on Mars?",
		"I hear the Terran Confederacy Navy is supplying pirate groups in NanoTrasen sectors as payback for NanoTrasen refusing to embargo the United Human Alliance. Probably just a rumour though.",
		"I hear the United Human Alliance is supplying pirate groups in NanoTrasen sectors as payback for NanoTrasen continuing to trade with the Terran Confederacy. Probably just a rumour though.",
		"Strange to think that some folks spend their entire lives in space.",
		"I never should have come to the outer sectors, but getting home is too expensive.",
		"Nothing ever happens in this miserable hellhole.",
		"I hear the UHA has started a new offensive against the Terran Confederacy. With the rebellions in the mining colonies and the constant rioting on Mars, the UHA might actually make some gains this time.",
		"The one nice thing about being out here is not having to worry about terrorist attacks. There's just pirates, lactera, asteroids, and whatever the hell else is out there in the cold void of space... Fuck.",
		"Been seeing a lot more traffic in these parts, I wonder why?",
		"If I were you I wouldn't hang around here too long. Not much to do.",
		"Oh, another visitor.",
		"I have relatives on Mars, I should really go visit them because I haven't heard from them for a while.",
		"Not a lot of Unathi on this station.",
		"Have you ever been to New Earth? I guess it's called Terra now... Apparently it was a beautiful place before the Galactic Crisis and the civil war.",
		"I have a cousin on one of the mining outposts that supposedly rose up, haven't heard from him in months."
		)

/mob/living/simple_animal/passive/npc/colonist/nanotrasen
	hiddenfaction = /datum/factions/nanotrasen
	speech_triggers = list(/datum/npc_speech_trigger/colonist/colonist_nt, /datum/npc_speech_trigger/colonist/colonist_pirate, /datum/npc_speech_trigger/colonist/colonist_galacticcrisis, /datum/npc_speech_trigger/colonist/colonist_lactera)

/mob/living/simple_animal/passive/npc/colonist/New()
	desc = "This is [src]. [initial(desc)]."
	if(prob(angryprob))
		angryspeak = 1
	if(prob(0.00001))
		say_list.speak += "I saw a mudcrab the other day. Vile creatures they are." //the chances of this being heard are so small, but I had to put it in.
	..()


/mob/living/simple_animal/passive/npc/colonist/labourer
	angryprob = 25
	jumpsuits = list(\
		/obj/item/clothing/under/focal,\
		/obj/item/clothing/under/frontier,\
		/obj/item/clothing/under/overalls,\
		/obj/item/clothing/under/grayson\
		)
	shoes = list(\
		/obj/item/clothing/shoes/workboots\
		)
	hats = list(\
		/obj/item/clothing/head/hardhat,\
		/obj/item/clothing/head/hardhat/dblue,\
		/obj/item/clothing/head/hardhat/orange,\
		/obj/item/clothing/head/hardhat/red,\
		/obj/item/clothing/head/hardhat/white,\
		/obj/item/clothing/head/bandana\
		)
	hat_chance = 75
	gloves = list(\
		/obj/item/clothing/gloves/botanic_leather,\
		/obj/item/clothing/gloves/thick/duty,\
		/obj/item/clothing/gloves/insulated\
		)
	glove_chance = 66
	suits = list(\
		/obj/item/clothing/suit/apron/overalls\
	)
	suit_chance = 5

/mob/living/simple_animal/passive/npc/colonist/labourer/nanotrasen
	hiddenfaction = /datum/factions/nanotrasen
	speech_triggers = list(/datum/npc_speech_trigger/colonist/colonist_nt, /datum/npc_speech_trigger/colonist/colonist_pirate, /datum/npc_speech_trigger/colonist/colonist_galacticcrisis, /datum/npc_speech_trigger/colonist/colonist_lizards, /datum/npc_speech_trigger/colonist/colonist_lactera)

/mob/living/simple_animal/passive/npc/colonist/highclass
	angryprob = 0
	jumpsuits = list(\
		/obj/item/clothing/under/blazer,\
		/obj/item/clothing/under/assistantformal,\
		/obj/item/clothing/under/gentlesuit,\
		/obj/item/clothing/under/librarian,\
		/obj/item/clothing/under/lawyer/bluesuit,\
		/obj/item/clothing/under/lawyer/oldman\
		)
	shoes = list(\
		/obj/item/clothing/shoes/laceup,\
		/obj/item/clothing/shoes/leather,\
		/obj/item/clothing/shoes/dress,\
		/obj/item/clothing/shoes/dress/white,\
		/obj/item/clothing/shoes/flats,\
		/obj/item/clothing/shoes/athletic\
		)
	hats = list(\
		/obj/item/clothing/head/fez,\
		/obj/item/clothing/head/bowler,\
		/obj/item/clothing/head/bowlerhat,\
		/obj/item/clothing/head/beaverhat,\
		/obj/item/clothing/head/boaterhat,\
		/obj/item/clothing/head/fedora,\
		/obj/item/clothing/head/feathertrilby,\
		/obj/item/clothing/head/that\
		)
	hat_chance = 25
	gloves = list(\
		/obj/item/clothing/gloves/white,\
		/obj/item/clothing/gloves/thick\
	)
	suits = list(\
		/obj/item/clothing/suit/leathercoat,\
		/obj/item/clothing/suit/wizrobe/gentlecoat,\
		/obj/item/clothing/suit/chaplain_hoodie\
	)
	suit_chance = 10


/mob/living/simple_animal/passive/npc/colonist/highclass/nanotrasen
	hiddenfaction = /datum/factions/nanotrasen
	speech_triggers = list(/datum/npc_speech_trigger/colonist/colonist_nt, /datum/npc_speech_trigger/colonist/colonist_pirate, /datum/npc_speech_trigger/colonist/colonist_lactera)
