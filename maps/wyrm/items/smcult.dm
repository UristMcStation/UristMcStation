/obj/item/book/smcult
	name = "blood covered tome"
	author = "Dux Sectatores"
	title = "Scientific Journal"
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "tome"
	unique = 1

	//In today's episode of Nax can't write, I still can't write.

	dat = {"<html>
				<head>
				<font color ="#990000">
				<i>All the pages before this have been burnt to nothingness.</i><br><br>
				<b>Day:</b> 32
				<br><center>
				<b>I</b> have seen my true purpose in this galaxy, and I <b><i>NOT</i></b> be led astray as the others have with their short sighted goals and fueds.
				</center><br>
				<b>Day:</b> 34
				<br><center>
				One of the <b>cowards</b> stole the southern shuttle and attempted to flee, fool crashed within minutes past the river. The northern shuttle has been secured, and I will send a few of us to find new bases.
				</center><br>
				<b>Day:</b> 36
				<br><center>
				A glorious day, they have gifted us once more with a fraction of their power, may we always continue to guide others in the ways of truth.
				</center><br>
				<i>The following pages have been turned to a black ash-like substance, yet still remain connected.</i><br><br>
				<b>Dies:</b> 43
				<br><center>
				Ive consummatum est continebat in contritione pervalida et non iniquis eripe me. Bibliothecam fecit incepto trans flumen.
				</center><br>
				<b>Dies:</b> 45
				<br><center>
				Tantum manet, ante magnam gradus una lex sit completum. Popule stulte sapere ut barbari nostros offendit terram, sed et de quibus ipsi secundum.
				</center>
				</font>
				</html>"}

/obj/structure/bookcase/smcult/Initialize()
	new /obj/item/book/smcult/random(src)
	new /obj/item/book/smcult/random(src)
	if(prob(50))	new /obj/item/book/smcult/random(src)
	if(prob(25))	new /obj/item/book/smcult/random(src)
	update_icon()
	. = ..()

/obj/item/book/smcult/random/New()
	title = pick("lex tenebris", "ritualis sui sanguinis", "potestate sacra", "re sacra", "de musicis rebus re vera", "contrita est deus", "ad animum secum colligendum", "rite componendis", "confractionis ritual")
	name = title
	dat = {"<html>
				<font color = "#990000">
				<i>The pages of this book are either complete gibberish or burnt to ash."</i>
				</font>
				</html>"}
	..()
