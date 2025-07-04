// Chili plants/variants.
/datum/seed/chili
	name = "chili"
	seed_name = "chili"
	display_name = "chili plant"
	chems = list(/datum/reagent/capsaicin = list(3,5), /datum/reagent/nutriment = list(1,25))
	mutants = list("icechili")
	kitchen_tag = "chili"

/datum/seed/chili/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"chili")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ed3300")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	fruit_size = ITEM_SIZE_TINY

/datum/seed/chili/ice
	name = "icechili"
	seed_name = "chilly pepper"
	display_name = "chilly pepper plant"
	mutants = null
	chems = list(/datum/reagent/frostoil = list(3,5), /datum/reagent/nutriment = list(1,50))
	kitchen_tag = "icechili"

/datum/seed/chili/ice/New()
	..()
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00edc6")

// Berry plants/variants.
/datum/seed/berry
	name = "berries"
	seed_name = "berry"
	display_name = "berry bush"
	mutants = list("glowberries","poisonberries","blueberries")
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/drink/juice/berry = list(10,10))
	kitchen_tag = "berries"

/datum/seed/berry/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fa1616")
	set_trait(TRAIT_PLANT_ICON,"bush")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/berry/blue
	name = "blueberries"
	seed_name = "blueberry"
	display_name = "blueberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/drink/juice/berry = list(10,10))
	kitchen_tag = "blueberries"

/datum/seed/berry/blue/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_COLOUR,"#1c225c")
	set_trait(TRAIT_WATER_CONSUMPTION, 5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.2)

/datum/seed/berry/glow
	name = "glowberries"
	seed_name = "glowberry"
	display_name = "glowberry bush"
	mutants = null
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/uranium = list(3,5))

/datum/seed/berry/glow/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#006622")
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_COLOUR,"#c9fa16")
	set_trait(TRAIT_WATER_CONSUMPTION, 3)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/berry/poison
	name = "poisonberries"
	seed_name = "poison berry"
	display_name = "poison berry bush"
	mutants = list("deathberries")
	chems = list(/datum/reagent/nutriment = list(1), /datum/reagent/toxin = list(3,5), /datum/reagent/toxin/poisonberryjuice = list(10,5))

/datum/seed/berry/poison/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#6dc961")
	set_trait(TRAIT_WATER_CONSUMPTION, 3)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/berry/poison/death
	name = "deathberries"
	seed_name = "death berry"
	display_name = "death berry bush"
	mutants = null
	chems = list(/datum/reagent/nutriment = list(1), /datum/reagent/toxin = list(3,3), /datum/reagent/lexorin = list(1,5))

/datum/seed/berry/poison/death/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,50)
	set_trait(TRAIT_PRODUCT_COLOUR,"#7a5454")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.35)

// Nettles/variants.
/datum/seed/nettle
	name = "nettle"
	seed_name = "nettle"
	display_name = "nettle"
	mutants = list("deathnettle")
	chems = list(/datum/reagent/nutriment = list(1,50), /datum/reagent/acid = list(0,1))
	kitchen_tag = "nettle"
	kitchen_tag = "nettle"

/datum/seed/nettle/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_STINGS,1)
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_PRODUCT_ICON,"nettles")
	set_trait(TRAIT_PRODUCT_COLOUR,"#728a54")

/datum/seed/nettle/death
	name = "deathnettle"
	seed_name = "death nettle"
	display_name = "death nettle"
	mutants = null
	chems = list(/datum/reagent/nutriment = list(1,50), /datum/reagent/acid/polyacid = list(0,1))
	kitchen_tag = "deathnettle"

/datum/seed/nettle/death/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_COLOUR,"#8c5030")
	set_trait(TRAIT_PLANT_COLOUR,"#634941")

//Tomatoes/variants.
/datum/seed/tomato
	name = "tomato"
	seed_name = "tomato"
	display_name = "tomato plant"
	mutants = list("bluetomato","bloodtomato")
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/drink/juice/tomato = list(10,10))
	kitchen_tag = "tomato"

/datum/seed/tomato/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"tomato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#d10000")
	set_trait(TRAIT_PLANT_ICON,"bush3")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/tomato/blood
	name = "bloodtomato"
	seed_name = "blood tomato"
	display_name = "blood tomato plant"
	mutants = list("killertomato")
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/blood = list(1,5))
	splat_type = /obj/decal/cleanable/blood/splatter

/datum/seed/tomato/blood/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#ff0000")

/datum/seed/tomato/killer
	name = "killertomato"
	seed_name = "killer tomato"
	display_name = "killer tomato plant"
	mutants = null
	can_self_harvest = TRUE
	possessable = TRUE
	product_type = /mob/living/simple_animal/passive/tomato

/datum/seed/tomato/killer/New()
	..()
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_COLOUR,"#a86747")

/datum/seed/tomato/blue
	name = "bluetomato"
	seed_name = "blue tomato"
	display_name = "blue tomato plant"
	mutants = list("bluespacetomato")
	chems = list(/datum/reagent/nutriment = list(1,20), /datum/reagent/lube = list(1,5))

/datum/seed/tomato/blue/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#4d86e8")
	set_trait(TRAIT_PLANT_COLOUR,"#070aad")

/datum/seed/tomato/blue/teleport
	name = "bluespacetomato"
	seed_name = "bluespace tomato"
	display_name = "bluespace tomato plant"
	mutants = null
	chems = list(/datum/reagent/nutriment = list(1,20), /datum/reagent/ethanol/singulo = list(10,5))

