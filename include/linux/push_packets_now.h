#ifndef _DELAYCALLBACK_H
#define _DELAYCALLBACK_H

#include <linux/unistd.h>
#include <linux/linkage.h>

_syscall1(long, sys_push_packets_now, unsigned long, arg1);

#endif
