
#define COMMAND_ROLES list(/datum/job/captain, /datum/job/firstofficer, /datum/job/hop, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/seniorscientist, /datum/job/qm, /datum/job/hos, /datum/job/blueshield, /datum/job/merchant)

//For roles that would have a higher level of education, typically doctors and other scientists
#define DOCTOR_ROLES list(/datum/job/cmo, /datum/job/psychiatrist, /datum/job/roboticist, /datum/job/seniorscientist, /datum/job/scientist)

//For members of the medical department
#define MEDICAL_ROLES list(/datum/job/cmo, /datum/job/doctor, /datum/job/psychiatrist)

//For members of the medical department, roboticists, and some Research
#define STERILE_ROLES list(/datum/job/cmo, /datum/job/doctor /datum/job/psychiatrist, /datum/job/roboticist, /datum/job/seniorscientist, /datum/job/scientist)

//For members of the engineering department
#define ENGINEERING_ROLES list(/datum/job/chief_engineer, /datum/job/engineer)

//For members of Engineering, Cargo, and Research
#define TECHNICAL_ROLES list(/datum/job/chief_engineer, /datum/job/engineer, /datum/job/roboticist, /datum/job/qm, /datum/job/cargo_tech, /datum/job/merchant, /datum/job/seniorscientist, /datum/job/scientist)

//For members of the security department
#define SECURITY_ROLES list(/datum/job/hos, /datum/job/officer)

//For members of the supply department
#define SUPPLY_ROLES list(/datum/job/qm, /datum/job/cargo_tech)

//For members of the service department
#define SERVICE_ROLES list(/datum/job/hop, /datum/job/janitor, /datum/job/chef, /datum/job/chaplain)

//For members of the exploration department
#define EXPLORATION_ROLES list(/datum/job/qm, /datum/job/cargo_tech, /datum/job/hop)

//For members of the research department and jobs that are scientific
#define RESEARCH_ROLES list(/datum/job/seniorscientist, /datum/job/scientist)

//For jobs that spawn with weapons in their lockers
#define ARMED_ROLES list(/datum/job/captain, /datum/job/firstofficer, /datum/job/hop, /datum/job/blueshield, /datum/job/hos, /datum/job/officer, /datum/job/merchant)

//For jobs that spawn with armor in their lockers
#define ARMORED_ROLES list(/datum/job/captain, /datum/job/hop, /datum/job/blueshield, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/qm, /datum/job/officer, /datum/job/merchant, /datum/job/submap/skrellscoutship_crew, /datum/job/submap/skrellscoutship_crew/leader, /datum/job/submap/scavver_pilot, /datum/job/submap/scavver_doctor, /datum/job/submap/scavver_engineer)
