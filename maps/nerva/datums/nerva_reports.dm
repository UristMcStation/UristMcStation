
//all ported from torch and mildly edited for nerva, for people who really like paperwork.
//command

/datum/computer_file/report/recipient/crew_transfer
	form_name = "CTA-PR-01"
	title = "Crew Transfer Application"
	logo = "\[nervalogo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/crew_transfer/generate_fields()
	..()
	var/list/xo_fields = list()
	add_field(/datum/report_field/text_label/header, "ICS Nerva - Personnel Resources")
	add_field(/datum/report_field/people/from_manifest, "Name (SO)")
	add_field(/datum/report_field/people/from_manifest, "Name (applicant)", required = 1)
	add_field(/datum/report_field/date, "Date filed")
	add_field(/datum/report_field/time, "Time filed")
	add_field(/datum/report_field/simple_text, "Present position")
	add_field(/datum/report_field/simple_text, "Requested position")
	add_field(/datum/report_field/pencode_text, "Reason stated")
	add_field(/datum/report_field/text_label/instruction, "The following fields render the document invalid if not signed clearly.")
	add_field(/datum/report_field/signature, "Applicant signature")
	xo_fields += add_field(/datum/report_field/signature, "Second Officer's signature")
	xo_fields += add_field(/datum/report_field/number, "Number of personnel in present/previous position")
	xo_fields += add_field(/datum/report_field/number, "Number of personnel in requested position")
	xo_fields += add_field(/datum/report_field/options/yes_no, "Approved")
	for(var/datum/report_field/field in xo_fields)
		field.set_access(access_edit = access_hop)

/datum/computer_file/report/recipient/access_modification
	form_name = "AMA-PR-02"
	title = "Crew Access Modification Application"
	logo = "\[nervalogo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/access_modification/generate_fields()
	..()
	var/list/xo_fields = list()
	add_field(/datum/report_field/text_label/header, "ICS Nerva - Personnel Resources")
	add_field(/datum/report_field/people/from_manifest, "Name (SO)")
	add_field(/datum/report_field/people/from_manifest, "Name (applicant)", required = 1)
	add_field(/datum/report_field/date, "Date filed")
	add_field(/datum/report_field/time, "Time filed")
	add_field(/datum/report_field/simple_text, "Present position")
	add_field(/datum/report_field/simple_text, "Requested access")
	add_field(/datum/report_field/pencode_text, "Reason stated")
	add_field(/datum/report_field/simple_text, "Duration of expanded access")
	add_field(/datum/report_field/text_label/instruction, "The following fields render the document invalid if not signed clearly.")
	add_field(/datum/report_field/signature, "Applicant signature")
	xo_fields += add_field(/datum/report_field/signature, "Second Officer's signature")
	xo_fields += add_field(/datum/report_field/number, "Number of personnel in relevant position")
	xo_fields += add_field(/datum/report_field/options/yes_no, "Approved")
	for(var/datum/report_field/field in xo_fields)
		field.set_access(access_edit = access_hop)


//Corporate/NT

/datum/computer_file/report/recipient/corp
	logo = "\[bluelogo\]"

/datum/computer_file/report/recipient/corp/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Vessel", GLOB.using_map.station_name)
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Index")


/datum/computer_file/report/recipient/corp/memo/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Subject")
	add_field(/datum/report_field/pencode_text, "Body")
	add_field(/datum/report_field/signature, "Authorizing Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")

/datum/computer_file/report/recipient/corp/memo/internal
	form_name = "NT-0003"
	title = "Internal Memorandum"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/memo/internal/New()
	..()
	set_access(access_xenobiology, access_xenobiology)

/datum/computer_file/report/recipient/corp/memo/external
	form_name = "NT-0005"
	title = "External Memorandum"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/memo/external/New()
	..()
	set_access(access_edit = access_xenobiology)

