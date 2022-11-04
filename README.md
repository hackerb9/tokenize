# tandy-tokenize

A tokenizer for TRS-80 Model 100 BASIC language. (Also works for the
Tandy 102 and Tandy 200.)

## Introduction

The Tandy/Radio-Shack Model 100 portable computer can save its BASIC
files in ASCII (plain text) or in a "tokenized" format where the
keywords — such as `FOR`, `IF`, `PRINT`, `REM` — are converted to a
single byte. Not only is this more compact, but it loads much faster.
Programs for the Model 100 are generally distributed in ASCII format,
but that has two downsides: ① the user must LOAD and re-SAVE the file
on their machine to tokenize it and ② the machine may not have enough
storage space for downloading or tokenizing the ASCII version.

This program solves that problem by tokenizing on the host computer
before downloading to the Model 100.

ASCII formatted BASIC files generally are given the extension `.DO` so
that the Model 100 will see them as text documents. Other common
extensions are `.BA`, `.100`, and `.200`. Tokenized BASIC files use
the extension `.BA`.

## Compilation

You can just run `make` on most machines. Alternately, you can compile
by hand:

```bash
flex tandy-tokenize.lex  &&  gcc -o tandy-tokenize lex.yy.c -lfl
```

Flex creates the file lex.yy.c from tokenize.lex. Linking with libfl
sets up useful defaults, like a `main()` routine.


## Usage

The main program reads from stdin and writes to stdout, so you'll need
to use redirection like so:

``` bash
tandy-tokenize < INPUT.DO > OUTPUT.BA
```

Note: The file OUTPUT.BA must be transferred to the Model 100 as a
binary file using a program such as TEENY. TELCOM's text capture will
not work.

### Alternate usage

There is also a helper script called "tokenize" which doesn't
require redirection. It has some nice features, like automatically
naming the .BA and not overwriting existing files by default. It can
operate on multiple input files. 

``` bash
$ tokenize PROG1.DO prog2.do PROG3.DO
Tokenizing 'PROG1.DO' into 'PROG1.BA'
Tokenizing 'prog2.do' into 'prog2.ba'
Output file 'PROG3.BA' already exists. Overwrite [y/N]?
```


## Machine compatibility

The TRS-80 Models 100 and 102 and the Tandy 200 all share the same
tokenized BASIC, as do the Kyocera Kyotronic-85 and Olivetti M10, 
so one program will work for any of them. However,the NEC family 
of portables, the PC-8201, PC-8201A, and PC-8300, have a different
BASIC tokenization format. (Sidenote: Converting this to handle NEC's
N82 BASIC should not be difficult.)

## Why Lex?

This program is written in
[Flex](https://web.stanford.edu/class/archive/cs/cs143/cs143.1128/handouts/050%20Flex%20In%20A%20Nutshell.pdf),
a lexical analyzer, because it made implementation trivial. It's mostly
just a table of keywords and the corresponding byte they should emit.
Flex handles special cases, like quoted strings and REMarks, easily.

The downside is that one must have flex installed to modify this program.
(Note: flex is not necessary to compile without modification
as flex generates C code, `yy.lex.c`.)

## Miscellaneous notes

* Line endings in the input file can either be `CRLF` (standard for
  a Model 100 text document) or simply `LF` (UNIX style).

* Conventions for filename extensions vary. Here are just some of them:
  * `.BA` All tokenized BASIC programs are .BA files, but note that
    most .BA files found on the Internet are in ASCII format. Before
    the existence of tokenizers like this, one was expected to know
    that ASCII files had to be renamed to .DO when downloading to a
    Model 100. 
  * `.DO` This is the extension the Model 100 uses for plain text
    BASIC files, but in general can mean any ASCII text document with
    CRLF line endings.
  * Although the BASIC language and tokenization is the same, some
    programs use POKEs or CALLs which work only one one model of
    portable computer and will cause others to crash badly, possibly
    losing files. To avoid this, some filename extensions are used:
	* `.100` An ASCII BASIC file that includes POKEs or CALLs specific
	  to the Model 100/102.
	* `.200` An ASCII BASIC file specific to the Tandy 200.
	* `.BA1` A tokenized BASIC file specific to the Model 100/102.	
	* `.BA2` A tokenized BASIC file specific to the Tandy 200.
	* `.BA0` A tokenized BASIC file specific to the NEC PC-8201A.

* To save in ASCII format on the Model 100, append `, A`:
  ```BASIC
  save "FOO", A
  ```

## More information

* The file format of tokenized BASIC in the Model 100/102 and Tandy 200: 
  http://fileformats.archiveteam.org/wiki/Tandy_200_BASIC_tokenized_file

## Alternatives

Here are some other ways that you can tokenize Model 100 BASIC on a
host system.

* Robert Pigford wrote a Model 100 tokenizer that runs in Microsoft Windows.
  Includes PowerBASIC source code. 
  http://www.club100.org/memfiles/index.php?&direction=0&order=nom&directory=Robert%20Pigford/TOKENIZE

* Mike Stein's entoke.exe is a tokenizer for Microsoft DOS.
  http://www.club100.org/memfiles/index.php?&direction=0&order=nom&directory=Mike%20Stein
  
* The Model 100's ROM disassembly shows that the tokenization code is quite short.
  http://www.club100.org/memfiles/index.php?action=downloadfile&filename=m100_dis.txt&directory=Ken%20Pettit/M100%20ROM%20Disassembly
  
* The VirtualT emulator can be scripted to tokenize a program through telnet.
  https://sourceforge.net/projects/virtualt/
