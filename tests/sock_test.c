#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <pthread.h>

void error(const char *msg)
{
    perror(msg);
    exit(1);
}

void client_thread(int *fd) {
	char buffer[256], outbuffer[256];
	int newsockfd = *fd;
	int n, yes=1;
	free(fd);

	if (setsockopt(newsockfd, SOL_SOCKET, SO_CROSS_LAYER_DELAY, &delay_ms,
									 sizeof(delay_ms)) == -1) {
		error("Setsockopt error: can't config sock delay");
	}


	for (;;) {
		bzero(buffer,256);
		bzero(outbuffer,256);
		n = read(newsockfd,buffer,255);
		if (!strcmp(buffer, "quit\r\n")) {
			close(newsockfd);
			return;
		}
		if (n < 0) error("ERROR reading from socket");
		printf("Here is the message: %s\n",buffer);
		strcat(outbuffer, "Received message: ");
		strcat(outbuffer, buffer);
		strcat(outbuffer, "\r\n");

		n = write(newsockfd,outbuffer,strlen(outbuffer));
		if (n < 0) error("ERROR writing to socket");
	}

}
int main() {
	int sockfd, newsockfd;
	socklen_t clilen;
	int delay_ms = 10000;
	int port = 15744, i=-1;
	struct sockaddr_in serv_addr, cli_addr;
	pthread_t pool[100];
	int *fd;
	
	sockfd = socket(AF_INET, SOCK_STREAM, 0);

	printf("INFO: Running with %dms delay\n", delay_ms);

	if (sockfd < 0) 
		error("ERROR opening socket");

	if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &yes,
	               sizeof(yes)) == -1) {
	  error("Setsockopt error: can't config reuse addr");
	  exit(EXIT_FAILURE);
	}


	bzero((char *) &serv_addr, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = INADDR_ANY;
	serv_addr.sin_port = htons(port);
	if (bind(sockfd, (struct sockaddr *) &serv_addr,
	         sizeof(serv_addr)) < 0) 
	         error("ERROR on binding");
	listen(sockfd,5);
	clilen = sizeof(cli_addr);

	for (;;) {
		newsockfd = accept(sockfd,
			            (struct sockaddr *) &cli_addr,
			            &clilen);
		if (newsockfd < 0)
			error("ERROR on accept");
		i++;
		fd = malloc(sizeof(int));
		*fd = newsockfd;
		pthread_create(&pool[i], NULL, client_thread, fd);
	}


	return 0;
}
