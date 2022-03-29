ORG 0H
MOV R6, #'K'; REAL KNOWN LETTER
MOV R7, #'R'; CHIPPED KNOWN LETTER
MOV P2, #2H; INDEX OF KNOWN LETTERS
MOV DPTR, #MYWORD


MOV A, R6
MOV B, R7
CJNE A,B,NOTEQU

EQUAL:
MOV R1,#0H
MOV A, P2
MOV R3,A
CLR A
SJMP STEP1

NOTEQU:
JC SMALL

SUBB A,B
MOV R1,A
MOV A, P2
MOV R3,A

GOSTART1:JZ STEP1
DEC R1
DJNZ R3,GOSTART1
CLR A

STEP2:
MOV A,R1
MOV R2,A
CJNE A,#0H,CONT
MOVC A,@A+DPTR
INC R3
SJMP LCDGO


CONT:
MOV R2,A
MOV A,R3
INC R3
MOVC A, @A+DPTR
JZ HERE
LOOP2: CJNE A,#5AH,GO3
MOV A,#40H
GO3:
INC A
DJNZ R2,LOOP2
LCDGO:
ACALL LETTER
ACALL COMMAND
INC R1
SJMP STEP2



SMALL:
MOV A,R7
MOV B,R6

SUBB A,B
MOV R1,A

MOV A, P2
MOV R3,A

GOSTART2:JZ STEP1
DEC R1
DJNZ R3,GOSTART2
CLR A


STEP1:
MOV A,R1
MOV R2,A
MOV A,R3
INC R3
MOVC A, @A+DPTR
JZ HERE
LOOP1: CJNE A,#40H,GO2
MOV A,#5AH
GO2:
DEC A
DJNZ R2,LOOP1
DEC A
ACALL LETTER
ACALL COMMAND
INC R1
SJMP STEP1



HERE:SJMP HERE




;P1.0-P1.7 DATA STORED
;P3.5  RS
;P3.6  RW
;P3.7  E

COMMAND: ;SENDS COMMANDS
MOV A,#0FH
mov p1,a ;DATA SENDING TO LCD VIA P1
clr p3.5 ;RS=0 BEFORE COMMAND
clr p3.6 ;R/W=0 IN ORTDER TO WRITE
setb p3.7 ;ENABLE 
acall DLY
clr p3.7;DISABLE
ret

LETTER: ;SENDS DATA 
mov p1,a ;LETTER SENDING TO LCD
setb p3.5 ;RS=1 BEFORE LETTER
clr p3.6 ;R/W=0 IN ORDER TO WRITE
setb p3.7 ;ENABLE
acall DLY
clr p3.7;DISABLE
ret

DLY: 
mov r4,#0FFh
OUTLOOP:
mov r5,#0FFh
djnz r5,$
djnz r4,OUTLOOP
ret



ORG 1000H
MYWORD: DB 'YKRAC' ,0
END