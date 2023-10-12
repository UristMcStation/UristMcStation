#ifdef ENABLE_FOV_CODE

// global.flip_dir[dir] = 180 degree rotation of dir. Unlike reverse_dir, UP remains UP & DOWN remains DOWN.
var/global/list/flip_dir = list(
	     2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15,
	16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21, 23, 28, 30, 29, 31, // UP - Same as first line but +16
	32, 34, 33, 35, 40, 42, 41, 43, 36, 38, 37, 39, 44, 46, 45, 47, // DOWN - Same as first line but +32
	48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63  // UP+DOWN - Same as first line but +48
)

#endif
