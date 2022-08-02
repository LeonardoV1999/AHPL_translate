#define char_long 50


/*typedef struct mod
{
	int modsize;
	int other;
}Mod;
*/
typedef struct Module_Composition /*se encarga de copiar */
    { char *moduleName;
      char inputs[char_long];
      char exinputs[char_long];
      char outputs[char_long];
      char buses[char_long];
      char exbuses[char_long];
      char memory[char_long];
      char clunits[char_long];
    }Mcom;
    

void AHPL_translate(Mcom input);


