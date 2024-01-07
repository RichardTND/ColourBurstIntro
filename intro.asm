;TND Colour Burster Intro
;First generated with TURBO CODER 64
;and compiled in TMPx. 
;
;Intro made by RICHARD/TND in 2024
;
;Featuring:
;
;* Colour washing
;* 1x2 Scrolltext 
;* Bouncy sprites
;* Music 
;
;Built for PAL C64s only

;First position of each row
;0400 - Text row 1
;0428 - Text row 2
;0450 - Text row 3
;0478 - Text row 4
;04a0 - Text row 5
;04c8 - Text row 6
;04f0 - Text row 7
;0518 - Text row 8
;0540 - Text row 9
;0568 - Text row 10
;0590 - Text row 11
;05b8 - Text row 12
;05e0 - Text row 13
;0608 - Text row 14
;0630 - Text row 15
;0658 - Text row 16
;0680 - Text row 17
;06a8 - Text row 19
;06d0 - Text row 19
;06f8 - Text row 20
;0720 - Text row 21
;0748 - Text row 22
;0770 - Text row 23
;0798 - Text row 24
;07c0 - Text row 25

		* =$0801 ;BASIC SYS 2064
		.byte $0d,$08,$e8,$07
		.byte $9e,$28,$32,$30
		.byte $36,$34,$29,$00
		
*         = $0810 ;start of main code
video     = $d000
imusic    = $1000
music    = $1003

;Setup
          jsr setup

;Initialise and start IRQ interrupts
          
		 sei

         lda #$7f 
         sta $dc0d
         lda $dc0d

		 lda #$32
	     sta $d012
         lda $d01a
         ora #$01
         sta $d01a

         lda $d011
         and #$7f
         sta $d011

          inc $d019

          lda #<irq1
         sta $0314
         lda #>irq1
         sta $0315
         lda #<nmi
         sta $0318
         lda #>nmi
         sta $0319
         cli

;Synchronise timer and call main loop 

s0       lda #0
		 sta rp 
		 cmp rp 
		 beq *-3 
		 jsr mainloop
		 
;Wait for spacebar to be pressed
		
		 lda $dc01
         cmp #$ef
         bne s0
         jmp 64738

nmi      rti

;Call subroutines to expand sprite
;position, do colour flash/burster,
;scroll double-height (1x2) 
;scroll text and bounce those sprites

mainloop 
		 jsr expandsprs		
		 jsr flashrtn 
		 jsr scroll1x2
		 jsr movespr
		 rts 

;Expand sprite MSB		 
		
expandsprs
	ldx #$00
exploop
	lda objpos1+1,x  
	sta $d001,x
	lda objpos1,x
	asl
	ror $d010
	sta $d000,x
	inx
	inx
	cpx #16
	bne exploop
	rts
		 
;IRQ RASTER INTERRUPTS 
		 
;Still area before raster position 
;black (Interrupt 1)

irq1     inc $d019
         lda #<irq2
         sta $0314
         lda #>irq2
         sta $0315
         lda #$32
         sta $d012
         lda #$08
         sta $d016
	 
         lda #$00
         sta $d020
         sta $d021
  	 lda #1
	 sta rp
         jsr $1003
         jmp $ea7e

;Still area top - black (Interrupt 2)

irq2     inc $d019
         lda #<irq3
         sta $0314
         lda #>irq3
         sta $0315
         lda #$88
         sta $d012
         lda #$08
         sta $d016
	 nop
	 nop
	 nop
	 nop
         lda #0
         sta $d020
         sta $d021     
         jmp $ea7e

;Scroll area - middle - flashing bar
;(Interrupt 3)

irq3     inc $d019
         lda #<irq4
         sta $0314
         lda #>irq4
         sta $0315
         lda #$99
         sta $d012
         lda xpos1x2
         sta $d016
	 ldy #$0a
	 dey
	 bne *-1
bar      lda #2
         sta $d020
         sta $d021
	
	   
         jmp $ea7e

;Still area bottom underneath 
;flashing bar (Interrupt 4)

irq4	 inc $d019
	 lda #<irq1
	 sta $0314
	 lda #>irq1
	 sta $0315
	 lda #$fa
	 sta $d012
	 ldx #$0b
	 dex
	 bne *-1
	 lda #0
	 sta $d020
         sta $d021
	 lda #$08
	 sta $d016
   	
	 jmp $ea7e

;Setup screen before interrupts are 
;activated.

setup     
		  ldx #$00
setuploop 	  lda #$20 
		  lda $0c00,x 
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

		  ldx #$00
