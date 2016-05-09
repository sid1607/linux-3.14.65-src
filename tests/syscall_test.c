#include <stdio.h>
#include <unistd.h>
#include <time.h>

int main() {
	struct timespec req, *rem;
	req.tv_sec = 0;
	req.tv_nsec = 100000000;

	while(1) {
		nanosleep(&req, rem);
		syscall(316);
		// printf("Pushed packets\n");
	}

	return 0;
}
