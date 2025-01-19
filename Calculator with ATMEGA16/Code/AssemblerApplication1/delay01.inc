#define stak_register R16
#define counter0 R16
#define counter1 R17
#define counter2 R18
#define counter3 R19
#define counter4 R20
#define counter5 R21
.EQU back_up_frequncy=$060
;********************************************************************************************************
;*************************************** decribe Stak ***************************************************
;********************************************************************************************************
.ORG 0
LDI stak_register,HIGH(RAMEND)
OUT SPH,stak_register
LDI stak_register,LOW(RAMEND)
OUT SPL,stak_register
.CSEG
;*********************************************************************************************************
LDI counter0,((ferquncy/1000000));we put on some frequncy into R21
STS back_up_frequncy,counter0;
;*********************************************************************************************************
;*********************************** the making a ms delay ***********************************************
;*********************************************************************************************************
.MACRO delay_1ms
	LDS counter0,back_up_frequncy
L:
	LDI counter1,250
L1:
	nop
	DEC counter1
BRNE L1
	DEC counter0
BRNE L
.ENDMACRO
	.MACRO delay_ms
				PUSH counter0
				PUSH counter1
				PUSH counter2
				PUSH counter3
				PUSH counter4
				PUSH counter5
		LDI counter2,low(@0)
		LDI counter3,BYTE2(@0)
		LDI counter4,BYTE3(@0)
		LDI counter5,BYTE4(@0)
	l3:
	delay_1ms
		SUBI counter2,$01
		SBCI counter3,$00
		SBCI counter4,$00
		SBCI counter5,$00
	BRNE l3
				POP counter5
				POP counter4
				POP counter3
				POP counter2
				POP counter1
				POP counter0
		
	.ENDMACRO

