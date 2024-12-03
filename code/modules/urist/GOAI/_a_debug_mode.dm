
// Uncomment to allow *ANY* debug logging in _b_debug_modules.dm. Otherwise, they are all disabled.
# define ENABLE_DEBUG_LOG_MACROS 1

// --- EXTREMELY IMPORTANT NOTE: ---
// Logging in BYOND *is expensive*!
//
// If you enable the debug macros, the same code that runs buttery smooth on a moldy potato
// might start choking up and looking choppy.
//
// While I cannot say for sure, most likely each write needs to acquire a lock on STDOUT/STDERR
// and there isn't any buffering mechanism unless you build one custom (which I didn't bother with).
//
// Point is, just including this might kill performance and is unrepresentative of live code.
