# NEC N82 tokenized number formats

## Integer

Single digit numbers use 1 byte. Numbers up to 255 use two bytes.
Numbers up to 32767 use three bytes. Negative numbers use an extra
byte ('F4').

Range: 0 to 32767.

| Decimal | N82 Representation |
|--------:|-------------------:|
|       0 |                 11 |
|       1 |                 12 |
|       2 |                 13 |
|       8 |                 19 |
|       9 |                 1A |
|         |                    |
|      10 |              0F 0A |
|      11 |              0F 0B |
|      19 |              0F 13 |
|      20 |              0F 14 |
|      32 |              0F 20 |
|      99 |              0F 63 |
|     100 |              0F 64 |
|     254 |              0F FE |
|     255 |              0F FF |
|         |                    |
|     256 |           1C 00 01 |
|     257 |           1C 01 01 |
|     258 |           1C 02 01 |
|     512 |           1C 00 02 |
|     ... |                    |
|   32767 |           1C FF 7F |
|         |                    |
|      \- |                 F4 |

Note: Minus sign is simply F4 before the number.

## Real (single precision)

All single-precision numbers require 5 bytes to represent.


     Microsoft Binary Format ("6-digit BASIC")
     Exponent: 8 bits (biased by 0x80)
     Sign bit: 1 bit
     Significand precision: 24 bits (23 explicitly stored)

                            bits 15 to 22 (2^-17 to 2^-24)
                            |
                            |  bits 7 to 14 (2^-9 to 2^-16)
                            |  |
                            |  |  sign bit, bits 0 to 6 (2^-2 to 2^-8)
                            |  |  |
                            |  |  |  exponent (bias 0x80)
                            ↓  ↓  ↓  ↓
                       ================
        32768           1D 00 00 00 90  == 2^16 * 2^-1
        32769           1D 00 01 00 90  == 2^16 * (.5 + 2^-16)
        32770           1D 00 02 00 90
        33024           1D 00 00 01 90
        65534           1D 00 FE 7F 90
        65535           1D 00 FF 7F 90  == 2^16 * [for i=-16 to -1: ∑(2^i)]
        65536           1D 00 00 00 91  == 2^17 * 0.5
        65537           1D 80 00 00 91  == 2^17 * (.5 + 2^-17)
        65538           1D 00 01 00 91
        65539           1D 80 01 00 91
        ...
       131070           1D 00 FF 7F 91
       131071           1D 80 FF 7F 91  == 2^17 * [for i=-17 to -1, ∑(2^i)]
       131072           1D 00 00 00 92
       131073           1D 40 00 00 92
        ...
      262,143           1D C0 FF 7F 92
      262,144           1D 00 00 00 93
      262,145           1D 20 00 00 93
    1,048,575           1D F0 FF 7F 94
    1,048,576           1D 00 00 00 95
    1,048,577           1D 08 00 00 95
    4,194,304           1D 00 00 00 97
    9,999,999           1D 7F 96 18 98

## Double Precision

All double precision numbers require 8 bytes.

     Microsoft Binary Format (64 bits)
     Exponent: 8 bits (biased by 0x80)
     Sign bit: 1 bit
     Significand precision: 56 bits (55 explicitly stored)

        ID B6 B5 B4 B3 B2 B1 B0 EX

    ID is 1F for double-precision floating point
    Value is (-1)^Signbit × Mantissa x 2 ^ Exponent
    Exponent is EX-128
    Signbit is high bit of B0. (Mantissa in B0 is only 7 bits)
    Mantissa is B0 B1 B2 B3 B4 B5 B6


                 10,000,000         1F 00 00 00 00 20 BC 3E 9B
                 16,777,215         1F 00 00 00 00 FF FF 7F 98
                 16,777,216         1F 00 00 00 00 00 00 00 99
        123,456,789,012,345         1F 00 F2 BE 1B 0C 91 60 AF
      1,234,567,890,123,456         1F 00 58 57 91 A7 5A 0C B3
     12,345,678,901,234,566         1F 18 2E AD 75 51 71 2F B6
     12,345,678,901,234,567         1F 1C 2E AD 75 51 71 2F B6

    123,456,789,012,345,677         1F A7 79 18 D3 A5 4D 5B B9    } Identical
    123,456,789,012,345,678         1F A7 79 18 D3 A5 4D 5B B9    } Identical


## Double fractions

  Note that implicit initial '1' in mantissa comes _after_ the radix
  ("decimal point"). `0b0.1` == 2^-1 == ½. That means the mantissa,
  before being multiplied by the exponent, is in the range [0.5, 1).

    1F 00 00 00 00 00 00 00 7E   .125#  2^-1 * 2^-2
    1F 00 00 00 00 00 00 00 7F   .25#   2^-1 * 2^-1
    1F 00 00 00 00 00 00 00 80   .5#    2^-1
    1F 00 00 00 00 00 00 20 80   .625#  2^-1    +     2^-3
    1F 00 00 00 00 00 00 40 80   .75#   2^-1 + 2^-2
    1F 00 00 00 00 00 00 60 80   .875#  2^-1 + 2^-2 + 2^-3

    1F 00 00 00 00 00 00 00 81   1# 2^-1 * 2^+1
    1F 00 00 00 00 00 00 00 82   2# 2^-1 * 2^+2
    1F 00 00 00 00 00 00 00 83   4# 2^-1 * 2^+3
    1F 00 00 00 00 00 00 00 89   256#   2^-1 * 2^+9
    1F 00 00 00 00 00 00 00 91   65536# 2^-1 * 2^+17

