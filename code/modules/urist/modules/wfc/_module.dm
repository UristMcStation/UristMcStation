// Core module definition; similar to map module defines
// If you use Dream Maker, everything is unticked b/c we include stuff from this file.

// Ugh this is temporarily not used since DM is weird; keeping this in as a 'manifest' of sorts.

// flag we can use to avoid double-including
#define DEEPMAINT_INCLUDED 1

#include "_wfc_defines.dm"

#ifdef STUB_OUT_SS13

#include "ss13_stubs.dm"
#include "modules\deepmaint\areas.dm"

#else

#include "fractal_coords.dm"

#endif

#include "core\calllib.dm"
#include "core\prefabs.dm"
#include "core\turf.dm"
#include "core\maptricks.dm"
//#include "core\debug.dm"