whitescroll	  lda #1
		  
		  sta $d9b8,x
		  sta $d9e0,x
	      inx
          cpx #40
          bne whitescroll

          lda #$18
          sta $d018
          lda #$08
          sta $d016

		ldx #$00
drawsprs	lda spritelogo,x
		sta $07f8,x
		lda #$03
		sta $d027,x
		inx
		cpx #8
		bne drawsprs

	 lda #$ff
	 sta $d015
	 sta $d01c
	 sta $d01d
	 lda #$0e
	 sta $d025
	 lda #$01
	 sta $d026
          
         ldx #$00
         lda #$00
         ldy #$00
         jsr $1000
         rts

;Memory transfer routine (not active)

memxfer        lda #$00
         sta $fc
         sta $fe
         lda #$80 ;copies from $8000
         sta $ff
         lda #$20 ;copies to $2000
         sta $fd
loop       ldy #$00
mov256   lda ($fe),y
         sta ($fc),y
         iny
         bne mov256
         inc $fd
         inc $ff
         lda $ff
         cmp #$84 ;ending address goes here.. right now it stops at $8400, copying $8000-$83FF down to $2000-$23FF
         bne loop
         rts

;Double height (1x2) scrolling text 
;subroutine.

scrolltext = $3000 ;wherever you load your text into memory..
screen1x2 = $05b8
scroll1x2 lda xpos1x2
         sec
         sbc speed1x2
         sta xpos1x2
         bpl exitsc1
         and #$07
         sta xpos1x2
         ldx #$00
move1x2 lda screen1x2+1,x
         sta screen1x2,x
         lda screen1x2+41,x
         sta screen1x2+40,x
         inx
         cpx #$27
         bne move1x2
         jsr getchar1x2
          lda scrolltext
tp1x2 = *-2
         beq restart1
         inc tp1x2
         bne st1x2
         inc tp1x2+1
         bne st1x2
restart1 lda #<scrolltext
         ldx #>scrolltext
         sta tp1x2
         stx tp1x2+1
         lda #$20
st1x2 sta screen1x2+39
         clc
         adc #$40
         sta screen1x2+79
exitsc1 rts

getchar1x2 lda screen1x2+39
         cmp #"<"
         beq speed1x2up
         cmp #">"
         beq slowdown1x2
         rts

speed1x2up inc speed1x2
         rts

slowdown1x2 dec speed1x2
         rts

;Flashing subroutine

flashrtn 
		jsr flashr2
		jsr flashr1
		
		rts 

;Colour burster control
		
flashr1
		ldx flashpointer1 
		lda coltbl1,x 
		sta $d800+20
		sta $d800+(1*40)+20
		sta $d800+(2*40)+20
		sta $d800+(3*40)+20
		sta $d800+(4*40)+20
		sta $d800+(5*40)+20
		sta $d800+(24*40)+20
		sta $d800+(23*40)+20
		sta $d800+(22*40)+20
		sta $d800+(21*40)+20
		sta $d800+(20*40)+20
		sta $d800+(19*40)+20
		inx 
		cpx #coltbl1end-coltbl1
		beq resetflash
		inc flashpointer1 
		jmp shiftcols

resetflash 
		ldx #0
		stx flashpointer1 
shiftcols
		jsr washback
		jsr washfrwd
		rts 
;Colour burst backwards		
washback
		ldx #$00
loop001 	lda $d800+1,x 
		sta $d800,x 
		lda $d800+(1*40)+1,x 
		sta $d800+(1*40),x 
		lda $d800+(2*40)+1,x 
		sta $d800+(2*40),x 
		lda $d800+(3*40)+1,x 
		sta $d800+(3*40),x 
		lda $d800+(4*40)+1,x 
		sta $d800+(4*40),x 
		lda $d800+(5*40)+1,x 
		sta $d800+(5*40),x
		inx 
		cpx #20
		bne loop001
		ldx #$00
loop001b  
		lda $d800+(19*40)+1,x 
		sta $d800+(19*40),x 
		lda $d800+(20*40)+1,x 
		sta $d800+(20*40),x 
		lda $d800+(21*40)+1,x 
		sta $d800+(21*40),x 
		lda $d800+(22*40)+1,x 
		sta $d800+(22*40),x 
		lda $d800+(23*40)+1,x 
		sta $d800+(23*40),x 
		lda $d800+(24*40)+1,x 
		sta $d800+(24*40),x 
		inx 
		cpx #20
		bne loop001b 
		rts 
		
;Colour burst forwards
		
washfrwd		

		ldx #19
