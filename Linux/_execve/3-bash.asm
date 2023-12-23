SYS_EXEC equ 0xb
SYS_EXIT equ 1
NORMAL_EXIT equ 0

global _start
section .text
_start:				;ld Entry Point
	jmp callbash
main:
	pop esi			;Holds address of "/bin/sh"
	push 0			;args[1] -> NULL
	push esi		;args[0] -> "/bin/sh"

	mov eax, SYS_EXEC	;syscall number
	mov ebx, esi		;Param#1 -> "/bin/sh"
	mov ecx, esp		;Param#2 -> Addr of array
	mov edx, 0		;Param#3 -> NULL
	int 80h			;Kernel Interrupt

exit:
	mov eax, SYS_EXIT	;Exit Code
	mov ebx, NORMAL_EXIT	;Exit Status
	int 80h			;Kernek Interrupt

callbash:
	call main		;push next addr onto stack
	db "/bin/sh",0
