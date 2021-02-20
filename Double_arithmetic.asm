.686           
.model flat,stdcall          
option casemap:none

include C:\masm32\include\windows.inc      ;MB_OK,NULL 
include C:\masm32\include\kernel32.inc     ;ExitProcess 
include C:\masm32\include\user32.inc       ;wsprintf, MessageBox
include C:\masm32\include\masm32.inc       ;FloatToStr

includelib C:\masm32\lib\kernel32.lib      ;ExitProcess
includelib C:\masm32\lib\user32.lib        ;MessageBox
includelib C:\masm32\lib\masm32.lib        ;FloatToStr     

.data          
    arr_a        dq    2.1,  4.23, 3.456, 2.0, 8.8;
    arr_b        dq    3.1,  15.5, 10.539, 3.6, 73.12;
    arr_c        dq    4.1,  5.22, 6.41111, 7.69, 8.88;
    arr_d        dq    1.1,  2.2, 3.0, 4.99, 55.63;
    
    var_a        dq    ?;
    var_b        dq    ?;
    var_c        dq    ?;
    var_d        dq    ?;
    
    const0       dq    0;
    const1       dq    2.0;
    const2       dq    4.0;
    const3       dq    23.0; 
    const4       dq    1000.0;
    
    temp         dq    ?;
    res          dt    ?;
    printRes     dq    ?;
    iterator     dw    5;            
    
    head         db    "Lab6", 0;
    
    format1      db    "(%s * 2 + ", 0;
    format2      db    "ln(%s / 4) ", 0;
    format3      db    "+ 23) / (%s", 0;
    format4      db    " * %s ", 0;
    format5      db    "- %s) = ", 0;

    buff1        db    25 DUP (?);
    buff2        db    25 DUP (?);
    buff3        db    25 DUP (?);
    buff4        db    25 DUP (?);
    buff5        db    25 DUP (?);
    buff6        db    25 DUP (?);
    tempBuff     db    20 DUP (?);
    buff         db    250 DUP(?), 0;
    
    lineFormat   db    6 DUP("%s"), 0;
    format       db    "%s",13;
    lineBuff     db    50 DUP(?), 0;

.code  
                    
start: 
    finit
    startLoop:
        xor eax, eax;
        xor ebx, ebx;

        mov bx, iterator;
        dec bx;
        fld arr_a[ebx * 8];
        fstp var_a;
        fld arr_b[ebx * 8];
        fstp var_b;
        fld arr_c[ebx * 8];
        fstp var_c;
        fld arr_d[ebx * 8];
        fstp var_d;

        fld var_d;
        fdiv const2;
        fstp temp;
        
        fldln2;
        fld temp;
        fyl2x; 
        fstp temp;
        
        fld var_c;
        fmul const1;
        fadd const3;
        fadd temp;
        fstp temp;
        
        fld var_a;
        fmul var_a;
        fsub var_b;

        fld temp;
        fxch st(1);
        fdiv; 

        fmul const4;
        frndint;
        fdiv const4;
         
        fstp res;                                           DT
        fld res;
        fstp printRes;

        invoke FloatToStr, var_c, addr tempBuff;
        invoke wsprintf, addr buff1, addr format1, addr tempBuff;
        invoke FloatToStr, var_d, addr tempBuff;
        invoke wsprintf, addr buff2, addr format2, addr tempBuff;
        invoke FloatToStr, var_a, addr tempBuff;
        invoke wsprintf, addr buff3, addr format3, addr tempBuff;
        invoke FloatToStr, var_a, addr tempBuff;
        invoke wsprintf, addr buff4, addr format4, addr tempBuff;
        invoke FloatToStr, var_b, addr tempBuff;
        invoke wsprintf, addr buff5, addr format5, addr tempBuff;
        invoke FloatToStr, printRes, addr buff6;

        invoke wsprintf, addr lineBuff,
                         addr lineFormat,
                         addr buff1,
                         addr buff2,
                         addr buff3,
                         addr buff4,
                         addr buff5,
                         addr buff6;
        
        invoke wsprintf, addr buff, addr format, addr buff, addr lineBuff;
                                                                         
    dec iterator;
    jnz startLoop
        
    invoke MessageBox,NULL, addr buff, addr head, MB_OK;
    invoke ExitProcess, NULL;

end start  