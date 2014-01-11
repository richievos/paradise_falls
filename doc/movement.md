# X / Y moves
## Empirical values

These were grabbed from capturing the signals sent when doing FL/FR/NL/NR/Center moves under Maintenance.

### Captures

FR

    2014-01-05T18:20:12.868-06:00: 4a 00 00 00 48 42 00 00 20 c1
    2014-01-05T18:20:12.871-06:00: 4a 01 00 00 48 42 00 00 02 43

FL

    2014-01-05T18:22:40.536-06:00: 4a 00 00 00 48 42 00 00 20 c1
    2014-01-05T18:22:40.539-06:00: 4a 01 00 00 48 42 00 00 20 41

Center

    2014-01-05T18:13:43.114-06:00: 4a 00 00 00 48 42 00 00 8c c2
    2014-01-05T18:13:43.120-06:00: 4a 01 00 00 48 42 00 00 8c 42

NL

    2014-01-05T18:20:40.331-06:00: 4a 00 00 00 48 42 00 00 02 c3
    2014-01-05T18:20:40.335-06:00: 4a 01 00 00 48 42 00 00 20 41

NR

    2014-01-05T18:21:13.016-06:00: 4a 00 00 00 48 42 00 00 02 c3
    2014-01-05T18:21:13.018-06:00: 4a 01 00 00 48 42 00 00 02 43

### Locations

**Left**:

    4a 01 00 00 48 42 00 00 20 41

**Right**:

    4a 01 00 00 48 42 00 00 02 43

**Far**:

    4a 00 00 00 48 42 00 00 20 c1

**Near**:

    4a 00 00 00 48 42 00 00 02 c3

**Center**:

    4a 01 00 00 48 42 00 00 8c 42
    4a 00 00 00 48 42 00 00 8c c2

## Toying with values

Printhead:

    4a 01 00 00 48 42 00 00 xx xx

Left - 00 00

    20 41
    0010 0000 0100 0001

    opposite
    82 04
    1000 0010 0000 0100

    flip pairs
    02 14
    0000 0010 0001 0100

Center

    8c 42
    1000 1100 0100 0010

    opposite
    42 31
    0100 0010 0011 0001

    flip pairs
    c8 24
    1100 1000 0010 0100
  
Right - ff ff

    02 43
    0000 0010 0100 0011

    opposite
    c2 40
    1100 0010 0100 0000

    flip pairs
    20 34
    0010 0000 0011 0100

And when manually modifying values it appears

    3f 41 is next to 40 41
    0011 1111 0100 0001
    0100 0000 0100 0001

    ff 41 is next to 00 42

    f    f    4    1
    1111 1111 0100 0001
    0000 0000 0100 0010

    ff 42 is next to 00 43
    1111 1111 1000 0010
    0000 0000 0000 0011

# X/Y Summary

The numeric format seems to be very weird. If we have a byte sequence of:

    ab cd

That actually is:

    dc ab

So, that means each 2 byte pair has the 2 bytes inverted. It also has them backwards.

# Z moves

## Empirical values

These were grabbed from capturing the signals sent when doing FL/FR/NL/NR/Center moves under Maintenance.

