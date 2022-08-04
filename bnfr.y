%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include "module.h"
    #define charl 50 /*define el numero maximo de declaraciones que puedo tener por modulo*/
    
    
    int n = 0;
    int ns = 0;
    int module = 1;                   /*halla el numero de modulos*/
    char *idVal;
    int  numVal;
    //void AHPL_translate(Mcom input);
    Mcom Module = {0};
    
    /******************************************************/
    /* estructura que define las banderas de las entradas*/
    char *inputsArray[charl] = {0}; /*arreglo que almacena el nombre de las entradas*/
    typedef struct mod_flags
    {
      bool inputF;
      
      bool rowF;
      bool colF;
    }ModuleFlag;
    /*----------------------------------------------------*/
    ModuleFlag ModuleF = {0};
    int row = 0;
    int col = 0;
    char *copyArray(ModuleFlag* MF ,char *array, Mcom* Module, int row, int col);
    /******************************************************/
    
%}
/* ?????????? */
%token id          /* id */
%token EOF_STMT    /* end of file */
%token ERROR_STMT  /* error */
%token NUMBER	   /* integer */
%token HEX	   /* hex number */
/* end of ??????????*/

/* keywords */
%token AHPLMODULE
%token INPUTS
%token EXINPUTS
%token BUSES
%token EXBUSES
%token OUTPUTS
%token MEMORY
%token LABELS
%token CLUNITS
%token BODY
%token NULLSTMT 
%token NODELAY
%token DEADEND
%token ENDSEQUENCE
%token CONTROLRESET
%token END
%token OPTION
%token CLOCKLIMIT
%token INITIALIZE
%token EXLINES
%token SUPPRESS
%token DUMP
%token ALL
%token REPEAT
%token ADD
%token ADDC
%token INC 
%token MEMFN
%token DCD
%token DEC
%token CMP
%token ASSOC
/* end of keywords */ 

/* operator */
%left NOT	   /* not */
%left AND	   /* and */
%left NAND        /* nand */
%left OR          /* or */
%left NOR         /* nor */
%left XOR         /* xor */
%left XNOR        /* xnor */
%left ANDCR       /* and col reduction */
%left NANDCR      /* nand col reduction */
%left ORCR        /* or col reduction */
%left NORCR       /* nor col reduction */
%left XORCR       /* xor col reduction */
%left XNORCR      /* xnor col reduction */
%left ANDRR	   /* and row reduction */
%left NANDRR	   /* nand row reduction */
%left ORRR	   /* or row reduction */
%left NORRR	   /* nor row reduction */
%left XORRR	   /* xor row reduction */
%left XNORRR	   /* xnor row reduction */

%token COLCAT	   /* colum catenation */
%token CONDITION   /* condition */
%token SLASH	   /* slash */
%token JUMP	   /* jump */
%token EQUAL	   /* equal */
%token TRANSFER    /* transfer */
%token RPARENTESIS /* right parentesis */
%token LPARENTESIS /* left parentesis */
%token LSQBRACKET  /* left square bracket */
%token RSQBRACKET  /* right square bracket */
%token LABRACKET   /* left angle bracket */
%token RABRACKET   /* right angle bracket */
%token SEMICOLON   /* semicolon */
%token ENCODE      /* encode */
%token PERIOD  	   /* period */
%token COLON	   /* colon */
%token BSLASH 	   /* back slash */
%token option	   /* option "!" */
%token MTIMES	   /* multiple times */
%token ONE         /* one '1' */
%token ZERO        /* zero '0' */
/* end of operators*/	

/* test tokens */

//%token module
%token comsec

//%token mheader
//%token mdclr
%token mbody 
%token mend

//%token inputs
%token exinputs
%token outputs
%token buses
%token exbuses
%token memory
%token clunits
/*%token aid
%token clkseq1
%token synop
%token srcexpr
%token destexpr1


%token constant
%token encode 
%token add
%token addc
%token inc
%token dec
%token dcd
%token busfn
%token assoc
%token compare
%token idrange*/
/* end of test tokens*/

%%

/*line 1 : <system> ::= <module> {<module>} <comsec> *
          define la estructura del sistema           */
system : module systemx comsec {Module.inputsNum = 0;}
       | module         comsec 
       ;
       
systemx: module         {module += 1;} 
       | systemx module {module += 1;}
       ;
/* end of line 1 ------------------------------------*/

/*line 2 : <module> ::= <mheader> <mdclr> <mbody> <mend> *
           define el formato de un modulo                */
