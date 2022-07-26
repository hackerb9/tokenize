# tokenize

A tokenizer for TRS-80 Model 100 BASIC

## Introduction

The Tandy/Radio-Shack Model 100 computer can save its BASIC files in ASCII or in a "tokenized" format where the keywords — such as `FOR`, `IF`, `PRINT`, `REM` — are converted to a single byte. Not only is this more compact, but it loads much faster. Programs for the Model 100 are generally distributed in ASCII format, but that has two downsides: ① the user must LOAD and re-SAVE the file on their machine to tokenize it and ② the machine may not have enough storage space for downloading or tokenizing the ASCII version.

This program solves that problem by tokenizing on the host computer before downloading to the Model 100.

## Machine compatibility

The TRS-80 Models 100 and 102 and the Tandy 200 all share the same tokenized BASIC, so this will work for any of them. However, other similar machines, such as the NEC PC-8201/8300, have a different BASIC tokenization format. 

## Lex? Why Lex?

This program is written using the Flex lexer because it made the program trivial. It's mostly just a table of keywords and the corresponding byte they should emit. Lex also makes special cases, like quoted strings and REMarks, very easy. The downside is that one must have flex installed to compile. Here is the basic method:
```
flex tokenize.lex && gcc lex.yy.c -lfl
```

Flex creates the file lex.yy.c from tokenize.lex. Linking with libfl lets us use defaults for some of the setup, like a `main()` routine.