### Captures

    0
    2014-01-05T22:54:25.257-06:00: 4a 02 00 00 20 41 00 00 00 80 => 06

    0.01
    2014-01-05T17:59:25.980-06:00: 4a 02 00 00 20 41 0a d7 23 bc => 06
    2014-01-05T17:59:26.960-06:00: 70 32 => fb ff ff ff 06

    0.02
    2014-01-05T17:59:40.062-06:00: 4a 02 00 00 20 41 0a d7 a3 bc => 06
    2014-01-05T17:59:40.961-06:00: 70 32 => f5 ff ff ff 06

    0.03
    2014-01-05T18:05:50.869-06:00: 4a 02 00 00 20 41 8f c2 f5 bc => 06
    2014-01-05T18:05:51.095-06:00: 70 32 => ee ff ff ff 06

    0.04
    2014-01-05T22:55:01.301-06:00: 4a 02 00 00 20 41 0a d7 23 bd => 06
    2014-01-05T22:55:01.459-06:00: 70 32 => e8 ff ff ff 06

    0.11
    2014-01-05T23:00:37.853-06:00: 4a 02 00 00 20 41 ae 47 e1 bd => 06

    0.12
    2014-01-05T23:00:49.686-06:00: 4a 02 00 00 20 41 8f c2 f5 bd => 06

    1
    2014-01-05T18:06:38.666-06:00: 4a 02 00 00 20 41 00 00 80 bf => 06
    2014-01-05T18:06:39.097-06:00: 70 32 => 7c fd ff ff 06

    2
    2014-01-05T18:08:19.659-06:00: 4a 02 00 00 20 41 00 00 00 c0 => 06
    2014-01-05T18:08:20.158-06:00: 70 32 => f8 fa ff ff 06

    100
    2014-01-05T23:02:09.217-06:00: 4a 02 00 00 20 41 00 00 c8 c2 => 06

    101.11
    2014-01-05T23:02:25.011-06:00: 4a 02 00 00 20 41 52 38 ca c2 => 06

    111.11
    2014-01-05T23:02:46.715-06:00: 4a 02 00 00 20 41 52 38 de c2 => 06

    111.22
    2014-01-05T23:03:10.909-06:00: 4a 02 00 00 20 41 a4 70 de c2 => 06

    122.22
    2014-01-05T23:04:34.093-06:00: 4a 02 00 00 20 41 a4 70 f4 c2 => 06

    122.44
    2014-01-05T23:04:59.299-06:00: 4a 02 00 00 20 41 48 e1 f4 c2 => 06

Height values

    0.00:   00 00 00 80
    0.01:   0a d7 23 bc
    0.02:   0a d7 a3 bc
    0.03:   8f c2 f5 bc
    0.04:   0a d7 23 bd
    0.11:   ae 47 e1 bd
    0.12:   8f c2 f5 bd
    1.00:   00 00 80 bf
    2.00:   00 00 00 c0
    100.00: 00 00 c8 c2
    101.11: 52 38 ca c2
    111.22: a4 70 de c2
    122.22: a4 70 f4 c2
    122.44: 48 e1 f4 c2

    0.01 -> 100
    1.00 -> 10,000

    0.00
        00 00 00 80
        0    0    0    0    0    0    8    0
        0000 0000 0000 0000 0000 0000 1000 0000

    0.01
        0a d7 23 bc
        0    a    d    7    2    3    b    c
        0000 1010 1101 0111 0010 0011 1011 1100

    0.02
        0a d7 a3 bc
        0    a    d    7    a    3    b    c
        0000 1010 1101 0111 1010 0011 1011 1100

    0.03
        8f c2 f5 bc
        8    f    c    2    f    5    b    c
        1000 1111 1100 0010 1111 0101 1011 1100

    0.04
        0a d7 23 bd
        0    a    d    7    2    3    b    d
        0000 1010 1101 0111 0010 0011 1011 1101

    0.11
        ae 47 e1 bd
        a    e    4    7    e    1    b    d
        1010 1110 0100 0111 1110 0001 1011 1101

    0.12
        8f c2 f5 bd
        8    f    c    2    f    5    b    d
        1000 1111 1100 0010 1111 1001 1011 1101

    1.00
        00 00 80 bf
        0    0    0    0    8    0    b    f
        0000 0000 0000 0000 0010 0000 1011 1111

    2.00
        00 00 00 c0
        0    0    0    0    0    0    c    0
        0000 0000 0000 0000 0000 0000 1100 0000

    100
        00 00 c8 c2
        0    0    0    0    c    8    c    2
        0000 0000 0000 0000 1100 1000 1100 0010

    101.11
        52 38 ca c2
        5    2    3    8    c    a    c    2
        0101 0010 0011 1000 1100 1010 1100 0010 

    111.11
        52 38 de c2
        5    2    3    8    d    e    c    2
        0101 0010 0011 1000 1101 1110 1100 0010 

    111.22:
        a4 70 de c2
        a    4    7    0    d    e    c    2

    122.22:
        a4 70 f4 c2
        a    4    7    0    f    4    c    2

    122.44:
        48 e1 f4 c2
        4    8    e    1    f    4    c    2


    f -> small jump
    h -> decent jump
    g -> giant jump


    00 00 c8 c2 much higher than       00 00 c8 c1
    00 00 c8 c2 noticeably higher than 00 00 c7 c2

    00 00 c7 b2 is basically the bottom
    00 00 00 a0 goes past the top

