/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: apineda <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/17 16:23:52 by apineda           #+#    #+#             */
/*   Updated: 2017/02/17 16:23:55 by apineda          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

static	void		ft_error(const char *str)
{
	write(2, str, strlen(str));
	exit(1);
}

static	void		ft_read(int newsock)
{
	char	buf[256];

	while (1)
	{
		bzero(buf, 256);
		if (!(read(newsock, buf, 255)))
			exit(0);
		if ((strcmp(buf, "exit\n") == 0) || (strcmp(buf, "EXIT\n") == 0))
			exit(0);
		if ((strcmp(buf, "ping\n") == 0))
			write(newsock, "pong\npong\n", 10);
		else if (strcmp(buf, "PING\n") == 0)
			write(newsock, "PONG\nPONG\n", 10);
		else if ((strcmp(buf, "pong\n") == 0))
			write(newsock, "ping\nping\n", 10);
		else if (strcmp(buf, "PONG\n") == 0)
			write(newsock, "PING\nPING\n", 10);
		else
		{
			write(newsock, buf, strlen(buf));
			write(newsock, buf, strlen(buf));
		}
	}
}

int					main(int argc, char **argv)
{
	int					sockfd;
	int					newsockfd;
	struct sockaddr_in	serv_addr;
	int					yes;

	yes = 1;
	if (argc < 2)
		ft_error("ERROR NO PORT\n");
	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int));
	bzero(&serv_addr, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = INADDR_ANY;
	serv_addr.sin_port = htons(atoi(argv[1]));
	bind(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
	listen(sockfd, 0);
	newsockfd = accept(sockfd, NULL, NULL);
	ft_read(newsockfd);
	return (0);
}
