
/*| Neon Signs
   ----------------------------------------------*/

   //| Note: for a more varied range of colors, I chose not to use the pre- #defined colors and instead individually converted the RGB values from each sprite into hex code - Mal

/obj/structure/sign/neon/Destroy()
	set_light(0)
	return ..()

/obj/structure/sign/neon
	desc = "A glowing sign."
	icon = 'icons/urist/citymap_icons/signs.dmi'
//	light_range = 4
//	light_power = 2

/obj/structure/sign/neon/item
	name = "item store"
	icon_state = "item"
	light_color = "#b79f41" //copper

/obj/structure/sign/neon/motel
	name = "motel"
	icon_state = "motel"
	light_color = "#59ff9b" //teal

/obj/structure/sign/neon/hotel
	name = "hotel"
	icon_state = "hotel"
	light_color = "#59ff9b" //teal

/obj/structure/sign/neon/flashhotel
	name = "hotel"
	icon_state = "flashhotel"
	light_color = "#ff8ff8" //hot pink

/obj/structure/sign/neon/lovehotel
	name = "hotel"
	icon_state = "lovehotel"
	light_color = "#59ff9b" //teal

/obj/structure/sign/neon/sushi
	name = "sushi"
	icon_state = "sushi"
	light_color = "#7dd3ff"  //sky blue

/obj/structure/sign/neon/bakery
	name = "bakery"
	icon_state = "bakery"
	light_color = "#ff8fee" //hot pink

/obj/structure/sign/neon/beer
	name = "pub"
	icon_state = "beer"
	light_color = "#cbdc54" //yellow

/obj/structure/sign/neon/inn
	name = "inn"
	icon_state = "inn"
	light_color = "#f070ff"  //deeper hot pink

/obj/structure/sign/neon/inn_alt
	name = "inn"
	icon_state = "inn_alt"
	light_color = "#39ffa4" //teal

/obj/structure/sign/neon/cafe
	name = "cafe"
	icon_state = "cafe"
	light_color = "#ff8fee" //hot pink

/obj/structure/sign/neon/diner
	name = "diner"
	icon_state = "diner"
	light_color = "#59ff9b" //teal

/obj/structure/sign/neon/bar_alt
	name = "bar"
	icon_state = "bar_alt"
	light_color = "#39ffa4" //teal

/obj/structure/sign/neon/casino
	name = "casino"
	icon_state = "casino"
	light_color = "#6ce08a" //teal

/obj/structure/sign/neon/cupcake
	name = "casino"
	icon_state = "casino"
	light_color = "#f4a9d8" //pink!

/obj/structure/sign/neon/peace
	name = "peace"
	icon_state = "peace"
	light_color = "#8559ff" //a cross between the blue and purple

/obj/structure/sign/neon/sale
	name = "sale"
	icon_state = "sale"
	light_color = "#6eb6ff" //sky blue

/obj/structure/sign/neon/exit
	name = "exit"
	icon_state = "exit"
	light_color = "#7fea6a" //lime green

/obj/structure/sign/neon/close
	name = "close"
	icon_state = "close"
	light_color = "#7fea6a" //lime green

/obj/structure/sign/neon/open
	name = "open"
	icon_state = "open"
	light_color = "#ffffff" //white

/obj/structure/sign/neon/disco
	name = "disco"
	icon_state = "disco"

/obj/structure/sign/neon/phone
	name = "phone"
	icon_state = "phone"
	light_color = "#7fea6a" //lime green

/obj/structure/sign/neon/armory
	name = "armory"
	icon_state = "armory"
	light_color = "#7fea6a" //lime green

/obj/structure/sign/neon/pizza
	name = "pizza"
	icon_state = "pizza"
	light_color = "#33cc00" //green

/obj/structure/sign/neon/clothes
	name = "clothes"
	icon_state = "clothes"
	light_color = "#ff9326" //orange

/obj/structure/sign/neon/bar
	name = "bar sign"
	desc = "The sign says 'Bar' on it."
	icon_state = "bar"
	light_color = "#63c4d6" //light blue

/*|	                                             */
/*| Double Signs
   ----------------------------------------------*/

/obj/structure/sign/double/city
	desc = "A sign."
	pixel_y = 32
	icon = 'icons/urist/citymap_icons/signs.dmi'

