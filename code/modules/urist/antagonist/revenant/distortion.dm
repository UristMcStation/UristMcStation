/* REALITY DISTORTION
//
// Revenants are severely anomalous; they act as a source of 'pseudo-radiation' that corrupts reality in a radius around them.
//
// In practical terms, we track an extra numeric variable representing how corrupted nearby atoms are.
// Above a threshold value, we randomly trigger effects that represent the Creeping Spoop.
//
// Design-wise, this is a localized effect to disincentivize hiding in a closet or hanging out and doing your job
// the whole shift, and on the flipside complicates Revenants' containment by Security/Science.
*/

/turf
	var/reality_distortion = 0