/datum/seed/tomato/blue/teleport/New()
	..()
	set_trait(TRAIT_TELEPORTING,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00e5ff")
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#4da4a8")
	set_trait(TRAIT_POTENCY, 15)

//Eggplants/varieties.
/datum/seed/eggplant
	name = "eggplant"
	seed_name = "eggplant"
	display_name = "eggplant"
	mutants = list("realeggplant")
	chems = list(/datum/reagent/nutriment = list(1,10))
	kitchen_tag = "eggplant"

/datum/seed/eggplant/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"eggplant")
	set_trait(TRAIT_PRODUCT_COLOUR,"#892694")
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

//Apples/varieties.
/datum/seed/apple
	name = "apple"
	seed_name = "apple"
	display_name = "apple tree"
	mutants = list("poisonapple","goldapple")
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/drink/juice/apple = list(10,10))
	kitchen_tag = "apple"

/datum/seed/apple/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"apple")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ff540a")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_FLESH_COLOUR,"#e8e39b")
	set_trait(TRAIT_IDEAL_LIGHT, 4)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/apple/poison
	name = "poisonapple"
	mutants = null
	chems = list(/datum/reagent/toxin/cyanide = list(1,5))

/datum/seed/apple/gold
	name = "goldapple"
	seed_name = "golden apple"
	display_name = "gold apple tree"
	mutants = null
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/gold = list(1,5))
	kitchen_tag = "goldapple"

/datum/seed/apple/gold/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffdd00")
	set_trait(TRAIT_PLANT_COLOUR,"#d6b44d")

//Ambrosia/varieties.
/datum/seed/ambrosia
	name = "ambrosia"
	seed_name = "ambrosia vulgaris"
	display_name = "ambrosia vulgaris"
	mutants = list("ambrosiadeus")
	chems = list(/datum/reagent/nutriment = list(1), /datum/reagent/drugs/hextro = list(1,8), /datum/reagent/kelotane = list(1,8,1), /datum/reagent/bicaridine = list(1,10,1), /datum/reagent/toxin = list(1,10))
	kitchen_tag = "ambrosia"

/datum/seed/ambrosia/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"ambrosia")
	set_trait(TRAIT_PRODUCT_COLOUR,"#9fad55")
	set_trait(TRAIT_PLANT_ICON,"ambrosia")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/ambrosia/deus
	name = "ambrosiadeus"
	seed_name = "ambrosia deus"
	display_name = "ambrosia deus"
	mutants = null
	chems = list(/datum/reagent/nutriment = list(1), /datum/reagent/bicaridine = list(1,8), /datum/reagent/synaptizine = list(1,8,1), /datum/reagent/hyperzine = list(1,10,1), /datum/reagent/drugs/hextro = list(1,10))
	kitchen_tag = "ambrosiadeus"

/datum/seed/ambrosia/deus/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#a3f0ad")
	set_trait(TRAIT_PLANT_COLOUR,"#2a9c61")

//Mushrooms/varieties.
/datum/seed/mushroom
	name = "mushrooms"
	seed_name = "chanterelle"
	seed_noun = SEED_NOUN_SPORES
	display_name = "chanterelle cluster"
	mutants = list("reishi","amanita","plumphelmet")
	chems = list(/datum/reagent/nutriment = list(1,25))
	splat_type = /obj/vine
	kitchen_tag = "mushroom"

/datum/seed/mushroom/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#dbda72")
	set_trait(TRAIT_PLANT_COLOUR,"#d9c94e")
	set_trait(TRAIT_PLANT_ICON,"mushroom")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_IDEAL_HEAT, 288)
	set_trait(TRAIT_LIGHT_TOLERANCE, 6)

/datum/seed/mushroom/mold
	name = "mold"
	seed_name = "brown mold"
	display_name = "brown mold"
	mutants = null

/datum/seed/mushroom/mold/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#7a5f20")
	set_trait(TRAIT_PLANT_COLOUR,"#7a5f20")
	set_trait(TRAIT_PLANT_ICON,"mushroom9")

/datum/seed/mushroom/plump
	name = "plumphelmet"
	seed_name = "plump helmet"
	display_name = "plump helmet cluster"
	mutants = list("walkingmushroom","towercap")
	chems = list(/datum/reagent/nutriment = list(2,10))
	kitchen_tag = "plumphelmet"

/datum/seed/mushroom/plump/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,2)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom10")
	set_trait(TRAIT_PRODUCT_COLOUR,"#b57bb0")
	set_trait(TRAIT_PLANT_COLOUR,"#9e4f9d")
	set_trait(TRAIT_PLANT_ICON,"mushroom2")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.35)

/datum/seed/mushroom/plump/walking
	name = "walkingmushroom"
	seed_name = "walking mushroom"
	display_name = "walking mushroom cluster"
	mutants = null
	can_self_harvest = TRUE
	possessable = TRUE
	product_type = /mob/living/simple_animal/passive/mushroom

/datum/seed/mushroom/plump/walking/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#fac0f2")
	set_trait(TRAIT_PLANT_COLOUR,"#c4b1c2")

/datum/seed/mushroom/hallucinogenic
	name = "reishi"
	seed_name = "reishi"
	display_name = "reishi cluster"
	mutants = list("libertycap","glowshroom")
	chems = list(/datum/reagent/nutriment = list(1,50), /datum/reagent/drugs/psilocybin = list(3,5))

/datum/seed/mushroom/hallucinogenic/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom11")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffb70f")
	set_trait(TRAIT_PLANT_COLOUR,"#f58a18")
	set_trait(TRAIT_PLANT_ICON,"mushroom6")

/datum/seed/mushroom/hallucinogenic/strong
	name = "libertycap"
	seed_name = "liberty cap"
	display_name = "liberty cap cluster"
	mutants = null
	chems = list(/datum/reagent/nutriment = list(1), /datum/reagent/soporific = list(3,3), /datum/reagent/drugs/hextro = list(1,25))