/obj/structure/sign/double/city/gamecenter
	name = "Game Center"
	desc = "A flashing sign which reads 'Game Center'."
	light_color = "#ffa851" //orange
//	light_range = 4
//	light_power = 2

/obj/structure/sign/double/city/gamecenter/right
	icon_state = "gamecenter-right"

/obj/structure/sign/double/city/gamecenter/left
	icon_state = "gamecenter-left"

/obj/structure/sign/double/city/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/double/city/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/city/maltesefalcon/right
	icon_state = "maltesefalcon-right"

//Making area mapping simpler since 2240//

/obj/structure/sign/double/city/teleporter/left
	name = "teleporter"
	icon_state = "teleporter1"
/obj/structure/sign/double/city/teleporter/right
	name = "teleporter"
	icon_state = "teleporter2"

/obj/structure/sign/double/city/museum/left
	icon_state = "museum1"
/obj/structure/sign/double/museum/right
	icon_state = "museum2"

/obj/structure/sign/double/city/police/left
	icon_state = "police1"
/obj/structure/sign/double/city/police/right
	icon_state = "police2"

/obj/structure/sign/double/city/warden/left
	icon_state = "warden1"
/obj/structure/sign/double/city/warden/right
	icon_state = "warden2"

/obj/structure/sign/double/city/copoffice/left
	icon_state = "copoffice1"
/obj/structure/sign/double/city/copoffice/right
	icon_state = "copoffice2"

/obj/structure/sign/double/city/visit/left
	icon_state = "visit1"
/obj/structure/sign/double/city/visit/right
	icon_state = "visit2"

/obj/structure/sign/double/city/prosecution/left
	icon_state = "prosecution1"
/obj/structure/sign/double/city/prosecution/right
	icon_state = "prosecution2"

/obj/structure/sign/double/city/defense/left
	icon_state = "defense1"
/obj/structure/sign/double/city/defense/right
	icon_state = "defense2"

/obj/structure/sign/double/city/courtyard/left
	icon_state = "courtyard1"
/obj/structure/sign/double/city/courtyard/right
	icon_state = "courtyard2"

/obj/structure/sign/double/city/training/left
	icon_state = "train1"
/obj/structure/sign/double/city/training/right
	icon_state = "train2"

/obj/structure/sign/double/city/cityhall/left
	icon_state = "cityhall1"
/obj/structure/sign/double/city/cityhall/right
	icon_state = "cityhall2"

/obj/structure/sign/double/city/mayor/left
	icon_state = "mayor1"
/obj/structure/sign/double/city/mayor/right
	icon_state = "mayor2"

/obj/structure/sign/city/directional/left
	icon_state = "cityhalldir1"
	pixel_y = 32
/obj/structure/sign/city/directional/right
	icon_state = "cityhalldir2"
	pixel_y = 32

/obj/structure/sign/double/city/challcar/left
	icon_state = "challcar1"
/obj/structure/sign/double/city/challcar/right
	icon_state = "challcar2"

/obj/structure/sign/double/city/meetingroom/left
	icon_state = "meetingroom1"
/obj/structure/sign/double/city/meetingroom/right
	icon_state = "meetingroom2"

/obj/structure/sign/double/city/hospital/left
	icon_state = "hospital1"
/obj/structure/sign/double/city/hospital/right
	icon_state = "hospital2"

/obj/structure/sign/double/city/court/left
	icon_state = "court1"
/obj/structure/sign/double/city/court/right
	icon_state = "court2"



/*|	                                             */
/*| Normal Signs
   ----------------------------------------------*/

/obj/structure/sign/city
	desc = "A sign."
	icon = 'icons/urist/citymap_icons/signs.dmi'

/obj/structure/sign/city/rent
	name = "Rent sign"
	icon_state = "rent"
	desc = "A sign that says 'For Rent' on it. This house might be vacant."

/obj/structure/sign/city/coffee
	name = "Coffee And Sweets"
	desc = "A sign which reads 'Coffee and Sweets'."
	icon_state = "coffee-left"

/obj/structure/sign/city/techshop
	name = "\improper techshop"
	desc = "A sign which reads 'tech shop'."
	icon_state = "techshop"

/obj/structure/sign/city/forsale
	name = "For Sale sign"
	icon_state = "forsale"
	desc = "A sign that says 'For Sale' on it."