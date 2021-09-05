; ====================================================================================================
; Green Bubble Object in Vanilla Ghost House
; ====================================================================================================
ObjGreenBubble:
        moveq   #0,d0
	    move.b	$24(a0),d0
	    move.w  ObjGreenBubble_Index(pc,d0.w),d1
	    jmp ObjGreenBubble_Index(pc,d1.w)
; --------------------------------------------------
; Green Bubble Object Index Routine
; --------------------------------------------------
ObjGreenBubble_Index:
        dc.w    ObjGreenBubble_Init-ObjGreenBubble_Index
        dc.w    ObjGreenBubble_Main-ObjGreenBubble_Index
; --------------------------------------------------
ObjGreenBubble_Init:
        addq.b  #2,$24(a0)
        move.b  #4,1(a0)
	    move.w	#$300,2(a0)
        move.l	#Map_GreenBubble,4(a0)
        move.b  #24,$16(a0)
        move.b  #24,$17(a0)
        move.b	#0,$18(a0)
        move.b	#32,$19(a0)
        rts

ObjGreenBubble_Main:
        lea (Ani_GreenBubble).l,a1
        jsr AnimateSprite
        jmp DisplaySprite


Nem_GreenBubble:
        incbin  "Objects/Hazards/Green Bubble/tiles.nem"
        even

Map_GreenBubble:
        include "Objects/Hazards/Green Bubble/mappings.asm"

Ani_GreenBubble:
        dc.w    GrBubAni0-Ani_GreenBubble
        dc.w    GrBubAni1-Ani_GreenBubble
        dc.w    GrBubAni2-Ani_GreenBubble

GrBubAni0:
        dc.b    1, 0, 1, 0, 1, $FD, 1
GrBubAni1:
        dc.b    1, 2, 3, 2, 3, $FD, 2
GrBubAni2:
        dc.b    1, 4, 5, 4, 5, $FD, 0
        even