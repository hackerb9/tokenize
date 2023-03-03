/* tandy-tokenize.lex		TRS-80 Model 100 BASIC tokenizer *
 *
 * Flex uses this to create lex.tokenize.c.
 * 
 * Compile with:   flex tandy-tokenize.lex && gcc lex.tokenize.c
 */

							    /* VARIABLES */
    uint8_t out[65536];		/* Output buffer  */
    int i=0;			/* Current index into buffer */
    int start=0;		/* Start of most recent line */
    int base=0;			/* Faked base address offset in memory */
    void update();		/* Update the line pointers */

							    /* DEFINITIONS */
%option prefix="tokenize"

/* Define states that simply copy text into out[] instead of tokenizing */  
%x string
%x remark

%%
							    /* RULES */

<*>\r		/* Ignore carriage return */
<*>\n		out[i++] = '\0'; update(); BEGIN(INITIAL);

^[[:space:]]*[0-9]+[ ]?	{	/* BASIC line number */
    uint16_t line=atoi(yytext);
    out[i++] = '*'; out[i++] = '*'; /* Dummy values for line pointer */
    out[i++] = line & 0xFF;	/* Little endian line number */
    out[i++] = line >> 8; 
}

\"		out[i++] = '"'; BEGIN(string);
<string>[^\"]*	strcpy((char *)(out+i), yytext); ; i=i+yyleng;
<string>\"	out[i++]='"'; BEGIN(INITIAL);
<string>\$	BEGIN(INITIAL);

    /* <string>[^"]*	{ */
    /*   strcpy((char *)out+i, tokenizetext); i=i+strlen(tokenizetext); */
    /*  } */

<remark>.*$	strcpy((char *)(out+i), yytext); ; i=i+yyleng; BEGIN(INITIAL);

<<EOF>>	{
    if (out[i-1] != '\0') { /* No newline before EOF? */
      out[i++] = '\0';
      update();
    }
    fwrite(out, i, 1, stdout);
    yyterminate();
  }

END		out[i++] = 128;
FOR		out[i++] = 129;
NEXT		out[i++] = 130;
DATA		out[i++] = 131;
INPUT		out[i++] = 132;
DIM		out[i++] = 133;
READ		out[i++] = 134;
LET		out[i++] = 135;
GOTO		out[i++] = 136;
RUN		out[i++] = 137;
IF		out[i++] = 138;
RESTORE		out[i++] = 139;
GOSUB		out[i++] = 140;
RETURN		out[i++] = 141;
REM		out[i++] = 142; 	BEGIN(remark);
STOP		out[i++] = 143;
WIDTH		out[i++] = 144;
ELSE		out[i++] = ':'; out[i++] = 145;
LINE		out[i++] = 146;
EDIT		out[i++] = 147;
ERROR		out[i++] = 148;
RESUME		out[i++] = 149;
OUT		out[i++] = 150;
ON		out[i++] = 151;
"DSKO$"		out[i++] = 152;
OPEN		out[i++] = 153;
CLOSE		out[i++] = 154;
LOAD		out[i++] = 155;
MERGE		out[i++] = 156;
FILES		out[i++] = 157;
SAVE		out[i++] = 158;
LFILES		out[i++] = 159;
LPRINT		out[i++] = 160;
DEF		out[i++] = 161;
POKE		out[i++] = 162;
PRINT		out[i++] = 163;
"?"		out[i++] = 163;
CONT		out[i++] = 164;
LIST		out[i++] = 165;
LLIST		out[i++] = 166;
CLEAR		out[i++] = 167;
CLOAD		out[i++] = 168;
CSAVE		out[i++] = 169;
"TIME$"		out[i++] = 170;
"DATE$"		out[i++] = 171;
"DAY$"		out[i++] = 172;
COM		out[i++] = 173;
MDM		out[i++] = 174;
KEY		out[i++] = 175;
CLS		out[i++] = 176;
BEEP		out[i++] = 177;
SOUND		out[i++] = 178;
LCOPY		out[i++] = 179;
PSET		out[i++] = 180;
PRESET		out[i++] = 181;
MOTOR		out[i++] = 182;
MAX		out[i++] = 183;
POWER		out[i++] = 184;
CALL		out[i++] = 185;
MENU		out[i++] = 186;
IPL		out[i++] = 187;
NAME		out[i++] = 188;
KILL		out[i++] = 189;
SCREEN		out[i++] = 190;
NEW		out[i++] = 191;
"TAB("		out[i++] = 192;
TO		out[i++] = 193;
USING		out[i++] = 194;
VARPTR		out[i++] = 195;
ERL		out[i++] = 196;
ERR		out[i++] = 197;
"STRING$"	out[i++] = 198;
INSTR		out[i++] = 199;
"DSKI$"		out[i++] = 200;
"INKEY$"	out[i++] = 201;
CSRLIN		out[i++] = 202;
OFF		out[i++] = 203;
HIMEM		out[i++] = 204;
THEN		out[i++] = 205;
NOT		out[i++] = 206;
STEP		out[i++] = 207;
"+"		out[i++] = 208;
"-"		out[i++] = 209;
"*"		out[i++] = 210;
"/"		out[i++] = 211;
"^"		out[i++] = 212;
AND		out[i++] = 213;
OR		out[i++] = 214;
XOR		out[i++] = 215;
EQV		out[i++] = 216;
IMP		out[i++] = 217;
MOD		out[i++] = 218;
"\\"		out[i++] = 219;
">"		out[i++] = 220;
"="		out[i++] = 221;
"<"		out[i++] = 222;
SGN		out[i++] = 223;
INT		out[i++] = 224;
ABS		out[i++] = 225;
FRE		out[i++] = 226;
INP		out[i++] = 227;
LPOS		out[i++] = 228;
POS		out[i++] = 229;
SQR		out[i++] = 230;
RND		out[i++] = 231;
LOG		out[i++] = 232;
EXP		out[i++] = 233;
COS		out[i++] = 234;
SIN		out[i++] = 235;
TAN		out[i++] = 236;
ATN		out[i++] = 237;
PEEK		out[i++] = 238;
EOF		out[i++] = 239;
LOC		out[i++] = 240;
LOF		out[i++] = 241;
CINT		out[i++] = 242;
CSNG		out[i++] = 243;
CDBL		out[i++] = 244;
FIX		out[i++] = 245;
LEN		out[i++] = 246;
"STR$"		out[i++] = 247;
VAL		out[i++] = 248;
ASC		out[i++] = 249;
"CHR$"		out[i++] = 250;
"SPACE$"	out[i++] = 251;
"LEFT$"		out[i++] = 252;
"RIGHT$"	out[i++] = 253;
"MID$"		out[i++] = 254;
"'"		out[i++] = ':'; out[i++] = 0x8E; out[i++] = 0xFF; BEGIN(remark);

.		out[i++] = yytext[0];




%%
							    /* USER CODE */
void update() {
  /* Set the line pointer, the first two bytes at the beginning of
     the most recent line, to point to the next line.

     Global input:
	out[]: the buffer holding the program so far.
	start: the index in out[] where the most recent line starts.
	i: the index in out[] where the next line will start.
	base: a fixed, non-zero offset
	
     Side effects:
 	out[start], out[start+1] hold the little ending address of
 	the next line (as offset by base)

	start is set to point to the next line (i).
  */

  uint16_t pos = base + i;
  out[start]   = pos & 0xFF;
  out[start+1] = pos >> 8; 
  start = i;
}
