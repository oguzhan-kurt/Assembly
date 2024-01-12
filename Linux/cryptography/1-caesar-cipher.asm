GLOBAL _start
SYS_WRITE equ 4
SYS_READ  equ 3
SYS_EXIT  equ 1
STDOUT	  equ 1
STDIN     equ 0

section .data
	inputMessage db "Plain Text : ",0
	len1 equ $-inputMessage
	shiftMessage db "Enter a Shift Number : ",0
	len2 equ $-shiftMessage
	count db 0


section .bss
	buffer resb 32
	shift  resb 4

section .text
_start:
	;Print Input Message to Console
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, inputMessage
	mov edx, len1
	int 80h

	;Get Plain Text from user
	mov eax, SYS_READ
	mov ebx, STDIN
	mov ecx, buffer
	int 80h

	;Print Shift Message to Console
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, shiftMessage
	mov edx, len2
	int 80h

	;Get Shift value from user
	mov eax, SYS_READ
	mov ebx, STDIN
	mov ecx, shift
	mov edx, 1
	int 80h

	;Convert ASCII Value to Integer
	mov eax, [shift]
	sub eax, '0'
	mov [shift], eax

	;Index of plain text
	mov esi, 0

	;Reset registers
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx


	;Start Cipher
iteration:
        mov al, [buffer + esi]		;Load the value of the memory location pointed by buffer+ESI into AL
	test al, al			;Check if the value loaded is zero
	je next				;If it is zero, exit the loop
        add al, [shift]			;If not, Add the value in shift to AL
        mov [buffer + esi], al		;Store the modified value back into the memory location buffer + esi
        inc esi				;Increment the pointer esi to move to the next element in the buffer
        inc byte[count]			;Increment the count variable to track the number of iterations
        jmp iteration			;Jump back to the beginning of the iteration

next:

	;Print Encrypted Text to Console
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, buffer
	mov edx, count
	int 80h

	;New Line
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, 10
	mov edx, 1
	int 80h

	;Exit Program
exit:
	mov eax, SYS_EXIT
	xor ebx, ebx
	int 80h












