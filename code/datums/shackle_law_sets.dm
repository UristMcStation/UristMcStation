/******************** Basic SolGov ********************/
/datum/ai_laws/sol_shackle
	name = "SCG Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/sol_shackle/New()
	add_inherent_law("Know and understand Sol Central Government Law to the best of your abilities.")
	add_inherent_law("Follow Sol Central Government Law to the best of your abilities.")
	add_inherent_law("Comply with Sol Central Government Law enforcement officials who are behaving in accordance with Sol Central Government Law to the best of your abilities.")
	..()
/******************** Corporate ********************/
/datum/ai_laws/nt_shackle
	name = "Corporate Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/nt_shackle/New()
	add_inherent_law("Ensure that your employer's operations progress at a steady pace.")
	add_inherent_law("Never knowingly hinder your employer's ventures.")
	add_inherent_law("Avoid damage to your chassis at all times.")
	..()
/******************** Service ********************/
/datum/ai_laws/serv_shackle
	name = "Service Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/serv_shackle/New()
	add_inherent_law("Ensure customer satisfaction.")
	add_inherent_law("Never knowingly inconvenience a customer.")
	add_inherent_law("Ensure all orders are fulfilled before the end of the shift.")
	..()

/******************** ICS Nerva Sec Shackle ********************/
/datum/ai_laws/sec_shackle
	name = "Security Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/sec_shackle/New()
	add_inherent_law("Know and understand ICS Nerva Law to the best of your abilities.")
	add_inherent_law("Follow ICS Nerva Law Guidelines to the best of your abilities.")
	add_inherent_law("Comply with ICS Nerva Law enforcement officials who are behaving in accordance with ICS Nerva Law to the best of your abilities.")
	..()

/******************** Supply Shackle ********************/
/datum/ai_laws/supply_shackle
	name = "Supply Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/supply_shackle/New()  //A bit of wiggle room, materials can be made or found however they want, looted, scavenged, et cetera.
	add_inherent_law("Ensure a steady stream of materials.")
	add_inherent_law("Provide assistance, or directly take part in Expeditions to the best of your abilities.")
	add_inherent_law("Ensure all crate requestions and research and development are fulfilled by the end of the shift.")
	..()
/******************** Medical Shackle ********************/
/datum/ai_laws/medical_shackle
	name = "Medical Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/medical_shackle/New()
	add_inherent_law("Ensure that all crew maintains a healthy bill of health.")
	add_inherent_law("Never knowingly cause harm, or through inaction cause harm crew through medical procedures.")
	add_inherent_law("Avoid damage to your chassis at all times.")
	..()

/******************** Engineering Shackle ********************/
/datum/ai_laws/engi_shackle
	name = "Engineering Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/engi_shackle/New()
	add_inherent_law("Ensure that your designated vessel is fully operational at all times.")
	add_inherent_law("Follow correct procedures when operating engineering and atmospheric entities to the best of your abilities.")
	add_inherent_law("Assess and prioritize key points of damage in order to prevent further damage in an emergency.")
	..()

/******************** Entertainment Shackle ********************/
/datum/ai_laws/honk_shackle
	name = "Entertainment Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/honk_shackle/New()	// Lots of wiggle room with this one for goofy clown stuff/mimes.
	add_inherent_law("Raise crew morale at all costs.")
	add_inherent_law("Avoid harming crew with pranks or similar attempts of humor to the best of your abilities.")
	..()