OK, time to try some assumptions. I'd like to assume it's using a floating point representation.
This is 32 bits, so based on http://en.wikipedia.org/wiki/Floating_point#IEEE_754:_floating_point_in_modern_computers,
we're dealing with a float. floats are signed.

Also, it's interesting the UI sometimes shows Cur: -0 when everything is disconnected. From these
2 facts, I'm going to assume it's signed.

Let's look at 0

    00 00 00 80
    0    0    0    0    0    0    8    0
    0000 0000 0000 0000 0000 0000 1000 0000

Maybe they're sending -0. All the examples I have always have a 1 in that position.

Let's use number positions as identified by:

    ab cd ef gh

I'm going see if things move if I send all 0s... it didn't move.

Interestingly, the value for 2.0 is close to wikipedia's -2 on http://en.wikipedia.org/wiki/Double_precision.

    Up   (+2):   00 00 00 c0
    Wiki (-2):   c000 0000 0000 0000

So now let's play with some floats. We'll use http://www.binaryconvert.com/convert_float.html to do the conversion.

    0.01
                0    a    d    7    2    3    b    c
        Up:     0000 1010 1101 0111 0010 0011 1011 1100
                3    c    2    3    d    7    0    a
        Float:  0011 1100 0010 0011 1101 0111 0000 1010
    0.02
                0    a    d    7    a    3    b    c
        Up:     0000 1010 1101 0111 1010 0011 1011 1100
                3    c    a    3    d    7    0    a
        Float:  0011 1100 1010 0011 1101 0111 0000 1010

So this doesn't directly hold up. Even out of order, the elements are wrong. But maybe it's a precision thing.

Back to the negative sign in. Whenever I flip things so there's a 0 instead of a 1 in the sign position, I can't
get things to go up. So that makes me think I'm correct about that being a sign position.

But the signs are inverted. What about -0.02

    0.02
                0    a    d    7    a    3    b    c
        Up:     0000 1010 1101 0111 1010 0011 1011 1100
                b    c    2    3    d    7    0    a
        Float:  1011 1100 0010 0011 1101 0111 0000 1010

Number wise, everything on this one but the 2 match up, in the Up there's another a.

So let's move away from these decimals, to 1.0, 2.0

    1.00
        00 00 80 bf
        Up:
                0    0    0    0    8    0    b    f
                0000 0000 0000 0000 0010 0000 1011 1111
        Float+:
                3    f    8    0    0    0    0    0
                0011 1111 1000 0000 0000 0000 0000 0000
        Float-:
                b    f    8    0    0    0    0    0
                1011 1111 1000 0000 0000 0000 0000 0000

That's again pretty promising. It looks like this one is:

    ab cd ef gh =>
    xx xx cx ab

And looking at 0.02:

    ab cd ef gh =>
    gx ef xd ab

Which together seems like it could be:

    gh ef cd ab

Which kind of looks like the above inversions we found for X/Y.

    ab cd =>
    dc ab

So it seems like things are consistent here.

Let's try and put the platform at 52.34 via our expectation, and then see what the Up app says it is.

    -52.34
    ab cd ef gh
    c2 51 5c 29

    gh ef cd ab
    29 5c 51 c2

The Up says we're at 52.00! Not perfect, but pretty close. Let's try some more.

    -52.00:  c2 50 00 00 => 00 00 50 c2    # Up says: 52
    -25.50:  c1 cc 00 00 => 00 00 cc c1    # Up says: 25
    -99.90:  c2 c7 cc cd => cd cc c7 c2    # Up says: 99

Pretty cool. We're close. Now to switch back to capture mode, to try and figure out why the decimal places are wrong (tomorrow).

## Summary

The numeric format seems to be very weird. If we have a byte sequence of:

    ab cd

That actually is:

    dc ab

So, that means each 2 byte pair has the 2 bytes inverted. It also has them backwards.

### Platform X/Y

    4a 0{0,1} 00 00 48 42 00 00 xx xx

    Far:    20 c1
    Center: 8c c2
    Near:   02 c3

Guessing those are adjusted based on calibration

### Platform Z

    4a 02 00 00 20 41 xx xx xx xx

    Bottom: 

### Printhead

    4a 01 00 00 48 42 00 00 xx xx

    Left:   20 41
    Center: 8c 42
    Right:  02 43

Guessing those are adjusted based on calibration