loop002 	lda $d800+20,x 
		sta $d800+21,x 
		lda $d800+(1*40)+20,x 
		sta $d800+(1*40)+21,x 
		lda $d800+(2*40)+20,x 
		sta $d800+(2*40)+21,x 
		lda $d800+(3*40)+20,x 
		sta $d800+(3*40)+21,x 
		lda $d800+(4*40)+20,x 
		sta $d800+(4*40)+21,x 
		lda $d800+(5*40)+20,x 
		sta $d800+(5*40)+21,x 
		dex 
		bpl loop002
		ldx #19
loop002b	lda $d800+(19*40)+20,x 
		sta $d800+(19*40)+21,x 
		lda $d800+(20*40)+20,x 
		sta $d800+(20*40)+21,x 
		lda $d800+(21*40)+20,x 
		sta $d800+(21*40)+21,x 
		lda $d800+(22*40)+20,x 
		sta $d800+(22*40)+21,x 
		lda $d800+(23*40)+20,x 
		sta $d800+(23*40)+21,x 				
		lda $d800+(24*40)+20,x 
		sta $d800+(24*40)+21,x 
		dex 
		bpl loop002b
		rts

;Colour flashing control 
		
flashr2 	lda flashdelay 
		cmp #2
		beq flashok2
		inc flashdelay 
		rts 
		
flashok2 
		lda #0
		sta flashdelay
		
		ldx flashpointer2 
getflash
		;Colour bar colour data
		lda coltbl2,x 
		sta bar+1
		;Silver chars colour data
		lda coltbl3,x 
		sta flashstore 
		inx 
		cpx #coltbl2end-coltbl2
		beq flok
		inc flashpointer2 
		jmp flashtext
flok 		ldx #0
		stx flashpointer2 
flashtext		
		ldx #$00
loop003
		lda flashstore 
		sta $d800+(7*40),x 
		sta $d800+(16*40),x 
		inx 
		cpx #$50
		bne loop003 
		rts 
;Bounce the TND 2024 sprites 

movespr lda sinusy1
		pha
		lda sinusy2
		pha
		ldx #0
bounce  lda sinusy1+1,x
        sta sinusy1,x
        lda sinusy2+1,x
        sta sinusy2,x
        inx
        bne bounce
		pla
		sta sinusy2+254
		pla
		sta sinusy1+254
		lda sinusy1
		sta objpos1+1
		lda sinusy1+(1*16)
		sta objpos1+3
		lda sinusy1+(2*16)
		sta objpos1+5
		lda sinusy1+(3*16)
		sta objpos1+7
		lda sinusy2+(4*16)
		sta objpos1+9
		lda sinusy2+(5*16)
		sta objpos1+11
		lda sinusy2+(6*16)
		sta objpos1+13
		lda sinusy2+(7*16)
		sta objpos1+15
		rts
		
;Some pointers		               

rp .byte 0 ;Raster sync pointer
speed1x2 .byte $02 ; Scroll speed
xpos1x2 .byte $00  ; $D016 control
flashdelay .byte $00 ;Flashing delay
flashpointer1 .byte $00 ;Burst pointer
flashpointer2 .byte $00 ;Flash pointer
flashstore .byte 0 ;Flash store pointer

;Sprite position table setup

objpos1	.byte $38,$31,$50,$4f
        .byte $68,$50,$80,$50
		.byte $30,$c9,$48,$e7
		.byte $60,$d0,$78,$d0

;Sprite frame table setup
spritelogo	.byte $a0,$a1,$a2,$a3
            .byte $a4,$a5,$a6,$a7

;Import music into project
*=$1000
         .binary "music.prg",2
;Import 1x2 charset into project
*=$2000
         .binary "1x2font.bin" 
;Import sprites into project
*=$2800
    	 .binary "sprites.prg",2
;Import scrolltext into project
*=$3000
         .binary "scrolltext.prg",2
		 .byte $00
;Top sprite sinus table
*=$3800

