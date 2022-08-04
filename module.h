#ifndef MODULE_H
#define MODULE_H

#define char_long 50
/*typedef struct mod
{
	int modsize;
	int other;
}Mod;
*/
typedef struct Module_Composition /*se encarga de copiar */
    { int   moduleNum;
      char *moduleName;          /**/
      int  inputsNum;
      char *inputs[char_long];
      int  exinputsNum;
      char exinputs[char_long];
      int  outputsNum;
      char outputs[char_long];
      int  busesNum;
      char buses[char_long];
      int  exbusesNum;
      char exbuses[char_long];
      int  memoryNum;
      char memory[char_long];
      int  clunitsNum;
      char clunits[char_long];
      
      int RowCOl[char_long][2];
     }Mcom;
void AHPL_translate(Mcom input, char *array[]);
#endif


