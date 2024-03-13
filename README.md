# m100-tokenize

A tokenizer for TRS-80 Model 100 (AKA "M100") BASIC language. Converts
`.DO` files to `.BA`.

    tokenize FOO.DO FOO.BA

Although, the documentation will refers to the "Model 100", this
program also works for the Tandy 102, Tandy 200, Kyocera Kyotronic-85,
and Olivetti M10, which all have [identical
tokenization](http://fileformats.archiveteam.org/wiki/Tandy_200_BASIC_tokenized_file).

_This does not work for the NEC PC-8201/8201A/8300 whose N82 BASIC has
a different tokenization._

## Introduction

The Tandy/Radio-Shack Model 100 portable computer can save its BASIC
files in ASCII (plain text) or in a "tokenized" format where the
keywords — such as `FOR`, `IF`, `PRINT`, `REM` — are converted to a
single byte. Not only is this more compact, but it loads much faster.

### The problem

Programs for the Model 100 are generally distributed in ASCII format,
but that has two downsides: ① the user must LOAD and re-SAVE the file
on their machine to tokenize it as only tokenized BASIC can be run and
② the machine may not have enough storage space for the tokenized
version while the ASCII version is also in memory.

### The solution

This program solves that problem by tokenizing on the host computer
before downloading to the Model 100. Additionally, this project
provides a decommenter and cruncher (whitespace remover) to save bytes
in the tokenized output at the expense of readability.

### File extension terminology

Tokenized BASIC files use the extension `.BA`. ASCII formatted BASIC
files should be given the extension `.DO` so that the Model 100 will
see them as text documents, although people often misuse `.BA` for
ASCII. 

## Programs in this project

* **tokenize**: A shell script which ties together all the following.

* **m100-tokenize**: Convert M100 BASIC program from ASCII (.DO)
  to executable .BA file.
  
* **m100-sanity**: Clean up the BASIC source code (sort lines and
  remove duplicates).
  
* **m100-jumps**: Analyze the BASIC source code and output a list of
  lines that begin with a comment and that are referred to by other
  lines in the program. Input should have been run through
  m100-sanity. 

* **m100-decomment**: Modify the BASIC source code to remove `REM`
  and `'` comments except it keeps lines mentioned on the command line
  (output from m100-jumps). This can save a lot of space if the
  program was well commented.

* **m100-crunch**: Modify the BASIC source code to remove all
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
 flex m100-tokenize.lex  &&  gcc lex.tokenize.c
```

Flex creates the file lex.tokenize.c from m100-tokenize.lex. The
`main()` routine is defined in m100-tokenize-main.c, which is
#included by m100-tokenize.lex.

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

### Running m100-tokenize and friends manually

Certain programs should _usually_ be run to process the input before
the final tokenization step, depending upon what is wanted.
m100-sanity is strongly recommended. (See [Abnormal
code](#Abnormal code) below.)

``` mermaid
flowchart LR;
m100-sanity ==> m100-tokenize
m100-sanity ==> m100-jumps
m100-sanity ==> m100-decomment --> m100-crunch --> m100-tokenize
m100-decomment --> m100-tokenize
```

| Programs used                                                                   | Effect                                     | Same as     |
|---------------------------------------------------------------------------------|--------------------------------------------|-------------|
| m100-sanity<br/>m100-tokenize                                                   | Identical output as a genuine Model 100    | tokenize    |
| m100-sanity<br/>m100-jumps<br/>m100-decomment<br/>m100-tokenize                 | Saves RAM by removing unnecessary comments | tokenize -d |
| m100-sanity<br/>m100-jumps<br/>m100-decomment<br/>m100-crunch<br/>m100-tokenize | Saves even more RAM, removing whitespace   | tokenize -c |
| m100-tokenize                                                                   | Abnormal code is kept as is                |             |

<details>

### m100-tokenize synopsis

**m100-tokenize** [ _INPUT.DO_ [ _OUTPUT.BA_ ] ]

Unlike `tokenize`, m100-tokenize never guesses the output filename.
With no files specified, the default is to use stdin and stdout so it
can be used as a filter in a pipeline. The other programs --
m100-sanity, m100-jumps, m100-decomment, and m100-crunch -- all have the
same syntax taking two optional filenames. 

### Example usage of m100-tokenize

When running m100-tokenize by hand, process the input through the
`m100-sanity` script first to correct possibly ill-formed BASIC source
code. 

``` bash
m100-sanity INPUT.DO | m100-tokenize > OUTPUT.BA
```

The above example is equivalent to running `tokenize INPUT.DO
OUTPUT.BA`.

### Example usage with decommenting

The m100-decomment program needs help from the m100-jumps program to
know when it shouldn't completely remove a commented out line, for
example,

``` BASIC
10 REM This line would normally be removed
20 GOTO 10   ' ... but now line 10 should be kept.
```

So, first, we get the list of line numbers that must be kept in the
variable `$jumps` and then we call m100-decomment passing in that list
on the command line.

    jumps=$(m100-sanity INPUT.DO | m100-jumps)
    m100-sanity INPUT.DO | 
	    m100-decomment - - $jumps | 
		m100-tokenize > OUTPUT.BA

The above example is equivalent to running `tokenize -d INPUT.DO
OUTPUT.BA`.

Note that m100-decomment keeps the entire text of comments which are
listed by m100-jumps with the presumption that, as targets of GOTO or
GOSUB, they are the most valuable remarks in the program. (This
behaviour may change in the future.)

Example output after decommenting but before tokenizing:
``` BASIC
10 REM This line would normally be removed
20 GOTO 10
```

### Example usage with crunching

The m100-crunch program removes all optional space and some other
optional characters, such as a double-quote at the end of a line or a
colon before an apostrophe. It also completely removes the text of
comments which may have been preserved by m100-decomment from the
m100-jumps list. In short, it makes the program extremely hard to
read, but does save a few more bytes in RAM.

    jumps=$(m100-sanity INPUT.DO | m100-jumps)
    m100-sanity INPUT.DO | 
	    m100-decomment - - $jumps | 
		m100-crunch | 
		m100-tokenize > OUTPUT.BA

The above example is equivalent to running `tokenize -c INPUT.DO
OUTPUT.BA`.

Example output after crunching but before tokenizing:

``` BASIC
10REM
20GOTO10
```

</details>

### An obscure note about stdout stream rewinding 

After finishing tokenizing, m100-tokenize rewinds the output
file in order to correct the **PL PH** line pointers. Rewinding
fails if the standard output is piped to another program. For
example:

  1. m100-tokenize  FOO.DO  FOO.BA
  2. m100-tokenize  <FOO.DO  >FOO.BA
  3. m100-tokenize  FOO.DO | cat > FOO.BA

Note that (1) and (2) are identical, but (3) is slightly different.

In example 3, the output stream cannot be rewound and the line
pointers will all contain "\*\*" (0x2A2A). This does not matter
for a genuine Model T computer which ignores **PL PH** in a file,
but some emulators are known to be persnickety and balk.

If you find this to be a problem, please file an issue as it is
potentially correctable using `open_memstream()`, but hackerb9 does
not see the need.

</details>


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
a lexical analyzer, because it made implementation trivial. The
tokenizer itself, m100-tokenize, is mostly just a table of keywords
and the corresponding byte they should emit. Flex handles special
cases, like quoted strings and REMarks, easily.

The downside is that one must have flex installed to _modify_ the
tokenizer. Flex is _not_ necessary to compile on a machine as flex can
generate portable C code. See the tokenize-cfiles.tar.gz in the github
release or run `make cfiles`.

## Abnormal code

The `tokenize` script always uses the m100-sanity program to clean up
the source code, but one can run m100-tokenize directly to
purposefully create abnormal, but valid, `.BA` files. These programs
cannot be created on genuine hardware, but **will** run.

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
which was created using m100-tokenizer.


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

## Testing

Run `make check` to try out the tokenizer on some [sample Model 100
programs](https://github.com/hackerb9/tokenize/tree/main/samples) and
some strange ones designed specifically to exercise peculiar syntax.
The program `bacmp` is used to compare the generated .BA file with one
created on hackerb9's Tandy 200.

Note that without m100-sanity, the SCRAMB.DO test, whose input is
scrambled and redundant, would fail.

``` BASIC
20 GOTO 10
10 GOTO 10
10 PRINT "!dlroW ,olleH"

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

* Hackerb9 has documented the file format of tokenized BASIC at
  http://fileformats.archiveteam.org/wiki/Tandy_200_BASIC_tokenized_file

## Alternatives

Here are some other ways that you can tokenize Model 100 BASIC when
the source code and the tokenized version won't both fit in the M100's
RAM. 

* Perhaps the simplest is to load the ASCII BASIC file to the M100 over
  a serial port from a PC host. On the Model 100, type:
  
          LOAD "COM:88N1"

  or for a Tandy 200, type

          LOAD "COM:88N1ENN"
  
  On the host side, send the file followed by the `^Z` ('\x1A')
  character to signal End-of-File. See hackerb9's
  [sendtomodelt](https://github.com/hackerb9/m100le/blob/main/adjunct/sendtomodelt)
  for a script to make this easier.

* Robert Pigford wrote a Model 100 tokenizer that runs in Microsoft Windows.
  Includes PowerBASIC source code. 
  http://www.club100.org/memfiles/index.php?&direction=0&order=nom&directory=Robert%20Pigford/TOKENIZE

* Mike Stein's entoke.exe is a tokenizer for Microsoft DOS.
  http://www.club100.org/memfiles/index.php?&direction=0&order=nom&directory=Mike%20Stein
  
* The Model 100's ROM disassembly shows that the tokenization code is quite short.
  http://www.club100.org/memfiles/index.php?action=downloadfile&filename=m100_dis.txt&directory=Ken%20Pettit/M100%20ROM%20Disassembly
  
* The VirtualT emulator can be scripted to tokenize a program through telnet.
  https://sourceforge.net/projects/virtualt/
