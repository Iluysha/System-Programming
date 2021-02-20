.model  tiny
.data

    error           db    13, "Incorrect password$";    
    password        db    CEh, CDh, CFh, CBh;      
    passLen=$-password                                  
    key             equ   1h;
    myData          db    13, "Mihailichenko Ilya, ",
    13, 10, "12.04.2000, ", 13, 10, "7318$";
    message         db    "Input:$ ";                   
    maxInput        db    5;                            
    inputLen        db    0;
    buffer          db    4 dup (0);                    
 
.code
org 100h
 
main:

    mov dx, offset message;
    mov ah,09h;
    int 21h
    
    mov dx, offset maxInput;
    mov ah, 0Ah;
    int 21h
    
    mov dl, 5;
    mov ah, 6;
    int 21h
    
    mov ah, passLen;
    mov bh, inputLen;
    cmp ah, bh;
    jne wrong
    
    lea si, buffer
    xor byte ptr[si], key
    xor byte ptr[si + 1], key
    xor byte ptr[si + 2], key
    xor byte ptr[si + 3], key

    mov cx, passLen;
    mov si, offset buffer;
    mov di, offset password;
    mov cx, passLen;
    repe cmpsb;
    je correct       
    jmp wrong
     
    correct:
    
    mov dx, offset myData;
    mov ah, 09h;
    int 21h
    
    jmp exit
       
    wrong:
    
    mov dx, offset error;
    mov ah, 09h;
    int 21h;
       
    exit:
    
    mov ah, 8;   
    int 21h
    mov ax, 4c00h;    
    int 21h;
    
end main
