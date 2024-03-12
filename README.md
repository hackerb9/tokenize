# tandy-tokenize

A tokenizer for TRS-80 Model 100 (AKA "M100") BASIC language. 

Although, the text refers to the "Model 100", this also works for the
Tandy 102, Tandy 200, Kyocera Kyotronic-85, and Olivetti M10, which
all have [identical tokenization](http://fileformats.archiveteam.org/wiki/Tandy_200_BASIC_tokenized_file).

_This does not yet work for the NEC PC-8201/8201A/8300 whose N82 BASIC
has a different tokenization._

## Introduction

The Tandy/Radio-Shack Model 100 portable computer can save its BASIC
files in ASCII (plain text) or in a "tokenized" format where the
keywords — such as `FOR`, `IF`, `PRINT`, `REM` — are converted to a
single byte. Not only is this more compact, but it loads much faster.
Programs for the Model 100 are generally distributed in ASCII format,
but that has two downsides: ① the user must LOAD and re-SAVE the file
on their machine to tokenize it as only tokenized BASIC can be run and
② the machine may not have enough storage space for the tokenized
version while the ASCII version is also in memory.

This program solves that problem by tokenizing on the host computer
before downloading to the Model 100. Additionally, this project
provides a decommenter and cruncher (whitespace remover) to save bytes
in the tokenized output at the expense of readability.

ASCII formatted BASIC files generally are given the extension `.DO` so
that the Model 100 will see them as text documents. Other common
extensions are `.BA`, `.100`, and `.200`. Tokenized BASIC files use
the extension `.BA`.

## Programs in this project

* **tokenize**: A shell script which ties together all the following.

* **tandy-tokenize**: Convert M100 BASIC program from ASCII (.DO)
  to executable .BA file.
  
* **tandy-sanity**: Clean up the BASIC source code (sort lines and
  remove duplicates).
  
* **tandy-jumps**: Analyze the BASIC source code and output a list of
  lines that begin with a comment and that are referred to by other
  lines in the program. Input should have been run through
  tandy-sanity. 

* **tandy-decomment**: Modify the BASIC source code to remove `REM`
  and `'` comments except it keeps lines mentioned on the command line
  (output from tandy-jumps). This can save a lot of space if the
  program was well commented.

* **tandy-crunch**: Modify the BASIC source code to remove all
  whitespace in an attempt to save even more space at the expense of
  readability. 

## Compilation & Installation

Presuming you have `flex` installed, just run `make` to compile.

``` BASH
$ git clone https://github.com/hackerb9/tokenize
$ make
$ make install
```

<details><summary><b>Optionally, you can compile by hand</b></summary>

```bash
 flex tandy-tokenize.lex  &&  gcc lex.tokenize.c
```

Flex creates the file lex.tokenize.c from tandy-tokenize.lex. The
`main()` routine is defined in tandy-tokenize-main.c, which is
#included by tandy-tokenize.lex.

</details>

## Usage

One can either use the tokenize wrapper or run the executables manually.

### The tokenize wrapper

The
"[tokenize](https://github.com/hackerb9/tokenize/blob/main/tokenize)"
script is easiest. By default, the output will be exactly the
same, byte for byte, as a .BA file created on actual hardware.

#### Synopsis

**tokenize** _INPUT.DO_ [ _OUTPUT.BA_ ]<br/>
**tokenize** [ **-d** | **--decomment** ] _INPUT.DO_ [ _OUTPUT.BA_ ]<br/>
**tokenize** [ **-c** | **--crunch** ] _INPUT.DO_ [ _OUTPUT.BA_ ]

The **-d** option decomments before tokenizing.

The **-c** option decomments _and_ removes all optional
whitespace before tokenizing.

#### Example

``` bash
$ tokenize PROG.DO
Output file 'PROG.BA' already exists. Overwrite [yes/No/rename]? R
Old file renamed to 'PROG.BA~'
```

### Running tandy-tokenize manually

#### Synopsis

**tandy-tokenize** [ _INPUT.DO_ [ _OUTPUT.BA_ ] ]

Unlike `tokenize`, tandy-tokenize does not require an input
filename as it is meant to be used as a filter in a pipeline.
With no files specified, the default is to use stdin and stdout. 

#### Example usage of tandy-tokenize

When running tandy-tokenize by hand, it is recommended to process
the input through the `tandy-sanity` script first to correct
possibly ill-formed BASIC source code.

``` bash
tandy-sanity INPUT.DO | tandy-tokenize > OUTPUT.BA
```

#### Stdout stream rewinding 

After finishing tokenizing, tandy-tokenize rewinds the output
file in order to correct the **PL PH** line pointers. Rewinding
fails if the standard output is piped to another program. For
example:

  1. tandy-tokenize  FOO.DO  FOO.BA
  2. tandy-tokenize  <FOO.DO  >FOO.BA
  3. tandy-tokenize  FOO.DO | cat > FOO.BA

Note that (1) and (2) are identical, but (3) is slightly different.

In example 3, the output stream cannot be rewound and the line
pointers will all contain "\*\*" (0x2A2A). This does not matter
for a genuine Model T computer which ignores **PL PH** in a file,
but some emulators are known to be persnickety and balk.


## Machine compatibility

Across the eight Kyotronic-85 Sisters, there are actually only
two different tokenized formats. The first, which I call "M100
BASIC" is supported by this program. The second, which is known
as "N82 BASIC", is not yet supported.

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

## Abnormal code

The `tokenize` script always uses the tandy-sanity program to
clean up the source code, but one can run tandy-tokenize directly
to purposefully create abnormal, but valid, programs. These
programs cannot be created on genuine hardware, but **will** run.

Here is an extreme example.

<details><summary><b>Source code for 
<a href="https://github.com/hackerb9/tokenize/blob/main/degenerate/GOTO10.DO">
"GOTO 10"</a> by hackerb9</b></summary>

```BASIC
1 I=-1
10 I=I+1: IF I MOD 1000 THEN 10 ELSE I=0
10 PRINT: PRINT
10 PRINT "This is line ten."
10 PRINT "This is also line ten."
5  PRINT "Line five runs after line ten."
10 PRINT "Where would GOTO 10 go?"
15 PRINT "  (The following line is 7 GOTO 10)"
7 GOTO 10
8 ERROR "Line 8 is skipped by GOTO 10."
10 PRINT: PRINT "It goes to the *next* line ten!"
10 FOR T=0 TO 1000: NEXT T
10 PRINT "Exceptions: Goes to *first* line ten"
10 PRINT "  if the current line is ten, or"
10 PRINT "  if a line number > 10 is seen."
10
10 'Shouldn't 10 GOTO 10 go to itself?
10 'It shouldn't have to search at all.
10 'Maybe it's a bug in Tandy BASIC?
10 'Perhaps it checks for (line >= 10)
10 'before it checks for (line == 10)?
10
10 'BTW, >= is one less op than >.
10 'On 8085, >= is CMP then check CY==0.
10 'But > also requires checking Z==0.
10
10 PRINT
10 PRINT "The next line is 9 GOTO 10. This time"
10 PRINT "it goes to the FIRST line ten, because"
10 PRINT "line 20 comes before the next line ten."
9 GOTO 10
20 ERROR "Line 20 is never reached, but it has an effect because 20>10."
10 ERROR "This is the final line ten. The previous GOTO 10 won't find it because line 20 comes first."
10
15
20 
0 PRINT "This program examines how"
1 PRINT "Model T computers run"
2 PRINT "degenerate tokenized BASIC."
3 PRINT "Trying to load it as a .DO"
4 PRINT "file will not work as"
5 PRINT "Tandy BASIC corrects issues"
6 PRINT "such as duplicate line numbers"
7 PRINT "and out of order lines."
8 PRINT "Please use hackerb9's"
9 PRINT "pre-tokenized GOTO10.BA."
```

To run this on a Model 100, download
[GOTO10.BA](https://github.com/hackerb9/tokenize/raw/main/degenerate/GOTO10.BA)
which was created using tandy-tokenizer.

</details>

takes care of automatically: sort line
numbers and keep only the last line of any duplicates. This
should be typically be used on any source code, hackerb9's
tandy-tokenize is able to generate tokenizations of degenerate
BASIC programs.



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

  Conventions for filename extensions vary. Here are just some of them:
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

* If the output is piped to another program, tandy-tokenize will not
  be able to rewind the stream to update the line pointers at the for
  each line. In that case, the characters '**' are used which will
  work fine on genuine Model 100 hardware. However, some emulators may
  complain or refuse to load up the tokenized file. 

## Decommenter

As a bonus, a program called tandy-decomment exists which tokenizes
programs while also shrinking the output size by throwing away data.
It removes the text of comments and extraneous whitespace. It could do
more thorough packing (merging lines together, removing unnecessary
lines), but I think it currently strikes a good balance of compression
versus complexity.

## Testing and a minor bug

Run `make test` to try out the tokenizer on some [sample Model 100
programs](https://github.com/hackerb9/tokenize/tree/main/samples) and
some strange ones designed specifically to exercise peculiar syntax.
The program `bacmp` is used to compare the generated .BA file with one
created on a actual Tandy 200.

Currently, the only test which is "failing" is SCRAMB.DO whose input
is scrambled and redundant. 

``` BASIC
20 GOTO 10
10 GOTO 10
10 PRINT "!dlroW ,olleH"

```

This tokenizer emits output as soon as a line is seen, so lines which
are out of order will be kept out of order. Likewise, a redundant line
will still be redundant in the output. The builtin tokenizer on the
Model 100 computer sorts the lines and keeps only the last of
duplicates. If this is a problem, one solution would be to sort the
input and keep only the last of each line number:

For example,

```BASH
rev | sort -u -n -k1,1 | tandy-tokenize > output.ba
```

## bacmp: BASIC comparator

The included
[bacmp.c](https://github.com/hackerb9/tokenize/blob/main/bacmp.c)
program may be useful for others who wish to discover if two tokenized
BASIC files are identical. Because of the way the Model 100 works, a
normal `cmp` test will fail. There are pointers from each BASIC line
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
