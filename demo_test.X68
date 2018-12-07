

		ORG	$4000

NOP
    RTS
    NOP
    RTS
    LEA     (A0),A0
    LEA     (A5),A0
    LEA     (A7),A0
    LEA     (A0),A7
    LEA     (A5),A7
    LEA     (A7),A7
	BRA       test_BRA
test_BRA:
	CMPI.B    #2,D1
	CMPI.W    #5,(A2)
	CMPI.W    #7,(A2)+
	CMPI.W    #8,$1234
    BCLR.L	  D0, D3
	BCLR.B    D1, (A2)
	BCLR.B    D1, -(A2)
	BCLR.B    D1, $12341234
	BCLR.L	  #1, D3
	BCLR.B    #4, (A2)
	BCLR.B    #8, -(A2)
	BCLR.B    #32, $1234
	EOR.B     D0, D1
	EOR.W     D0, (A2)
	EOR.B     D1, (A1)+
	EOR.B     D1, -(A2)
	EOR.W	  D1, $1234
	EOR.L     D1, $12341234
    MOVE.B    D0,D1
    MOVE.B    D0,(A0)
    MOVE.B    D0,(A0)+
    MOVE.B    D0,-(A0)
    MOVE.B    (A0),D0
    MOVE.B    (A0),(A1)
    MOVE.B    (A0),(A1)+
    MOVE.B    (A0),-(A1)
    MOVE.B    (A0)+,D0
    MOVE.B    (A0)+,(A1)
    MOVE.B    (A0)+,(A1)+
    MOVE.B    (A0)+,-(A1)
    MOVE.B    -(A0),D0
    MOVE.B    -(A0),(A1)
    MOVE.B    -(A0),(A1)+
    MOVE.B    -(A0),-(A1)
    MOVE.W    D0,D1
    MOVE.W    D0,(A0)
    MOVE.W    D0,(A0)+
    MOVE.W    D0,-(A0)
    MOVE.W    A0,D0
    MOVE.W    A0,(A1)
    MOVE.W    A0,(A1)+
    MOVE.W    A0,-(A1)
    MOVE.W    (A0),D0
    MOVE.W    (A0),(A1)
    MOVE.W    (A0),(A1)+
    MOVE.W    (A0),-(A1)
    MOVE.W    (A0)+,D0
    MOVE.W    (A0)+,(A1)
    MOVE.W    (A0)+,(A1)+
    MOVE.W    (A0)+,-(A1)
    MOVE.W    -(A0),D0
    MOVE.W    -(A0),(A1)
    MOVE.W    -(A0),(A1)+
    MOVE.W    -(A0),-(A1)
    MOVE.L    D0,D1
    MOVE.L    D0,(A0)
    MOVE.L    D0,(A0)+
    MOVE.L    D0,-(A0)
    MOVE.L    A0,D0
    MOVE.L    A0,(A1)
    MOVE.L    A0,(A1)+
    MOVE.L    A0,-(A1)
    MOVE.L    (A0),D0
    MOVE.L    (A0),(A1)
    MOVE.L    (A0),(A1)+
    MOVE.L    (A0),-(A1)
    MOVE.L    (A0)+,D0
    MOVE.L    (A0)+,(A1)
    MOVE.L    (A0)+,(A1)+
    MOVE.L    (A0)+,-(A1)
    MOVE.L    -(A0),D0
    MOVE.L    -(A0),(A1)
    MOVE.L    -(A0),(A1)+
    MOVE.L    -(A0),-(A1)
    MOVEM.W   A1-A7,-(A1)
    MOVEM.L   D1-D7,-(A1)
    MOVEM.W   A1/D7,-(A1)
    MOVEM.L   A1/D7,-(A1)
    MOVEM.W   A1-A7,(A1)
    MOVEM.L   D1-D7,(A1)
    MOVEM.W   A1/D7,(A1)
    MOVEM.L   A1/D7,(A1)
    MOVEM.W   (A1)+,A1-A7
    MOVEM.L   (A1)+,D1-D7
    MOVEM.W   (A1)+,A1/D7
    MOVEM.L   (A1)+,A1/D7
    MOVEM.W   (A1),A1-A7
    MOVEM.L   (A1),D1-D7
    MOVEM.W   (A1),A1/D7
    MOVEM.L   (A1),A1/D7
    MOVEA.W    D0,A0
    MOVEA.W    A0,A0
    MOVEA.W    (A0),A0
    MOVEA.W    (A0)+,A0
    MOVEA.W    -(A0),A0
    MOVEA.L    D0,A0
    MOVEA.L    A0,A0
    MOVEA.L    (A0),A0
    MOVEA.L    (A0)+,A0
    MOVEA.L    -(A0),A0
    ADD.B     D1,D2
    ADD.B     D1,(A1)
    ADD.B     D1,(A1)+
    ADD.B     D1,-(A1)
    ADD.B     (A1),D1
    ADD.B     (A1)+,D1
    ADD.B     -(A1),D1
    ADD.W     D1,D2
    ADD.W     D1,(A1)
    ADD.W     D1,(A1)+
    ADD.W     D1,-(A1)
    ADD.W     (A1),D1
    ADD.W     (A1)+,D1
    ADD.W     -(A1),D1
    ADD.L     D1,D2
    ADD.L     D1,(A1)
    ADD.L     D1,(A1)+
    ADD.L     D1,-(A1)
    ADD.L     (A1),D1
    ADD.L     (A1)+,D1
    ADD.L     -(A1),D1
    ADDA.W        D1,A2
    ADDA.W        (A1),A2
    ADDA.W        (A1)+,A2
    ADDA.W        -(A1),A2
    ADDA.L        D1,A2
    ADDA.L        (A1),A2
    ADDA.L        (A1)+,A2
    ADDA.L        -(A1),A2
	SUBQ.B 	  #1, D1
	SUBQ.B 	  #2, (A1)
	SUBQ.B 	  #3, (A1)+
	SUBQ.B 	  #4, -(A1)
	SUBQ.W 	  #1, D1
	SUBQ.W 	  #2, (A1)
	SUBQ.W 	  #3, (A1)+
	SUBQ.W 	  #4, -(A1)
	SUBQ.L 	  #1, D1
	SUBQ.L 	  #2, (A1)
	SUBQ.L 	  #3, (A1)+
	SUBQ.L 	  #4, -(A1)
	SUBQ.L 	  #1, A2
	SUB.B     D1,D2
    SUB.B     D1,(A1)
    SUB.B     D1,(A1)+
    SUB.B     D1,-(A1)
    SUB.B     (A1),D1
    SUB.B     (A1)+,D1
    SUB.B     -(A1),D1
    SUB.B     D1,D2
    SUB.B     D1,(A1)
    SUB.B     D1,(A1)+
    SUB.B     D1,-(A1)
    SUB.B     (A1),D1
    SUB.B     (A1)+,D1
    SUB.B     -(A1),D1
    SUB.W     D1,D2
    SUB.W     D1,(A1)
    SUB.W     D1,(A1)+
    SUB.W     D1,-(A1)
    SUB.W     A1,D1
    SUB.W     (A1),D1
    SUB.W     (A1)+,D1
    SUB.W     -(A1),D1
    SUB.L     D1,D2
    SUB.L     D1,(A1)
    SUB.L     D1,(A1)+
    SUB.L     D1,-(A1)
    SUB.L     A1,D1
    SUB.L     (A1),D1
    SUB.L     (A1)+,D1
    SUB.L     -(A1),D1
    MULS.W    D0,D1
    MULS.W    (A0),D1
    MULS.W    -(A0),D1
    MULS.W    (A0)+,D1
    DIVS.W    D0,D1

    DIVS.W    (A0),D1
    DIVS.W    -(A0),D1
    DIVS.W    (A0)+,D1
    AND.B     D1,D2
    AND.B     D1,(A1)
    AND.B     D1,(A1)+
    AND.B     D1,-(A1)
    AND.B     (A1),D1
    AND.B     (A1)+,D1
    AND.B     -(A1),D1
    AND.W     D1,D2
    AND.W     D1,(A1)
    AND.W     D1,(A1)+
    AND.W     D1,-(A1)
    AND.W     (A1),D1
    AND.W     (A1)+,D1
    AND.W     -(A1),D1
    AND.L     D1,D2
    AND.L     D1,(A1)
    AND.L     D1,(A1)+
    AND.L     D1,-(A1)
    AND.L     (A1),D1
    AND.L     (A1)+,D1
    AND.L     -(A1),D1
	NEG.B     D5
	NEG.B     (A6)
	NEG.B     (A6)+
	NEG.W     -(A6)
	NEG.W     $9000
	NEG.L     $9000FFFF
	ORI.B     #1,D2
    ORI.W     #6,(A1)
	ORI.W     #8, $9000
	ORI.L     #8, $9000FFFF
	ORI.L     #1,(A1)
    OR.B     D1,D2
    OR.B     D1,(A1)
    OR.B     D1,(A1)+
    OR.B     D1,-(A1)
    OR.B     (A1),D1
    OR.B     (A1)+,D1
    OR.B     -(A1),D1
    OR.W     D1,D2
    OR.W     D1,(A1)
    OR.W     D1,(A1)+
    OR.W     D1,-(A1)
    OR.W     (A1),D1
    OR.W     (A1)+,D1
    OR.W     -(A1),D1
    OR.L     D1,D2
    OR.L     D1,(A1)
    OR.L     D1,(A1)+
    OR.L     D1,-(A1)
    OR.L     (A1),D1
    OR.L     (A1)+,D1
    OR.L     -(A1),D1
    LSL.B     D1,D2
    LSL.W     D1,D2
    LSL.W     (A1)
    LSL.W     (A1)+
    LSL.W     -(A1)
    LSL.L     D1,D2
    LSR.B     D1,D2
    LSR.W     D1,D2
    LSR.W     (A1)
    LSR.W     (A1)+
    LSR.W     -(A1)
    LSR.L     D1,D2
    ASR.B     D1,D2
    ASR.W     D1,D2
    ASR.W     (A1)
    ASR.W     (A1)+
    ASR.W     -(A1)
    ASR.L     D1,D2
    ASL.B     D1,D2
    ASL.W     D1,D2
    ASL.W     (A1)
    ASL.W     (A1)+
    ASL.W     -(A1)
    ASL.L     D1,D2
    ROL.B     D1,D2
    ROL.W     D1,D2
    ROL.W     (A1)
    ROL.W     (A1)+
    ROL.W     -(A1)
    ROL.L     D1,D2
    ROR.B     D1,D2
    ROR.W     D1,D2
    ROR.W     (A1)
    ROR.W     (A1)+
    ROR.W     -(A1)
    ROR.L     D1,D2
    CMP.B    D0,D1
    CMP.B    (A0),D1
    CMP.B    -(A0),D1
    CMP.B    (A0)+,D1
    CMP.W    D0,D1
    CMP.W    A0,D1
    CMP.W    (A0),D1
    CMP.W    -(A0),D1
    CMP.W    (A0)+,D1
    CMP.L    D0,D1
    CMP.L    A0,D1
    CMP.L    (A0),D1
    CMP.L    -(A0),D1
    CMP.L    (A0)+,D1
    BCC.L     label1
    BCC.L     label2
    BCC.L     label1
    BCC.L     label2
    BCC.L     label3
    JSR       (A0)
    JSR       $1234
    JSR       $12345678
    JSR       label1
    JSR       label2
    JSR       label3
    NOP
    RTS
    MOVE.B    $12,D1
    MOVE.B    $12,(A0)
    MOVE.B    $12,(A0)+
    MOVE.B    $12,-(A0)
    MOVE.B    $1234,D0
    MOVE.B    $1234,(A1)
    MOVE.B    $1234,(A1)+
    MOVE.B    $1234,-(A1)
    MOVE.B    $12345678,D0
    MOVE.B    $12345678,(A1)
    MOVE.B    $12345678,(A1)+
    MOVE.B    $12345678,-(A1)
    MOVE.B    #$12,D0
    MOVE.B    #$12,(A1)
    MOVE.B    #$12,(A1)+
    MOVE.B    #$12,-(A1)
    MOVE.W    $12,D1
    MOVE.W    $12,(A0)
    MOVE.W    $12,(A0)+
    MOVE.W    $12,-(A0)
    MOVE.W    $1234,D0
    MOVE.W    $1234,(A1)
    MOVE.W    $1234,(A1)+
    MOVE.W    $1234,-(A1)
    MOVE.W    $12345678,D0
    MOVE.W    $12345678,(A1)
    MOVE.W    $12345678,(A1)+
    MOVE.W    $12345678,-(A1)
    MOVE.W    #$1234,D0
    MOVE.W    #$1234,(A1)
    MOVE.W    #$1234,(A1)+
    MOVE.W    #$1234,-(A1)
    MOVE.L    $12,D1
    MOVE.L    $12,(A0)
    MOVE.L    $12,(A0)+
    MOVE.L    $12,-(A0)
    MOVE.L    $1234,D0
    MOVE.L    $1234,(A1)
    MOVE.L    $1234,(A1)+
    MOVE.L    $1234,-(A1)
    MOVE.L    $12345678,D0
    MOVE.L    $12345678,(A1)
    MOVE.L    $12345678,(A1)+
    MOVE.L    $12345678,-(A1)
    MOVE.L    #$12345678,D0
    MOVE.L    #$12345678,(A1)
    MOVE.L    #$12345678,(A1)+
    MOVE.L    #$12345678,-(A1)
    ADD.B     D1,$12
    ADD.B     D1,$1234
    ADD.B     D1,$12345678
    ADD.B     $12,D1
    ADD.B     $1234,D1
    ADD.B     $12345678,D1
    ADD.W     D1,$12
    ADD.W     D1,$1234
    ADD.W     D1,$12345678
    ADD.W     $12,D1
    ADD.W     $1234,D1
    ADD.W     $12345678,D1
    ADD.L     D1,$12
    ADD.L     D1,$1234
    ADD.L     D1,$12345678
    ADD.L     $12,D1
    ADD.L     $1234,D1
    ADD.L     $12345678,D1
    ADDA.W    $12,A2
    ADDA.W    $1234,A2
    ADDA.W    $12345678,A2
    ADDA.L    $12,A2
    ADDA.L    $1234,A2
    ADDA.L    $12345678,A2
    ADDA.L    #$12345678,A2
	SUBQ.W 	  #1, $9321
	SUBQ.L 	  #2, $43215678
	SUBQ.W 	  #7, $9342
	SUBQ.L 	  #8, $493299AA
    SUB.B     D1,$12
    SUB.B     D1,$1234
    SUB.B     D1,$12345678
    SUB.B     $12,D1
    SUB.B     $1234,D1
    SUB.B     $12345678,D1
    SUB.B     #$12,D1
    SUB.W     D1,$12
    SUB.W     D1,$1234
    SUB.W     D1,$12345678
    SUB.W     $12,D1
    SUB.W     $1234,D1
    SUB.W     $12345678,D1
    SUB.L     D1,$12
    SUB.L     D1,$1234
    SUB.L     D1,$12345678
    SUB.L     $12,D1
    SUB.L     $1234,D1
    SUB.L     $12345678,D1
    MULS.W    $12,D1
    MULS.W    $1234,D1
    MULS.W    $12345678,D1
    MULS.W    #$1234,D1
    DIVS.W    $12,D1
    DIVS.W    $1234,D1
    DIVS.W    $12345678,D1
    DIVS.W    #$1234,D1
    LSL.B     #$1,D2
    LSL.W     #$2,D2
    LSL.L     #$3,D2
    LSL.W     $12
    LSL.W     $1234
    LSL.W     $12345678
    ASR.B     #$1,D2
    ASR.W     #$2,D2
    ASR.L     #$3,D2
    ASR.W     $12
    ASR.W     $1234
    ASR.W     $12345678
    ROL.B     #$1,D2
    ROL.W     #$2,D2
    ROL.L     #$3,D2
    ROL.W     $12
    ROL.W     $1234
    ROL.W     $12345678
    *ROR added for Group A1 testing :)
    ROR.B     #$1,D2
    ROR.W     #$2,D2
    ROR.L     #$3,D2
    ROR.W     $12
    ROR.W     $1234
    ROR.W     $12345678
label1
label2
label3
label4    CMP.B     $12,D1
    CMP.B     $1234,D1
    CMP.B     $12345678,D1
    CMP.B     #$12,D1
    CMP.W     $12,D1
    CMP.W     $1234,D1
    CMP.W     $12345678,D1
    CMP.W     #$1234,D1
    CMP.L     $12,D1
    CMP.L     $1234,D1
    CMP.L     $12345678,D1
    CMP.L     #$12345678,D1
    BCC.B     label4
    BCC.W     label1
    BCC.W     label2
    BCC.W     label3
	BCS.W     label3
	BGE.W     label3
	BLT.W     label3
	BVC.L     label3
    JSR       label1
    JSR       label2
    JSR       label3
    MOVEA     D1,A1
    ADDA      D1,A1
    BTST      #1,D1


    SIMHALT



    END    START






















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
