
#define __delay_ms__
.include "delay01.inc"
.def temp=R16
.def Commonad_Lcd=R17
.def x1=R18 //0~15
.def y1=R19 //1 or 2
.def keypad=R20
.def num1=R21
.def num2=R22
.def ACC=R24
.def count=R23
#define RS_1 sbi PORTD,0
#define RS_0 cbi PORTD,0
#define E_1 sbi PORTD,1
#define E_0 cbi PORTD,1
#define DB4 PORTD.4
#define DB5 PORTD.5
#define DB6 PORTD.6
#define DB7 PORTD.7
#define data_lcd PORTD
.equ ferquncy=8000000
; Replace with your application code

start:
ldi count,0x00
call LCD_Config
call LCD_Init
ldi y1,2
ldi x1,5
call lcd_location

ldi temp,0xF0
out DDRA,temp
ldi temp,0x0f
out PORTA,temp
main:
ldi count,0x00
L1:
call Keypad_Scan
cpi keypad,0x30
brlo main
cpi keypad,0x3b
brge main

up_1:
mov Commonad_Lcd,keypad
call lcd_data
call Function1
up_2:
call Keypad_Scan
cpi count,3
brlo Number1
rjmp up_2

Number1:
cpi keypad,0x30
brlo Num1_End
cpi keypad,0x3b
brge Num1_End
mov Commonad_Lcd,keypad
call lcd_data
call Function1
up_3:
call Keypad_Scan
cpi keypad,0x30
brlo Num1_End
cpi keypad,0x3b
brge Num1_End
jmp up_3

Num1_End:
mov Commonad_Lcd,keypad
call lcd_data
mov ACC,keypad
Num2_1:
ldi count,0x00
up_4:
call Keypad_Scan
cpi keypad,0x30
brlo Num2_1
cpi keypad,0x3b
brge Num2_1
cpi count,2
brlo Number2_2
rjmp up_4
Number2_2:
mov Commonad_Lcd,keypad
call lcd_data
call Function2
up_5:
call Keypad_Scan
cpi keypad,0x3b
brge Num2_End
cpi count,3
brlo Number2_3
jmp up_5
Number2_3:
mov Commonad_Lcd,keypad
call lcd_data
call Function2
Num2_End:
ldi Commonad_Lcd,'='
call lcd_data
cpi ACC,'+'
breq sum
cpi ACC,'-'
breq sub1
cpi ACC,'*'
breq mul1
cpi ACC,'/'
breq div1
jmp Num2_End
sum:
ADC num1,num2
call ASCI
jmp End

sub1:
cp num1,num2
brge sub2
sub num2,num1
ldi Commonad_Lcd,'-'
call lcd_data
mov num1,num2
jmp N1
sub2:
sub num1,num2
N1:
call ASCI
jmp End

mul1:
mul num1,num2
mov num1,R0
call ASCI
jmp End

div1:
clr temp
div2:
sbc num1, num2
brlo div_end
inc temp
jmp div2
div_end:
add num1,num2
//
mov num2,temp
ldi temp,10
cp num2,temp
brge div3
dec temp
dec num2
ldi temp,48
adc num2,temp
mov Commonad_Lcd,num2
call lcd_data
ldi Commonad_Lcd,'.'
call lcd_data
ldi temp,48
adc num1,temp
mov Commonad_Lcd,num1
call lcd_data
jmp End
div3:
mov temp,num1
mov num1,num2
call ASCI
ldi Commonad_Lcd,'.'
call lcd_data
mov num1,temp
ldi temp,48
adc num1,temp
mov Commonad_Lcd,num1
call lcd_data
End:
jmp End

ASCI:
clr num2              ; ????????? ?? ??? ???????
div_loop:
    subi num1, 10     ; ?? ???? 10 ?? R16
    brlo end_div     ; ??? R16 ???? ?? 0 ???? ?? ?????? ????? ???
    inc num2          ; ?????? ?????????
    rjmp div_loop    ; ????? ????

