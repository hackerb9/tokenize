# tokenize

A tokenizer for TRS-80 Model 100 BASIC

## Introduction

The Tandy/Radio-Shack Model 100 computer can save its BASIC files in
ASCII or in a "tokenized" format where the keywords — such as `FOR`, `IF`, `PRINT`, `REM` — are converted to a single byte. Not only is this more compact, but it loads much faster. Programs for the Model 100 are generally distributed in ASCII format, but that has two downsides: ① the user must LOAD and re-SAVE the file on their machine to tokenize it and ② the machine may not have enough storage space for downloading or tokenizing the ASCII version.

This program solves that problem by tokenizing on the host computer before downloading to the Model 100.

ASCII formatted BASIC files generally have the extension `.DO` so that
the Model 100 will see them as text documents. Tokenized BASIC files
usually have the extension `.BA`. 

## Usage

The program reads from stdin and writes to stdout, so you'll need
to use redirection like so:

``` bash
tokenize < INPUT.DO > OUTPUT.BA
```

## Machine compatibility

The TRS-80 Models 100 and 102 and the Tandy 200 all share the same tokenized BASIC, so this will work for any of them. However, other similar machines, such as the NEC PC-8201/8300, have a different BASIC tokenization format. 

Converting this to NEC BASIC should not be difficult.

## Lex?

This program is written in
[Flex](https://web.stanford.edu/class/archive/cs/cs143/cs143.1128/handouts/050%20Flex%20In%20A%20Nutshell.pdf),
a lexical analyzer, because it made implementation trivial. It's mostly
just a table of keywords and the corresponding byte they should emit.
Flex handles special cases, like quoted strings and REMarks, easily.
The downside is that one must have flex installed to compile.
Here is the basic method of compilation:

```
flex tokenize.lex  &&  gcc lex.yy.c -lfl
```

Flex creates the file lex.yy.c from tokenize.lex. Linking with libfl
sets up useful defaults, like a `main()` routine.

## Usage notes

* Line endings in the input file can either be `CR``LF` (standard for
  a Model 100 text document) or simply `LF` (UNIX style).

## More information

* The file format of tokenized BASIC in the Model 100/102 and Tandy 200: 
  http://fileformats.archiveteam.org/wiki/Tandy_200_BASIC_tokenized_file

## Alternatives

Here are some other ways that you can tokenize Model 100 BASIC on a host system. 

* Robert Pigford wrote a Model 100 tokenizer that runs in Microsoft Windows.
  Includes PowerBASIC source code. 
  http://www.club100.org/memfiles/index.php?&direction=0&order=nom&directory=Robert%20Pigford/TOKENIZE

* Mike Stein's entoke.exe is a tokenizer for Microsoft DOS.
  http://www.club100.org/memfiles/index.php?&direction=0&order=nom&directory=Mike%20Stein
  
* The Model 100's ROM disassembly shows that the tokenization code is quite short.
  http://www.club100.org/memfiles/index.php?action=downloadfile&filename=m100_dis.txt&directory=Ken%20Pettit/M100%20ROM%20Disassembly
  
* The VirtualT emulator can be scripted to tokenize a program through telnet.
  https://sourceforge.net/projects/virtualt/