/datum/seed/mushroom/hallucinogenic/strong/New()
	..()
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom8")
	set_trait(TRAIT_PRODUCT_COLOUR,"#f2e550")
	set_trait(TRAIT_PLANT_COLOUR,"#d1ca82")
	set_trait(TRAIT_PLANT_ICON,"mushroom3")

/datum/seed/mushroom/poison
	name = "amanita"
	seed_name = "fly amanita"
	display_name = "fly amanita cluster"
	mutants = list("destroyingangel","plastic")
	chems = list(/datum/reagent/nutriment = list(1), /datum/reagent/toxin/amatoxin = list(3,3), /datum/reagent/drugs/psilocybin = list(1,25))

/datum/seed/mushroom/poison/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ff4545")
	set_trait(TRAIT_PLANT_COLOUR,"#e0ddba")
	set_trait(TRAIT_PLANT_ICON,"mushroom4")

/datum/seed/mushroom/poison/death
	name = "destroyingangel"
	seed_name = "destroying angel"
	display_name = "destroying angel cluster"
	mutants = null
	chems = list(/datum/reagent/nutriment = list(1,50), /datum/reagent/toxin/amatoxin = list(13,3), /datum/reagent/drugs/psilocybin = list(1,25))

/datum/seed/mushroom/poison/death/New()
	..()
	set_trait(TRAIT_MATURATION,12)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,35)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ede8ea")
	set_trait(TRAIT_PLANT_COLOUR,"#e6d8dd")
	set_trait(TRAIT_PLANT_ICON,"mushroom5")

/datum/seed/mushroom/towercap
	name = "towercap"
	seed_name = "tower cap"
	display_name = "tower cap cluster"
	chems = list(/datum/reagent/woodpulp = list(10,1))
	mutants = null
	fruit_size = ITEM_SIZE_NORMAL

/datum/seed/mushroom/towercap/New()
	..()
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom7")
	set_trait(TRAIT_PRODUCT_COLOUR,"#79a36d")
	set_trait(TRAIT_PLANT_COLOUR,"#857f41")
	set_trait(TRAIT_PLANT_ICON,"mushroom8")

/datum/seed/mushroom/glowshroom
	name = "glowshroom"
	seed_name = "glowshroom"
	display_name = "glowshroom cluster"
	mutants = null
	chems = list(/datum/reagent/radium = list(1,20))

/datum/seed/mushroom/glowshroom/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#006622")
	set_trait(TRAIT_PRODUCT_ICON,"mushroom2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ddfab6")
	set_trait(TRAIT_PLANT_COLOUR,"#efff8a")
	set_trait(TRAIT_PLANT_ICON,"mushroom7")

/datum/seed/mushroom/plastic
	name = "plastic"
	seed_name = "plastellium"
	display_name = "plastellium cluster"
	mutants = null
	chems = list(/datum/reagent/toxin/plasticide = list(1,10))

/datum/seed/mushroom/plastic/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom6")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e6e6e6")
	set_trait(TRAIT_PLANT_COLOUR,"#e6e6e6")
	set_trait(TRAIT_PLANT_ICON,"mushroom10")

//Flowers/varieties
/datum/seed/flower
	name = "harebells"
	seed_name = "harebell"
	display_name = "harebell patch"
	chems = list(/datum/reagent/nutriment = list(1,20))

/datum/seed/flower/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_ICON,"flower5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#c492d6")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"flower")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/poppy
	name = "poppies"
	seed_name = "poppy"
	display_name = "poppy patch"
	chems = list(/datum/reagent/nutriment = list(1,20), /datum/reagent/tramadol = list(1,10))
	kitchen_tag = "poppy"

/datum/seed/flower/poppy/New()
	..()
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#b33715")
	set_trait(TRAIT_PLANT_ICON,"flower3")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/sunflower
	name = "sunflowers"
	seed_name = "sunflower"
	display_name = "sunflower patch"

/datum/seed/flower/sunflower/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fff700")
	set_trait(TRAIT_PLANT_ICON,"flower2")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/lavender
	name = "lavender"
	seed_name = "lavender"
	display_name = "lavender patch"
	chems = list(/datum/reagent/nutriment = list(1,20), /datum/reagent/bicaridine = list(1,10))
	fruit_size = ITEM_SIZE_TINY

/datum/seed/flower/lavender/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"flower6")
	set_trait(TRAIT_PRODUCT_COLOUR,"#b57edc")
	set_trait(TRAIT_PLANT_COLOUR,"#6b8c5e")
	set_trait(TRAIT_PLANT_ICON,"flower4")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.05)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

//Grapes/varieties
/datum/seed/grapes
	name = "grapes"
	seed_name = "grape"
	display_name = "grape vine"
	mutants = list("greengrapes","whitegrapes")
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/sugar = list(1,5), /datum/reagent/drink/juice/grape = list(10,10))

/datum/seed/grapes/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"grapes")
	set_trait(TRAIT_PRODUCT_COLOUR,"#bb6ac4")
	set_trait(TRAIT_PLANT_COLOUR,"#378f2e")
	set_trait(TRAIT_PLANT_ICON,"vine")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/grapes/green
	name = "greengrapes"
	seed_name = "green grape"
	display_name = "green grape vine"
	mutants = list("grapes","whitegrapes")
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/sugar = list(1,5), /datum/reagent/drink/juice/grape/green = list(10,10))

/datum/seed/grapes/green/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#42ed2f")

//Everything else
/datum/seed/peanuts
	name = "peanut"
	seed_name = "peanut"
	display_name = "peanut plant"
	chems = list(/datum/reagent/nutriment/groundpeanuts = list(3,5))
	kitchen_tag = "peanut"

