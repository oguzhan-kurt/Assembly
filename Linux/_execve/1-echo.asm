;execve("/bin/echo",{"/bin/echo","test",NULL},NULL);

SYS_EXECVE equ 0xb
SYS_EXIT equ 1

GLOBAL _start
section .text

_start:
	xor eax, eax

	;Big-Endian "////bin/echo"
	push eax
	push 0x6F686365		;Big-Endian "echo"
	push 0x2F6E6962		;Big-Endian "bin/"
	push 0x2F2F2F2F		;////

	mov ebx, esp		;"////bin/echo" move to ebx

	push eax		; argv[2] --> NULL
	push 0x74736574		; argv[1] --> "test"

	mov esi, esp		;"test" move to esi

	push eax		;Parameter #3 --> NULL
	push esi		;Parameter #2 --> arg[]
	push ebx		;Parameter #1 --> "/bin/echo"

	;call execve
	mov eax, SYS_EXECVE
	mov ecx, esp
	int 80h

exit:
	mov eax, SYS_EXIT	;syscall
	mov ebx, 1		;Normal Exit
	int 80h			;Kernel Interrupt