module : mheader mdclr mbody mend 
       | mheader       mbody mend
       ;
/* end of line 2 ----------------------------------------*/           

/*line 3 : <mheader> ::= AHPLMODULE: id     *     
          define el formato de un encabezado*/
mheader : AHPLMODULE COLON id PERIOD {Module.moduleName = idVal;}
	;
/* end of line 3 ----------------------------------------*/

/*line 4 : <mdclr> ::= {<inputs> | <exinputs> | <outputs> |
			<buses>  | <exbuses>  | <memory>  | clunits } *
  se encarga de definir el formato de declaracion de un modulo        */
mdclr	: mdclrx
	| mdclr mdclrx
	;

mdclrx	: inputs   
	| exinputs /*!!determinar el numero de veces que aparece alguno de estos items !!*/
	| outputs
	| buses
	| exbuses
	| memory
	| clunits
	;
/* end of line 4 -----------------------------------------------------*/

/*line 5 : <inputs> ::= INPUTS: <aid> {;aid}.     *
  se encarga de definir el formato de una entrada */
inputs	: INPUTS COLON inputsy inputsx PERIOD 
	| INPUTS COLON inputsy         PERIOD 
	;
inputsx : SEMICOLON aid        {ModuleF.inputF = true;
				inputsArray[Module.inputsNum] = 
	                        copyArray(&ModuleF,
	                                   inputsArray[Module.inputsNum],
	                                   &Module,
	                                   row,
	                                   col);}
	| inputsx SEMICOLON aid{ModuleF.inputF = true;
				inputsArray[Module.inputsNum] = 
	                        copyArray(&ModuleF,
	                        	   inputsArray[Module.inputsNum],
	                        	   &Module,
	                        	   row,
	                        	   col);}
	;
inputsy : aid		       {ModuleF.inputF = true;
				inputsArray[Module.inputsNum] = 
	                        copyArray(&ModuleF,
	                        	   inputsArray[Module.inputsNum],
	                        	   &Module,
	                        	   row,
	                        	   col);}
	;
/*end of line 5 ----------------------------------*/


/*line 12 : <aid> ::= id ['<' num '>']['[' num ']'] *
  se encarga de definir el formato en el que se     *
  escibe una variable                               */
aid:      id           {ModuleF.rowF = false ; ModuleF.colF = false; row = 0; col  = 0;}
      //| id    aidy  /*(parece ser que es un arreglo de solo columnas) !! no se ve correcto !!*/
	| id aidx       /* variable en forma de arrego (BUS) */
	| id aidx aidy  /* variable en forma de matriz */
	;
aidx	: LABRACKET NUMBER RABRACKET   {row  = numVal;
					ModuleF.rowF = true;
					ModuleF.colF = false;}
	;
aidy	: LSQBRACKET NUMBER RSQBRACKET {col  = numVal;
					ModuleF.rowF = true;
					ModuleF.colF = true;}
	;	
/*end of line 12 -----------------------------------*/
%%
char *copyArray(ModuleFlag* MF ,char *array, Mcom* Module, int row, int col)
{  
   char* copyA = 0;                 //se crea siempre que se usa la funcion
   int copyNum = 0; 
   if(MF->inputF == true)
   {
   	if(MF->rowF==false && MF->colF ==false)
   	{
	  //Module->inputs 
	  copyA = idVal;
	  Module->inputs[Module->inputsNum] = copyA;
	  printf("\n%s\n", Module->inputs[Module->inputsNum]);
	  printf("\nrows = %d ; col = %d\n", row, col);
	  array = copyA;
	  //
	  Module->inputsNum++;
	  MF->inputF = false;
        }else if(MF->rowF==true && MF->colF ==false)
   	      {
	       copyA = idVal;
	  Module->inputs[Module->inputsNum] = copyA;
	  printf("\n%s\n", Module->inputs[Module->inputsNum]);
	  printf("\nrows = %d ; col = %d\n", row, col);
	  array = copyA;
	  //
	  Module->inputsNum++;
	  MF->inputF = false;
              }else if(MF->rowF==true && MF->colF ==true)
   	            {
	              copyA = idVal;
	              Module->inputs[Module->inputsNum] = copyA;
	              printf("\n%s\n", Module->inputs[Module->inputsNum]);
	              printf("\nrows = %d ; col = %d\n", row, col);
	              array = copyA;
	              //
	              Module->inputsNum++;
	              MF->inputF = false;
                    }
   }
  return (char*)array;
}