/datum/seed/peanuts/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"nuts")
	set_trait(TRAIT_PRODUCT_COLOUR,"#c4ae7a")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/peppercorn
	name = "peppercorn"
	seed_name = "peppercorn"
	display_name = "black pepper plant"
	chems = list(/datum/reagent/blackpepper = list(10,10))
	fruit_size = ITEM_SIZE_TINY

/datum/seed/peppercorn/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"nuts")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4d4d4d")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/cabbage
	name = "cabbage"
	seed_name = "cabbage"
	display_name = "cabbage patch"
	chems = list(/datum/reagent/nutriment = list(1,7), /datum/reagent/drink/juice/cabbage = list (3, 3))
	kitchen_tag = "cabbage"
	fruit_size = ITEM_SIZE_NORMAL

/datum/seed/cabbage/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cabbage")
	set_trait(TRAIT_PRODUCT_COLOUR,"#84bd82")
	set_trait(TRAIT_PLANT_COLOUR,"#6d9c6b")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/lettuce
	name = "lettuce"
	seed_name = "lettuce"
	display_name = "lettuce plant"
	chems = list(/datum/reagent/nutriment = list(1,5), /datum/reagent/drink/juice/lettuce = list (2, 4))
	kitchen_tag = "lettuce"
	fruit_size = ITEM_SIZE_NORMAL

/datum/seed/lettuce/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,2)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"lettuce")
	set_trait(TRAIT_PRODUCT_COLOUR,"#59ca42")
	set_trait(TRAIT_PLANT_COLOUR,"#4fcb5b")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/banana
	name = "banana"
	seed_name = "banana"
	display_name = "banana tree"
	chems = list(/datum/reagent/drink/juice/banana = list(10,10), /datum/reagent/potassium = list(2,3))
	trash_type = /obj/item/bananapeel
	kitchen_tag = "banana"

/datum/seed/banana/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_ICON,"bananas")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffec1f")
	set_trait(TRAIT_PLANT_COLOUR,"#69ad50")
	set_trait(TRAIT_PLANT_ICON,"tree4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/corn
	name = "corn"
	seed_name = "corn"
	display_name = "corn plant"
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/nutriment/cornoil = list(1,10))
	kitchen_tag = "corn"
	trash_type = /obj/item/carvable/corncob

/datum/seed/corn/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"corn")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fff23b")
	set_trait(TRAIT_PLANT_COLOUR,"#87c969")
	set_trait(TRAIT_PLANT_ICON,"corn")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/potato
	name = "potato"
	seed_name = "potato"
	display_name = "potato plant"
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/drink/juice/potato = list(3,6))
	kitchen_tag = "potato"

/datum/seed/potato/New()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"potato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#d4cab4")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/garlic
	name = "garlic"
	seed_name = "garlic"
	display_name = "garlic plant"
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/drink/juice/garlic = list(3,6))
	kitchen_tag = "garlic"

/datum/seed/garlic/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,12)
	set_trait(TRAIT_PRODUCT_ICON,"bulb")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fff8dd")
	set_trait(TRAIT_PLANT_ICON,"stalk")
	set_trait(TRAIT_WATER_CONSUMPTION, 7)

/datum/seed/onion
	name = "onion"
	seed_name = "onion"
	display_name = "onion plant"
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/drink/juice/onion = list(3,6))
	kitchen_tag = "onion"

/datum/seed/onion/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"bulb")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffeedd")
	set_trait(TRAIT_PLANT_ICON,"stalk")
	set_trait(TRAIT_WATER_CONSUMPTION, 5)

/datum/seed/soybean
	name = "soybean"
	seed_name = "soybean"
	display_name = "soybean plant"
	chems = list(/datum/reagent/drink/milk/soymilk = list(10,20))
	kitchen_tag = "soybeans"

/datum/seed/soybean/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"bean")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ebe7c0")
	set_trait(TRAIT_PLANT_ICON,"stalk")

/datum/seed/wheat
	name = "wheat"
	seed_name = "wheat"
	display_name = "patch of wheat"
	chems = list(/datum/reagent/nutriment/flour = list(15,15))
	kitchen_tag = "wheat"

/datum/seed/wheat/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"wheat")
	set_trait(TRAIT_PRODUCT_COLOUR,"#dbd37d")
	set_trait(TRAIT_PLANT_COLOUR,"#bfaf82")
	set_trait(TRAIT_PLANT_ICON,"stalk2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/rice
	name = "rice"
	seed_name = "rice"
	display_name = "patch of rice"
	chems = list(/datum/reagent/nutriment/rice = list(10,15))
	kitchen_tag = "rice"

/datum/seed/rice/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"rice")
	set_trait(TRAIT_PRODUCT_COLOUR,"#d5e6d1")
	set_trait(TRAIT_PLANT_COLOUR,"#8ed17d")
	set_trait(TRAIT_PLANT_ICON,"stalk2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/carrots
	name = "carrot"
	seed_name = "carrot"
	display_name = "carrot patch"
	chems = list(/datum/reagent/nutriment = list(1,20), /datum/reagent/imidazoline = list(3,5), /datum/reagent/drink/juice/carrot = list(10,20))
	kitchen_tag = "carrot"

/datum/seed/carrots/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ff9900")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/weeds
	name = "weeds"
	seed_name = "weed"
	display_name = "patch of weeds"

/datum/seed/weeds/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_POTENCY,-1)
	set_trait(TRAIT_IMMUTABLE,-1)
	set_trait(TRAIT_PRODUCT_ICON,"flower4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fceb2b")
	set_trait(TRAIT_PLANT_COLOUR,"#59945a")
	set_trait(TRAIT_PLANT_ICON,"bush6")

