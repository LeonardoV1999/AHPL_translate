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
    Mcom Module = {0};
    
    /******************************************************/
    /* estructura que define las banderas de las entradas*/
    //char *inputsArray[charl] = {0}; /*arreglo que almacena el nombre de las entradas*/
    
    /*----------------------------------------------------*/
    ModuleFlag ModuleF = {0};
    int row = 0;
    int col = 0;
    
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
%token LCBRACE     /* left curly brace */
%token RCBRACE     /* right curly brace */
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
//%token exinputs
//%token outputs
%token buses
%token exbuses
//%token memory
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
inputsx : SEMICOLON aid1        {ModuleF.inputF = true;
				 Module.inputsArray[Module.inputsNum] = 
	                         copyArray(&ModuleF,
	                                    Module.inputsArray[Module.inputsNum],
	                                   &Module,
	                                    row,
	                                    col,
	                                    idVal);}
	| inputsx SEMICOLON aid1 {ModuleF.inputF = true;
			 	  Module.inputsArray[Module.inputsNum] = 
	                          copyArray(&ModuleF,
	                        	     Module.inputsArray[Module.inputsNum],
	                        	    &Module,
	                        	     row,
	                        	     col,
	                        	     idVal);}
	;
inputsy : aid1		         {ModuleF.inputF = true;
				  Module.inputsArray[Module.inputsNum] = 
	                          copyArray(&ModuleF,
	                        	     Module.inputsArray[Module.inputsNum],
	                        	    &Module,
	                        	     row,
	                        	     col,
	                        	     idVal);}
	;
/*end of line 5 ----------------------------------*/

/*line 6 : <exinputs> ::= EXINPUTS: <exaid> {; <exaid>}.*
  en caso de ser un arreglo bidimensional solo será     *
  necesario introducir el numero de filas               */
exinputs : EXINPUTS COLON exinputsy exinputsx PERIOD 
	 | EXINPUTS COLON exinputsy           PERIOD
	 ;
exinputsx: exinputsz exaid        {ModuleF.exinputF = true;
                                   Module.exinputsE = true;
                                   Module.exinputs[Module.exinputsNumR][Module.exinputsNumC] = 
                                   copyArray(&ModuleF,
	                           Module.exinputsArray[Module.exinputsNumR],
	                           &Module,
	                            row,
	                            col,
	                            idVal);}
	 |exinputsx exinputsz exaid{ModuleF.exinputF = true;
                                    Module.exinputsE = true;
                                    Module.exinputs[Module.exinputsNumR][Module.exinputsNumC] = 
                                    copyArray(&ModuleF,
	                            Module.exinputsArray[Module.exinputsNumR],
	                            &Module,
	                             row,
	                             col,
	                             idVal);}
	 ;
exinputsy: exaid		    {ModuleF.exinputF = true;
				    Module.exinputsE = true;
                                    Module.exinputs[Module.exinputsNumR][Module.exinputsNumC] = 
                                    copyArray(&ModuleF,
	                            Module.exinputsArray[Module.exinputsNumR],
	                            &Module,
	                            row,
	                            col,
	                            idVal);}
	 ;
exinputsz: SEMICOLON                {Module.exinputsNumC = 0;}
	 ;
/*exinputsr: EXINPUTS COLON         {Module.exinputsNumR = 0;
					Module.exinputsNumC = 0;}
	 ;*/
/*end of line 6 ----------------------------------------*/

/*line 7 : <outputs> ::= OUTPUTS: <aid> {; <aid>} *
  define el formato de una salida                 */
outputs	: OUTPUTS COLON outputsy outputsx PERIOD 
	| OUTPUTS COLON outputsy          PERIOD 
	;
outputsx : SEMICOLON aid1        {ModuleF.outputF = true;
				 Module.outputsArray[Module.outputsNum] = 
	                         copyArray(&ModuleF,
	                                    Module.outputsArray[Module.outputsNum],
	                                   &Module,
	                                    row,
	                                    col,
	                                    idVal);}
	| outputsx SEMICOLON aid1 {ModuleF.outputF = true;
			 	  Module.outputsArray[Module.outputsNum] = 
	                          copyArray(&ModuleF,
	                        	     Module.outputsArray[Module.outputsNum],
	                        	    &Module,
	                        	     row,
	                        	     col,
	                        	     idVal);}
	;
outputsy : aid1		         {ModuleF.outputF = true;
				  Module.outputsArray[Module.outputsNum] = 
	                          copyArray(&ModuleF,
	                        	     Module.outputsArray[Module.outputsNum],
	                        	    &Module,
	                        	     row,
	                        	     col,
	                        	     idVal);}
	;

/*end of line 7 ----------------------------------*/

/*line 10 : <memory> ::= MEMORY: <aid> {; aid} !!!!!!!!!!!!!!!!!!!!!editar!!!!!!!!!!!!!!!!!!!!*/
memory	: MEMORY COLON memoryy memoryx PERIOD 
	| MEMORY COLON memoryy         PERIOD 
	;
