#define MATERIAL_PLASTIC                 "plastic"
#define MATERIAL_PLASTEEL                "plasteel"
#define MATERIAL_STEEL                   "steel"
#define MATERIAL_GLASS                   "glass"
#define MATERIAL_GOLD                    "gold"
#define MATERIAL_SILVER                  "silver"
#define MATERIAL_ELECTRUM                "electrum"
#define MATERIAL_DIAMOND                 "diamond"
#define MATERIAL_PHORON                  "phoron"
#define MATERIAL_URANIUM                 "uranium"
#define MATERIAL_CRYSTAL                 "crystal"
#define MATERIAL_SANDSTONE               "sandstone"
#define MATERIAL_CONCRETE                "concrete"
#define MATERIAL_IRON                    "iron"
#define MATERIAL_PLATINUM                "platinum"
#define MATERIAL_BRONZE                  "bronze"
#define MATERIAL_BORAX                   "borax"
#define MATERIAL_BORON_GLASS             "borosilicate glass"
#define MATERIAL_MARBLE                  "marble"
#define MATERIAL_RESIN                   "resin"
#define MATERIAL_CULT                    "cult"
#define MATERIAL_REINFORCED_CULT         "cult2"
#define MATERIAL_VOX                     "voxalloy"
#define MATERIAL_TITANIUM                "titanium"
#define MATERIAL_RUTILE					 "rutile"
#define MATERIAL_OSMIUM_CARBIDE_PLASTEEL "osmium-carbide plasteel"
#define MATERIAL_OSMIUM                  "osmium"
#define MATERIAL_HYDROGEN                "hydrogen"
#define MATERIAL_WASTE                   "waste"
#define MATERIAL_ELEVATORIUM             "elevatorium"
#define MATERIAL_ALIENALLOY              "aliumium"
#define MATERIAL_SAND                    "sand"
#define MATERIAL_GRAPHITE                "graphite"
#define MATERIAL_DEUTERIUM               "deuterium"
#define MATERIAL_TRITIUM                 "tritium"
#define MATERIAL_SUPERMATTER             "supermatter"
#define MATERIAL_PITCHBLENDE             "pitchblende"
#define MATERIAL_HEMATITE                "hematite"
#define MATERIAL_QUARTZ                  "quartz"
#define MATERIAL_PYRITE                  "pyrite"
#define MATERIAL_SPODUMENE               "spodumene"
#define MATERIAL_CINNABAR                "cinnabar"
#define MATERIAL_PHOSPHORITE             "phosphorite"
#define MATERIAL_ROCK_SALT               "rock salt"
#define MATERIAL_POTASH                  "potash"
#define MATERIAL_BAUXITE                 "bauxite"
#define MATERIAL_COPPER                  "copper"
#define MATERIAL_CARDBOARD               "cardboard"
#define MATERIAL_CLOTH                   "cloth"
#define MATERIAL_CARPET                  "carpet"
#define MATERIAL_ALUMINIUM               "aluminium"
#define MATERIAL_NULLGLASS               "nullglass"
#define MATERIAL_GROWTH                  "growth"

//woods
#define MATERIAL_WOOD                    "wood"
#define MATERIAL_MAHOGANY                "mahogany"
#define MATERIAL_MAPLE                   "maple"
#define MATERIAL_EBONY                   "ebony"
#define MATERIAL_WALNUT                  "walnut"
#define MATERIAL_BAMBOO                  "bamboo"
#define MATERIAL_YEW                     "yew"
#define MATERIAL_VOXRES                  "vox bioresin"

