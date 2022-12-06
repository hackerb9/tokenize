/* tandy-decomment.lex		TRS-80 Model 100 BASIC decommenter 
 *
 * Removes comments (REMarks) while tokenizing Model 100 BASIC.
 * Additionally: Removes white space and colons before a comment.
 * Bonus: Two single-ticks ('') marks a comment to keep.
 * 
 * Compile with:   flex tandy-decomment.lex && gcc lex.yy.c -lfl
 */


/* Exclusive states. String copies text instead of lexing. */  
%x string

%%

<*>\r		/* Ignore carriage return */
<*>\n		putchar('\0'); BEGIN(INITIAL);

^[[:space:]]*[0-9]+[ ]?	{	/* BASIC line number */
  uint16_t line=atoi(yytext);
  putchar(42);  putchar(42);	/* Dummy placeholder values */
  putchar(line & 0xFF);
  putchar(line >> 8);
 }

\"		putchar('"'); BEGIN(string);
<string>\"	putchar('"'); BEGIN(INITIAL);

<<EOF>>		{ yyterminate(); }

[: \t]*"''"[^\r\n]*	putchar(142); printf(yytext); /* Keep '' comments. */
[: \t]*('|REM)[^\r\n]*	putchar(':'); putchar(0x8E); putchar(0xFF);  /* Delete comments + whitespace. */

END		putchar(128);
FOR		putchar(129);
NEXT		putchar(130);
DATA		putchar(131);
INPUT		putchar(132);
DIM		putchar(133);
READ		putchar(134);
LET		putchar(135);
GOTO		putchar(136);
RUN		putchar(137);
IF		putchar(138);
RESTORE		putchar(139);
GOSUB		putchar(140);
RETURN		putchar(141);
STOP		putchar(143);
WIDTH		putchar(144);
ELSE		putchar(':'); putchar(145);
LINE		putchar(146);
EDIT		putchar(147);
ERROR		putchar(148);
RESUME		putchar(149);
OUT		putchar(150);
ON		putchar(151);
"DSKO$"		putchar(152);
OPEN		putchar(153);
CLOSE		putchar(154);
LOAD		putchar(155);
MERGE		putchar(156);
FILES		putchar(157);
SAVE		putchar(158);
LFILES		putchar(159);
LPRINT		putchar(160);
DEF		putchar(161);
POKE		putchar(162);
PRINT		putchar(163);
"?"		putchar(163);
CONT		putchar(164);
LIST		putchar(165);
LLIST		putchar(166);
CLEAR		putchar(167);
CLOAD		putchar(168);
CSAVE		putchar(169);
"TIME$"		putchar(170);
"DATE$"		putchar(171);
"DAY$"		putchar(172);
COM		putchar(173);
MDM		putchar(174);
KEY		putchar(175);
CLS		putchar(176);
BEEP		putchar(177);
SOUND		putchar(178);
LCOPY		putchar(179);
PSET		putchar(180);
PRESET		putchar(181);
MOTOR		putchar(182);
MAX		putchar(183);
POWER		putchar(184);
CALL		putchar(185);
MENU		putchar(186);
IPL		putchar(187);
NAME		putchar(188);
KILL		putchar(189);
SCREEN		putchar(190);
NEW		putchar(191);
"TAB("		putchar(192);
TO		putchar(193);
USING		putchar(194);
VARPTR		putchar(195);
ERL		putchar(196);
ERR		putchar(197);
"STRING$"	putchar(198);
INSTR		putchar(199);
"DSKI$"		putchar(200);
"INKEY$"	putchar(201);
CSRLIN		putchar(202);
OFF		putchar(203);
HIMEM		putchar(204);
THEN		putchar(205);
NOT		putchar(206);
STEP		putchar(207);
"+"		putchar(208);
"-"		putchar(209);
"*"		putchar(210);
"/"		putchar(211);
"^"		putchar(212);
AND		putchar(213);
OR		putchar(214);
XOR		putchar(215);
EQV		putchar(216);
IMP		putchar(217);
MOD		putchar(218);
"\\"		putchar(219);
">"		putchar(220);
"="		putchar(221);
"<"		putchar(222);
SGN		putchar(223);
INT		putchar(224);
ABS		putchar(225);
FRE		putchar(226);
INP		putchar(227);
LPOS		putchar(228);
POS		putchar(229);
SQR		putchar(230);
RND		putchar(231);
LOG		putchar(232);
EXP		putchar(233);
COS		putchar(234);
SIN		putchar(235);
TAN		putchar(236);
ATN		putchar(237);
PEEK		putchar(238);
EOF		putchar(239);
LOC		putchar(240);
LOF		putchar(241);
CINT		putchar(242);
CSNG		putchar(243);
CDBL		putchar(244);
FIX		putchar(245);
LEN		putchar(246);
"STR$"		putchar(247);
VAL		putchar(248);
ASC		putchar(249);
"CHR$"		putchar(250);
"SPACE$"	putchar(251);
"LEFT$"		putchar(252);
"RIGHT$"	putchar(253);
"MID$"		putchar(254);

%%