//No access restrictions for easier use.
/datum/computer_file/report/recipient/corp/sales
	form_name = "NT-2192"
	title = "Corporate Sales Contract and Receipt"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/sales/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "Product Information")
	add_field(/datum/report_field/simple_text, "Product Name")
	add_field(/datum/report_field/simple_text, "Product Type")
	add_field(/datum/report_field/number, "Product Unit Cost (T)")
	add_field(/datum/report_field/number, "Product Units Requested")
	add_field(/datum/report_field/number, "Total Cost (T)")
	add_field(/datum/report_field/text_label/header, "Seller Information")
	add_field(/datum/report_field/text_label/instruction, "The 'Purchaser' may not return any sold product units for re-compensation in [GLOB.using_map.local_currency_name], but may return the item for an identical item, or item of equal material (not [GLOB.using_map.local_currency_name_singular]) value. The 'Seller' agrees to make their best effort to repair, or replace any items that fail to accomplish their designed purpose, due to malfunction or manufacturing error - but not user-caused damage.")
	add_field(/datum/report_field/people/from_manifest, "Name")
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")

/datum/computer_file/report/recipient/corp/payout
	form_name = "NT-3310"
	title = "Next of Kin Payout Authorization"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/payout/generate_fields()
	..()
	add_field(/datum/report_field/people/from_manifest, "This document hereby authorizes the payout of the remaining salary of")
	add_field(/datum/report_field/pencode_text, "As well as the net-worth of any remaining personal assets: (Asset, [GLOB.using_map.local_currency_name_singular] Amount)")
	add_field(/datum/report_field/pencode_text, "Including personal effects")
	add_field(/datum/report_field/text_label, "To be shipped and delivered directly to the employee's next of kin without delay.")
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")
	set_access(access_edit = access_xenobiology)

/datum/computer_file/report/recipient/corp/fire
	form_name = "NT-0102"
	title = "Corporate Employment Termination Form"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/fire/New()
	..()
	set_access(access_heads, access_heads)
	set_access(access_xenobiology, override = 0)

/datum/computer_file/report/recipient/corp/fire/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "Notice of Termination of Employment")
	add_field(/datum/report_field/people/from_manifest, "Name")
	add_field(/datum/report_field/number, "Age")
	add_field(/datum/report_field/simple_text, "Position")
	add_field(/datum/report_field/pencode_text, "Reason for Termination")
	add_field(/datum/report_field/signature, "Authorized by")
	add_field(/datum/report_field/text_label/instruction, "Please attach employment records alongside notice of termination.")

/datum/computer_file/report/recipient/corp/incident/New()
	..()
	set_access(access_edit = access_xenobiology)

/datum/computer_file/report/recipient/corp/incident/generate_fields()
	..()
	add_field(/datum/report_field/pencode_text, "Summary of Incident")
	add_field(/datum/report_field/pencode_text, "Details of Incident")

/datum/computer_file/report/recipient/corp/incident/proc/add_signatures()
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/signature, "Witness Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")

/datum/computer_file/report/recipient/corp/incident/ship
	form_name = "NT-3203"
	title = "Corporate Ship Incident Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/incident/ship/generate_fields()
	..()
	add_field(/datum/report_field/pencode_text, "Departments Involved")
	add_signatures()

/datum/computer_file/report/recipient/corp/volunteer
	form_name = "NT-1443"
	title = "Corporate Test Subject Volunteer Form"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/volunteer/generate_fields()
	..()
	var/list/temp_fields = list()
	add_field(/datum/report_field/people/from_manifest, "Name of Volunteer")
	add_field(/datum/report_field/simple_text, "Intended Procedure(s)")
	add_field(/datum/report_field/simple_text, "Compensation for Volunteer: (if any)")
	add_field(/datum/report_field/people/list_from_manifest, "Handling Researcher(s)")
	add_field(/datum/report_field/text_label/instruction, "By signing, the \"Volunteer\" agrees to absolve the Corporation, and its employees, of any liability or responsibility for injuries, damages, property loss or side-effects that may result from the intended procedure. If signed by an authorized representative, this form is deemed reviewed, but is only approved if so marked.")
	add_field(/datum/report_field/signature, "Volunteer's Signature:")
	temp_fields += add_field(/datum/report_field/signature, "Corporate Representative's Signature")
	temp_fields += add_field(/datum/report_field/options/yes_no, "Approved")
	for(var/datum/report_field/temp_field in temp_fields)
		temp_field.set_access(access_edit = access_xenobiology)

