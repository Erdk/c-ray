#ifdef LTTNG_MULTITRACE
#undef TRACEPOINT_PROVIDER
#define TRACEPOINT_PROVIDER cray

#undef TRACEPOINT_INCLUDE
#define TRACEPOINT_INCLUDE "./tp2.h"

#if !defined(_TP2_H) || defined(TRACEPOINT_HEADER_MULTI_READ)
#define _TP2_H

#include <lttng/tracepoint.h>

TRACEPOINT_EVENT(
  cray,
  intersect_aabb,
  TP_ARGS(void),
)

TRACEPOINT_EVENT(
  cray,
  intersect_nodes,
  TP_ARGS(void),
)

TRACEPOINT_EVENT(
  cray,
  intersect_polygon,
  TP_ARGS(void),
)


#endif /* _TP2_H */

#include <lttng/tracepoint-event.h>

#endif /* LTTNG_MULTITRACE */
