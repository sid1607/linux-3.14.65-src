#include <stdio.h>
#include <net/delaycallback.h>

int main() {
	sys_push_packets_now(0);
	printf("Pushed packets\n");
	return 0;
}
