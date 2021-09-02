; (RNGInput).w Word sized
; (RNGOutput).w Word sized

GetRandomNum:
        moveq   #1,d0               ; LDY #$01
        bsr.s   TickRNG             ; JSL TickRNG
        subq    #1,d0               ; DEY
        bsr.s   TickRNG             ; JSL TickRNG
        rts                         ; RTL

TickRNG:
        move.b  (RNGInput).w,d1     ; LDA RNGInput
        asl.b   #2,d1               ; ASL A
        add.b   (RNGInput).w,d1     ; ADC RNGInput
        move.b  d1,(RNGInput).w     ; STA RNGInput
        asl.b   #1,(RNGInput+1).w   ; ASL RNGInput+1
        move.b  #$20,d1             ; LDA #$20
        btst    (RNGInput+1).w      ; BIT RNGInput+1
        bcc.s   @RNGBranch0         ; BCC @RNGBranch0
        beq.s   @RNGBranch2         ; BEQ @RNGBranch2
        bne.s   @RNGBranch1         ; BNE @RNGBranch1
    @RNGBranch0:
        bne.s   @RNGBranch2         ; BNE @RNGBranch2
    @RNGBranch1:
        addi.b  #1,(RNGInput+1).w   ; INC RNGInput+1
    @RNGBranch2:
        move.b  (RNGInput+1).w,d1   ; LDA RNGInput+1
        eor.b   (RNGInput).w,d1     ; EOR RNGInput
        move.b  d1,(RNGOutput).w    ; STA RNGOutput+1,Y
        rts                         ; RTL