memoryx : SEMICOLON aid        {ModuleF.memoryF = true;
				 Module.memoryArray[Module.memoryNum] = 
	                         copyArray(&ModuleF,
	                                    Module.memoryArray[Module.memoryNum],
	                                   &Module,
	                                    row,
	                                    col,
	                                    idVal);}
	| memoryx SEMICOLON aid {ModuleF.memoryF = true;
			 	  Module.memoryArray[Module.memoryNum] = 
	                          copyArray(&ModuleF,
	                        	     Module.memoryArray[Module.memoryNum],
	                        	    &Module,
	                        	     row,
	                        	     col,
	                        	     idVal);}
	;
memoryy : aid		         {ModuleF.memoryF = true;
				  Module.memoryArray[Module.memoryNum] = 
	                          copyArray(&ModuleF,
	                        	     Module.memoryArray[Module.memoryNum],
	                        	    &Module,
	                        	     row,
	                        	     col,
	                        	     idVal);}
	;
/*end of line 10 -----------------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

/*line 12 : <aid> ::= id ['<' num '>']['[' num ']'] *
  se encarga de definir el formato en el que se     *
  escibe una variable                               */
aid:      id           {ModuleF.rowF = false;
			ModuleF.colF = false;
			row = 0;
			col  = 0;}
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

/*line 13 : <exaid> ::= <id> '{' {<aid1> {; <aid1>}}'}' (inventada por mi) *
            <exaid> ::= <id> '[' {exaidw {;exaidw}} ']' (mejora)           *
  esta linea define el formato en el que se describen                       *
  las declaraciones provenientes de modulos externos                        *
  (exinputs y exbuses)                                                      */
exaid	: exaidy LSQBRACKET exaidw exaidx exaidz 
	| exaidy LSQBRACKET exaidw        exaidz 
	| exaidy LSQBRACKET               exaidz 
	;
exaidy	: id     {/*necesito sabe el nombre del modulo*/
		   Module.exinputsNumC = 0;
		   Module.exinputs[Module.exinputsNumR][Module.exinputsNumC] = idVal;
		   printf("\n%s\n",Module.exinputs[Module.exinputsNumR][Module.exinputsNumC]);
		   Module.exinputsE = true;
		   Module.exbusesE  = true; }
	;
exaidz	: RSQBRACKET {Module.exinputsNumR ++;
		   Module.exinputsNumC = 0;}
	;
exaidx	: SEMICOLON exaidw         {Module.exinputsE = true;
				    Module.exbusesE  = true;}
				    
	| exaidx SEMICOLON exaidw  {Module.exinputsE = true;
				    Module.exbusesE  = true;}
	;
/*line 14 : <exaidw>   ::= '{'<aid1> , <aid1>'}'         *
  esta linea se encarga de definir el formato de         *
  separacion que hay entre las entradas externas de los  *
  modulos y como se unen con las entradas o buses        *
  internos						 */
exaidw	: LCBRACE exaid1 COLCAT exaid1 RCBRACE /*verificar*/
	;
/*end of line 14 ----------------------------------------*/
	
exaid1  : id {ModuleF.rowF = false; 
	      ModuleF.colF = false;
	      Module.exinputsStore[Module.exinputsNumR] ++; /* almacena la cantidad de entrada *
	       						     * para un arreglo externo         */
	      Module.exinputsNumC ++;
	      Module.exinputs[Module.exinputsNumR][Module.exinputsNumC] = idVal;
	      printf("\n%s\n",Module.exinputs[Module.exinputsNumR][Module.exinputsNumC]);
	      row = 0;
	      col = 0;}
					 
	| id LABRACKET NUMBER RABRACKET 
	      {row  = numVal;
	       col  = 0;
               Module.exinputsStore[Module.exinputsNumR] ++;/* almacena la cantidad de entrada *
	       						     * para un arreglo externo         */
	       Module.exinputsNumC ++;
	       Module.exinputs[Module.exinputsNumR][Module.exinputsNumC] = idVal;
               printf("\n%s\n",Module.exinputs[Module.exinputsNumR][Module.exinputsNumC]);
               ModuleF.rowF = true;
	       ModuleF.colF = false;}
	;

/*end of line 13 ----------------------------------------*/


/*line 15 : <aid1> ::= id ['<'num'>'] (inventada por mi) *
  define la descripcion de un arreglo o una variable     *
  de un bit						 */
aid1	: id				{ModuleF.rowF = false ; 
					 ModuleF.colF = false;
					 row = 0;
					 col  = 0;}
					 
	| id LABRACKET NUMBER RABRACKET {row  = numVal;
					 col  = 0;
					 ModuleF.rowF = true;
					 ModuleF.colF = false;}
	;
/*end of line 15 ----------------------------------------*/
%%

