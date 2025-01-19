;
; AssemblerApplication1.asm
;
; Created: 9/22/2024 7:11:31 PM
; Author : ali
;
#define __delay_ms__
.include "delay01.inc"
.def temp=R16
.def Commonad_Lcd=R17
.def x1=R18 //0~15
.def y1=R19 //1 or 2
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
call LCD_Config
call LCD_Init
ldi y1,2
ldi x1,5
call lcd_location
ldi Commonad_Lcd,'a'
call lcd_data

L1:
rjmp L1




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
 