/datum/computer_file/report/recipient/corp/deny
	form_name = "NT-1443D"
	title = "Rejection of Test Subject Volunteer Notice"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/deny/generate_fields()
	..()
	add_field(/datum/report_field/text_label, "Dear Sir/Madam, we regret to inform you that your volunteer application for service as a test subject with the Corporation has been rejected. We thank you for your interest in our company and the progression of research. Attached, you will find a copy of your original volunteer form for your records. Regards,")
	add_field(/datum/report_field/signature, "Corporate Representative's Signature")
	add_field(/datum/report_field/people/from_manifest, "Name of Volunteer")
	add_field(/datum/report_field/text_label/header, "Reason for Rejection")
	add_field(/datum/report_field/options/yes_no, "Physically Unfit")
	add_field(/datum/report_field/options/yes_no, "Mentally Unfit")
	add_field(/datum/report_field/options/yes_no, "Project Cancellation")
	add_field(/datum/report_field/simple_text, "Other")
	add_field(/datum/report_field/options/yes_no, "Report Approved")
	set_access(access_edit = access_xenobiology)

//docking

/datum/computer_file/report/recipient/shuttle
	logo = "\[logo\]"

/datum/computer_file/report/recipient/docked
	logo = "\[logo\]"
	form_name = "SUP-12"
	title = "Docked Vessel Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/docked/New()
	..()
	set_access(access_cargo, access_cargo)
	set_access(access_heads, override = 0)

/datum/computer_file/report/recipient/docked/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ICS Nerva Supply and Hangar Management Department")
	add_field(/datum/report_field/text_label/header, "General Info")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/simple_text, "Vessel Name")
	add_field(/datum/report_field/simple_text, "Vessel Pilot/Owner")
	add_field(/datum/report_field/simple_text, "Vessel Intended Purpose")
	add_field(/datum/report_field/people/from_manifest, "Docking Authorized by")
	add_field(/datum/report_field/text_label/header, "General Cargo Info")
	add_field(/datum/report_field/pencode_text, "List the types of cargo onboard the vessel")
	add_field(/datum/report_field/text_label/header, "Hazardous Cargo Info")
	add_field(/datum/report_field/options/yes_no, "Weaponry")
	add_field(/datum/report_field/options/yes_no, "Live Cargo")
	add_field(/datum/report_field/options/yes_no, "Biohazardous material")
	add_field(/datum/report_field/options/yes_no, "Chemical or radiation hazard")
	add_field(/datum/report_field/signature, "To indicate authorization for vessel entry, sign here")
	add_field(/datum/report_field/text_label/header, "Undocking and Departure")
	add_field(/datum/report_field/time, "Undocking Time")
	add_field(/datum/report_field/pencode_text, "Additional Undocking Comments")

/datum/computer_file/report/recipient/exp
	logo = "\[logo\]"

/datum/computer_file/report/recipient/exp/fauna
	form_name = "EXP-19f"
	title = "Alien Fauna Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/exp/fauna/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ICS Nerva Expeditions")
	add_field(/datum/report_field/text_label/instruction, "The following is to be filled out by members of an away team after discovery and study of new alien life forms.")

	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/people/list_from_manifest, "Personnel Involved")
	add_field(/datum/report_field/pencode_text, "Anatomy/Appearance")
	add_field(/datum/report_field/pencode_text, "Locomotion")
	add_field(/datum/report_field/pencode_text, "Diet")
	add_field(/datum/report_field/pencode_text, "Habitat")
	add_field(/datum/report_field/simple_text, "Homeworld")
	add_field(/datum/report_field/pencode_text, "Behavior")
	add_field(/datum/report_field/pencode_text, "Defense/Offense")
	add_field(/datum/report_field/pencode_text, "Special Characteristic(s)")
	add_field(/datum/report_field/pencode_text, "Classification")

/datum/computer_file/report/recipient/exp/planet
	form_name = "EXP-17"
	title = "Exoplanet Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/exp/planet/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ICS Nerva Expeditions")
	add_field(/datum/report_field/text_label/instruction, "The following is to be filled out by members of an away team after an expedition to an uncharted Exoplanet.")

	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/simple_text, "Planet Name")
	add_field(/datum/report_field/people/list_from_manifest, "Personnel Involved")
	add_field(/datum/report_field/pencode_text, "Terrain Information")
	add_field(/datum/report_field/simple_text, "Habitability")
	add_field(/datum/report_field/pencode_text, "Summary on Fauna")
	add_field(/datum/report_field/pencode_text, "Summary on Flora")
	add_field(/datum/report_field/pencode_text, "Points of Interest")
	add_field(/datum/report_field/pencode_text, "Observations")


