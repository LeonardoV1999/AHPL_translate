%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "module.h"
    
    
    
    int n = 0;
    int ns = 0;
    int module = 1;                   /*halla el numero de modulos*/
    char *idVal;
    void AHPL_translate(Mcom input);
    Mcom Module;
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

%token inputs
%token exinputs
%token outputs
%token buses
%token exbuses
%token memory
%token clunits
/*%token clkseq1
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
system : module systemx comsec 
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
mheader : AHPLMODULE COLON id PERIOD {Module.moduleName = idVal;
				      printf("%s",Module.moduleName);}
	;
/* end of line 3 ----------------------------------------*/

/*line 3 : <mdclr> ::= {<inputs> | <exinputs> | <outputs> |
			<buses>  | <exbuses>  | <memory>  | clunits } *
  se encarga de definir el formato de declaracion de un modulo        */
mdclr	: mdclrx
	| mdclr mdclrx
	;

mdclrx	: inputs
	| exinputs
	| outputs
	| buses
	| exbuses
	| memory
	| clunits
	;
/* end of line 3 -----------------------------------------------------*/

/*!!!*/
%%
