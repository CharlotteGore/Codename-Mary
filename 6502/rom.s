  .org $8000

  .org $8010
   lda #$ff
   sta $d012
   lda #$00
   lda $d012
   sta $10
   sei
   lda #$31   ; Load the default vector interrupt location
   sta $0314  ;
   lda #$ea   ;
   sta $0315  ;
   ldx $0315  ;
   ldy $0314  ;

   lda #$01
   cli
   ldy $d012
   sta $d01a
   lda $ff00
   sta $02
   ldx #$32
   stx $ff02
   inx
   stx $ff02
   inx 
   stx $ff02
   inx 
   stx $ff02
   inx 
   stx $ff02
   inx 
   stx $ff02
   inx 
   stx $ff02
   inx 
   stx $ff02
   inx 
   stx $ff02
   inx 
   stx $ff02
   inx 
  wait:
   lda $d010
   sta $00
   jmp wait

  .org $ea00 ; 
  jmp ($0314)

  .org $ea31
  rti

  .org $fffc
  .word $8010
  .word $ea00