end_div:
    subi num1, -10 
	ldi temp,48
	adc num2,temp
	mov Commonad_Lcd,num2
	call lcd_data
	ldi temp,48
	adc num1,temp
	mov Commonad_Lcd,num1
	call lcd_data
	ret
Function2:
ldi temp,10
mul num2,temp
mov num2,R0
mov temp,keypad
subi temp,48
adc num2,temp
ret

Function1:
ldi temp,10
mul num1,temp
mov num1,R0
mov temp,keypad
subi temp,48
adc num1,temp
ret

Keypad_Scan:
ldi temp,0x0f
out PORTA,temp
in temp,PINA
ANDI temp,0x0f
cpi temp,0x0f
brne Keypad_Scan
up1:
in temp,PINA
ANDI temp,0x0f
cpi temp,0x0f
breq up1
delay_ms 5
in temp,PINA
ANDI temp,0x0f
cpi temp,0x0f
breq up1
ldi temp,0b01111111
out PORTA,temp
NOP
in temp,PINA
ANDi temp,0x0f
cpi temp,0x0f
Brne col1
ldi temp,0b10111111
out PORTA,temp
NOP
in temp,PINA
ANDi temp,0x0f
cpi temp,0x0f
Brne col2
ldi temp,0b11011111
out PORTA,temp
NOP
in temp,PINA
ANDi temp,0x0f
cpi temp,0x0f
Brne col3
ldi temp,0b11101111
out PORTA,temp
NOP
in temp,PINA
ANDi temp,0x0f
cpi temp,0x0f
Brne col4
col1:
ldi	R30,low(KCODE0<<1)
ldi R31,high(KCODE0<<1)
rjmp Find
col2:
ldi	R30,low(KCODE1<<1)
ldi R31,high(KCODE1<<1)
rjmp Find	
col3:
ldi	R30,low(KCODE2<<1)
ldi R31,high(KCODE2<<1)
rjmp Find
col4:
ldi	R30,low(KCODE3<<1)
ldi R31,high(KCODE3<<1)
rjmp Find
Find:
LSR temp
BRCC Match 
lpm R25,Z+
rjmp Find
Match:
lpm		R25,z
mov keypad,R25
inc count
ret

LCD_Config:
ldi temp,0xff
out DDRD,temp
ldi temp,0x00
out PORTD,temp
ret

LCD_Init:
ldi Commonad_Lcd,0x33
call lcd_commond
ldi Commonad_Lcd,0x32
call lcd_commond
ldi Commonad_Lcd,0x28
call lcd_commond
ldi Commonad_Lcd,0x0C//0000 1011
call lcd_commond
ldi Commonad_Lcd,0x06
call lcd_commond
ldi Commonad_Lcd,0x01
call lcd_commond
ret

lcd_commond:
mov temp,Commonad_Lcd
andi temp,0xf0
out  data_lcd,temp
RS_0
E_1
delay_ms 10
E_0
delay_ms 10
mov temp,Commonad_Lcd
andi temp,0x0f
swap temp
out data_lcd,temp
RS_0
E_1
delay_ms 10
E_0
delay_ms 10
ret

lcd_data:
mov temp,Commonad_Lcd
andi temp,0xf0
out  data_lcd,temp
RS_1
E_1
delay_ms 10
E_0
delay_ms 10
mov temp,Commonad_Lcd
andi temp,0x0f
swap temp
out data_lcd,temp
RS_1
E_1
delay_ms 10
E_0
delay_ms 10
ret

lcd_location:
cpi y1,1 //pc=1
brne l2
ldi y1,0x80
l2:
cpi y1,2// PC=2
brne l3
ldi y1,0xC0			//pC=3
add y1,x1
mov Commonad_Lcd,y1
call lcd_commond 
ret

lcd_clr:
ldi Commonad_Lcd,0x01
call lcd_commond
ret

l3:
rjmp l1

.org 0x300 

KCODE0: .db '/', '*', '-', '+'
KCODE1: .db '9', '6', '3', '='
KCODE2: .db '8', '5', '2', '0'
KCODE3: .db '7', '4', '1', 'O'