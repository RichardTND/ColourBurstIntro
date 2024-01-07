TND COLOUR BURST INTRO

As a little experiment with Retro 64's Turbo Coder 64 project. I thought I should give myself a try at making a little intro. It only took me a couple of hours to make, but here is how I made it.

MUSIC:

Basically the music was from my own HVSC library. I took out Time_Takes_Its_Toll.sid. The music was originally placed at $5000 and then I relocated the tune to $1000 using SIDRELOC. If using SIDReloc for music, the must be saved in PSID format using SIDPlay Win/2. (If using V3, that will not be possible).

SPRITES:

The sprites were created and generated using Spritepad V2.0 and were exported as a program file.

CHARSET:

Ultrafont PC was used to generate a double-height character set out of the default ROM charset. The charset was exported as four rows in binary format.

SCREEN:

I designed the raw screen layout in the style of the RIFF RAFFS crack intro using Charpad V2.7.6 by first importing the raw charset I exported from Ultrafont PC. I changed the asterisk font to use the vertical line character. Then I designed the whole screen layout and exported both the charset and screen in raw binary format.

TEXT:

The scroll text was written using Texty in Turbo Coder 64 and was exported as a .prg file.

PREPARING THE PROJECT:

First of all using the Turbo Code Builder I did as follows:

- Add BASIC line to execute with 'RUN': Yes
- Code location in memory             : $0810 (SYS 2064)
- Set up for screen splits            : Yes (Raster splits)
- Character set filename              : 1x2charset.bin
- Character set location in memory    : $2000
- Screen RAM filename                 : screen.bin
- Screen RAM file's location in memory: $0C00 (As I am copying to $0400)
- Colour RAM filename                 : I left that blank
- Colour RAM location in memory       : I left that blank
- Sprite set filename                 : sprites.prg (I exported sprites as a .prg file)
- Sprite set location in memory       : $2800
- Koala pic filename                  : Not required so I left it blank
- Koala location in memory            : Not required so I left it blank
- Music filename                      : music.prg 
- Music location in memory            : $1000
- Music initialisation location       : $1000
- Music player routine                : $1003

For the splits, I had to modify them slightly as there was a limited number of 3 splits. My intro required 4 splits.
Don't forget, this is only generating the back bone of the project.

Split1:                               lda #$32
                                      sta $d012
                                      lda #$08
                                      sta $d016
                                      lda #0
                                      sta $d020
                                      sta $d021

                                    
Split2:                               lda #$9b
                                      sta $d012
                                      lda #$08
                                      sta $d016
			              lda #1
                                      sta $d020
                                      sta $d021

Split3:                               lda #$fa
                                      sta $d012
                                      lda #$08
                                      sta $d016
                                      lda #2
                                      sta $d020
				      sta $d021
                                    
- CPU Detection                       : No because I am working with PAL
- Clean the screen                    : No because I am doing it manually

Additional setup/routines             ldx #$00
                         setuploop    lda $0c00,x
				      sta $0400,x
                                      lda $0d00,x 
                                      sta $0500,x
                                      lda $0e00,x
                                      sta $0600,x
                                      lda $0ee8,x
                                      sta $06e8,x
                                      lda #$00
                                      sta $d800,x 
                                      sta $d900,x
                                      sta $da00,x
                                      sta $dae8,x
                                      inx 
                                      bne setuploop

                                      lda #$18
                                      sta $d018

- 1x1 scroller:                         : No 
- 1x2 scroller:                         : Yes
- 2x2 scroller:                         : No
- FLI display code                      : No
- Scroll text filename                  : scrolltext.prg
- Scroll text location in memory:       : $3000
- Joystick port 1                       : No
- Joystick port 2                       : No 
- Memory copy routine (relocator)       : Yes
- VIC bank selector                     : No
- Chart showing beginning address of
  each text line                        : Yes

- Sine data - number of points          : Left blank because I used WixBouncer instead
- Sine data - amplitude                 : Left blank
- Cosine data - number of points        : Left blank
- Cosine data - amplitude               : Left blank.

I then clicked on Engage the Turbo Coder and saved the source as intro.asm then fixed the raster routine, and created a few of my other routines. Then compiled everything using TMPx. To get the final result, it took me approximately two hours to finish off my intro. 

Turbo Coder 64 and its online tools can be found at:
https://retro64.ca

The TMPx can be found at:
https://turbo.style64.org/

Finally, for crunching you can use Crunchy or grab the latest version of Exomizer (V3.1.2) at:
https://bitbucket.org/magli143/exomizer/wiki/Home

Please feel free to play around with this source, but of course please don't upload this intro onto CSDB or other sites because I did not make it for those purposes. It was made for an educational purpose of learning to use Turbo Coder 64. You are welcome to modify the source code to make your own intros and stuff like that for showing off :)

Have fun :)

Richard / The New Dimension
                                       