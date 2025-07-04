/obj/machinery/vending/medical
	name = "\improper NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	icon_vend = "med-vend"
	base_type = /obj/machinery/vending/medical
	req_access = list(access_medical_equip)
	idle_power_usage = 200
	product_ads = {"\
		Go save some lives!;\
		The best stuff for your medbay.;\
		Only the finest tools.;\
		Natural chemicals!;\
		This stuff saves lives.;\
		Don't you want some?;\
		Ping!\
	"}
	antag_slogans = {"\
		Half these treatments are banned by Sol for being 'too strong'! Ignore the imperialists, try oxycodone today!;\
		We put the practical in malpractice!;\
		Medical license not included.\
	"}
	products = list(
		/obj/item/reagent_containers/glass/bottle/dylovene = 4,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 4,
		/obj/item/reagent_containers/glass/bottle/soporific = 4,
		/obj/item/reagent_containers/syringe/antiviral = 4,
		/obj/item/reagent_containers/pill/antitox = 6,
		/obj/item/reagent_containers/syringe = 12,
		/obj/item/device/scanner/health = 5,
		/obj/item/reagent_containers/glass/beaker = 4,
		/obj/item/reagent_containers/dropper = 2,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 3,
		/obj/item/stack/medical/splint = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/pain = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/allergy = 12
	)
	rare_products = list(
		/obj/item/device/cosmetic_surgery_kit = 75,
		/obj/item/defibrillator/compact/combat/loaded = 50
	)
	contraband = list(
		/obj/item/clothing/mask/chewable/candy/lolli/meds = 8,
		/obj/item/reagent_containers/pill/tox = 3,
		/obj/item/reagent_containers/pill/stox = 4,
		/obj/item/reagent_containers/glass/bottle/toxin = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/combatpain = 2
	)
	antag = list(
		/obj/item/reagent_containers/hypospray = 1,
		/obj/item/device/cosmetic_surgery_kit = 0,
		/obj/item/defibrillator/compact/combat/loaded = 0
	)
