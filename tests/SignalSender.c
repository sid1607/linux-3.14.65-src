#include <signal.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

const int minSleepMillis = 100;
const int maxSleepMillis = 300;

const int MILLIS_TO_MICROS = 1000;
const int KERNEL_PID = 1;
const int TEST_SIGNAL = 100;

int main(int argc, char const *argv[]) {
	// Seed the random number generator
	srand(time(NULL));

	while(1) {
		// Determine sleep time
		int sleepMillis = (rand() % (maxSleepMillis - minSleepMillis)) + minSleepMillis;

		// Sleep for that amount
		usleep(sleepMillis * MILLIS_TO_MICROS);

		// Send signal to PID
		// https://www.win.tue.nl/~aeb/linux/lk/lk-5.html
		// http://www.gnu.org/software/libc/manual/html_node/Signaling-Another-Process.html
		// int kill(pid_t pid, int sig);
		kill(KERNEL_PID, TEST_SIGNAL);
	}

	return 0;
}
