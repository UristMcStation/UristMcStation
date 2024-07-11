/mob/verb/generate_gamma(alpha as num)
	for(var/i = 0, i <= 10, i++)
		var/sample = rand_gamma(alpha)
		to_chat(usr, "GAMMA SAMPLE: [sample] @ alpha=[alpha]")


/mob/verb/generate_beta(alpha as num, beta as num)
	for(var/i = 0, i <= 10, i++)
		var/sample = rand_beta(alpha, beta)
		to_chat(usr, "BETA SAMPLE: [sample] @ alpha=[alpha] & beta=[beta]")
