#ifndef UTILS_H
#define UTILS_H

#include <stdio.h>
#include <string.h>

char *intToStr(int val) {
	char aux[100];
	memset(aux, 0, sizeof(aux));
	sprintf(aux, "%d", val);
	return strdup(aux);
};

#endif