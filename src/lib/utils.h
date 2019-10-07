#ifndef UTILS_H
#define UTILS_H

#include <stdio.h>
#include <string.h>
#include "const.h"

char *intToStr(int val) {
	char aux[100];
	memset(aux, 0, sizeof(aux));
	sprintf(aux, "%d", val);
	return strdup(aux);
};

const char * salto_opuesto(char *salto) {
	if (strcmp(salto, saltos[tsJE]) == 0) {
		return saltos[tsJNE];
	} else if (strcmp(salto, saltos[tsJNE]) == 0) {
		return saltos[tsJE];
	} else if (strcmp(salto, saltos[tsJL]) == 0) {
		return saltos[tsJGE];
	} else if (strcmp(salto, saltos[tsJLE]) == 0) {
		return saltos[tsJG];
	} else if (strcmp(salto, saltos[tsJG]) == 0) {
		return saltos[tsJLE];
	} else if (strcmp(salto, saltos[tsJGE]) == 0) {
		return saltos[tsJL];
	} else if (strcmp(salto, saltos[tsJMP]) == 0) {
		return saltos[tsJMP];
	}
	return "";
}

#endif