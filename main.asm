option casemap:none
WriteConsoleA proto
ReadConsoleA proto
Sleep proto
GetStdHandle proto
GetTickCount proto
ExitProcess proto
SetConsoleCursorPosition proto
.data
number DD ?
number_string DB 10 DUP(0)
space_string DB "                                                          "
sum DD ?
user_string DB 10 DUP(0)
user_number DD ?
amount_delay DD 1000
amount_exercises DD 1
handle_input QWORD ?
handle_output QWORD ?
digits DD 2
chars_written QWORD ?
stack_save QWORD ?
string1 DB "Enter amount of digits (1-5): "
string2 DB "Enter amount of delay in miliseconds: "
string3 DB "Enter amount of exersises: "
string4 DB "Enter your answer: "
correct DB "CORRECT"
wrong DB "WRONG"
again DB "again = 1 ,other = exit "
good_bay DB "Good Bay"
.code
	main proc
		mov rcx,-11
		call GetStdHandle
		mov handle_output,rax
		mov rcx,-10
		call GetStdHandle
		mov handle_input,rax
		run_main2:
		mov sum,0
		call get_info
		run_main:
			mov r14,0
			mov r14d,digits
			call generate_random
			mov r14,0
			mov r14d,digits
			mov r13,0
			call print_number
			mov r14,0
			mov r14d,digits
			call generate_random
			mov r14,0
			mov r14d,digits
			mov r13,6
			call print_number
			dec amount_exercises
			cmp amount_exercises,0
			jne run_main
		call check
		mov rcx,5000
		call Sleep
		call ask
		cmp number,1
		je run_main2
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		mov rsi,offset space_string
		mov rbx,50
		call print_string
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		mov rsi,offset good_bay
		mov rbx,8
		call print_string
		mov rcx,0
		call ExitProcess
	main endp

	generate_random proc
		pop r11
		mov stack_save,r11
		mov number,0
		mov ebx,9
		mov rsi,offset number_string
		run_gen:
			mov rcx,7
			call Sleep
			mov rax,0
			mov rdx,0
			call GetTickCount
			div ebx
			inc edx
			mov r15d,edx
			mov al,dl
			add al,48
			mov [rsi],al
			mov rax,0
			mov rdx,0
			mov eax,number
			mul ebx
			add eax,r15d
			mov number,eax
			inc rsi
			dec r14
			jnz run_gen
		mov byte ptr[rsi],0
		mov eax,number
		add sum,eax
		mov r11,stack_save
		push r11
		ret
	generate_random endp

	print_number proc
		pop r11
		mov stack_save,r11
		mov rcx,handle_output
		mov rdx,r13
		call SetConsoleCursorPosition
		mov rcx,handle_output
		mov rdx,offset number_string
		mov r8,r14
		lea r9,chars_written
		push 0h
		call WriteConsoleA
		pop rcx
		mov rcx,0
		mov ecx,amount_delay
		call Sleep
		mov rcx,handle_output
		mov rdx,r13
		call SetConsoleCursorPosition
		mov rcx,handle_output
		mov rdx,offset space_string
		mov r8,10
		lea r9,chars_written
		push 0h
		call WriteConsoleA
		pop rcx
		mov r11,stack_save
		push r11
		ret
	print_number endp

	get_info proc
		pop r11
		mov stack_save,r11
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		mov rsi,offset space_string
		mov rbx,50
		call print_string
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		lea rsi,string3
		mov rbx,27
		call print_string
		call input_string
		mov eax,number
		mov amount_exercises,eax
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		lea rsi,string1
		mov rbx,30
		call print_string
		call input_string
		mov eax,number
		mov digits,eax
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		lea rsi,string2
		mov rbx,38
		call print_string
		call input_string
		mov eax,number
		mov amount_delay,eax
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		mov rsi,offset space_string
		mov rbx,50
		call print_string
		mov r11,stack_save
		push r11
		ret
	get_info endp

	print_string proc
		mov rcx,handle_output
		mov rdx,rsi
		mov r8,rbx
		mov r9,offset chars_written
		push 0h
		call WriteConsoleA
		pop r9
		ret
	print_string endp

	input_string proc
		mov rcx,handle_input
		mov rdx,offset user_string
		mov r8,10
		mov r9,offset chars_written
		push 0h
		call ReadConsoleA
		pop r9
		mov rsi,offset user_string
		input_run:
			inc rsi
			cmp byte ptr[rsi],0
			jne input_run
		dec rsi
		mov byte ptr[rsi],0
		dec rsi
		mov byte ptr[rsi],0
		mov rsi,offset user_string
		mov number,0
		mov ebx,10
		input_run2:
			mov rax,0
			mov rdx,0
			mov eax,number
			mul ebx
			mov number,eax
			mov eax,0
			mov al,[rsi]
			sub al,48
			add number,eax
			inc rsi
			cmp byte ptr[rsi],0
			jne input_run2
		mov rsi,offset user_string
		mov rcx,10
		input_run3:
			mov byte ptr [rsi],0
			inc rsi
			loop input_run3
		ret
	input_string endp

	check proc
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		mov rsi,offset string4
		mov rbx,19
		call print_string
		call input_string
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		mov rsi,offset space_string
		mov rbx,50
		call print_string
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		mov eax,number
		cmp eax,sum
		jne check2
		mov rsi,offset correct
		mov rbx,7
		call print_string 
		ret
		check2:
		mov rsi,offset wrong
		mov rbx,5
		call print_string
		ret
	check endp

	ask proc
		mov rcx,handle_output
		mov rdx,0
		call SetConsoleCursorPosition
		mov rsi,offset again
		mov rbx,24
		call print_string
		call input_string
		ret
	ask endp
end