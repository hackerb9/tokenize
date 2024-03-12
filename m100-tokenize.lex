/* m100-tokenize.lex		TRS-80 Model 100 BASIC tokenizer *
 *
 * Flex uses this to create lex.tokenize.c.
 * 
 * Compile with:   	flex m100-tokenize.lex
 *			gcc lex.tokenize.c
 */

%option prefix="tokenize"

/* Define states that simply copy text instead of lexing */  
%x string
%x remark

  /* Functions defined in m100-tokenize-main.c */
  int yyput(uint8_t);		/* putchar, but for yyout instead of stdout. */
  uint8_t lastput=255;		/* last written character, for EOF without nl */
  int fixup_ptrs();		/* rewrite line pointers, if possible. */

  /* An array to store line pointers, to be fixed up at EOF */
  uint16_t ptr[65536];
  int nlines = 0;

%%

^[[:space:]]*[0-9]+[ ]?	{
    ptr[nlines++] = ftell(yyout);   /* Cache the location of the current line */
    yyput('*'); yyput('*');	    /* Dummy placeholder pointer to next line. */
    uint16_t linenum=atoi(yytext);  /* BASIC line number. */
    yyput(linenum & 0xFF);
    yyput(linenum >> 8);
  }

\"		yyput('"'); BEGIN(string);
<string>\"	yyput('"'); BEGIN(INITIAL);

   /* Newline matches <string> and <remark> start conditions. */
<*>\r?\n		yyput('\0'); BEGIN(INITIAL);

<<EOF>>	{
    (lastput == '\0') || yyput('\0'); /* Handle EOF without preceding newline */
    fixup_ptrs();
    yyterminate();
  }

END		yyput(128);
FOR		yyput(129);
NEXT		yyput(130);
DATA		yyput(131);
INPUT		yyput(132);
DIM		yyput(133);
READ		yyput(134);
LET		yyput(135);
GO[ \t]*TO	yyput(136);
RUN		yyput(137);
IF		yyput(138);
RESTORE		yyput(139);
GOSUB		yyput(140);
RETURN		yyput(141);
REM		yyput(142); BEGIN(remark);
STOP		yyput(143);
WIDTH		yyput(144);
ELSE		yyput(':'); yyput(145);
LINE		yyput(146);
EDIT		yyput(147);
ERROR		yyput(148);
RESUME		yyput(149);
OUT		yyput(150);
ON		yyput(151);
"DSKO$"		yyput(152);
OPEN		yyput(153);
CLOSE		yyput(154);
LOAD		yyput(155);
MERGE		yyput(156);
FILES		yyput(157);
SAVE		yyput(158);
LFILES		yyput(159);
LPRINT		yyput(160);
DEF		yyput(161);
POKE		yyput(162);
PRINT		yyput(163);
"?"		yyput(163);
CONT		yyput(164);
LIST		yyput(165);
LLIST		yyput(166);
CLEAR		yyput(167);
CLOAD		yyput(168);
CSAVE		yyput(169);
"TIME$"		yyput(170);
"DATE$"		yyput(171);
"DAY$"		yyput(172);
COM		yyput(173);
MDM		yyput(174);
KEY		yyput(175);
CLS		yyput(176);
BEEP		yyput(177);
SOUND		yyput(178);
LCOPY		yyput(179);
PSET		yyput(180);
PRESET		yyput(181);
MOTOR		yyput(182);
MAX		yyput(183);
POWER		yyput(184);
CALL		yyput(185);
MENU		yyput(186);
IPL		yyput(187);
NAME		yyput(188);
KILL		yyput(189);
SCREEN		yyput(190);
NEW		yyput(191);
"TAB("		yyput(192);
TO		yyput(193);
USING		yyput(194);
VARPTR		yyput(195);
ERL		yyput(196);
ERR		yyput(197);
"STRING$"	yyput(198);
INSTR		yyput(199);
"DSKI$"		yyput(200);
"INKEY$"	yyput(201);
CSRLIN		yyput(202);
OFF		yyput(203);
HIMEM		yyput(204);
THEN		yyput(205);
NOT		yyput(206);
STEP		yyput(207);
"+"		yyput(208);
"-"		yyput(209);
"*"		yyput(210);
"/"		yyput(211);
"^"		yyput(212);
AND		yyput(213);
OR		yyput(214);
XOR		yyput(215);
EQV		yyput(216);
IMP		yyput(217);
MOD		yyput(218);
"\\"		yyput(219);
">"		yyput(220);
"="		yyput(221);
"<"		yyput(222);
SGN		yyput(223);
INT		yyput(224);
ABS		yyput(225);
FRE		yyput(226);
INP		yyput(227);
LPOS		yyput(228);
POS		yyput(229);
SQR		yyput(230);
RND		yyput(231);
LOG		yyput(232);
EXP		yyput(233);
COS		yyput(234);
SIN		yyput(235);
TAN		yyput(236);
ATN		yyput(237);
PEEK		yyput(238);
EOF		yyput(239);
LOC		yyput(240);
LOF		yyput(241);
CINT		yyput(242);
CSNG		yyput(243);
CDBL		yyput(244);
FIX		yyput(245);
LEN		yyput(246);
"STR$"		yyput(247);
VAL		yyput(248);
ASC		yyput(249);
"CHR$"		yyput(250);
"SPACE$"	yyput(251);
"LEFT$"		yyput(252);
"RIGHT$"	yyput(253);
"MID$"		yyput(254);
"'"		yyput(':'); yyput(0x8E); yyput(0xFF); BEGIN(remark);

%%

/* The main() routine, yyput(), fixup_ptrs() */
    #include "m100-tokenize-main.c"
