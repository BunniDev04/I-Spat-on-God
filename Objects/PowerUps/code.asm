; ====================================================================================================
; Power Up Object
; ====================================================================================================

; $30(a0)   flower and cape's turn timer

ObjPowerUp:
        moveq   #0,d0
	move.b	$24(a0),d0
	move.w  ObjPowerUp_Index(pc,d0.w),d1
	jmp ObjPowerUp_Index(pc,d1.w)
; --------------------------------------------------
; Power Up Object Routine Index
; --------------------------------------------------
ObjPowerUp_Index:
        dc.w    ObjPowerUp_Init-ObjPowerUp_Index
        dc.w    ObjPowerUp_Super-ObjPowerUp_Index   ; Super mushroom
        dc.w    ObjPowerUp_Fire-ObjPowerUp_Index    ; Fire flower
        dc.w    ObjPowerUp_Cape-ObjPowerUp_Index    ; Cape feather
        dc.w    ObjPowerUp_1Up-ObjPowerUp_Index ; 1-Up msuhroom
        dc.w    ObjPowerUp_Star-ObjPowerUp_Index    ; Invincibility star
        dc.w    ObjPowerUp_Collect-ObjPowerUp_Index
; --------------------------------------------------
ObjPowerUp_Init:
        move.b  $28(a0),d0 ; Get the object's subtype
        lsl.b   #1,d0   ; Multiply it by 2
        add.b   #2,d0
        move.b  d0,$24(a0)  ; Determines what object code to run
        move.b  #4,1(a0)
	move.w	#$680,2(a0)
        move.l	#Map_PowerUps,4(a0)
        move.b  #7,$16(a0)
        move.b  #7,$17(a0)
        move.b	#3,$18(a0)
        move.b	#8,$19(a0)
        rts

ObjPowerUp_Super:
        move.b  $28(a0),$1A(a0)
        jsr ObjectFall
        jsr ObjHitFloor
        tst.w   d1
        bpl.s   @MoveObj
        add.w   d1,$C(a0)
        clr.w   $12(a0)

    @MoveObj:
        sub.w   #1,8(a0)
        jmp DisplaySprite

ObjPowerUp_Fire:
        move.b  $28(a0),$1A(a0)
        tst.b   $30(a0) ; Timer code doesn't work, plz fix
        bne.s   @Display
        bchg    #0,1(a0)
        move.b  #15,$30(a0)

    @Display:
        subq.b    #1,$30(a0)
        jsr DisplaySprite
        rts

ObjPowerUp_Cape:
        rts

ObjPowerUp_1Up:
        move.b  $28(a0),$1A(a0)
        jsr ObjectFall
        jsr ObjHitFloor
        tst.w   d1
        bpl.s   @MoveObj
        add.w   d1,$C(a0)
        clr.w   $12(a0)

    @MoveObj:
        sub.w   #1,8(a0)
        jmp DisplaySprite

ObjPowerUp_Star:
ObjPowerUp_Collect:

Nem_PowerUps:
        incbin  "Objects/PowerUps/tiles.nem"
        even

Map_PowerUps:
        include "Objects/PowerUps/mappings.asm"
        even