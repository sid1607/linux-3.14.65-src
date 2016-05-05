#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

const int minSleepMillis = 100;
const int maxSleepMillis = 300;

const int MILLIS_TO_NANOS = 1000000;
const int KERNEL_PID = 1;
const int TEST_SIGNAL = 100;
struct timespec sleepDuration={0};

void msleep(unsigned long milisec);

int main(int argc, char const *argv[]) {
	// Seed the random number generator
	srand(time(NULL));


	while(1) {
		// Determine sleep time
		int sleepMillis = (rand() % (maxSleepMillis - minSleepMillis)) + minSleepMillis;

		// Sleep for that amount
		msleep((long) sleepMillis);

		// Send signal to PID
		// https://www.win.tue.nl/~aeb/linux/lk/lk-5.html
		// http://www.gnu.org/software/libc/manual/html_node/Signaling-Another-Process.html
		// kill(KERNEL_PID, TEST_SIGNAL);
		printf("Slept for %d.\n", sleepMillis);
	}

	return 0;
}

// http://cc.byexamples.com/2007/05/25/nanosleep-is-better-than-sleep-and-usleep/
void msleep(unsigned long milisec) {
    time_t sec=(int)(milisec/1000);
    milisec=milisec-(sec*1000);
    sleepDuration.tv_sec=sec;
    sleepDuration.tv_nsec=milisec*1000000L;
    while(nanosleep(&sleepDuration, &sleepDuration)==-1) {
        continue;
    }
}
