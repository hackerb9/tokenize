/* n82-tokenize.lex		NEC PC-8201A N82-BASIC tokenizer *
 *
 * Flex uses this to create lex.tokenize.c.
 * 
 * Compile with:   	flex n82-tokenize.lex
 *			gcc lex.tokenize.c
 */

  #include <ctype.h>		/* For toupper() */

%option prefix="tokenize"
%option case-insensitive

/* Define states that simply copy text instead of lexing */  
%x string
%x remark
%x data
%x datastring

  /* Functions defined in n82-tokenize-main.c */
  int yyput(uint8_t);		/* putchar, but for yyout instead of stdout. */
  uint8_t lastput=255;		/* last written character, for EOF without nl */
  int fixup_ptrs();		/* rewrite line pointers, if possible. */

  /* An array to store line pointers, to be fixed up at EOF */
  uint16_t ptr[65536];
  int nlines = 0;

%%

^[[:space:]]*[0-9]+[ ]?	{
    ptr[nlines++] = ftell(yyout);   /* Cache the location of the current line */
    yyput('*'); yyput('*');	    /* Dummy placeholder pointer to next line.*/
    uint16_t linenum=atoi(yytext);  /* BASIC line number. */
    yyput(linenum & 0xFF);
    yyput(linenum >> 8);
  }

\"		yyput('"'); BEGIN(string);
<string>\"	yyput('"'); BEGIN(INITIAL);

<data>\"	yyput('"'); BEGIN(datastring);
<datastring>\"	yyput('"'); BEGIN(data);

  //xxxxx need to handle literal numeric expressions here. Not just ASCII.