/datum/seed/whitebeets
	name = "whitebeet"
	seed_name = "white-beet"
	display_name = "white-beet patch"
	chems = list(/datum/reagent/nutriment = list(0,20), /datum/reagent/sugar = list(1,5))
	kitchen_tag = "whitebeet"

/datum/seed/whitebeets/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#eef5b0")
	set_trait(TRAIT_PLANT_COLOUR,"#4d8f53")
	set_trait(TRAIT_PLANT_ICON,"carrot2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/sugarcane
	name = "sugarcane"
	seed_name = "sugarcane"
	display_name = "sugarcane patch"
	chems = list(/datum/reagent/sugar = list(4,5))
	fruit_size = ITEM_SIZE_NORMAL

/datum/seed/sugarcane/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR,"#b4d6bd")
	set_trait(TRAIT_PLANT_COLOUR,"#6bbd68")
	set_trait(TRAIT_PLANT_ICON,"stalk3")
	set_trait(TRAIT_IDEAL_HEAT, 298)

/datum/seed/watermelon
	name = "watermelon"
	seed_name = "watermelon"
	display_name = "watermelon vine"
	chems = list(/datum/reagent/nutriment = list(1,6), /datum/reagent/drink/juice/watermelon = list(10,6))
	fruit_size = ITEM_SIZE_NORMAL

/datum/seed/watermelon/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"vine")
	set_trait(TRAIT_PRODUCT_COLOUR,"#326b30")
	set_trait(TRAIT_PLANT_COLOUR,"#257522")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_FLESH_COLOUR,"#f22c2c")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/pumpkin
	name = "pumpkin"
	seed_name = "pumpkin"
	display_name = "pumpkin vine"
	chems = list(/datum/reagent/nutriment = list(1,6))
	kitchen_tag = "pumpkin"
	fruit_size = ITEM_SIZE_NORMAL

/datum/seed/pumpkin/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"vine2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#f9ab28")
	set_trait(TRAIT_PLANT_COLOUR,"#bae8c1")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/citrus
	name = "lime"
	seed_name = "lime"
	display_name = "lime tree"
	chems = list(/datum/reagent/nutriment = list(1,20), /datum/reagent/drink/juice/lime = list(10,20))
	kitchen_tag = "lime"

/datum/seed/citrus/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#3af026")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_FLESH_COLOUR,"#3af026")
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/citrus/lemon
	name = "lemon"
	seed_name = "lemon"
	display_name = "lemon tree"
	chems = list(/datum/reagent/nutriment = list(1,20), /datum/reagent/drink/juice/lemon = list(10,20))
	kitchen_tag = "lemon"

/datum/seed/citrus/lemon/New()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#f0e226")
	set_trait(TRAIT_FLESH_COLOUR,"#f0e226")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/citrus/orange
	name = "orange"
	seed_name = "orange"
	display_name = "orange tree"
	kitchen_tag = "orange"
	chems = list(/datum/reagent/nutriment = list(1,20), /datum/reagent/drink/juice/orange = list(10,20))

/datum/seed/citrus/orange/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffc20a")
	set_trait(TRAIT_FLESH_COLOUR,"#ffc20a")
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/grass
	name = "grass"
	seed_name = "grass"
	display_name = "patch of grass"
	chems = list(/datum/reagent/nutriment = list(1,20))
	kitchen_tag = "grass"
	fruit_size = ITEM_SIZE_NORMAL

/datum/seed/grass/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,2)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"grass")
	set_trait(TRAIT_PRODUCT_COLOUR,"#09ff00")
	set_trait(TRAIT_PLANT_COLOUR,"#07d900")
	set_trait(TRAIT_PLANT_ICON,"grass")
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/cocoa
	name = "cocoa"
	seed_name = "cacao"
	display_name = "cacao tree"
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/nutriment/coco = list(4,5))

/datum/seed/cocoa/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#cca935")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/cherries
	name = "cherry"
	seed_name = "cherry"
	seed_noun = SEED_NOUN_PITS
	display_name = "cherry tree"
	chems = list(/datum/reagent/nutriment = list(1,15), /datum/reagent/sugar = list(1,15), /datum/reagent/nutriment/cherryjelly = list(10,15))
	kitchen_tag = "cherries"

/datum/seed/cherries/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cherry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#a80000")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_PLANT_COLOUR,"#2f7d2d")
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/kudzu
	name = "kudzu"
	seed_name = "kudzu"
	display_name = "kudzu vine"
	chems = list(/datum/reagent/nutriment = list(1,50), /datum/reagent/dylovene = list(1,25))

/datum/seed/kudzu/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_SPREAD,2)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#96d278")
	set_trait(TRAIT_PLANT_COLOUR,"#6f7a63")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

/datum/seed/diona
	name = "diona"
	seed_name = "diona"
	seed_noun = SEED_NOUN_NODES
	display_name = "replicant pod"
	can_self_harvest = TRUE
	possessable = TRUE
	product_type = /mob/living/carbon/alien/diona

/datum/seed/diona/New()
	..()
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_ENDURANCE,8)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_PRODUCT_ICON,"diona")
	set_trait(TRAIT_PRODUCT_COLOUR,"#799957")
	set_trait(TRAIT_PLANT_COLOUR,"#66804b")
	set_trait(TRAIT_PLANT_ICON,"alien4")

/datum/seed/shand
	name = "shand"
	seed_name = "S'randar's hand"
	display_name = "S'randar's hand plant"
	chems = list(/datum/reagent/bicaridine = list(0,10))
	kitchen_tag = "shand"