// skins and bones
#define MATERIAL_SKIN_GENERIC            "skin"
#define MATERIAL_SKIN_LIZARD             "lizardskin"
#define MATERIAL_SKIN_CHITIN             "chitin"
#define MATERIAL_SKIN_FUR                "brown fur"
#define MATERIAL_SKIN_FUR_GRAY           "gray fur"
#define MATERIAL_SKIN_FUR_WHITE          "white fur"
#define MATERIAL_SKIN_GOATHIDE           "goathide"
#define MATERIAL_SKIN_COWHIDE            "cowhide"
#define MATERIAL_SKIN_SHARK              "sharkskin"
#define MATERIAL_SKIN_FISH               "fishskin"
#define MATERIAL_SKIN_FUR_ORANGE         "orange fur"
#define MATERIAL_SKIN_FUR_BLACK          "black fur"
#define MATERIAL_SKIN_FUR_HEAVY          "heavy fur"
#define MATERIAL_SKIN_FISH_PURPLE        "purple fishskin"
#define MATERIAL_SKIN_FEATHERS           "white feathers"
#define MATERIAL_SKIN_FEATHERS_PURPLE    "purple feathers"
#define MATERIAL_SKIN_FEATHERS_BLUE      "blue feathers"
#define MATERIAL_SKIN_FEATHERS_GREEN     "green feathers"
#define MATERIAL_SKIN_FEATHERS_BROWN     "brown feathers"
#define MATERIAL_SKIN_FEATHERS_RED       "red feathers"
#define MATERIAL_SKIN_FEATHERS_BLACK     "black feathers"
#define MATERIAL_HIDE_GENERIC			 "scraped hide"

#define MATERIAL_BONE_GENERIC            "bone"
#define MATERIAL_BONE_CARTILAGE          "cartilage"
#define MATERIAL_BONE_FISH               "fishbone"

#define MATERIAL_LEATHER_GENERIC         "leather"
#define MATERIAL_LEATHER_LIZARD          "scaled hide"
#define MATERIAL_LEATHER_FUR             "furred hide"
#define MATERIAL_LEATHER_CHITIN          "treated chitin"

// defaults
#define DEFAULT_WALL_MATERIAL      MATERIAL_STEEL
#define DEFAULT_FURNITURE_MATERIAL MATERIAL_ALUMINIUM

#define MATERIAL_ALTERATION_NONE     FLAGS_OFF
#define MATERIAL_ALTERATION_NAME     FLAG_01
#define MATERIAL_ALTERATION_DESC     FLAG_02
#define MATERIAL_ALTERATION_COLOR    FLAG_03
#define MATERIAL_ALTERATION_ALL      (~MATERIAL_ALTERATION_NONE)

#define SHARD_SHARD "shard"
#define SHARD_SHRAPNEL "shrapnel"
#define SHARD_STONE_PIECE "piece"
#define SHARD_SPLINTER "splinters"
#define SHARD_NONE ""

#define MATERIAL_UNMELTABLE    FLAG_01
#define MATERIAL_BRITTLE       FLAG_02
#define MATERIAL_PADDING       FLAG_03

#define TABLE_BRITTLE_MATERIAL_MULTIPLIER 4 // Amount table damage is multiplied by if it is made of a brittle material (e.g. glass)

//Weight thresholds
#define MATERIAL_HEAVY 		24
#define MATERIAL_LIGHT    	18

//Construction difficulty
#define MATERIAL_EASY_DIY 		0
#define MATERIAL_NORMAL_DIY    	1
#define MATERIAL_HARD_DIY    	2
#define MATERIAL_VERY_HARD_DIY 	3

//Stack flags
#define USE_MATERIAL_COLOR            FLAG_01
#define USE_MATERIAL_SINGULAR_NAME    FLAG_02
#define USE_MATERIAL_PLURAL_NAME      FLAG_03
#define USE_MATERIAL_ICON             FLAG_04

//Arbitrary hardness thresholds
#define  MATERIAL_SOFT   10
#define  MATERIAL_FLEXIBLE  20
#define  MATERIAL_RIGID  40
#define  MATERIAL_HARD  60
#define  MATERIAL_VERY_HARD  80

//Wall & Airlock layering flags
#define MATERIAL_PAINTABLE_MAIN FLAG_01
#define MATERIAL_PAINTABLE_STRIPE FLAG_02
#define MATERIAL_PAINTABLE_DETAIL FLAG_03
#define MATERIAL_PAINTABLE_WINDOW FLAG_04
#define MATERIAL_WALL_HAS_EDGES FLAG_05
