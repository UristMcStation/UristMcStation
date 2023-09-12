// Core module definition; similar to map module defines
// If you use Dream Maker, everything is unticked b/c we include stuff from this file.

// flag we can use to avoid double-including
#define DEEPMAINT_INCLUDED 1

#include "_wfc_defines.dm"

#ifdef STUB_OUT_SS13

#include "ss13_stubs.dm"
#include "modules\deepmaint\areas.dm"

#else

#include "fractal_coords.dm"
#include "modules\deepmaint\hooks.dm"

#endif

#include "core\calllib.dm"
//#include "core\debug.dm"
#include "core\prefabs.dm"
#include "core\turf.dm"
#include "core\maptricks.dm"

// Deepmaint stuff
#include "modules\deepmaint\_deepmaint.dm"

// Landmass - terrain generation stuff
// Currently not needed, used for dev initially
//#include "modules\deepmaint\_landmass.dm"
