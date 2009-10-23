// TLDebugLog is a drop-in replacement for NSLog that logs iff the build variable TL_DEBUG is defined
#ifdef TL_DEBUG
#define TLDebugLog(format, args...) NSLog(format, ## args)
#else
#define TLDebugLog(format, args...)
#endif