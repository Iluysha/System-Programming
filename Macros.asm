.686

include c:\masm32\include\masm32rt.inc 
includelib \masm32\lib\user32.lib 
 
.data 
 
  
    myName db "Mihailichenko Ilya", 0 
    myDate db "12.04.2000", 0
    myNumb db "7318", 0 
 
    inputb db 128 dup (0), '$' 
 
    hConsoleInput  dd 0 
    lpNumberOfCharsRead db 0 
 
    message1 db "Enter the password:",0 
    message2 db "Correct input",10, 13, 0 
    message3 db "Wrong password", 0 
    caption db "Input", 0 
    password db 31h, 32h, 30h, 34h
    passwordl=$-password 
    key equ 1h
  
  MacrosOutput macro info, msg ;; macros for output 
    invoke MessageBox, 0, offset info, offset msg ,MB_OK 
  endm
 
  MacrosEncrypt macro pass, key, len ;; macros for encryption 
    mov ecx, len 
    lea esi, pass 
    mov ebx, 0 
  Encrypt:   
    xor byte ptr[esi], key 
    inc esi
    inc ebx    
    cmp ebx, 4    ; if esi!=4 goto Encrypt 
    jne Encrypt  
  endm
 
  MacrosCompare macro input,  pass, len ;; macros for comparing password 
    local righ  
    lea ebx, input 
    call stringlength  
    mov edi, esi  
  
    mov edi, len 
    sub edi, esi  
    cmp edi, 0  
    jge righ  
    jne wrng  
  
    righ:  
      cld  
      mov ecx, len 
      lea esi,  input 
      lea edi,  pass 
      repe cmpsb      
  endm
 
.code 
start: 
  MacrosEncrypt password, key, passwordl
 
  call AllocConsole   
  invoke SetConsoleTitle, offset caption 
 
 
  invoke GetStdHandle, STD_INPUT_HANDLE 
  mov hConsoleInput, eax 
 
  invoke ReadConsole, hConsoleInput,offset inputb, 128, offset lpNumberOfCharsRead, NULL 
 
  MacrosCompare inputb, password, passwordl
 
 MacrosOutput myName, message2
 MacrosOutput myDate, message2
 MacrosOutput myNumb, message2
 invoke ExitProcess, 0 
 
wrng proc 
  invoke MessageBox, 0, offset message3, offset message3 ,MB_OK 
  invoke ExitProcess, 0 
wrng endp  
 
stringlength proc 
 
      mov esi, 0                                               
      mov edx, 0 
 
    iter: 
 
      mov eax, [ebx+esi]                                         
      inc esi 
      cmp eax, edx                                              
      jne iter                                              
  
      sub esi, 3                                            
   ret 
 
stringlength endp 
 
end start


