.386           
.model flat,stdcall          
option casemap:none

include C:\masm32\include\windows.inc 
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc  

includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

.data          
    arr_a        dw    8,  -210, -177, -78, -212;     
    arr_b        dw    81,  93,   59,   41,  100;
    arr_c        dw    2,   3,    3,    2 ,  4;
    
    var_a        dw    ?;
    var_b        dw    ?;
    var_c        dw    ?;
    iterator     dw    5;
    
    const1       dw    2;
    const2       dw    38;  
    const3       dw    -1;   
    const4       dw    5;                    

    head         db    "Lab5", 0;

    format1      db    "(%u * 2 - ", 0;
    format2      db    "%u * 38) / (", 0;
    format3p     db    "%u + ", 0;
    format3m     db    "%u - ", 0;
    format4      db    "%u / ", 0;
    format5e     db    "%u + 1) / 2", 0;
    format5u     db    "%u + 1) * 5", 0;
    format6      db    " = %u", 0;

    buff1        db    15 DUP (?);
    buff2        db    15 DUP (?);
    buff3        db    15 DUP (?);
    buff4        db    15 DUP (?);
    buff5        db    15 DUP (?);
    buff6        db    15 DUP (?);
    
    lineFormat   db    6 DUP("%s"), 0;
    format       db    "%s",13;
    lineBuff     db    50 DUP(?), 0;
    buff         db    ?;

.code  
                    
start: 
    xor ebx, ebx;

    startLoop:

        mov bx, iterator;
        dec bx;
        mov ax, arr_a[ebx * 2];
        mov var_a, ax;
        mov ax, arr_b[ebx * 2];
        mov var_b, ax;
        mov ax, arr_c[ebx * 2];
        mov var_c, ax;

        mov ax, var_b;       
        mul const1;           
        mov bx, ax;

        mov ax, var_c;      
        mul const2;          
        sub bx, ax;
        
        add var_a, 0;
        js negative
            invoke wsprintf, addr buff3, addr format3p, var_b;
            mov ax, var_a;
            mov cx, var_b;
            div var_c;                       
            add cx, ax; 
            jmp positive    
        negative:
            invoke wsprintf, addr buff3, addr format3m, var_b;
            mov ax, var_a;
            mov cx, var_b;
            imul const3;
            mov var_a, ax;    
            div var_c;                       
            sub cx, ax;     
        positive:
        add cx, 1;

        mov ax, bx;
        div cx;
        mov bx, ax;

        xor dx, dx;
        div const1;
        cmp dx, 0;
    
        je evenNumb
            invoke wsprintf, addr buff5, addr format5u, var_c;
            mov ax, bx;
            mul const4;
            jmp unevenNumb
        evenNumb: 
            invoke wsprintf, addr buff5, addr format5e, var_c;
            mov ax, bx;
            div const1;    
        unevenNumb:

        invoke wsprintf, addr buff6, addr format6, ax;
        invoke wsprintf, addr buff1, addr format1, var_b;
        invoke wsprintf, addr buff2, addr format2, var_c;
        invoke wsprintf, addr buff4, addr format4, var_a;

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