/datum/computer_file/report/recipient/shuttle/post_flight
	logo = "\[logo\]"
	form_name = "EXP-3"

//medical

/datum/computer_file/report/recipient/medical
	logo = "\[logo\]"
	form_name = "MED-00"

/datum/computer_file/report/recipient/medical/incidentreport
	form_name = "MED-04"
	title = "Medical Incident Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/medical/incidentreport/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Vessel", GLOB.using_map.station_name)
	add_field(/datum/report_field/date, "Date of Incident")
	add_field(/datum/report_field/time, "Time of Incident")
	add_field(/datum/report_field/people/from_manifest, "Patient")
	add_field(/datum/report_field/people/from_manifest, "Attending Physician")
	add_field(/datum/report_field/pencode_text, "Details of Injuries")
	add_field(/datum/report_field/pencode_text, "Details of Treatment")
	add_field(/datum/report_field/pencode_text, "Other Notes")
	add_field(/datum/report_field/text_label/instruction, "By signing below, I affirm that all of the above is factually correct to the best of my knowledge.")
	add_field(/datum/report_field/signature, "Attending Physician's Signature")
	set_access(access_surgery)

/datum/computer_file/report/recipient/medical/checkup
	form_name = "MED-013b"
	title = "Regular Health Checkup Checklist"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/medical/checkup/generate_fields()
	..()
	add_field(/datum/report_field/text_label/instruction, "You will need the following equipment for this: stethoscope, health analyzer, penlight.")
	add_field(/datum/report_field/people/from_manifest, "Patient")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Take pulse", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Check blood pressure", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Listen for heart noises", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Listen for lung noises", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask if they exercise", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask if they smoke, and how much per day", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Check eye reaction to penlight", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask about any recent radiation exposure", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask about any recent sickness", "NOT CHECKED")
	add_field(/datum/report_field/pencode_text, "Other Notes")
	add_field(/datum/report_field/signature, "Doctor's Signature")
	set_access(access_edit = access_medical_equip)

/datum/computer_file/report/recipient/medical/autopsy
	form_name = "MED-015"
	title = "Autopsy Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/medical/autopsy/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Vessel", GLOB.using_map.station_name)
	add_field(/datum/report_field/simple_text, "Patient Name")
	add_field(/datum/report_field/text_label/header, "Death Information")
	add_field(/datum/report_field/date, "Date of Death")
	add_field(/datum/report_field/time, "Time of Death")
	add_field(/datum/report_field/text_label/instruction, "Check yes if the time of death is estimated, no if it is exact.")
	add_field(/datum/report_field/options/yes_no, "Estimated")
	add_field(/datum/report_field/simple_text, "Cause(s) of Death")
	add_field(/datum/report_field/text_label/instruction, "Describe how the patient died.")
	add_field(/datum/report_field/pencode_text, "Death Narrative")
	add_field(/datum/report_field/text_label/instruction, "Describe postmortem handling of the body.")
	add_field(/datum/report_field/pencode_text, "Postmortem Narrative")
	add_field(/datum/report_field/text_label/header, "Doctor Information")
	add_field(/datum/report_field/text_label/instruction, "By signing below, I affirm that all of the above is factually correct to the best of my knowledge.")
	add_field(/datum/report_field/people/from_manifest, "Doctor")
	add_field(/datum/report_field/signature, "Doctor's Signature")
	set_access(access_morgue, access_surgery)

	add_field(/datum/report_field/text_label/instruction, "By signing below, I affirm that I have reviewed all of the above and affirm it is factually correct to the best of my knowledge. If there is no Chief Medical Officer available, this signature may be skipped.")
	var/datum/report_field/cmofield = add_field(/datum/report_field/people/from_manifest, "Chief Medical Officer")
	cmofield.set_access(access_morgue, access_cmo)
	cmofield = add_field(/datum/report_field/signature, "Chief Medical Officer's Signature")
	cmofield.set_access(access_morgue, access_cmo)

//borging contract