-?[0-9.]+([%#!]|[DE][-+]?[0-9]+    if ( yytext[0] == '-')
			        yyput(0xF1);
			    yyput(atoi(yytext) + 0x11);
			    BEGIN(INITIAL)

   /* Newline ends <string>, <remark>, <data>, and <datastring> conditions. */
<*>\r?\n		yyput('\0'); BEGIN(INITIAL);

   /* DATA statements can be ended with a colon (if not quoted as a string) */
<data>:			yyput(':'); BEGIN(INITIAL);

<<EOF>>	{
    (lastput == '\0') || yyput('\0'); /* Handle EOF without preceding newline */
    fixup_ptrs();
    yyterminate();
  }

  /* Table of tokens, case-insensitive due to %option above. */
END		yyput(0x81);
FOR		yyput(0x82);
NEXT		yyput(0x83);
DATA		yyput(0x84); BEGIN(data);
INPUT		yyput(0x85);
DIM		yyput(0x86);
READ		yyput(0x87);
LET		yyput(0x88);
GO[ \t]*TO	yyput(0x89);
RUN		yyput(0x8A);
IF		yyput(0x8B);
RESTORE		yyput(0x8C);
GOSUB		yyput(0x8D);
RETURN		yyput(0x8E);
REM		yyput(0x8F); BEGIN(remark);
STOP		yyput(0x90);
PRINT           yyput(0x91);
"?"             yyput(0x91);
CLEAR           yyput(0x92);
LIST            yyput(0x93);
NEW             yyput(0x94);
ON              yyput(0x95);
POKE            yyput(0x98);
CONT            yyput(0x99);
CSAVE           yyput(0x9a);
CLOAD           yyput(0x9b);
OUT             yyput(0x9c);
LPRINT          yyput(0x9d);
LLIST           yyput(0x9e);
WIDTH           yyput(0xa0);
ELSE            yyput(':'); yyput(0xa1);
ERROR           yyput(0xa6);
RESUME          yyput(0xa7);
MENU            yyput(0xa8);
RENUM           yyput(0xaa);
DEFSTR          yyput(0xab);
DEFINT          yyput(0xac);
DEFSNG          yyput(0xad);
DEFDBL          yyput(0xae);
LINE            yyput(0xaf);
PRESET          yyput(0xb0);
PSET            yyput(0xb1);
BEEP            yyput(0xb2);
FORMAT          yyput(0xb3);
KEY             yyput(0xb4);
COLOR           yyput(0xb5);
COM             yyput(0xb6);
MAX             yyput(0xb7);
CMD             yyput(0xb8);
MOTOR           yyput(0xb9);
SOUND           yyput(0xba);
EDIT            yyput(0xbb);
EXEC            yyput(0xbc);
SCREEN          yyput(0xbd);
CLS             yyput(0xbe);
POWER           yyput(0xbf);
BLOAD           yyput(0xc0);
BSAVE           yyput(0xc1);
"DSKO$"         yyput(0xc2);
OPEN            yyput(0xc5);
CLOSE           yyput(0xca);
LOAD            yyput(0xcb);
MERGE           yyput(0xcc);
FILES           yyput(0xcd);
NAME            yyput(0xce);
KILL            yyput(0xcf);
SAVE            yyput(0xd2);
LFILES          yyput(0xd3);
LOCATE          yyput(0xd5);
TO              yyput(0xd7);
THEN            yyput(0xd8);
"TAB("          yyput(0xd9);
STEP            yyput(0xda);
NOT             yyput(0xde);
ERL             yyput(0xdf);
ERR             yyput(0xe0);
"STRING$"       yyput(0xe1);
USING           yyput(0xe2);
INSTR           yyput(0xe3);
"'"             yyput(0xe4);
CSRLIN          yyput(0xe6);
OFF             yyput(0xe7);
"DSKI$"         yyput(0xe8);
"INKEY$"        yyput(0xe9);
"TIME$"         yyput(0xea);
"DATE$"         yyput(0xeb);
STATUS          yyput(0xee);
">"             yyput(0xf0);
"="             yyput(0xf1);
"<"             yyput(0xf2);
"+"             yyput(0xf3);
"-"             yyput(0xf4);
"*"             yyput(0xf5);
"/"             yyput(0xf6);
"^"             yyput(0xf7);
AND             yyput(0xf8);
OR              yyput(0xf9);
XOR             yyput(0xfa);
EQV             yyput(0xfb);
IMP             yyput(0xfc);
MOD             yyput(0xfd);
"\\"            yyput(0xfe);

"LEFT$"         yyput(0xff); yyput(0x81);
"RIGHT$"        yyput(0xff); yyput(0x82);
"MID$"          yyput(0xff); yyput(0x83);
SGN             yyput(0xff); yyput(0x84);
INT             yyput(0xff); yyput(0x85);
ABS             yyput(0xff); yyput(0x86);
SQR             yyput(0xff); yyput(0x87);
RND             yyput(0xff); yyput(0x88);
SIN             yyput(0xff); yyput(0x89);
LOG             yyput(0xff); yyput(0x8a);
EXP             yyput(0xff); yyput(0x8b);
COS             yyput(0xff); yyput(0x8c);
TAN             yyput(0xff); yyput(0x8d);
ATN             yyput(0xff); yyput(0x8e);
FRE             yyput(0xff); yyput(0x8f);
INP             yyput(0xff); yyput(0x90);
POS             yyput(0xff); yyput(0x91);
LEN             yyput(0xff); yyput(0x92);
"STR$"          yyput(0xff); yyput(0x93);
VAL             yyput(0xff); yyput(0x94);
ASC             yyput(0xff); yyput(0x95);
"CHR$"          yyput(0xff); yyput(0x96);
PEEK            yyput(0xff); yyput(0x97);
"SPACE$"        yyput(0xff); yyput(0x98);
LPOS            yyput(0xff); yyput(0x9b);
CINT            yyput(0xff); yyput(0x9f);
CSNG            yyput(0xff); yyput(0xa0);
CDBL            yyput(0xff); yyput(0xa1);
FIX             yyput(0xff); yyput(0xa2);
DSKF            yyput(0xff); yyput(0xa6);
EOF             yyput(0xff); yyput(0xa7);
LOC             yyput(0xff); yyput(0xa8);
LOF             yyput(0xff); yyput(0xa9);
"'"		yyput(':'); yyput(0x8F); yyput(0xE4); BEGIN(remark);


   /* Anything not yet matched is a variable name, so capitalize it. */
<INITIAL>.	{
    char *yptr = yytext;
    while ( *yptr )
       yyput( toupper( *yptr++ ) );
}




%%

/* The main() routine, yyput(), fixup_ptrs() */
    #include "m100-tokenize-main.c"

/* Literal number handling routine */
int tokenize_number(char *s) {
    int len = strlen(s);
    if (len == 0) return 1;
    int sign = (s[0] == '-');
    if (sign) s++, len--;
    


    return 0;
 }

  // xxx this is not finished yet. xxxx
  // N82 integers can only range from -32768 to 32767 
  /* Single digit integers are efficiently encoded as 0 = 0x11 to 9 = 0x1A. */
  // 0 = 0x11
  // 1 = 0x12
  // 9 = 0x1A

  /* Minus sign is encoded as 0xF4 */
  // -1 = 0xF4 0x12
	  
  /* Numbers from 10 to 255 are encoded with an ID of 0F */ 
  // 10  = 0x0F0A
  // 255 = 0x0FFF 

  /* Numbers 256 to 32767 are encoded with an ID of 1C */
  //	256		1C 00 01
  //	257		1C 01 01
  //	512		1C 00 02
  //	32767		1C FF 7F

  /* Single precision floating point. 1D B0 B1 B2 EX */
  //	32768		1D 00 00 00 90
  // 	32769		1D 00 01 00 90
  // 	65534		1D 00 FE 7F 90
  //	65535		1D 00 FF 7F 90
  //   131071		1D 80 FF 7F 91	
  //   131072		1D 00 00 00 92

  /* Double-precision floating point. ID: 1F */
  // 	1F 00 00 00 00 00 00 00 7E	 .125#	              2^-3
  //	1F 00 00 00 00 00 00 00 7F	 .25#	       2^-2
  //	1F 00 00 00 00 00 00 00 80	 .5#	2^-1
  //	1F 00 00 00 00 00 00 20 80	 .625#	2^-1     +    2^-3
  //	1F 00 00 00 00 00 00 40 80	 .75#	2^-1 + 2^-2
  //	1F 00 00 00 00 00 00 60 80	 .875#	2^-1 + 2^-2 + 2^-3
  //	1F 80 00 00 00 00 00 00 FF	8.507059173023492D+37	-> (same)

    /*******************************************************************/
    /* Microsoft Binary Format (MBF) for 64-bit floating point numbers */
    /* Tokenized as nine bytes:                                        */
    /* ID B0 B1 B2 B3 B4 B5 B6 EX                                      */
    /*                                                                 */
    /* ID is 1F for double-precision floating point                    */
    /* Value is (-1)^Signbit x  Mantissa ^ Exponent                    */
    /* 8-bit Exponent is EX-128                                        */
    /* Signbit is high bit of B6. (B6 is left with only 7 bits)        */
    /* 55-bit Mantissa is B6 B5 B4 B3 B2 B1 B0                         */
    /* 						                       */
    /* There is an implicit "1" bit at the start of the mantissa.      */
    /* Note that the implicit 1 is AFTER the decimal point.	       */
    /* 						                       */
    /*******************************************************************/


	  
