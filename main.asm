data segment

    
    ; Constants 
    ;binome: Oussama BOUSSAHLA
    ;        Labadi HARETH
    
    
    calculator dw 0dh, 0ah, "              .__               .__          __                ", 0dh, 0ah, "  ____ _____  |  |   ____  __ __|  | _____ _/  |_  ___________ ", 0dh, 0ah, "_/ ___\\__  \ |  | _/ ___\|  |  \  | \__  \\   __\/  _ \_  __ \", 0dh, 0ah, "\  \___ / __ \|  |_\  \___|  |  /  |__/ __ \|  | (  <_> )  | \/", 0dh, 0ah, " \___  >____  /____/\___  >____/|____(____  /__|  \____/|__|   ", 0dh, 0ah, "     \/     \/          \/                \/ ", 0dh, 0ah, 0dh, 0ah, "                                    Created by: BOUSSAHLA Oussama", 0dh, 0ah, "                                                LABADI Hareth", 0dh, 0ah, "$" 

                    
                            
    msg_wlc    db  0dh, 0ah, 0dh, 0ah, ":> Welcome to our calculator program!",0dh,0ah,0dh,0ah,0dh,0ah,"Our calculator supports arithmetic operations in base 2, 10, and 16.",0dh,0ah,0dh,0ah,"$" 
        
    msg_base   db 0dh, 0ah,0dh, 0ah, "Please, select the base for your operands and results using the following commands:",0dh,0ah, 0dh,0ah,"- Enter 'b' to use base 2 (binary)", 0dh,0ah, "- Enter 'd' to use base 10 (decimal)", 0dh,0ah,"- Enter 'h' to use base 16 (hexadecimal)", 0dh,0ah, "$"
    base10     db 0dh,0ah, 0dh,0ah, 'Your operations will be in base 10 $'
    base2      db 0dh,0ah, 0dh,0ah, 'Your operations will be in base 2 $'
    base16     db 0dh,0ah, 0dh,0ah, "Your operations will be in base 16 $"
    msg_cpsL   db 0dh, 0ah, 0dh,0ah, 0ah, 0dh, '<!> Important: Please turn on Caps Lock to use base 16 correctly $'
    
    
    msg_op     db 0dh,0ah,0dh,0ah,'Please, Enter the operation (+, -, *, or /): $'
    
    msg1_2     db 0dh, 0ah, 0dh, 0ah, 'Enter the first binary number ( max 16-digits ) : $'
    msg2_2     db 0dh, 0ah, 0dh, 0ah, 'Enter the second binary number ( max 16-digits ) : $'
    
    msg1_10    db 0dh, 0ah, 0dh, 0ah,'Enter the first decimal number ( max 5-digits < 65535 ) : $'
    msg2_10    db 0dh, 0ah, 0dh, 0ah, 'Enter the second decimal number ( max 5-digits <65535 ) : $'
    msg_Of_10  db 0dh, 0ah, 0dh, 0ah, "<!> Warning: The decimal number must be lower then or equal 65535 else your results will be overflowed", 0dh, 0ah, "$"
    
        
    msg1_16    db 0dh, 0ah, 0dh, 0ah,'Enter the first hexadecimal number (max 4-digits in upper case only): $'
    msg2_16    db 0dh, 0ah,'Enter the second hexadecimal number (max 4-digits in upper case only): $'
    
    msg_rslt   db 0dh, 0ah, 0dh, 0ah, 'Operation result: $'
    msg_rtr    db 0dh, 0ah, 0dh, 0ah, "- For another operation in this base press the key 's' -> same", 0dh, 0ah,"- For another operation in anoter base press the key 'o' -> other", 0dh, 0ah,"- Press any other key to exit", 0dh, 0ah, "$"
    
    msg_exit   db 0dh,0ah ,'thank you for using the calculator! :> ', 0Dh,0Ah, '$'
    msg_err    db 0dh, 0ah, ':< Error: Invalid input!', 0dh, 0ah, '$'
    msg_Div0   db 0dh, 0ah, 0dh,  0ah, ":< Division Error, second operand couldn't be 0 $" 
    msg_of     db 0dh, 0ah, 0dh, 0ah, ' <!> warning: result overflow $'
    
    
    ; Variables
    base   db 0
    sign   db 0
    caseOP db 1
    isER   db 'f'
    op1    dw  0
    op2    dw  0
    bool   db  0 
    cnt    db  5
    
data ends 

; Code segment
code segment
    assume cs:code, ds:data

    ; Main program
    start:  
    
        
        
        mov ax, data
        mov ds, ax 
        
        ;the word calculator
        mov ah, 9h
        lea dx, calculator
        int 21h        
           
        call delay
        call delay

        ; Welcome and ask for base
        mov ah, 09h
        lea dx, msg_wlc
        int 21h
        
        
readB:  ; Read base from input
        call read_base
         
        cmp [base], 'b'
        jz base_2
        
        cmp [base], 'd'
        jz base_10
        
        cmp [base], 'h'
        jz base_16 
                     
                     
                     
;=============================================================================================
         
base_2:
         
bin_op:  
        ;reading and dispalying the operation 
        call read_sign
        
        ;ferifying the operation
        cmp al,'+' 
        je add_2
        
        cmp al,'*'
        je mul_2
        
        cmp al,'-'
        je sub_2 
        
        cmp al,'/'
        je div_2
        
        
        
        
add_2:  
        
 in1_2_add:
        cmp [isER], 't'
        jnz cnt_add_2_1
        ;return the adress of the error procedure in case of error
        pop dx 
        pop dx
        
cnt_add_2_1:

        ;display the message to read the first term 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_2  
        int 21h 
        
        
        ;read the input
        call InputNo_2 
        
        
        ;store the result in op1 for display
        mov [op1], bx
        ;store the op1 in stack for calcultions
        push bx

 in2_2_add:
        cmp [isER], 't'
        jnz cnt_add_2_2 
        ;return the adress of the error procedure in case of error
        pop dx 
        pop dx 
        
cnt_add_2_2: 
        ;display the message to read the second term
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_2
        int 21h 
        
        
        ;read the input
        call InputNo_2
        


        ;store the result in op2 for display
        mov [op2], bx  
        
        ;get the first operand
        pop dx

        ;executing the operation (addition) and puting the rslt in dx        
        add dx,op2         
        
        ;check for overflow
        call DispOvflow 

        
        ;storing the rslt in stack
        push dx
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h
        
        ;display the op1
        mov bx, op1
        call view_2  
        
        
        ;display the sign
        mov ah, 2h
        mov dx, '+'
        int 21h
        
        ;display the op2
        mov bx, op2
        call view_2 
        
        ;display equals
        mov ah, 02h
        mov dx, '='
        int 21h
        
        
        ;display the result
        pop bx
        call view_2
        
        ;display choices
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        mov ah, 0h
        int 16h
        
        cmp al, 's'
        jz bin_op
        
        
        cmp al, 'o'
        jz readB         
        jmp exit             


sub_2:
 in1_2_sub:
        cmp [isER], 't'
        jnz cnt_sub_2_1
        ;return the adress of the error procedure in case of error
        pop dx 
        pop dx
        
cnt_sub_2_1:

        ;display the message to read the first term 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_2  
        int 21h 
        
        
        ;read the input
        call InputNo_2 
        

        ;store the result in op1 for display
        mov [op1], bx
        ;store the result in stack for calcultions
        push bx

 in2_2_sub:
        cmp [isER], 't'
        jnz cnt_sub_2_2 
        ;return the adress of the error procedure in case of error
        pop dx 
        pop dx 
        
cnt_sub_2_2: 
        ;display the message to read the second term
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_2
        int 21h 
        
        
        ;read the input
        call InputNo_2
        
        ;store the result in op2 for display
        mov [op2], bx
        ;get the first operand
        pop dx

        ;executing the operation (substraction) and puting the rslt in dx        
        sub dx,[op2]
        
        ;check for overflow
        call DispOvflow 
        
        ;storing the rslt in stack
        push dx
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h
        
        ;display the op1
        mov bx, op1
        call view_2 
        
        mov ah, 2h
        mov dx, '-'
        int 21h
        
        ;display the op2
        mov bx, op2
        call view_2 
        
        mov ah, 02h
        mov dx, '='
        int 21h
        
        
        ;display the result
        pop bx
        call view_2
        
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        mov ah, 0h
        int 16h
        
        cmp al, 's'
        jz bin_op
        
        
        cmp al, 'o'
        jz readB         
        jmp exit             


mul_2: 
 in1_2_mul:
        cmp [isER], 't'
        jnz cnt_mul_2_1
        ;return the adress of the error procedure in case of error
        pop dx 
        pop dx
        
cnt_mul_2_1:

        ;display the message to read the first term 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_2  
        int 21h 
        
        
        ;read the input
        call InputNo_2 
       
        
        ;store the result in op1 for display
        mov [op1], bx
        ;store the result in stack for calcultions
        push bx

 in2_2_mul:
        cmp [isER], 't'
        jnz cnt_mul_2_2 
        ;return the adress of the error procedure in case of error
        pop dx 
        pop dx 
        
cnt_mul_2_2: 
        ;display the message to read the second term
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_2
        int 21h 
        
        
        ;read the input
        call InputNo_2
        
        ;store the result in op2 for display
        mov [op2], bx
        
        
        pop ax
        ;executing the operation (multiplication) and puting the rslt in dx        
        mul bx
        
        call DispOvflow_mul
        
        ;storing the rslt in stack
        push ax
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h
        
        ;display the op1
        mov bx, op1
        call view_2 
        
        mov ah, 2h
        mov dx, '*'
        int 21h
        
        ;display the op2
        mov bx, op2
        call view_2 
        
        mov ah, 02h
        mov dx, '='
        int 21h
        

        ;display the result
        pop bx
        call view_2
        
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        mov ah, 1h
        int 21h
        
        cmp al, 's'
        jz bin_op
        
        
        cmp al, 'o'
        jz readB         
        jmp exit             




div_2: 
 in1_2_div:
        cmp [isER], 't'
        jnz cnt_div_2_1
        ;return the adress of the error procedure in case of error
        pop dx 
        pop dx
        
cnt_div_2_1:

        ;display the message to read the first term 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_2  
        int 21h 
        
        
        ;read the input
        call InputNo_2 
       
        ;store the result in op1 for display
        mov [op1], bx
        ;store the result in stack for calcultions
        push bx

 in2_2_div:
        cmp [isER], 't'
        jnz cnt_div_2_2 
        ;return the adress of the error procedure in case of error
        pop dx 
        pop dx 
        
cnt_div_2_2: 
        ;display the message to read the second term
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_2
        int 21h 
        
        
        ;read the input
        call InputNo_2
        
        ;store the result in op2 for display
        mov [op2], bx
        
        cmp bx, 0 
        
        ;verify division over 0
        jne Cte_2 
        call DispDiv0
        jmp cnt_div_2_2
        
        ;get the op1
 Cte_2: pop ax 
        ;clear dx=0 to avoid overflow
        mov dx, 0h
        ;executing the operation (divison) and puting the rslt in dx        
        div bx
        
        
        ;storing the rslt in stack
        push ax
        call DispOvflow_mul
        
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h
        
        ;display the op1
        mov bx, op1
        call view_2 
        
        mov ah, 2h
        mov dx, '/'
        int 21h
        
        ;display the op2
        mov bx, op2
        call view_2 
        
        mov ah, 02h
        mov dx, '='
        int 21h
        
        pop ax
        ;display the result
        mov bx, ax
        call view_2
        
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        mov ah, 1h
        int 21h
        
        cmp al, 's'
        jz bin_op
        
        
        cmp al, 'o'
        jz readB         
        jmp exit             


 

InputNo_2: 
       
       ;cleaning bx
       mov bx, 0
       ;initialize loop counter
       mov cx, 16
                        
       
      
 readC:  
       
       ;set input function to read a charachter                  
       mov ah, 1 
       
       ;read a character
       int 21h
       
       ;verify if the input is 0, 1 or odh else repeat reading
       call err_2 
       
       ; compare AL with CR
       cmp al, 0dh
       
       ;if it is binary we prepare it for calculation (shifting)               
       jne biForm              
       jmp end_readC         

       ; convert ascii into decimal code by removing 30
biForm:and ax, 000FH            
       shl bx, 1
       ;add the bit uising bit level (conversion from binary to hexa level)              
       or bx, ax              
       loop readC 
       
end_readC:
       ret
       
       
       
;procedure to display a binary number  
view_2:
        
        ; initialize loop counter
        mov cx, 16                  
        mov ah, 2h
      
      
                                  
       
putC:
        ; shift BL towards left by 1 position                 
        shl bx, 1 
        ; jump to label @ONE if CF=1              
        jc one
        
        ; set dl=0 else                  
        mov dl, 30H
        
        cmp bool, 0
        je loop_putC
        jmp display_2
                      
                    
        ; set DL=1
one:    mov dl, 31H 
        mov bool, 1           

display_2:

       ; print the character         
       int 21H 
                      
loop_putC:
       loop putC
       
       mov bool, 0               
       
       ret



;=============================================================================================        
         
base_10: 
 
dec_op:  
        ;reading and dispalying the operation 
        call read_sign 
        
        ;verifying the operation
        cmp al,'+' 
        je add_10
        
        cmp al,'*'
        je mul_10     
        
        cmp al,'-'
        je sub_10 
        
        cmp al,'/'                 
        je div_10
 
        
add_10: 
        ;display the message to read the first term
 in1_10_add:
        cmp [isER], 't'
        jnz cnt_add_10_1
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_add_10_1: 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_10  
        int 21h
        
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read the first term (num per num)
        call InputNo_10  ;the input result (our num) is in dx
        mov [op1], dx 
        
        
         
        ;display the message to read the second term
 in2_10_add:
        cmp [isER], 't'
        jnz cnt_add_10_2
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_add_10_2: 
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_10
        int 21h
         
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read one num separatly
        call InputNo_10  ;the input result (our num) is in dx
        mov [op2], dx 
        
        
        ;executing the operation (addition) and puting the rslt in dx        
        add dx,op1
        
        call DispOvflow
        
        ;storing the rslt in stack
        push dx
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h
        
        
        
        ;display the op1
        mov dx, op1
        mov cx,10000 
        call View_10 
        
        ;display the sign
        mov ah, 2h
        mov dx, '+'
        int 21h
        
        ;display op2
        mov dx, op2
        mov cx,10000 
        call View_10 
        
        mov ah, 02h
        mov dx, '='
        int 21h
        
        ;display result
        mov cx, 10000
        pop dx
        call View_10
        
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        mov ah, 0h
        int 16h
        
        cmp al, 's'
        jz dec_op
        
        
        cmp al, 'o'
        jz readB         
        jmp exit         


sub_10:
        
in1_10_sub:
        ;display the message to read the first term
        cmp [isER], 't'
        jnz cnt_sub_10_1
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_sub_10_1: 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_10  
        int 21h
        
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read the first term (num per num)
        call InputNo_10  ;the input result (our num) is in dx
        mov [op1], dx 
        push dx 
        
       
         
        ;display the message to read the second term
 in2_10_sub:
        cmp [isER], 't'
        jnz cnt_sub_10_2
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_sub_10_2: 
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_10
        int 21h
         
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read one num separatly
        call InputNo_10  ;the input result (our num) is in dx
        mov [op2], dx 
        
        
        pop dx ;;get op1 and put it in dx
        ;executing the operation (substraction) and puting the rslt in dx        
  
        sub dx,[op2]
        
        call DispOvflow
        
        ;storing the rslt in stack
        push dx
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h
        
        mov dx, op1
        mov cx,10000 
        call View_10 
        
        mov ah, 2h
        mov dx, '-'
        int 21h
        
        mov dx, op2
        mov cx,10000 
        call View_10 
        
        mov ah, 02h
        mov dx, '='
        int 21h
        
        mov cx, 10000
        pop dx
        call View_10
        
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        mov ah, 0h
        int 16h
        
        cmp al, 's'
        jz dec_op
        
        
        cmp al, 'o'
        jz readB

        jmp exit         


mul_10:

in1_10_mul:
        ;display the message to read the first term
        cmp [isER], 't'
        jnz cnt_mul_10_1
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_mul_10_1: 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_10  
        int 21h
        
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read the first term (num per num)
        call InputNo_10  ;the input result (our num) is in dx
        mov [op1], dx 
         
        ;display the message to read the second term
 in2_10_mul:
        cmp [isER], 't'
        jnz cnt_mul_10_2
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_mul_10_2: 
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_10
        int 21h
         
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read one num separatly
        call InputNo_10  ;the input result (our num) is in dx
        mov [op2], dx
        
        ;putting the second operator in the accumulator
        mov ax, [op2]
        
        
        ;executing the operation (multiplication) and puting the rslt in dx        
        mul [op1]
        
        call DispOvflow_mul 
        
        ;storing the rslt in stack
        push ax
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h 
        
        ;display the first term
        mov dx, op1
        mov cx,10000 
        call View_10 
        
        ;display the sign
        mov ah, 2h
        mov dx, '*'
        int 21h
        
        ;display the second term
        mov dx, op2
        mov cx,10000 
        call View_10 
        
        ;display '='
        mov ah, 02h
        mov dx, '='
        int 21h
        
        ;display the result
        mov cx, 10000
        pop dx
        call View_10
        
        ;display the message to repeat the operations
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        ;reading the answer
        mov ah, 0h
        int 16h
        
        ;still at the same base
        cmp al, 's'
        jz dec_op
        
        ;go to another base
        cmp al, 'o'
        jz readB

        jmp exit


div_10:

in1_10_div:
        ;display the message to read the first term
        cmp [isER], 't'
        jnz cnt_div_10_1
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_div_10_1: 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_10  
        int 21h
        
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read the first term (num per num)
        call InputNo_10  ;the input result (our num) is in dx
        mov [op1], dx
         
         
        ;display the message to read the second term
 in2_10_div:
        cmp [isER], 't'
        jnz cnt_div_10_2
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_div_10_2: 
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_10
        int 21h
         
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read one num separatly
        call InputNo_10  ;the input result (our num) is in dx
        
        
        
        cmp dx, 0 
        
        ;verify division over 0
        jne Cte_10 
        call DispDiv0
        jmp cnt_div_10_2 
        

cte_10: mov [op2], dx
                
        mov cx, [op2] ;; or dx 
        
        ;clearing dx before the division it will be considered as part of the dividend
        xor dx, dx  

        
        ;putting the second operator in the accumulator
        mov ax, [op1]
        
        
        ;executing the operation (division) and puting the rslt in dx        
        div [op2]
        
        call DispOvflow_mul
        
        
        ;storing the rslt in stack
        push ax  
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h 
        
        ;display the first term
        mov dx, op1
        mov cx,10000 
        call View_10 
        
        ;display the sign
        mov ah, 2h
        mov dx, '/'
        int 21h
        
        ;display the second term
        mov dx, op2
        mov cx,10000 
        call View_10 
        
        ;display '='
        mov ah, 02h
        mov dx, '='
        int 21h
        
        ;display the result
        mov cx, 10000
        pop dx
        call View_10
        
        ;display the message to repeat the operations
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        ;reading the answer
        mov ah, 0h
        int 16h
        
        ;still at the same base
        cmp al, 's'
        jz dec_op
        
        ;go to another base
        cmp al, 'o'
        jz readB

        jmp exit 

 

InputNo_10:

        mov cnt, 5
start_InputNo_10:
        
        
        ;read and display one key press using int 21 serv 1
        mov ah,1h
        int 21h  
        
        
        call err_10
        ;intiallization for FormNo_10  
        mov dx,0  
        mov bx,1 
        
        ;verfy the enter key which indicate the end of entering the num 
        cmp al,0dh         
        
        ;if it's the enter key then this mean we already have our number 
        ;stored in the stack, so we will return it back using FormNo 
        je FormNo_10
        
        
        ;convert the num in ascii code stored in al to a dec num   
        sub ax,30h
        
        ;clean ah before push it to the stack bec we need al only
        mov ah,0
        ;push the contents of ax to the stack 
        push ax 
        
        
        ;counter for the number of digits
        inc cx
        dec cnt
        
        ;check if we reached the max num of digits which is 5
        cmp cnt, 0
        je FormNo_10
                   
        jmp start_InputNo_10         
        
         
        ret 
        
        
;we took each number separatly so we need to form our number 
;and store in one bit for example if our number 235
FormNo_10:

            
            ;get the num in the head of the stack  and store it in ax    
            pop ax 
            
            
            push dx
            ;multiplay the digit in ax by the base in bx and store the new part in ax   
            mul bx 
            pop dx
            
            ;add the new part to our cumule 
            add dx,ax
            
            ;store the last base in ax for multiplaying using acc ax=1
            mov ax,bx
            ;update the base by 10 to prepare the other term of mul to get the next base     
            mov bx,10
            
            push dx
            ;get the next base ->ax =10 and store it in bx
            mul bx
            pop dx
            
            ;store the result of mul (next base) in bx =100 to prepare it for next unit
            mov bx,ax
            
            
            
            ;decrement one digit
            dec cx  
            
              
            cmp cx, 6
            ja  err_10   
            
            cmp cx,0
            jne FormNo_10 
            
            ;output is is in dx
            ret 
         
        

View_10:    ;initialize the boolean var
            mov bool, 0 
            
            ;if the hole num is 0
            cmp dx, 0 
            jne start_View_10
            
            ;dispaly the zero alone
            mov ah, 2h   
            
            push dx
            mov dl, 30h
            int 21h 
            pop dx 
            ret              
            
start_View_10:
            ;the input is in dx, we store it in ax
            mov ax,dx 
            
            ;intitialization
            mov dx,0   ;to clean dh in order to avoid overflow 
            
            ;get the digit in the last right  d/10000
            ;the digit in the right is in ax so we will convert it
            div cx   
            
            cmp ax, 0 
            jne isNot_0_10
            
            cmp bool, 0 
            je cnt_View_10   
            
            
            
isNot_0_10: mov bool, 1
      
            
            ;display the caracter
            call ViewNo_10        
            
cnt_View_10:
            ;store the rest in dx to bx
            mov bx,dx
            ;clean dx from the rest 
            mov dx,0 
            
            ;prepare for delete one zero from 10000, moving it to ax
            mov ax,cx
            ;prepare the other term
            mov cx,10
            
            div cx
            
            ;store the rest of the number in dx to prepare it for next div
            mov dx,bx
            ;stotre the new big base 
            mov cx,ax  
            
            ;verify the loop
            cmp ax,0
            jne start_View_10
            ret
            
       
ViewNo_10: 

           ;save the content of ax and dx
           push ax 
           push dx 
           
           ;mov the digit in ax to dx to display it wit int 21h
           mov dx,ax 
           add dl,30h ;add 30 to its value to convert it back to ascii
           mov ah,2
           int 21h
           
           pop dx  
           pop ax
           ret      
         
         
;======================================================================================================         
base_16:
        mov ah, 09h
        lea dx, msg_cpsL
        int 21h
hex_op:  
        ;reading and dispalying the operation 
        call read_sign
        
        ;verifying the operation
        cmp al,'+' 
        je add_16
        
        cmp al,'*'
        je mul_16     
        
        cmp al,'-'
        je sub_16 
        
        cmp al,'/'                 
        je div_16
           
         
   
        
add_16: 
        ;display the message to read the first term
 in1_16_add:
        cmp [isER], 't'
        jnz cnt_add_16_1
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_add_16_1: 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_16  
        int 21h
        
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read the first term (num per num)
        call InputNo_16  ;the input result (our num) is in dx
        mov [op1], dx 
         
        ;display the message to read the second term
 in2_16_add:
        cmp [isER], 't'
        jnz cnt_add_16_2
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_add_16_2: 
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_16
        int 21h
         
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read one num separatly
        call InputNo_16  ;the input result (our num) is in dx
        mov [op2], dx
        
        
        ;executing the operation (addition) and puting the rslt in dx        
        add dx,op1
        
        call DispOvflow 
        
        ;storing the rslt in stack
        push dx
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h
        
        mov dx, op1
        mov cx,4096 
        call View_16 
        
        mov ah, 2h
        mov dx, '+'
        int 21h
        
        mov dx, op2
        mov cx,4096 
        call View_16 
        
        mov ah, 02h
        mov dx, '='
        int 21h
        
        mov cx, 4096
        pop dx
        call View_16
        
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        mov ah, 0h
        int 16h
        
        cmp al, 's'
        jz hex_op
        
        cmp al, 'S'
        jz hex_op
        
        
        cmp al, 'o'
        jz readB
        
        cmp al, 'O'
        jz readB 
                
        jmp exit         


sub_16:
        
in1_16_sub:
        ;display the message to read the first term
        cmp [isER], 't'
        jnz cnt_sub_16_1
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_sub_16_1: 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_16  
        int 21h
        
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read the first term (num per num)
        call InputNo_16  ;the input result (our num) is in dx
        mov [op1], dx 
        push dx
         
        ;display the message to read the second term
 in2_16_sub:
        cmp [isER], 't'
        jnz cnt_sub_16_2
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_sub_16_2: 
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_16
        int 21h
         
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read one num separatly
        call InputNo_16  ;the input result (our num) is in dx
        mov [op2], dx
        
        pop dx ;;get op1 and put it in dx
        ;executing the operation (substraction) and puting the rslt in dx        
        sub dx,[op2] 
        
        call DispOvflow
        
        ;storing the rslt in stack
        push dx
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h
        
        mov dx, op1
        mov cx,4096 
        call View_16 
        
        mov ah, 2h
        mov dx, '-'
        int 21h
        
        mov dx, op2
        mov cx,4096 
        call View_16 
        
        mov ah, 02h
        mov dx, '='
        int 21h
        
        mov cx, 4096
        pop dx
        call View_16
        
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        mov ah, 0h
        int 16h
        
        cmp al, 's'
        jz hex_op
        
        cmp al, 'S'
        jz hex_op
        
        
        cmp al, 'o'
        jz readB
        
        cmp al, 'O'
        jz readB 

        jmp exit         


mul_16:

in1_16_mul:
        ;display the message to read the first term
        cmp [isER], 't'
        jnz cnt_mul_16_1
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_mul_16_1: 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_16  
        int 21h
        
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read the first term (num per num)
        call InputNo_16  ;the input result (our num) is in dx
        mov [op1], dx 
         
        ;display the message to read the second term
 in2_16_mul:
        cmp [isER], 't'
        jnz cnt_mul_16_2
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_mul_16_2: 
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_16
        int 21h
         
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read one num separatly
        call InputNo_16  ;the input result (our num) is in dx
        mov [op2], dx
        
        ;putting the second operator in the accumulator
        mov ax, [op2]
        
        
        ;executing the operation (multiplication) and puting the rslt in dx        
        mul [op1]  
        
        call DispOvflow_mul
        
        ;storing the rslt in stack
        push ax
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h 
        
        ;display the first term
        mov dx, op1
        mov cx,4096 
        call View_16 
        
        ;display the sign
        mov ah, 2h
        mov dx, '*'
        int 21h
        
        ;display the second term
        mov dx, op2
        mov cx,4096 
        call View_16 
        
        ;display '='
        mov ah, 02h
        mov dx, '='
        int 21h
        
        ;display the result
        mov cx, 4096
        pop dx
        call View_16
        
        ;display the message to repeat the operations
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        ;reading the answer
        mov ah, 0h
        int 16h
        
        ;still at the same base
        cmp al, 's'
        jz hex_op
        
        cmp al, 'S'
        jz hex_op
        
        ;go to another base
        cmp al, 'o'
        jz readB
        
        cmp al, 'O'
        jz readB 

        jmp exit


div_16:

in1_16_div:
        ;display the message to read the first term
        cmp [isER], 't'
        jnz cnt_div_16_1
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_div_16_1: 
        mov [caseOP], 1
        mov ah,09h  
        lea dx, msg1_16  
        int 21h
        
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read the first term (num per num)
        call InputNo_16  ;the input result (our num) is in dx
        mov [op1], dx
         
         
        ;display the message to read the second term
 in2_16_div:
        cmp [isER], 't'
        jnz cnt_div_16_2
        pop dx  ;return the adress of the error procedure in case of error
        
cnt_div_16_2: 
        mov [caseOP], 2
        mov ah,9h
        lea dx, msg2_16
        int 21h
         
        ;intialize cx to 0, it will be incremented in InputNo
        mov cx,0h 
        ;calling InputNp that read one num separatly
        call InputNo_16  ;the input result (our num) is in dx 
        

        cmp dx, 0 
        
        ;verify division over 0
        jne Cte_16 
        call DispDiv0
        jmp cnt_div_16_2 
        
Cte_16:  ;putting the value of dx in op2 for display later
        mov [op2], dx
        
        
        mov cx, [op2] ;; or dx 
        
        ;clearing dx before the division it will be considered as part of the dividend
        xor dx, dx  

        
        ;putting the second operator in the accumulator
        mov ax, [op1]
        
        ;set dx to 0 to avoid overflow
        mov dx, 0
        ;executing the operation (division) and puting the rslt in dx        
        div [op2]
        
        call DispOvflow_mul 
        
        
        ;storing the rslt in stack
        push ax  
        
        ;display the rslt message 
        mov ah,9
        lea dx, msg_rslt
        int 21h 
        
        ;display the first term
        mov dx, op1
        mov cx,4096 
        call View_16 
        
        ;display the sign
        mov ah, 2h
        mov dx, '/'
        int 21h
        
        ;display the second term
        mov dx, op2
        mov cx,4096 
        call View_16 
        
        ;display '='
        mov ah, 02h
        mov dx, '='
        int 21h
        
        ;display the result
        mov cx, 4096
        pop dx
        call View_16
        
        ;display the message to repeat the operations
        mov ah, 9h
        lea dx, msg_rtr
        int 21h
        
        ;reading the answer
        mov ah, 0h
        int 16h
        
        ;still at the same base
        cmp al, 's'
        jz hex_op
        
        cmp al, 'S'
        jz hex_op
        
        ;go to another base
        cmp al, 'o'
        jz readB
        
        cmp al, 'O'
        jz readB 

        jmp exit 



InputNo_16:
        
        mov cnt, 4

start_InputNo_16:

        
        ;read one key press using int 21    
        mov ah,1h
        int 21h 
        
        
        call err_16
        ;intiallization    
        mov dx,0  
        mov bx,1 
        
        ;verfy the enter key which indicate the end of entering the num 
        cmp al,0dh
        ;if it's the enter key then this mean we already have our number 
        ;stored in the stack, so we will return it back using FormNo
        je FormNo_16 
        

        ;convert the num in ascii code stored in al to a hex num
        cmp al, 3Ah
        jb isDec
        sub al, 37h
        jmp isHex
        
           
isDec:  sub ax,30h
         
isHex:  ;clean ah before push it to the stack bec we need al only
        mov ah,0
        ;push the contents of ax to the stack 
        push ax
        
        ;counter for the number of digit  
        inc cx
        dec cnt
        
        ;check if we reached the max num of digits which is 4
        cmp cnt, 0        
        je FormNo_16 
           
        jmp start_InputNo_16         
        
        ret 
        
        
;we took each number separatly so we need to form our number 
;and store in one bit for example if our number 235
FormNo_16:
            ;get the num in the head of the stack  and store it in ax    
            pop ax 
            
            
            push dx
            ;multiplay the digit in ax by the base in bx and store the new part in ax   
            mul bx 
            pop dx
            
            ;add the new part to our cumule 
            add dx,ax
            
            ;store the last base in ax for multiplaying using acc ax=1
            mov ax,bx
            ;update the base by 16 to prepare the other term of mul to get the next base     
            mov bx,16
            
            push dx
            ;get the next base ->ax =16 and store it in bx
            mul bx
            pop dx
            
            ;store the result of mul (next base) in bx =160 to prepare it for next unit
            mov bx,ax
            
            
            
            ;decrement one digit
            dec cx 
            
            cmp cx, 6
            ja err_16
            
            cmp cx,0
            jne FormNo_16
            ret 
         
        

View_16:    ;initialize the boolean var
            mov bool, 0
            
            ;if the hole num is 0
            cmp dx, 0
            jne start_View_16
            
            ;display the zero alone
            mov ah, 2h
            
            push dx
            mov dl, 30h
            int 21h
            pop dx  
            
start_View_16:
            ;the input is in dx, we store it in ax
            mov ax,dx   
            
            ;intitialization
            mov dx,0   ;to clean dh in order to push it
            ;get the digit in the last right  d/4096
            ;the digit in the right is in ax so we will convert it
            div cx     
            
            cmp ax, 0
            jne isNot_0_16
            
            cmp bool, 0
            je cnt_View_16
            
isNot_0_16: mov bool, 1

            ;display the caracter
            call ViewNo_16  
cnt_View_16:
            ;store the rest in dx to bx
            mov bx,dx
            ;clean dx from the rest 
            mov dx,0 
            
            ;prepare for delete on zero from 4096, moving it to ax
            mov ax,cx
            ;prepare the other term
            mov cx,16
            div cx
            
            ;store the rest of the number in dx to prepare it for next div
            mov dx,bx
            ;stotre the new big base 
            mov cx,ax 
            
            ;verify the loop
            cmp ax,0
            jne start_View_16
            ret
       
ViewNo_16: 

           ;save the content of ax and dx
           push ax 
           push dx 
           
           ;mov the digit in ax to dx to display it wit int 21h
           mov dx,ax
           cmp dl, 0ah
           jb CnvisDec
           add dl, 37h
           jmp CntisHex 
CnvisDec:  add dl,30h ;add 30 to its value to convert it back to ascii
CntisHex:  mov ah,2
           int 21h
           pop dx  
           pop ax
           ret      
 
        jmp exit


;===================================================================================================
;reading and displaying the base prcedure

read_base:
            ;display the the first message of base
            mov ah, 09h
            lea dx, msg_base
            int 21h


            ;reading the base
            mov ah,0                       
            int 16h 
            mov [base], al
             
            jmp dispBsCode
            
               
            
         m2:
            mov dx, ax
            int 21h
            call delay
            mov ah, 9h
            lea dx, base2
            int 21h
            call delay
            ret    
            
        m10:
            mov dx, ax
            int 21h
            ;call delay
            mov ah, 9h
            lea dx, base10
            int 21h
            ;call delay
            ret
            
        m16:
            mov dx, ax
            int 21h
            call delay
            mov ah, 9h
            lea dx, base16
            int 21h
            call delay
            ret   
            
  dispBsCode:mov ah, 2h
            cmp al, 'b'
            jz m2
            
            
            cmp al, 'd' 
            jz m10
            
            
            
            cmp al, 68H             
            jz m16
            
            mov ah, 02h
            mov dx, ax
            int 21h
            call delay
            
            call invalid_input
            jmp read_base 
            
            
;read and display the signe
read_sign:
            mov ah, 09h
            lea dx, msg_op  
            int 21h 
            
            mov ah, 1h
            int 21h
            mov [sign], al
                 
            
            cmp al, '+'
            jz end_read_s
            
            cmp al, '-'
            jz end_read_s 
            
            cmp al, '*'
            jz end_read_s 
            
            cmp al, '/'
            jz end_read_s
            
           ; cmp al, '%'
           ; jz end_read_s
            
            call delay
            call invalid_input
            jmp read_sign 
end_read_s: ret
 
 
 
 
 
 
;error procedure of the base 2
            
err_2:
            mov [isER], 'f'     
            cmp al, '0'
            jz end_err_2
        
            cmp al, '1'
            jz end_err_2
            
            cmp al, 0dh
            jz end_err_2
            
            
            call invalid_input
            call delay
            mov [isER], 't'
            
            
errSigns_2: cmp sign, '+'
            jz errAdd_2
            
            cmp sign, '-'
            jz errSub_2
            
            cmp sign, '*'
            jz errMul_2
            
            cmp sign, '/'
            jz errDiv_2

             
errAdd_2:   cmp [caseOP], 1 
            jz in1_2_add
            jmp in2_2_add
            
errSub_2 :  cmp [caseOP], 1 
            jz in1_2_sub
            jmp in2_2_sub
            
errMul_2:   cmp [caseOP], 1 
            jz in1_2_mul
            jmp in2_2_mul
            
errDiv_2:   cmp [caseOP], 1 
            jz in1_2_div
            jmp in2_2_div

  
end_err_2:  ret 
 
 
  
  
  
;error precedure of base 10
            
err_10:
            ;initialize isER by 'f'
            mov [isER], 'f' 
            
            cmp al, 0dh
            jz end_err_10
                
            cmp al, '0'
            jz end_err_10
        
            cmp al, '1'
            jz end_err_10
        
            cmp al, '2'
            jz end_err_10
        
            cmp al, '3'
            jz end_err_10
        
            cmp al, '4'
            jz end_err_10
        
            cmp al, '5'
            jz end_err_10
        
            cmp al, '6'        
            jz end_err_10
            
            cmp al, '7'             
            jz end_err_10
        
            cmp al, '8'             
            jz end_err_10        
            
            cmp al, '9'
            jz end_err_10
             
              
            call invalid_input
            call delay
            mov [isER], 't'
            
            
errSigns_10:cmp sign, '+'
            jz errAdd_10
            
            cmp sign, '-'
            jz errSub_10
            
            cmp sign, '*'
            jz errMul_10
            
            cmp sign, '/'
            jz errDiv_10


errAdd_10:  cmp [caseOP], 1 
            jz in1_10_add
            jmp in2_10_add
            
errSub_10:  cmp [caseOP], 1 
            jz in1_10_sub
            jmp in2_10_sub
            
errMul_10:  cmp [caseOP], 1 
            jz in1_10_mul
            jmp in2_10_mul

errDiv_10:  cmp [caseOP], 1 
            jz in1_10_div
            jmp in2_10_div

  
end_err_10:ret     



 
;error precedure of base 16
            
err_16:
            ;initialize isER by 'f'
            mov [isER], 'f'  
            
            
            cmp al, 0dh
            jz end_err_16
               
            cmp al, '0'
            jz end_err_16
        
            cmp al, '1'
            jz end_err_16
        
            cmp al, '2'
            jz end_err_16
        
            cmp al, '3'
            jz end_err_16
        
            cmp al, '4'
            jz end_err_16
        
            cmp al, '5'
            jz end_err_16
        
            cmp al, '6'        
            jz end_err_16
            
            cmp al, '7'             
            jz end_err_16
        
            cmp al, '8'             
            jz end_err_16        
            
            cmp al, '9'
            jz end_err_16
            
            cmp al, 'A'
            jz end_err_16
            
            cmp al, 'B'
            jz end_err_16
            
            cmp al, 'C'
            jz end_err_16
            
            cmp al, 'D'
            jz end_err_16
            
            cmp al, 'E'
            jz end_err_16
            
            cmp al, 'F'
            jz end_err_16
            
                        
            call invalid_input
            call delay
            mov [isER], 't'
            
            
errSigns_16:   cmp sign, '+'
            jz errAdd_16
            
            cmp sign, '-'
            jz errSub_16
            
            cmp sign, '*'
            jz errMul_16
            
            cmp sign, '/'
            jz errDiv_16

             
errAdd_16:  cmp [caseOP], 1 
            jz in1_16_add
            jmp in2_16_add
            
errSub_16:  cmp [caseOP], 1 
            jz in1_16_sub
            jmp in2_16_sub
            
errMul_16:  cmp [caseOP], 1 
            jz in1_16_mul
            jmp in2_16_mul

errDiv_16:  cmp [caseOP], 1 
            jz in1_16_div
            jmp in2_16_div


  
 end_err_16:ret     
 
 
 
 
 DispDiv0:
        
            mov ah, 09h
            lea dx, msg_Div0
            int 21h
            ret            
                                       
DispOvflow:
            jc isof 
            ret
       isof:mov ah, 9
            lea dx, msg_of
            int 21h  
            clc
            ret
            
DispOvflow_mul: 
            jo isof_mul 
            ret
       isof_mul:mov ah, 9
            lea dx, msg_of
            int 21h
            clc 
            ret
            
                       

            
            
delay:
            mov cx, 02Fh  
delay_loop:
            
            dec cx          
            jnz delay_loop  
            ret                        


; Error handling
invalid_input:
            mov ah, 09h
            lea dx, msg_err
            int 21h 
            ret
            

; Exit program
exit: 
        mov ah, 09h
        lea dx, msg_exit
        int 21h 
        
        call delay
        call delay 
        call delay
        
        mov ah, 4cH
        int 21h

end start        
