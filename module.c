#include "module.h"
#include <stdio.h>

void AHPL_translate(Mcom input, char *array[])
{
	printf("\n\nlibrary ieee;\n");
	printf("use ieee.std_logic_1164.all;\n");
	printf("\nentity %s is\n", input.moduleName);
	/*inicio de entradas y salidas*/
	printf("port(");
	/*entradas*/
	for(int i = 0;i<input.inputsNum;i++)
	{
	  printf("\n\t%s :in std_logic;\n",array[i]); //quitar el ';' en la ultima entrada p salida
	}
	/*fin de entradas*/
	printf(");");
	/*fin de entradas y salidas*/
	printf("\nend entity %s;\n",input.moduleName);
	
	/*arquitectura*/
	printf("\narchitecture ARC%s of %s is",input.moduleName,input.moduleName);
	/*señales o estados*/
	
	/*fin de señales o estados*/
	printf("\nbegin\n");
	
	printf("\nend architecture ARC%s;\n", input.moduleName);
	/*fin de arquitectura*/
	
	/*textos para ir probando el diseño*/
	printf("\n\n\n***texto de prueba***\n\n\n");
	for (int i = 0; i < input.inputsNum;i++)
	{
          printf("\n%s\n", array[i]);
	}
        //printf("\n%s\n", array[3]);
	return ;
}
