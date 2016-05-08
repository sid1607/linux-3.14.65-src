#include <stdio.h>
#include <unistd.h>

int main() {
	syscall(316);
	printf("Pushed packets\n");
	return 0;
}