/datum/seed/shand/New()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"alien3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#378c61")
	set_trait(TRAIT_PLANT_COLOUR,"#378c61")
	set_trait(TRAIT_PLANT_ICON,"tree5")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/mtear
	name = "mtear"
	seed_name = "Messa's tear"
	display_name = "Messa's tear plant"
	chems = list(/datum/reagent/nutriment/honey = list(1,10), /datum/reagent/kelotane = list(3,5))
	kitchen_tag = "mtear"

/datum/seed/mtear/New()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"alien4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4cc5c7")
	set_trait(TRAIT_PLANT_COLOUR,"#4cc789")
	set_trait(TRAIT_PLANT_ICON,"bush7")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/tobacco
	name = "tobacco"
	seed_name = "tobacco"
	display_name = "tobacco plant"
	mutants = list("finetobacco", "puretobacco", "badtobacco")
	chems = list(/datum/reagent/tobacco = list(1,10))
	fruit_size = ITEM_SIZE_TINY

/datum/seed/tobacco/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"tobacco")
	set_trait(TRAIT_PRODUCT_COLOUR,"#749733")
	set_trait(TRAIT_PLANT_COLOUR,"#749733")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_HEAT, 299)
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/tobacco/finetobacco
	name = "finetobacco"
	seed_name = "fine tobacco"
	display_name = "fine tobacco plant"
	chems = list(/datum/reagent/tobacco/fine = list(1,10))

/datum/seed/tobacco/finetobacco/New()
	..()
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_PRODUCT_COLOUR,"#33571b")
	set_trait(TRAIT_PLANT_COLOUR,"#33571b")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.20)

/datum/seed/tobacco/puretobacco //provides the pure nicotine reagent
	name = "puretobacco"
	seed_name = "succulent tobacco"
	display_name = "succulent tobacco plant"
	chems = list(/datum/reagent/nicotine = list(1,10))

/datum/seed/tobacco/puretobacco/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#b7c61a")
	set_trait(TRAIT_PLANT_COLOUR,"#b7c61a")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.30)

/datum/seed/tobacco/bad
	name = "badtobacco"
	seed_name = "low-grade tobacco"
	display_name = "low-grade tobacco plant"
	mutants = list("tobacco")
	chems = list(/datum/reagent/tobacco/bad = list(1,10))

/datum/seed/tobacco/bad/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#8c8626")
	set_trait(TRAIT_PLANT_COLOUR,"#8c8626")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)

// Alien weeds.
/datum/seed/xenomorph
	name = "xenomorph"
	seed_name = "alien weed"
	display_name = "alien weeds"
	force_layer = OBJ_LAYER
	chems = list(/datum/reagent/toxin/phoron = list(1,3))

/datum/seed/xenomorph/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#3d1934")
	set_trait(TRAIT_FLESH_COLOUR,"#3d1934")
	set_trait(TRAIT_PLANT_COLOUR,"#3d1934")
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_SPREAD,2)
	set_trait(TRAIT_POTENCY,50)

/datum/seed/algae
	name = "algae"
	seed_name = "algae"
	display_name = "algae patch"
	chems = list(
		/datum/reagent/nutriment = list(2,12),
		/datum/reagent/toxin/bromide = list(3,8)
	)
	kitchen_tag = "algae"
	exude_gasses = list(GAS_METHYL_BROMIDE = 3)

/datum/seed/algae/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"algae")
	set_trait(TRAIT_PRODUCT_COLOUR,"#84bd82")
	set_trait(TRAIT_PLANT_COLOUR,"#6d9c6b")
	set_trait(TRAIT_PLANT_ICON,"algae")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/bamboo
	name = "bamboo"
	seed_name = "bamboo"
	display_name = "bamboo patch"
	chems = list(/datum/reagent/bamboo = list(6,1))
	mutants = null
	fruit_size = ITEM_SIZE_NORMAL

/datum/seed/bamboo/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR, WOOD_COLOR_GENERIC)
	set_trait(TRAIT_PLANT_COLOUR,"#99bc20")
	set_trait(TRAIT_PLANT_ICON,"stalk3")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/resin
	name = "resinplant"
	seed_name = "resin plant"
	display_name = "resin plant"
	chems = list(/datum/reagent/resinpulp = list(6,1))
	mutants = null
	exude_gasses = list(null)

/datum/seed/resin/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#3a4e1b")
	set_trait(TRAIT_PLANT_COLOUR,"#5e41be")
	set_trait(TRAIT_PRODUCT_ICON,"resin")
	set_trait(TRAIT_PLANT_ICON,"resin")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/breather
	name = "breather"
	seed_name = "breather"
	display_name = "breather"
	chems = list(
		/datum/reagent/nutriment = list(2,12),
		/datum/reagent/ammonia = list(3,8)
	)
	exude_gasses = list(GAS_NITROGEN = 3)

/datum/seed/breather/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"breather")
	set_trait(TRAIT_PLANT_ICON,"breather")
	set_trait(TRAIT_WATER_CONSUMPTION, 4)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 1)
	set_trait(TRAIT_LIGHT_TOLERANCE, 6)

// Fruit Expansion

/datum/seed/melon
	name = "melon"
	seed_name = "melon"
	display_name = "melon vine"
	chems = list(/datum/reagent/nutriment = list(1,6), /datum/reagent/drink/juice/melon = list(10,6))
	fruit_size = ITEM_SIZE_NORMAL

/datum/seed/melon/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"vine")
	set_trait(TRAIT_PRODUCT_COLOUR,"#d4dc26")
	set_trait(TRAIT_PLANT_COLOUR,"#cad72a")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_FLESH_COLOUR,"#f2b32c")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/coffee
	name = "coffee"
	seed_name = "coffee bean"
	display_name = "coffee plant"
	chems = list(/datum/reagent/nutriment/coffee = list(10,10))

