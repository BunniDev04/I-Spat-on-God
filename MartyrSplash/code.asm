; ---------------------------------------------------------------------------
; Martyr Splash Screen
; Graphics and screen setup - BunniDev
; Wave effect - Rivet
; ---------------------------------------------------------------------------

MartyrSplash:
		move.b	#$E4,d0
		bsr.w	PlaySound_Special	; Stop the music
		bsr.w	ClearPLC
		lea	($C00004).l,a6
		move.w	#$8004,(a6)	; 8 color mode
		move.w	#$8230,(a6)	; Foreground nametable address
		move.w	#$8407,(a6)	; Background nametable address
		move.w	#$8700,(a6)	; Set background color to palette entry 0
		move.w	#$8B00|%00000011,(a6)		;Setting HScroll to be every line
		move.w #$8C00|%10000001,(a6)	; Force resolution to 320x224
		clr.b	($FFFFF64E).w
		move	#$2700,sr	; Disable interrupts
		move.w	($FFFFF60C).w,d0
		andi.b	#$BF,d0
		move.w	d0,($C00004).l
		bsr.w	ClearScreen
	
		; Load the splash screen's tiles
		move.l	#$40000000,($C00004).l
		lea	(MartyrTiles).l,a0
		bsr.w	NemDec
		lea	($FF0000).l,a1

		; Load the background's mappings
		lea	(MartyrBGMap).l,a0
		move.w	#0,d0
		bsr.w	EniDec
		lea	($FF0000).l,a1
		move.l	#$60000003,d0	; Write to the background
		moveq	#44-1,d1	; Width
		moveq	#28-1,d2	; Height
		bsr.w	ShowVDPGraphics

		; Load the foreground's mappings
		lea	(MartyrFGMap).l,a0
		move.w	#0,d0
		lea	($FF0000).l,a1
		bsr.w	EniDec
		move.l	#$40000003,d0	; Write to the foreground
		moveq	#40-1,d1	; Width
		moveq	#28-1,d2	; Height
		bsr.w	ShowVDPGraphics

		; Load the palette
		moveq	#0,d0
		bsr.w	PalLoad2

		move.w	($FFFFF60C).w,d0
		ori.b	#$40,d0
		move.w	d0,($C00004).l
		move.w	#60*10,($FFFFF614).w
		move.w	#0, ($FFFFF5C0).w			;Zero out Counter just in case

MartyrLoop:
		move.b	#4,($FFFFF62A).w
		bsr.w	DelayProgram

MartyrBGDeform:
		lea ($FFFFCC00),a1
		moveq   #0, d0
		moveq	#0, d3						;Avoid using d1 (Calcsine modifies it)
		move.w  #224-1, d2					;Line count to decrease (-1 for dbf)
		move.w  ($FFFFF5C0).w, d0			;Get counter
		move.w	d0, d3						;d0 will be changed, save counter

	@loop:
		moveq	#0, d0
		move.w	d3, d0						;For Calcsine
		bsr.w   CalcSine
		lsr.w	#1, d0						;Make the wave smaller
		neg.w	d3							;Flip per-line counter
		bmi		@OddFrame					;Only add 1 to it on an even frame
		addq	#2, d3						;Next line will be at a different pos (Change for wavy-ness)
	@OddFrame:
		move.l	d0, (a1)+					;Upload to HScroll in RAM (B Plane in bottom word)
		dbf 	d2, @loop
		addq	#2,($FFFFF5C0).w			;Incrementing Speed (Change to adjust speed)
		
		tst.w	($FFFFF614).w	; Check if the timer is up
		beq.s	MartyrEnd	; If so, go to the title screen
		andi.b	#$80,($FFFFF605).w	; Check if start was pressed
		beq.s	MartyrLoop	; If not, continue looping until either start or the timer is up

MartyrEnd:
		move.b	#4,($FFFFF600).w	; Go to the title screen
		rts	

; ===========================================================================