## Exponent Bias and Special Numbers

  The first byte (from the right since we're little endian) is the
  exponent. The exponent is "biased" by 0x80, which simply means that
  negative exponents are represented by bytes from 0x7F to 0x01.

| Byte (hex) | Exponent (decimal) | Note                                                       |
|:----------:|-------------------:|------------------------------------------------------------|
| 00         |          *special* | Zero                                                       |
| 01         |             2^-127 | Smallest representable numbers                             |
| 02         |             2^-126 |                                                            |
| ...        |                    |                                                            |
| 7E         |               2^-2 | [0.125, 0.25)                                              |
| 7F         |               2^-1 | [0.25, 0.5)                                                |
| 80         |           2^0 == 1 | [0.5, 1.0)                                                 |
| 81         |                2^1 | [1.0, 2.0)                                                 |
| 82         |                2^2 | [2.0, 4.0)                                                 |
| ...        |                    |                                                            |
| FF         |              2^127 | Largest representable numbers                              |
|            |                    | From: [85,070,591,730,234,615,865,843,651,857,942,052,864 |
|            |                    | to  170,141,183,460,469,231,731,687,303,715,884,105,728)   |

>  Note: N82 Basic has no notion of infinity or NaN, which means it has
>  an extra bit of "precision" in its mantissa compared to IEEE. (Note
>  that "precision" does _not_ mean "accuracy".)

## Sign bit

  Bit 8, the most significant bit of the second byte is the sign bit.
  Since it is not a two's complement number, it is possible to have a
  value of negative zero.


## N82 BASIC quirk

  EDITing a line in basic converts back and forth between binary and
  decimal which can cause a constant number to change!

    1F 00 00 00 00 00 00 00 FD  ->  2.126764793255866D+37    ->1F 0D 00...
    1F 00 00 00 00 00 00 00 FE  ->  4.253529586511731D+37   -> 1F 03 00...
    1F 00 00 00 00 00 00 7F FE  ->  8.473828473128839D+37   -> 1F 0F 00...

    1F FB FF FF FF FF FF 7F FE  ->  8.507059173023461D+37   (no change)

                                8.5070591730234611D+37  -> 1F 00 00...
    1F 00 00 00 00 00 00 00 FF  8.507059173023462D+37   -> 1F 03 00...
    1F 03 00 00 00 00 00 00 FF  8.507059173023463D+37   -> 1F 07 00...
    1F 07 00 00 00 00 00 00 FF  8.507059173023464D+37   -> 1F 0D 00...
    1F 0D 00 00 00 00 00 00 FF  8.507059173023465D+37   -> 1F 11 00...
    1F 11 00 00 00 00 00 00 FF  8.507059173023466D+37   -> 1F 15 00...
    1F 15 00 00 00 00 00 00 FF  8.507059173023467D+37   -> 1F 19 00...
    1F 19 00 00 00 00 00 00 FF  8.507059173023468D+37   -> 1F 1C 00...
    1F 1C 00 00 00 00 00 00 FF  8.507059173023469D+37   -> 1F 21 00...
    1F 21 00 00 00 00 00 00 FF  8.50705917302347D+37    -> 1F 25 00...
    1F 25 00 00 00 00 00 00 FF  8.507059173023471D+37   -> 1F 2B 00...
    1F 2B 00 00 00 00 00 00 FF  8.507059173023473D+37   -> 1F 33 00...
    1F 33 00 00 00 00 00 00 FF  8.507059173023474D+37   -> 1F 37 00...
       37                                  75
       3B                          .
       42                          .
       48                          .
       4B
       4F
       53
       5B
       62
       6a
       6e
       71
       75
       7a
       7d                                  92       -> 1F 80 00...
    1F 80 00 00 00 00 00 00 FF  8.507059173023492D+37   -> (same)


    1F 00 00 00 00 00 00 7F 7F   .498046875#
    1F 08 00 00 00 00 00 7F 7F   .4980468750000001# -> 1F 13 00...
    1F 13 00 00 00 00 00 7F 7F   .4980468750000001# -> (same)

    1F 00 00 00 00 00 00 7F 80   .99609375#
    1F 08 00 00 00 00 00 7F 80   .9960937500000001# -> 1F 0B 00...
    1F 0B 00 00 00 00 00 7F 80   .9960937500000002# -> 1F 13 00...
    1F 13 00 00 00 00 00 7F 80   .4980468750000003# -> (same)
