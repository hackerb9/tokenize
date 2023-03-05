# tandy-tokenize

A tokenizer for TRS-80 Model 100 (AKA "M100") BASIC language. 

Although, the text refers to the "Model 100", this also works for the
Tandy 102, Tandy 200, Kyocera Kyotronic-85, and Olivetti M10, which
all have the same tokenization.

It does not yet work for the NEC PC-8201/8201A/8300 whose N82 BASIC
has a different tokenization.

## Introduction

The Tandy/Radio-Shack Model 100 portable computer can save its BASIC
files in ASCII (plain text) or in a "tokenized" format where the
keywords — such as `FOR`, `IF`, `PRINT`, `REM` — are converted to a
single byte. Not only is this more compact, but it loads much faster.
Programs for the Model 100 are generally distributed in ASCII format,
but that has two downsides: ① the user must LOAD and re-SAVE the file
on their machine to tokenize it as only tokenized BASIC can be run and
② the machine may not have enough storage space for downloading or
tokenizing the ASCII version.

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

The main program allows one to specify the input .DO and output .BA file. 

``` bash
tandy-tokenize INPUT.DO OUTPUT.BA
```

Note: You must transfer OUTPUT.BA to the Model 100 as a binary file
using a program such as [TEENY](https://youtu.be/H0xx9cOe97s). Neither
TELCOM's "download" (text capture) nor BASIC's `LOAD "COM:"` will work
as those both expect ASCII format.

### Alternate usage

There is also a helper script called "tokenize" which doesn't require
specifying the output name. It automatically derives the .BA and
checks for existing files so they are not overwritten. It can operate
on multiple input files.

``` bash
$ tokenize PROG1.DO prog2.do PROG3.DO
Tokenizing 'PROG1.DO' into 'PROG1.BA'
Tokenizing 'prog2.do' into 'prog2.ba'
Output file 'PROG3.BA' already exists. Overwrite [y/N]?
```


## Machine compatibility

Across the eight Kyotronic-85 Sisters, there are actually only two
different tokenized formats. The first, which I call "M100 BASIC" is
supported by this program. The second, which is known as "N82 BASIC",
is not yet supported.

The TRS-80 Models 100 and 102 and the Tandy 200 all share the same
tokenized BASIC. While less commonly seen, the Kyocera Kyotronic-85
and Olivetti M10 also use that tokenization, so one .BA program can
work for any of them. However, the NEC family of portables, the
PC-8201, PC-8201A, and PC-8300, have a different BASIC tokenization
format. (Sidenote: Converting this program to handle NEC's N82 BASIC
is not expected to be difficult as N82 BASIC is almost the same as
M100 BASIC.)

## Why Lex?

This program is written in
[Flex](https://web.stanford.edu/class/archive/cs/cs143/cs143.1128/handouts/050%20Flex%20In%20A%20Nutshell.pdf),
a lexical analyzer, because it made implementation trivial. It's mostly
just a table of keywords and the corresponding byte they should emit.
Flex handles special cases, like quoted strings and REMarks, easily.

The downside is that one must have flex installed to _modify_ the
tokenizer. Flex is _not_ necessary to compile and run as flex actually
generates C code which can be compliled anywhere (see the file
`lex.tokenize.c`). 

## Miscellaneous notes

* Tokenized BASIC files are binary files, not ASCII and as such cannot
  be transferred easily using the builtin TELCOM program or the `LOAD
  "COM:"` or `SAVE "COM:"` commands. Instead, one must use a program
  such as [TEENY](https://youtu.be/H0xx9cOe97s) which can transfer
  8-bit data.

* Line endings in the input file can either be `CRLF` (standard for
  a Model 100 text document) or simply `LF` (UNIX style).

* Even when the tokenized format is the same, there exist a multitude
  of filename extensions to signify to users that a program is
  intended to run on a certain platform and warn that it may use
  system specific features. 

* Conventions for filename extensions vary. Here are just some of them:
  * `.DO` This is the extension the Model 100 uses for plain text
    BASIC files, but in general can mean any ASCII text document with
    CRLF line endings.
  * `.BA` All tokenized BASIC programs are named .BA on the Model 100,
    but note that most .BA files found on the Internet are in ASCII
    format. Before the existence of tokenizers like this, one was
    expected to know that ASCII files had to be renamed to .DO when
    downloading to a Model 100.
  * Although the BASIC language and tokenization is the same, some
    programs use POKEs or CALLs which work only one one model of
    portable computer and will cause others to crash badly, possibly
    losing files. To avoid this, some filename extensions are used:
	* `.100` An ASCII BASIC file that includes POKEs or CALLs specific
	  to the Model 100/102.
	* `.200` An ASCII BASIC file specific to the Tandy 200.
	* `.BA1` A tokenized BASIC file specific to the Model 100/102.	
	* `.BA2` A tokenized BASIC file specific to the Tandy 200.
  * The `.BA0` and `.NEC.BA` extension signify a tokenized BASIC file
    specific to the NEC portables. This is a different tokenization
    format than any of the above and is not yet supported.

* To save in ASCII format on the Model 100, append `, A`:
  ```BASIC
  save "FOO", A
  ```

## Decommenter

As a bonus, a program called tandy-decomment exists which tokenizes
programs while also shrinking the output size by throwing away data.
It removes the text of comments and extraneous whitespace. It could do
more thorough packing (merging lines together, removing unnecessary
lines), but I think it currently strikes a good balance of compression
versus complexity.

## Testing

Run `make test` to try out the tokenizer on some standard Model 100
programs and some strange ones designed specifically to exercise
peculiar syntax. The program `bacmp` is used to compare the generated
.BA file with one created on a actual Tandy 200.

Currently, the only test which is "failing" is SCRAMB.DO whose input
is scrambled and redundant. 

``` BASIC
20 GOTO 10
10 GOTO 10
10 PRINT "!dlroW ,olleH"

```

This tokenizer emits output as soon as a line is seen, so lines which
are out of order will be kept out of order. Likewise, a redundant line
will still be redundant in the output. This could be fixed using a
preprocessor that sorts the lines and keeps only the last of duplicates.

## bacmp

The `bacmp` program may be useful for others who wish to discover if
two BASIC files are identical. Because of the way the Model 100 works,
a normal `cmp` test will fail. There are pointers from each BASIC line
to the next which change based upon where the program happens to be in
memory. The `bacmp` program handles that by allowing line pointers to
differ as long as they are offset by a constant amount.

Note that generating correct line pointers is actually unnecessary in
a tokenizer; they could be any arbitrary values. The Model 100 always
regenerates the pointers when it loads a .BA file. However, some
emulators insist on having them precisely correct, so this tokenizer
has followed suit.

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
