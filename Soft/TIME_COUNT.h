#ifndef _TIME_COUNT_
#define _TIME_COUNT_

#include <sys/time.h>
#include <time.h>

static long get_tick_count(void) {
	struct timespec now;
	clock_gettime(CLOCK_MONOTONIC, &now);
	return now.tv_sec * 1000000000 + now.tv_nsec;

}

#endif 