/datum/computer_file/report/recipient/borging
	form_name = "CC-BORG-09"
	title = "Cyborgification Contract"
	logo = "\[logo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/borging/generate_fields()
	..()
	var/list/xo_fields = list()
	add_field(/datum/report_field/text_label/header, "ICS Nerva - Robotics")
	add_field(/datum/report_field/people/from_manifest, "Name (Roboticist)", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Name (Acting Captain)", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Name (subject)", required = 1)
	add_field(/datum/report_field/date, "Date filed")
	add_field(/datum/report_field/time, "Time filed")
	add_field(/datum/report_field/text_label/instruction, "I, undersigned, hereby agree to willingly undergo a Regulation Lobotomization with intention of cyborgification or AI assimilation, and I am aware of all the consequences of such an act. I also understand that this operation may be irreversible, and that my employment contract will be terminated.")
	add_field(/datum/report_field/signature, "Subject's signature")
	add_field(/datum/report_field/signature, "Roboticist's signature")
	xo_fields += add_field(/datum/report_field/signature, "Acting Captain's signature")
	xo_fields += add_field(/datum/report_field/options/yes_no, "Approved")
	for(var/datum/report_field/field in xo_fields)
		field.set_access(access_edit = access_hop)

//anomaly

/datum/computer_file/report/recipient/sci/anomaly
	form_name = "NT-SCI-1546"
	title = "Anomalistic Object Report"
	logo = "\[bluelogo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sci/anomaly/New()
	..()
	set_access(access_research, access_research)

/datum/computer_file/report/recipient/sci/anomaly/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Vessel", GLOB.using_map.station_name)
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Index")
	add_field(/datum/report_field/simple_text, "AO Codename")
	add_field(/datum/report_field/people/from_manifest, "Reporting Scientist")
	add_field(/datum/report_field/people/from_manifest, "Overviewing Senior Scientist")
	add_field(/datum/report_field/pencode_text, "Containment Procedures")
	add_field(/datum/report_field/pencode_text, "Generalized Overview")
	add_field(/datum/report_field/simple_text, "Approximate Age of AO")
	add_field(/datum/report_field/simple_text, "Threat Level of AO")

//security

/datum/computer_file/report/recipient/sec
	logo = "\[logo\]"

/datum/computer_file/report/recipient/sec/New()
	..()
	set_access(access_security)
	set_access(access_heads, override = 0)

/datum/computer_file/report/recipient/sec/incident
	form_name = "SEC-01"
	title = "Security Incident Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/incident/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ICS Nerva Security Department")
	add_field(/datum/report_field/text_label/instruction, "To be filled out by Officer on duty responding to the Incident. Report must be signed and submitted before the end of the shift!")
	add_field(/datum/report_field/people/from_manifest, "Reporting Officer")
	add_field(/datum/report_field/simple_text, "Offense/Incident Type")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time of incident")
	add_field(/datum/report_field/people/list_from_manifest, "Assisting Officer(s)")
	add_field(/datum/report_field/simple_text, "Location")
	add_field(/datum/report_field/text_label/instruction, "(V-Victim, S-Suspect, W-Witness, M-Missing, A-Arrested, RP-Reporting Person, D-Deceased)")
	add_field(/datum/report_field/pencode_text, "Personnel involved in Incident")
	add_field(/datum/report_field/text_label/instruction, "(D-Damaged, E-Evidence, L-Lost, R-Recovered, S-Stolen)")
	add_field(/datum/report_field/pencode_text, "Description of Items/Property")
	add_field(/datum/report_field/pencode_text, "Narrative")
	add_field(/datum/report_field/signature, "Reporting Officer's signature")
	set_access(access_edit = access_security)

/datum/computer_file/report/recipient/sec/investigation
	form_name = "SEC-02"
	title = "Investigation Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/investigation/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ICS Nerva Security Department")
	add_field(/datum/report_field/text_label/instruction, "For internal use only.")
	add_field(/datum/report_field/people/from_manifest, "Name")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Case name")
	add_field(/datum/report_field/pencode_text, "Summary")
	add_field(/datum/report_field/pencode_text, "Observations")
	add_field(/datum/report_field/signature, "Signature")
	set_access(access_edit = access_security)

/datum/computer_file/report/recipient/sec/evidence
	form_name = "SEC-02b"
	title = "Evidence and Property Form"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/evidence/generate_fields()
	..()
	var/datum/report_field/temp_field
	add_field(/datum/report_field/text_label/header, "ICS Nerva Security Department")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/people/from_manifest, "Confiscated from")
	add_field(/datum/report_field/pencode_text, "List of items in custody/evidence lockup")
	set_access(access_edit = access_security)
	temp_field = add_field(/datum/report_field/signature, "Chief of Security's signature")
	temp_field.set_access(access_edit = list(access_security, access_armory))
	temp_field = add_field(/datum/report_field/signature, "Detective's signature")
	temp_field.set_access(access_edit = list(access_security, access_forensics_lockers))

