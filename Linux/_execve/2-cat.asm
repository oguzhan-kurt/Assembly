;execve("/bin/cat",{"/bin/cat","/etc/passwd",NULL},NULL);

SYS_EXECVE equ 0xb
SYS_EXIT equ 1
NORMAL_EXIT equ 0

GLOBAL _start

section .text
_start:
	xor eax, eax
	push eax

	;Big Endian->/bin/cat
	push 0x7461632F		;/cat -- big endian
	push 0x6E69622F		;/bin -- big endian

	mov ebx, esp		;/bin/cat

	push eax		;NULL third arg

	;Big Endian->/etc//passwd
	push 0x64777373		;sswd
	push 0x61702F2F		;//pa
	push 0x6374652F		;/etc

	mov esi, esp		;/etc/passwd

	push eax
	push esi
	push ebx

	mov ecx, esp

	mov eax, 0xb		;SYS_EXECVE
	int 80h			;Interrupt

exit:
	mov eax, 1		;SYS_EXIT
	mov ebx, 0		;NORMAL EXIT
	int 80h			;INTERRUPT
