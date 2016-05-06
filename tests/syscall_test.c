#include <stdio.h>
#include <unistd.h>

int main() {
	sys_push_packets_now(0);
	printf("Pushed packets\n");
	return 0;
}