/datum/computer_file/report/recipient/sec/statement
	form_name = "SEC-02c"
	title = "Written Statement"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/statement/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ICS Nerva Security Department")
	add_field(/datum/report_field/text_label/instruction, "To be filled out by crewmember involved to document their side of an incident.")
	add_field(/datum/report_field/people/from_manifest, "Submitting Individual")
	add_field(/datum/report_field/simple_text, "Offense/Incident Type")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time of incident")
	add_field(/datum/report_field/simple_text, "Location")
	add_field(/datum/report_field/text_label/instruction, "(V-Victim, S-Suspect, W-Witness, M-Missing, A-Arrested, RP-Reporting Person, D-Deceased)")
	add_field(/datum/report_field/pencode_text, "Personnel involved in Incident")
	add_field(/datum/report_field/text_label/instruction, "(D-Damaged, E-Evidence, L-Lost, R-Recovered, S-Stolen)")
	add_field(/datum/report_field/pencode_text, "Description of Items/Property")
	add_field(/datum/report_field/pencode_text, "Narrative")
	add_field(/datum/report_field/text_label/instruction, "By submitting this form, I understand this is considered a formal police report. I understand that all information written above is truthful and accurate. I understand that intentionally filing a fraudulent police report is a criminal offense that will be prosecuted to the fullest extent of the law.  As this is a binding legal document, I understand that by filing this form that any intentionally false information may warrant disciplinary action against myself. This statement was given on my own volition to assist with documenting the above summarized incident.")
	add_field(/datum/report_field/signature, "Signature")
	set_access(access_edit = access_security)

/datum/computer_file/report/recipient/sec/arrest
	form_name = "SEC-03"
	title = "Arrest Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/arrest/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ICS Nerva Security Department")
	add_field(/datum/report_field/text_label/instruction, "To be filled out by Arresting Officer or Chief of Security. Report must be signed and submitted before the end of the shift!")
	add_field(/datum/report_field/people/from_manifest, "Booking Officer")
	add_field(/datum/report_field/people/list_from_manifest, "Arresting Officer(s)")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time of incident")
	add_field(/datum/report_field/people/from_manifest, "Arrested Individual")
	add_field(/datum/report_field/simple_text, "Charges")
	add_field(/datum/report_field/simple_text, "Sentence")
	add_field(/datum/report_field/pencode_text, "Personal Property held for Safekeep")
	add_field(/datum/report_field/text_label/instruction, "The following seven questions are to be answered in YES/NO format")
	add_field(/datum/report_field/simple_text, "Escape Risk?")
	add_field(/datum/report_field/simple_text, "Suicide Risk?")
	add_field(/datum/report_field/simple_text, "Warrant Presented?")
	add_field(/datum/report_field/simple_text, "Advised of Rights?")
	add_field(/datum/report_field/simple_text, "Searched?")
	add_field(/datum/report_field/simple_text, "Provided an Opportunity for Statement?")
	add_field(/datum/report_field/simple_text, "If needed, provided timely medical aid?")
	add_field(/datum/report_field/simple_text, "IF YES, what injuries are pre-existing?")
	add_field(/datum/report_field/text_label/instruction, "This document MUST be submitted to, and reviewed by, the Chief of Security or above.")
	add_field(/datum/report_field/signature, "Reporting Officer's signature")
	set_access(access_edit = access_security)

/datum/computer_file/report/recipient/sec/restraining
	form_name = "SEC-04"
	title = "Restraining Order"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/restraining/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ICS Nerva Security Department")
	add_field(/datum/report_field/text_label/instruction, "To be filled out by the Chief of Security, First Officer, or Captain. Report must be signed and submitted for the order to be considered valid. Any paper copies must be stamped.")
	add_field(/datum/report_field/people/from_manifest, "Plantiff")
	add_field(/datum/report_field/people/from_manifest, "Defendant(s)")
	add_field(/datum/report_field/date, "Date Effective")
	add_field(/datum/report_field/time, "Time Effective")
	add_field(/datum/report_field/text_label/instruction, "THE DEFENDANT IS ORDERED TO: 1) Not to abuse Plaintiff(s) by physically harming them, attempting to physically harm them, place them in fear of imminent physical harm; 2) Stop harassing them by any wilfull and malicious conduct aimed at them and intended to cause fear, intimidation, abuse, or damage to property; 3) Not to contact Plaintiff(s) unless authorized to do so by the CO, XO, COS or their appointee; 4) Remain out of the Plaintiff(s) workplace, 5) Remain no less than 20M away from Plaintiff. Violation of this legal order will result in arrest for Endangerment and any other applicable charges, including any applicable legal violations.")
	add_field(/datum/report_field/signature, "Submitting Officer's signature")
	set_access(access_edit = access_hos)

