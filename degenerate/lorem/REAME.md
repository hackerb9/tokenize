# Largest BASIC programs

To experimentally discover the size of the largest possible tokenized
BASIC program on a Model T computer, use a host computer to send a
program line-by-line over the serial port to be tokenized.

* On Tandy 200:
  ```BASIC
  ?fre(0)
   19334
  load "com:98n1enn"
  ```
* On UNIX host:
  ```bash
  $ stty -F /dev/ttyUSB0 icanon ixon ixoff stop ^S start ^Q susp undef eof ^Z
  $ stty -F /dev/ttyUSB0 onlcr icrnl -echo 19200 pass8 -cstopb
  $ ./lorem.sh 19214 > /dev/ttyUSB0 && echo -n $'\cZ'  >/dev/ttyUSB0
  ```

On a Tandy 200, with the default of 19334 bytes free, a BASIC program
of &lt;= 19214 bytes works, but &gt;= 19215 gives an `?OM Error`. It
seems **120 bytes** are needed to parse a line of BASIC. 

Note that after loading such a program, commands like `?fre(0)` and
`clear` will die with an out of memory error. In fact, while the
program can be `RUN` after loading it over the serial port, even just
`SAVE`ing the program will cause it to fail to RUN with an `?OM Error`!

Running `CLEAR 136` (which frees 120 characters compared to the
default of 256) gives 19454 bytes free on a Tandy 200. The maximum
lorem BASIC program then becomes 19454 - 120 = 19334 bytes.

The maximum possible filesize can be achieved by running `CLEAR 0`,
which on the Tandy 200 gives 19590 bytes free. Again, the maximum
lorem BASIC program I'm able to transmit is 19590 - 120 = 19470 bytes.
Of course, with zero bytes of string space reserved, no useful program
can be run.

| Model     | Max Bytes Free | Max tokenized BASIC filesize |
|-----------|----------------|------------------------------|
| Model 100 |                |                              |
| Tandy 200 | 19,588         | 19,470                       |
| Tandy 102 |                |                              |
