# ifdef GOAI_LIBRARY_FEATURES

# define CONSCIOUS 0
# define UNCONSCIOUS 1
# define DEAD 2

# define I_HURT "harm"
# define I_HELP "help"

/mob
	var/real_name

/mob/living
	var/stat = CONSCIOUS
	var/faction

/mob/living/carbon

/mob/living/carbon/human
	var/a_intent

/mob/living/simple_animal

/mob/living/simple_animal/hostile

/mob/living/bot

# endif
