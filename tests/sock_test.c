#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>

void error(const char *msg)
{
    perror(msg);
    exit(1);
}


int main() {
	int sockfd, newsockfd, portno;
	socklen_t clilen;
	char buffer[256];
	int delay_ms = 10;
	int port = 15744;
	struct sockaddr_in serv_addr, cli_addr;
	int n;
	
	sockfd = socket(AF_INET, SOCK_STREAM, 0);

	if (setsockopt(sockfd, SOL_SOCKET, SO_CROSS_LAYER_DELAY, &delay_ms,
								 sizeof(delay_ms)) == -1) {
		error("Setsockopt error: can't config sock delay");
	}

	if (sockfd < 0) 
		error("ERROR opening socket");
 
 	return 0;   
}
