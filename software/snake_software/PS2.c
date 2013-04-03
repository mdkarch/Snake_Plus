#include <io.h>
#include <system.h>
#include <stdio.h>

char* getInput()
{
	char* code;
	while(!IORD_8DIRECT(PS2_BASE, 0));
	code = IORD_8DIRECT(PS2_BASE,4);
	printf("Key recieved: %x", code);

}