/datum/computer_file/report/recipient/sec/ltc
	form_name = "SEC-05"
	title = "License to Carry"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/ltc/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ICS Nerva Security Department")
	add_field(/datum/report_field/text_label/instruction, "To be filled out by the Chief of Security, First Officer, or Captain. Report must be signed and submitted for the order to be considered valid. Any paper copies must be stamped.")
	add_field(/datum/report_field/people/from_manifest, "Licensee")
	add_field(/datum/report_field/date, "Date Effective")
	add_field(/datum/report_field/time, "Time Effective")
	add_field(/datum/report_field/simple_text, "Reason for License")
	add_field(/datum/report_field/simple_text, "Authorized for Possession Of")
	add_field(/datum/report_field/text_label/instruction, "THIS LICENSE IS ISSUED 'AT-WILL' AND MAY BE REVOKED AT ANY TIME FOR ANY REASON BY THE CAPTAIN, FIRST OFFICER, OR THE CHIEF OF SECURITY. IN THE EVENT OF ILLEGAL CONDUCT, THIS LICENSE MAY BE REVOKED BY ANY LAW ENFORCEMENT OFFICER ACTING IN THE COURSE OF THEIR NORMAL DUTIES. ALL LICENSEES ARE REQUIRED TO ABIDE BY LOCAL LAWS AND REGULATIONS AT ALL TIMES. OPEN CARRY OF LICENSED ITEMS IS GENERALLY NOT PERMITTED UNLESS EXPLICITLY DENOTED. THIS DOCUMENT MUST BE CARRIED BY THE LICENSED PARTY WHEN THEY ARE IN DIRECT OR CONSTRUCTIVE POSSESSION OF THE AFOREMENTIONED ITEMS OR WEAPONS THAT THEY ARE AUTHORIZED FOR. COPIES OF THIS DOCUMENT WILL BE FORWARDED TO THE CAPTAIN, FIRST OFFICER, AND CHIEF OF SECURITY FOR REFERENCE.")
	add_field(/datum/report_field/signature, "Submitting Officer's signature")
	set_access(access_edit = access_hos)

//misc

/datum/computer_file/report/recipient/sol
	logo = "\[logo\]"
	form_name = "REP-00"

/datum/computer_file/report/recipient/sol/audit
	form_name = "REP-12"
	title = "ICS Nerva Department Audit"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sol/audit/generate_fields()
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Name of Department")
	add_field(/datum/report_field/pencode_text, "Positive Observations")
	add_field(/datum/report_field/pencode_text, "Negative Observations")
	add_field(/datum/report_field/pencode_text, "Other Notes")
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")
	set_access(access_edit = access_hop, override = 0)
	set_access(access_edit = access_xenobiology, override = 0)
	..()

/datum/computer_file/report/recipient/sol/crewman_incident
	form_name = "REP-4"
	title = "Crewman Incident Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sol/crewman_incident/generate_fields()
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/people/from_manifest, "Crewman Involved in Incident")
	add_field(/datum/report_field/simple_text, "Nature of Incident")
	add_field(/datum/report_field/pencode_text, "Description of incident")
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")
	set_access(access_edit = list(access_heads))
	..()

/datum/computer_file/report/recipient/sol/work_visa
	form_name = "REP-03b"
	title = "Work Visa Issuing Form"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sol/work_visa/generate_fields()
	var/datum/report_field/temp_field
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/people/from_manifest, "Recipient of Work Visa")
	add_field(/datum/report_field/simple_text, "Species of Recipient")
	temp_field = add_field(/datum/report_field/signature, "Issuer of Work Visa Signature")
	add_field(/datum/report_field/signature, "Recipient of Work Visa Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")
	temp_field.set_access(access_edit = access_hop)
	..()
