// JSON string definitions
// note that to make it easier to edit as an equation, they are transposed (relative to the array indices)
#define COLMX_BASIC         "\[\[1,0,0,0,0],\[0,1,0,0,0],\[0,0,1,0,0],\[0,0,0,1,0]]"

#define COLMX_GREYSCALE     "\[\[ 0.33, 0.33, 0.33, 0.00, 0.00],\[ 0.33, 0.33, 0.33, 0.00, 0.00],\[ 0.33, 0.33, 0.33, 0.00, 0.00],\[0,0,0,1,0]]"
#define COLMX_EXPRESSIONIST "\[\[ 0.50, 0.33, 0.33, 0.00, 0.00],\[ 0.20, 0.33, 0.33, 0.00, 0.00],\[ 0.20, 0.33, 0.33, 0.00, 0.00],\[0,0,0,1,0]]"

#define COLMX_GRIMDARK      "\[\[ 1.00, 0.20, 0.20, 0.00,-0.50],\[ 0.33, 0.50, 0.20, 0.00,-0.10],\[ 0.33, 0.20, 0.50, 0.00,-0.10],\[0,0,0,1,0]]"
#define COLMX_CYBERPUNK     "\[\[ 0.70, 0.20, 0.20, 0.00,-0.30],\[ 0.40, 0.80, 0.50, 0.00,-0.45],\[ 0.30, 0.20, 0.40, 0.00,-0.20],\[0,0,0,1,0]]"

#define COLMX_NOIR          "\[\[ 1.30, 0.25, 0.25, 0.00,-0.70],\[ 0.30, 0.60, 0.60, 0.00,-0.30],\[ 0.30, 0.60, 0.60, 0.00,-0.30],\[0,0,0,1,0]]"

#define DEFAULT_COLOR_MATRIX new /datum/array(COLMX_BASIC)

/client
	//vg color code
	var/datum/array/cached_colormatrix = null
	var/updating_color = 0