/datum/seed/coffee/New()
	..()
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"nuts")
	set_trait(TRAIT_PRODUCT_COLOUR,"#71503e")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 7)

/datum/seed/grapes/white
	name = "whitegrapes"
	seed_name = "white grape"
	display_name = "white grape vine"
	mutants = list("grapes","greengrapes")
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/sugar = list(1,5), /datum/reagent/drink/juice/grape/white = list(10,10))

/datum/seed/grapes/white/New()
	..()
	set_trait(TRAIT_PRODUCT_ICON,"grapes")
	set_trait(TRAIT_PRODUCT_COLOUR,"#f5efd4")
	set_trait(TRAIT_PLANT_COLOUR,"#378f2e")

/datum/seed/vanilla
	name = "vanilla"
	seed_name = "vanilla flower"
	display_name = "vanilla flower"
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/drink/syrup_vanilla = list(4,5))
	fruit_size = ITEM_SIZE_TINY

/datum/seed/vanilla/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ffffda")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/pineapple
	name = "pineapples"
	seed_name = "pineapple"
	display_name = "pineapple plant"
	chems = list(/datum/reagent/drink/juice/pineapple = list(10,10), /datum/reagent/enzyme = list(1,5),/datum/reagent/nutriment = list(1,10))
	trash_type = /obj/item/carvable/corncob/hollowpineapple
	kitchen_tag = "pineapple"

/datum/seed/pineapple/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"pineapple")
	set_trait(TRAIT_PRODUCT_COLOUR,"#f6e12d")
	set_trait(TRAIT_PLANT_ICON,"tree4")
	set_trait(TRAIT_FLESH_COLOUR,"#f6ce79")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/pear
	name = "pears"
	seed_name = "pear"
	display_name = "pear tree"
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/drink/juice/pear = list(10,10))

/datum/seed/pear/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"apple")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e1e463")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_FLESH_COLOUR,"#e8e39b")
	set_trait(TRAIT_IDEAL_LIGHT, 4)
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/coconut
	name = "coconuts"
	seed_name = "coconut"
	display_name = "coconut tree"
	chems = list(/datum/reagent/nutriment = list(1,20), /datum/reagent/drink/coconut = list(10,20))
	trash_type = /obj/item/carvable/corncob/hollowcoconut

/datum/seed/coconut/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#a36b09")
	set_trait(TRAIT_PLANT_ICON,"tree4")
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/cinnamon
	name = "cinnamon"
	seed_name = "cinnamon"
	display_name = "cinnamon tree"
	chems = list(/datum/reagent/cinnamon = list(10,20))
	fruit_size = ITEM_SIZE_TINY

/datum/seed/cinnamon/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR,"#cd6139")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.05)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

/datum/seed/olives
	name = "olives"
	seed_name = "olives"
	display_name = "olive tree"
	chems = list(/datum/reagent/nutriment = list(1,20), /datum/reagent/oliveoil = list(10,20))

/datum/seed/olives/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"grapes")
	set_trait(TRAIT_PRODUCT_COLOUR,"#87a46e")
	set_trait(TRAIT_PLANT_COLOUR,"#378f2e")
	set_trait(TRAIT_PLANT_ICON,"vine")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)


// Exotic Edibles

/datum/seed/gukhe
	name = "gukhe"
	seed_name = "gukhe bloom"
	display_name = "gukhe bloom"
	chems = list(/datum/reagent/nutriment = list(2,12), /datum/reagent/capsaicin = list(10,10))
	kitchen_tag = "gukhe"

/datum/seed/gukhe/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"algae")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e93e1c")
	set_trait(TRAIT_PLANT_COLOUR,"#6d9c6b")
	set_trait(TRAIT_PLANT_ICON,"algae")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/hrukhza
	name = "hrukhza"
	seed_name = "hrukhza flower"
	display_name = "hrukhza flower"
	chems = list(/datum/reagent/drink/unathijuice = list(10,10), /datum/reagent/nutriment = list(5,5))

/datum/seed/hrukhza/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"tobacco")
	set_trait(TRAIT_PRODUCT_COLOUR,"#126028")
	set_trait(TRAIT_PLANT_COLOUR,"#749733")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_HEAT, 299)
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/okrri
	name = "okrri"
	seed_name = "o'krri mushroom"
	seed_noun = SEED_NOUN_SPORES
	display_name = "o'krri cluster"
	chems = list(/datum/reagent/nutriment = list(1,25), /datum/reagent/drugs/psilocybin = list(1,3))
	splat_type = /obj/vine
	kitchen_tag = "mushroom"

/datum/seed/okrri/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e0e926")
	set_trait(TRAIT_PLANT_COLOUR,"#caa859")
	set_trait(TRAIT_PLANT_ICON,"mushroom")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_IDEAL_HEAT, 288)
	set_trait(TRAIT_LIGHT_TOLERANCE, 4)

/datum/seed/ximikoa
	name = "ximikoa"
	seed_name = "ximi'koa"
	display_name = "ximi'koa patch"
	chems = list(/datum/reagent/nutriment = list(1,2), /datum/reagent/sugar = list(4,5))
	fruit_size = ITEM_SIZE_TINY

/datum/seed/ximikoa/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"flower6")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e12626")
	set_trait(TRAIT_PLANT_COLOUR,"#c54646")
	set_trait(TRAIT_PLANT_ICON,"flower4")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.05)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

/datum/seed/qokkloa
	name = "qokkloa"
	seed_name = "qokk'loa moss"
	display_name = "qokk'loa moss"
	chems = list(/datum/reagent/drugs/hextro = list(1,25), /datum/reagent/ethanol/qokkloa = list(10,10) )

