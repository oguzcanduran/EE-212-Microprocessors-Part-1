ORG 0H
MOV R0,#9H
MOV R1,#30H
MOV DPTR, #MYWORD
MOV R2, #0H
START:
MOV A,R2
INC R2
MOVC A, @A+DPTR
JZ HERE
ADD A, R0
INC R0
CJNE A,#5BH, CHECK
MOV A,#41H
SJMP GO
CHECK:JNC BIGGER
SMALLER:
SJMP GO
BIGGER:
SUBB A,#26D
GO:
MOV @R1,A
MOV P1,A
ACALL LETTER
ACALL COMMAND
INC R1
SJMP START

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
mov r5,#0Fh
djnz r5,$
djnz r4,OUTLOOP
ret



ORG 1000H
MYWORD: DB 'PART' ,0
END