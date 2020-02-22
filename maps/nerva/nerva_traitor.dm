datum/objective/steal
	var/obj/item/steal_target
	var/target_name

var/global/possible_items[] = list(
	"the captain's colt single action revolver" = /obj/item/weapon/gun/projectile/revolver/coltsaa,
	"a bluespace rift generator" = /obj/item/integrated_circuit/manipulation/bluespace_rift,
	"the chain of command whip" = /obj/item/weapon/melee/whip/chainofcommand,
	"a functional AI inside a Intellicard" = /obj/item/weapon/aicard,
	"the [station_name()] blueprints" = /obj/item/blueprints,
	"a piece of corgi meat" = /obj/item/weapon/reagent_containers/food/snacks/meat/corgi,
	"a chief engineer's jumpsuit" = /obj/item/clothing/under/rank/chief_engineer,
	"a chief of security's jumpsuit" = /obj/item/clothing/under/urist/nerva/cosregular,
	"a first officer's jumpsuit" = /obj/item/clothing/under/urist/nerva/foregular,
	"a chief medical officer's jumpsuit" = /obj/item/clothing/under/rank/chief_medical_officer,
	"a ion rifle" = /obj/item/weapon/gun/energy/ionrifle,
	"a championship belt" = /obj/item/weapon/storage/belt/champion,
	"the detective's vintage .45 pistol" = /obj/item/weapon/gun/projectile/colt,
	"the bodyguard's deckard .38" = (/obj/item/weapon/gun/projectile/revolver/detective/deckard,
	"an ablative vest" = /obj/item/clothing/suit/armor/laserproof,
	"the chief engineer's advanced engineering hardsuit control module" = /obj/item/weapon/rig/ce/equipped,
	"a hand-teleporter" = /obj/item/device/electronic_assembly/clam,
	"the captain's soap" = /obj/item/weapon/soap/deluxe,
	"the ICS Nerva station account card" = /obj/item/weapon/card/station_account,
	"circuit board (AI Core)" = /obj/item/weapon/circuitboard/aicore
)