/datum/seed/qokkloa/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"alien3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#8c4637")
	set_trait(TRAIT_PLANT_COLOUR,"#37808c")
	set_trait(TRAIT_PLANT_ICON,"tree5")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/aghrassh
	name = "aghrassh"
	seed_name = "aghrassh"
	display_name = "aghrassh tree"
	chems = list(/datum/reagent/nutriment = list(1,20))
	kitchen_tag = "aghrassh"

/datum/seed/aghrassh/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#866523")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_PHOTOSYNTHESIS, 1)

/datum/seed/gummen
	name = "gummen"
	seed_name = "gummen"
	display_name = "gummen bean plant"
	chems = list(/datum/reagent/nutriment = list(10,20))

/datum/seed/gummen/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"bean")
	set_trait(TRAIT_PRODUCT_COLOUR,"#36a32f")
	set_trait(TRAIT_PLANT_ICON,"stalk")

/datum/seed/flower/affelerin
	name = "affelerin"
	seed_name = "affelerin"
	display_name = "affelerin flower"
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/drink/affelerin = list(10,10))
	fruit_size = ITEM_SIZE_TINY

/datum/seed/flower/affelerin/New()
	..()
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#31d496")
	set_trait(TRAIT_PLANT_ICON,"flower3")
	set_trait(TRAIT_FLESH_COLOUR,"#ac43e0")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/berry/iridast
	name = "iridast"
	seed_name = "iridast"
	display_name = "iridast bush"
	mutants = list("berries","glowberries","poisonberries","blueberries")
	chems = list(/datum/reagent/nutriment = list(1,10), /datum/reagent/ethanol/iridast = list(10,10), /datum/reagent/drugs/psilocybin = list(1,3))
	kitchen_tag = "berries"

/datum/seed/berry/iridast/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fa68ff")
	set_trait(TRAIT_PLANT_ICON,"bush")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

//aquaculture

/datum/seed/shellfish 		//parent shellfish
	name = "shellfish"
	seed_name = "shellfish"
	seed_noun = SEED_NOUN_EGGS
	display_name = "bed of shellfish"
	product_type = /obj/item/shellfish

/datum/seed/shellfish/New()
	..()
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_CARNIVOROUS,1)
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"egg")
	set_trait(TRAIT_WATER_CONSUMPTION,6)
	set_trait(TRAIT_IDEAL_LIGHT,4)
	set_trait(TRAIT_LIGHT_TOLERANCE,6)
	set_trait(TRAIT_IDEAL_HEAT, 288)
	set_trait(TRAIT_PRODUCT_COLOUR,"#f2f2f2")
	set_trait(TRAIT_PLANT_COLOUR,"#f2f2f2")
	set_trait(TRAIT_PLANT_ICON,"algae")
	set_trait(TRAIT_PHOTOSYNTHESIS,0)


/datum/seed/shellfish/clam
	name = "clam"
	seed_name = "clam"
	display_name = "bed of clams"
	product_type = /obj/item/shellfish/clam

/datum/seed/shellfish/clam/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCT_COLOUR,"#f2f2f2")
	set_trait(TRAIT_PLANT_COLOUR,"#f2f2f2")


/datum/seed/shellfish/mussel
	name = "mussel"
	seed_name = "mussel"
	display_name = "bed of mussels"
	product_type = /obj/item/shellfish/mussel

/datum/seed/shellfish/mussel/New()
	..()
	set_trait(TRAIT_IDEAL_LIGHT,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_IDEAL_HEAT, 295)
	set_trait(TRAIT_PRODUCT_COLOUR,"#34449f")
	set_trait(TRAIT_PLANT_COLOUR,"#34449f")


/datum/seed/shellfish/oyster
	name = "oyster"
	seed_name = "oyster"
	display_name = "bed of oysters"
	product_type = /obj/item/shellfish/oyster

/datum/seed/shellfish/oyster/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#a8899c")
	set_trait(TRAIT_PLANT_COLOUR,"#a8899c")


/datum/seed/shellfish/shrimp
	name = "shrimp"
	seed_name = "shrimp"
	display_name = "bed of shrimp"
	product_type = /obj/item/shellfish/shrimp

/datum/seed/shellfish/shrimp/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_IDEAL_LIGHT,7)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_IDEAL_HEAT, 295)
	set_trait(TRAIT_PRODUCT_COLOUR,"#f8897b")
	set_trait(TRAIT_PLANT_COLOUR,"#f8897b")


/datum/seed/shellfish/crab
	name = "crab"
	seed_name = "crab"
	display_name = "bed of crabs"
	can_self_harvest = TRUE
	product_type = /mob/living/simple_animal/passive/crab

/datum/seed/shellfish/crab/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,0)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_IDEAL_LIGHT,5)
	set_trait(TRAIT_PRODUCT_COLOUR,"#ef5f32")
	set_trait(TRAIT_PLANT_COLOUR,"#ef5f32")

/datum/seed/almond
	name = "almond"
	seed_name = "almond"
	display_name = "almond plant"
	chems = list(/datum/reagent/nutriment/almondmeal = list(4,7))
	kitchen_tag = "almond"

/datum/seed/almond/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"nuts")
	set_trait(TRAIT_PRODUCT_COLOUR,"#eddcc8")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/maneater
	name = "maneater"
	seed_name = "maneater"
	seed_noun = SEED_NOUN_PITS
	display_name = "bulbous pod"
	can_self_harvest = TRUE
	product_type = /mob/living/simple_animal/hostile/man_eater

/datum/seed/maneater/New()
	..()
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_ENDURANCE,10)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#40641a")
	set_trait(TRAIT_PLANT_COLOUR,"#579712")
	set_trait(TRAIT_PLANT_ICON,"alien4")
	set_trait(TRAIT_HARVEST_REPEAT,1)