sinusy1
  .byte 63,65,67,69,71,73
      .byte 74,76,77,78,78,79
      .byte 79,79,79,78,78,77
      .byte 76,75,73,72,70,68
      .byte 66,63,61,59,56,54
      .byte 51,49,52,54,57,59
      .byte 62,64,66,68,70,72
      .byte 73,75,76,77,78,78
      .byte 79,79,79,79,78,77
      .byte 76,75,74,72,71,69
      .byte 67,65,63,60,58,55
      .byte 53,50,50,53,55,58
      .byte 60,63,65,67,69,71
      .byte 73,74,75,77,77,78
      .byte 79,79,79,79,78,78
      .byte 77,76,75,73,72,70
      .byte 68,66,64,62,59,57
      .byte 54,52,49,51,54,57
      .byte 59,61,64,66,68,70
      .byte 72,73,75,76,77,78
      .byte 78,79,79,79,79,78
      .byte 78,77,75,74,73,71
      .byte 69,67,65,63,61,58
      .byte 56,53,50,50,53,55
      .byte 58,60,62,65,67,69
      .byte 71,72,74,75,76,77
      .byte 78,79,79,79,79,79
      .byte 78,77,76,75,74,72
      .byte 70,68,66,64,62,59
      .byte 57,55,52,49,51,54
      .byte 56,59,61,63,66,68
      .byte 70,71,73,74,76,77
      .byte 78,78,79,79,79,79
      .byte 78,78,77,76,74,73
      .byte 71,69,67,65,63,61
      .byte 58,56,53,51,50,52
      .byte 55,57,60,62,64,66
      .byte 69,70,72,74,75,76
      .byte 77,78,79,79,79,79
      .byte 79,78,77,76,75,74
      .byte 72,70,69,67,64,62
      .byte 60,57,55,52,50,51
      .byte 53,56,58,61
	  
;Bottom sprite sinus table

	*=$3a00
 
sinusy2  .byte 217,215,213,211,209,207
      .byte 206,204,203,202,202,201
      .byte 201,201,201,202,202,203
      .byte 204,205,207,208,210,212
      .byte 214,217,219,221,224,226
      .byte 229,231,228,226,223,221
      .byte 218,216,214,212,210,208
      .byte 207,205,204,203,202,202
      .byte 201,201,201,201,202,203
      .byte 204,205,206,208,209,211
      .byte 213,215,217,220,222,225
      .byte 227,230,230,227,225,222
      .byte 220,217,215,213,211,209
      .byte 207,206,205,203,203,202
      .byte 201,201,201,201,202,202
      .byte 203,204,205,207,208,210
      .byte 212,214,216,218,221,223
      .byte 226,228,231,229,226,223
      .byte 221,219,216,214,212,210
      .byte 208,207,205,204,203,202
      .byte 202,201,201,201,201,202
      .byte 202,203,205,206,207,209
      .byte 211,213,215,217,219,222
      .byte 224,227,230,230,227,225
      .byte 222,220,218,215,213,211
      .byte 209,208,206,205,204,203
      .byte 202,201,201,201,201,201
      .byte 202,203,204,205,206,208
      .byte 210,212,214,216,218,221
      .byte 223,225,228,231,229,226
      .byte 224,221,219,217,214,212
      .byte 210,209,207,206,204,203
      .byte 202,202,201,201,201,201
      .byte 202,202,203,204,206,207
      .byte 209,211,213,215,217,219
      .byte 222,224,227,229,230,228
      .byte 225,223,220,218,216,214
      .byte 211,210,208,206,205,204
      .byte 203,202,201,201,201,201
      .byte 201,202,203,204,205,206
      .byte 208,210,211,213,216,218
      .byte 220,223,225,228,230,229
      .byte 227,224,222,219

;Colour table (Char rolling)
* = $2400

coltbl1
		.byte $00,$00,$00,$00,$00,$00,$00,$00
		.byte $00,$00,$00,$00,$00,$00,$00,$00
		.byte $00,$00,$00,$00,$00,$00,$00,$00
		.byte $09,$02,$08,$05,$0f,$03,$07,$0d 
		.byte $01,$0d,$07,$0f,$05,$08,$02,$09
		.byte $00,$00,$00,$00,$00,$00,$00,$00
		.byte $06,$04,$0c,$0a,$0f,$07,$01,$07
		.byte $0f,$0a,$0c,$04,$06,$00,$00,$00
		.byte $00,$00,$00,$00,$00,$00,$00,$00
		.byte $00,$00,$00,$00,$00,$00,$00,$00
		.byte $00,$00,$00
coltbl1end

;Colour table (flashing bar) 

coltbl2
		.byte $00,$09,$08,$05,$07,$01
		.byte $05,$08,$09,$09,$00,$00
		.byte $00,$00,$00,$00,$00,$00
		.byte $00,$00,$00,$00,$00,$00
		.byte $00,$00,$00,$00,$00,$00
coltbl2end
		
;Colour table (flashing text) 
coltbl3 	.byte $01,$0f,$0c,$0b,$00,$00
        	.byte $0b,$0c,$0f,$01,$01,$01
		.byte $01,$01,$01,$01,$01,$01
		.byte $01,$01,$01,$01,$01,$01
		.byte $01,$01,$01,$01,$01,$01
coltbl3end		

;Import screen matrix data (charpad)
*=$0c00
         .binary "screen.bin" 