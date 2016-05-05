#include <linux/kernel.h>
#include <net/sock.h>

asmlinkage long sys_push_packets_now(unsigned long data) {
    printk("Socket push callback initiating...\n");
    cl_timer_callback(data);
    printk("Socket push callback complete.\n");
    return 0;
}
