.686

include c:\masm32\include\masm32rt.inc 
includelib \masm32\lib\user32.lib 
 
.data 
 
  
    info db "Mihailichenko Ilya", 10, 
            "12.04.2000", 10, 
            "7318", 0 
 
 
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
 
.code 
start: 

  call decrypt
 
  call AllocConsole   
  invoke SetConsoleTitle, offset caption 
 
 
  invoke GetStdHandle, STD_INPUT_HANDLE 
  mov hConsoleInput, eax 
 
  invoke ReadConsole, hConsoleInput,offset inputb, 128, offset lpNumberOfCharsRead, NULL 
 
  call check 
 
  invoke MessageBox, 0, offset info, offset message2 ,MB_OK 
  invoke ExitProcess, 0 
 
 
  wrng proc 
    invoke MessageBox, 0, offset message3, offset message3 ,MB_OK 
    invoke ExitProcess, 0 
  wrng endp 
 
  check proc 
    lea ebx, inputb 
    call stringlength 
    mov edi, esi 
 
    mov edi, passwordl 
    sub edi, esi 
    cmp edi, 0 
    jge  righ 
    jne wrng 
 
    righ: 
    mov ecx, passwordl 
    lea esi,  inputb 
    lea edi,  password 
    repe cmpsb     
 
  check endp 
 
 
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

decrypt proc
  mov ecx, passwordl
  lea esi, password
  xor byte ptr[esi], key
  inc esi
  xor byte ptr[esi], key
  inc esi
  xor byte ptr[esi], key
  inc esi
  xor byte ptr[esi], key
  ret
decrypt endp
 
end start

