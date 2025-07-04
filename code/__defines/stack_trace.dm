/// Gives us the stack trace from CRASH() without ending the current proc.
/// Do not call directly, use the [stack_trace] macro instead.
/// May also be used by other tooling like from rust.
/proc/_stack_trace(message, file, line)
	CRASH("[message] ([file]:[line])")

/// gives us the stack trace from CRASH() without ending the current proc.
#define stack_trace(message) _stack_trace(message, __FILE__, __LINE__)
