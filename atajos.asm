;atajos 
PrintN macro Num    
    xor ax,ax
    mov dl,Num
    add dl,48
    mov ah,02h
    int 21h
endm

Print16 macro Regis 
    local zero,noz
    mov bx,4    
    xor ax,ax   
    mov ax,Regis   
    mov cx,10  
    zero:
        xor dx,dx  
        div cx 
        push dx 
        dec bx 
        jnz zero    
        xor bx,4    
    noz:
        pop dx 
        PrintN dl   
        dec bx  
        jnz noz 
endm




GetPrint macro buffer
	MOV AX,@data
	MOV DS,AX
	MOV AH,09H
	MOV DX,OFFSET buffer
	INT 21H
endm



GetInput macro 
	MOV AH,01H 
	int 21H
endm

GetInputMax macro cadena
	mov ah, 3fh 					
	mov bx, 00 						
	mov cx, 20 						
	mov dx, offset[cadena]
	int 21h
endm



;;; automata 

GetShow macro txt, operator, bufferInfo, operatorAux
	local Lsalida, Lh, Lo, Lw, Lsave, Lpalabra, Lsalida2, Lsalida3
	
	push ax
  	push si
  	push di 

  	xor si, si 
	xor di, di 
	xor ax, ax

	cmp txt[si], 73H 
    je Lh
	cmp txt[si], 53H 
    je Lh	
    jmp Lsalida	

    Lh:	

    	inc si
    	cmp txt[si], 68H 
	    je Lo
		cmp txt[si], 48H 
	    je Lo
    	jmp Lsalida

	    Lo:

    		inc si
	    	cmp txt[si], 6FH 
		    je Lw
			cmp txt[si], 4FH 
		    je Lw
	    	jmp Lsalida

	    	Lw:

	    		inc si
		    	cmp txt[si], 77H 
			    je Lsave
				cmp txt[si], 57H 
			    je Lsave
		    	jmp Lsalida

				Lsave:

					inc si
					cmp txt[si], 20H 
					je Lsave
					xor ax, ax
					mov al, txt[si]
					mov operator[DI], al
					jmp Lpalabra

				Lpalabra:
					inc si
					INC DI
					xor ax, ax
					mov al, txt[si]				
					cmp txt[si], 24H 
					cmp txt[si], 0Ah 
					je Lsalida2
					cmp txt[si], 08H 
					je Lsalida2					
					mov operator[DI], al					
					jmp Lpalabra

	Lsalida2:
		mov operator[DI], 24h
		Analyzer bufferInfo, operator, operatorAux
		
		jmp Lsalida

    Lsalida:

  		pop di 
  		pop si
  		pop ax

endm


Int_String macro intNum
  local div10, signoN, unDigito, obtenerDePila
  push ax
  push bx
  push cx
  push dx
  push si
  xor si,si
  xor cx,cx
  xor bx,bx
  xor dx,dx
  mov bx,0ah 				
  test ax,1000000000000000 	
  jnz signoN
  unDigito:
      cmp ax, 0009h
      ja div10
      mov intNum[si], 30h 	
      inc si
      jmp div10
  signoN:					 
  	  neg ax 				
  	  mov intNum[si], 2dh 	
  	  inc si
  	  jmp unDigito
  div10:
      xor dx, dx 			
      div bx 				
      inc cx 				
      push dx 				
      cmp ax,0h 			
      je obtenerDePila
	  jmp div10
  obtenerDePila:
      pop dx 				
      add dl,30h 			
      mov intNum[si],dl 	
      inc si
      loop obtenerDePila
      mov ah, '$' 			
      mov intNum[si],ah      						
      pop si
      pop dx
      pop cx
      pop bx
      pop ax
endm


String_Int macro stringNum
  local ciclo, salida, verificarNegativo, negacionRes
  push bx
  push cx
  push dx
  push si 
  xor ax, ax
  xor bx, bx
  xor dx, dx
  xor si, si
  mov bx, 000Ah						
  ciclo:
      mov cl, stringNum[si]
      inc si
      cmp cl, 2Dh 					
      jz ciclo    					
      cmp cl, 30h 					
      jb verificarNegativo 			
      cmp cl, 39h 					
      ja verificarNegativo
  	  sub cl, 30h					
  	  mul bx      					
      mov ch, 00h
   	  add ax, cx  					
  	  jmp ciclo
  negacionRes:
      neg ax 						
      jmp salida
  verificarNegativo: 
      cmp stringNum[0], 2Dh 		
      jz negacionRes
  salida:
      								
      pop si
      pop dx
      pop cx
      pop bx
endm



Analyzer macro txt, compare, operator
	local Lsalida, Ls1, L0, L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11, L12, L13, L14, L15, L16, L17, L18, L19, L20, L21, L22, L23, L24, L25, L26, L27, L28, L200, L700, L110, L150, L170, L180
	

	push ax
  	push si
  	push di 

  	xor si, si 
	xor di, di 
	xor ax, ax


	cmp txt[si], 7bh 
	je L0

	Ls1:
		inc si
		cmp txt[si], 7bh 
		je L0
		jmp Ls1

	L0:
		inc si
		xor di, di
		cmp txt[si], 22h 
		je L1
		jmp L0

	L1: 

		inc si
		xor ax, ax
		mov al, txt[si]

		cmp txt[si], 22h 
		je L28
		mov _padre[di], al
		inc di

		jmp L1

	L28:
		mov _padre[di], "$"
		xor di, di
		jmp L2
	L2:

		inc si
		cmp txt[si], 3Ah 
		je L3

		jmp L2

	L3:
		inc si
		cmp txt[si], 5Bh 
		je L4

		jmp L3

	L4: 
		inc si
		cmp txt[si], 7Bh 
		jne L4
		jne L5
		jmp L5

	L5: 

		inc si
		cmp txt[si], 22h 
		jne L5
		xor di, di
		je L6

		jmp L5

	L6: 

		inc si

		xor ax, ax
		mov al, txt[si]

		cmp txt[si], 22h 
		je L700

		mov operator[di], al
		inc di
		
		jmp L6

	L700:

		mov operator[di], 24h
		xor di, di
		
	
		jmp L7
	L7:
		
		inc si
		cmp txt[si], 3AH 
		je L8

		jmp L7

	L8: ;
		inc si
		cmp txt[si], 7BH 
		je L9

		jmp L8

	L9: 

		inc si
		cmp txt[si], 22H 
		je L10
		
		jmp L9

	L10: 

		inc si

		xor ax, ax
		mov al, txt[si]
		cmp txt[si], 22H 
		je L110
		
		mov _aritmethic[di], al
		inc di
		jmp L10

	L110:
		mov _aritmethic[di], 24h
		xor di, di
		
		jmp L11
	L11:

		inc si
		cmp txt[si], 3AH 
		je L12

		jmp L11

	L12:
		inc si
		cmp txt[si], 7BH 
		je L13

		jmp L12
	
	L13: 

		inc si
		cmp txt[si], 22H 
		je L14
		
		jmp L13

	L14: 

		inc si
		xor ax, ax
		mov al, txt[si]

		cmp txt[si], 22H 
		je L150
		
		mov _num1S[di], al
		inc di
		jmp L14

	L150:
	mov _num1S[di], 24h
	xor di, di
	
	jmp L15

	L15:

		inc si

		cmp txt[si], 3AH 
		je L16

		jmp L15

	L16:

		inc si
		xor ax, ax
		mov al, txt[si]
		cmp txt[si], 2ch 
		je L170
		mov _num1S[di], al
		inc di
		jmp L16

	L170:
		mov _num1S[di], 24h
		xor di, di
		
		jmp L17

	L17: 

		inc si
		cmp txt[si], 22H 
		je L18
		
		jmp L17

	L18: 

		inc si
		xor ax, ax
		mov al, txt[si]

		cmp txt[si], 22H 
		je L180
		
		mov _num2S[di], al
		inc di
		jmp L18

	L180:
	mov _num2S[di], 24h
	xor di, di
	
	jmp L19

	L19:

		inc si

		cmp txt[si], 3AH 
		je L20

		jmp L19

	L20:
		inc si
		xor ax, ax
		mov al, txt[si]
		cmp txt[si], 0ah 
		je L21
		mov _num2S[di], al
		inc di
		jmp L20
	L21:
		mov _num2S[di], 24h
		xor di, di
		
		jmp L22

	L22:
		getCompare compare, operator
		jmp L23
	L23:
		inc si
		cmp txt[si], 7DH 
		je L24

		jmp L23


	L24:
		inc si
		cmp txt[si], 7DH 
		je L25

		jmp L24


	L25:

		inc si
		cmp txt[si], 7DH 
		je L26

		jmp L25
	
	L26:

		inc si
		
		cmp txt[si], 5dh 
		je L27 

		cmp txt[si], 2ch 
		je L4 

		jmp L26

	L27:

		inc si
		cmp txt[si], 7DH 
		je Lsalida

		jmp Lsalida
	L200:

	Lsalida:
  		pop di 
  		pop si
  		pop ax

endm



getCompare macro compare1, compare2
	local LF, LE, Lsalida, L0, Ldivision, Ldivision0, Lmultiplicacion, Lmultiplicacion0, Lresta, Lresta0, Lsuma, Lsuma0
	push si
	push ax


	xor ax, ax
	xor si, si
	mov al, compare1[si]
	cmp compare2[si], al
	je L0
	jne LF

	L0:
		inc si

		cmp compare2[si], 24h
		je LE

		xor ax, ax
		mov al, compare1[si]
		cmp compare2[si], al
		je L0
		jne LF


		jmp L0

	LE:
		
		

		xor si, si
		; divisón
		cmp _aritmethic[si], 2fh 
		je Ldivision
		cmp _aritmethic[si], 64h 
		je Ldivision0
		; multiplicación
		cmp _aritmethic[si], 2ah 
		je Lmultiplicacion
		cmp _aritmethic[si], 6dh 
		je Lmultiplicacion0
		; resta
		cmp _aritmethic[si], 2dh 
		je Lresta
		cmp _aritmethic[si], 73h 
		je Lresta0
		; suma
		cmp _aritmethic[si], 2bh 
		je Lsuma
		cmp _aritmethic[si], 61h 
		je Lsuma0
		

		Ldivision0:
			inc si
			cmp _aritmethic[si], 69h 
			jne Lsalida

			inc si
			cmp _aritmethic[si], 76h 
			jne Lsalida

			jmp Ldivision
		

		Lmultiplicacion0:
			inc si
			cmp _aritmethic[si], 75h 
			jne Lsalida

			inc si
			cmp _aritmethic[si], 6ch 
			jne Lsalida

			jmp Lmultiplicacion

		Lresta0:

			inc si
			cmp _aritmethic[si], 75h 
			jne Lsalida

			inc si
			cmp _aritmethic[si], 62h 
			jne Lsalida

			jmp Lresta

		Lsuma0:

			inc si
			cmp _aritmethic[si], 64h 
			jne Lsalida

			inc si
			cmp _aritmethic[si], 64h 
			jne Lsalida

			jmp Lsuma0




		Ldivision:
			xor ax, ax
			String_Int _num1S
			mov _numero1, ax
			GetMayor _numero1
			GetMenor _numero1

			xor ax, ax
			String_Int _num2S
			mov _numero2, ax
			GetMayor _numero2
			GetMenor _numero2


			mov ax,_numero1    
	        cwd                 
	        mov bx,_numero2    
	        idiv bx             

	        mov _calcuResultado,ax  
	        Int_String _numResult 

	        GetPrint _salto
	        GetPrint _RESULT
	        GetPrint compare1
	        GetPrint _salto
	        GetPrint _numResult

			jmp Lsalida

		Lmultiplicacion:
			xor ax, ax
			String_Int _num1S
			mov _numero1, ax
			GetMayor _numero1
			GetMenor _numero1

			xor ax, ax
			String_Int _num2S
			mov _numero2, ax
			GetMayor _numero2
			GetMenor _numero2

			mov ax, _numero1
	        mov bx, _numero2
	        imul bx
	        mov _calcuResultado,ax
	        mov ax,_calcuResultado
	        Int_String _numResult 

	        GetPrint _salto
	        GetPrint _RESULT
	        GetPrint compare1
	        GetPrint _salto
	        GetPrint _numResult

			jmp Lsalida

		Lresta:
			xor ax, ax
			String_Int _num1S
			mov _numero1, ax
			GetMayor _numero1
			GetMenor _numero1


			xor ax, ax
			String_Int _num2S
			mov _numero2, ax
			GetMayor _numero2
			GetMenor _numero2


			mov dx, _numero1
	        sub dx, _numero2
	        mov _calcuResultado, dx
	        mov ax, _calcuResultado
	        Int_String _numResult 

	        GetPrint _salto
	        GetPrint _RESULT
	        GetPrint compare1
	        GetPrint _salto
	        GetPrint _numResult

			jmp Lsalida

		Lsuma:
			xor ax, ax
			String_Int _num1S
			mov _numero1, ax
			GetMayor _numero1
			GetMenor _numero1


			xor ax, ax
			String_Int _num2S
			mov _numero2, ax
			GetMayor _numero2
			GetMenor _numero2


			mov dx, _numero1
	        add dx, _numero2
	        mov _calcuResultado, dx
	        mov ax, _calcuResultado
	        Int_String _numResult 

	        GetPrint _salto
	        GetPrint _RESULT
	        GetPrint compare1
	        GetPrint _salto
	        GetPrint _numResult

			jmp Lsalida
		
	LF:
		
		jmp Lsalida
	Lsalida:
		pop ax
		pop si

endm

GetMayor macro d1
	Local Lsalida, mayor, Lp
	push ax

	mov ax, d1

	cmp _Mayor, ax
	jg mayor

	jmp Lsalida

	mayor:
		mov _Mayor, ax
		Int_String _MayorS
		
		jmp Lsalida

	Lsalida:
		pop ax
endm


GetMenor macro d1
	Local Lsalida, menor
	push ax

	mov ax, d1
	cmp _Menor, ax
	jl menor

	jmp Lsalida

	menor:
		mov _Menor, ax
		Int_String _MenorS
		
		jmp Lsalida

	Lsalida:
		pop ax
endm


; REPORTE
reporte macro

	mov _reporteHandle,0
	GetCreateFile _createFile, _reporteHandle

	GetWriteFile _reporteHandle, _Reporte0S
	GetWriteFile _reporteHandle, _Reporte1S
	GetWriteFile _reporteHandle, _Reporte2S
	GetWriteFile _reporteHandle, _Reporte3S
	GetWriteFile _reporteHandle, _Reporte4S
	GetWriteFile _reporteHandle, _Reporte5S
	GetWriteFile _reporteHandle, _Reporte6S
	GetWriteFile _reporteHandle, _Reporte7S

	GetWriteDate _reporteHandle

	GetWriteFile _reporteHandle, _Reporte18S

	GetWriteFile _reporteHandle, _Reporte19S
	GetWriteFile _reporteHandle, _MediaS
	GetWriteFile _reporteHandle, _Reporte31S

	GetWriteFile _reporteHandle, _Reporte20S
	GetWriteFile _reporteHandle, _MedianaS
	GetWriteFile _reporteHandle, _Reporte31S

	GetWriteFile _reporteHandle, _Reporte21S
	GetWriteFile _reporteHandle, _MenorS
	GetWriteFile _reporteHandle, _Reporte31S

	GetWriteFile _reporteHandle, _Reporte22S
	GetWriteFile _reporteHandle, _MayorS

	GetWriteFile _reporteHandle, _Reporte25S

	GetWriteFile _reporteHandle, _Reporte28S
	GetWriteFile _reporteHandle, _Reporte29S

	GetCloseFile _reporteHandle

endm



GetShowMayor macro txt
	local Lsalida, Lh, Lo, Lw, Lspace, Lm, La, Ly, Lo1, Lr, mayor
	
	push ax
  	push si
  	push di 

  	xor si, si 
	xor di, di 
	xor ax, ax

	cmp txt[si], 73H 
    je Lh
	cmp txt[si], 53H 
    je Lh	
    jmp Lsalida	

    Lh:	

    	inc si
    	cmp txt[si], 68H 
	    je Lo
		cmp txt[si], 48H 
	    je Lo
    	jmp Lsalida

    Lo:

		inc si
		cmp txt[si], 6FH 
	    je Lw
		cmp txt[si], 4FH 
	    je Lw
		jmp Lsalida

	Lw:

		inc si
    	cmp txt[si], 77H ;
	    je Lspace
		cmp txt[si], 57H ;
	    je Lspace
    	jmp Lsalida

	Lspace:

		inc si
		cmp txt[si], 20H 
		je Lm

		jmp Lsalida

	Lm:
		inc si
		cmp txt[si], 6dh 
		je La
		cmp txt[si], 4dh 
		je La

		jmp Lsalida

	La:
		inc si
		cmp txt[si], 61h 
		je Ly
		cmp txt[si], 41h 
		je Ly

		jmp Lsalida

	

	Ly:
		inc si
		cmp txt[si], 79h 
		je Lo1
		cmp txt[si], 59h 
		je Lo1

		jmp Lsalida

	Lo1:

		inc si
		cmp txt[si], 6FH 
	    je Lr
		cmp txt[si], 4FH 
	    je Lr
		jmp Lsalida

	Lr:
		inc si
		cmp txt[si], 72h 
		je mayor
		cmp txt[si], 52h 
		je mayor

		jmp Lsalida
	
	mayor:
		GetPrint _ResultMayor
		GetPrint _MayorS
		GetPrint _salto

    Lsalida:

  		pop di 
  		pop si
  		pop ax

endm

GetShowMenor macro txt
	local Lsalida, Lh, Lo, Lw, Lspace, Lm, Le, Ln, Lo1, Lr, menor
	
	push ax
  	push si
  	push di 

  	xor si, si 
	xor di, di 
	xor ax, ax

	cmp txt[si], 73H 
    je Lh
	cmp txt[si], 53H 
    je Lh	
    jmp Lsalida	

    Lh:	

    	inc si
    	cmp txt[si], 68H 
	    je Lo
		cmp txt[si], 48H 
	    je Lo
    	jmp Lsalida

    Lo:

		inc si
		cmp txt[si], 6FH 
	    je Lw
		cmp txt[si], 4FH 
	    je Lw
		jmp Lsalida

	Lw:

		inc si
    	cmp txt[si], 77H ;
	    je Lspace
		cmp txt[si], 57H ;
	    je Lspace
    	jmp Lsalida

	Lspace:

		inc si
		cmp txt[si], 20H 
		je Lm

		jmp Lsalida

	Lm:
		inc si
		cmp txt[si], 6dh 
		je Le
		cmp txt[si], 4dh 
		je Le

		jmp Lsalida

	Le:
		inc si
		cmp txt[si], 65h 
		je Ln
		cmp txt[si], 45h 
		je Ln

		jmp Lsalida

	Ln:
		inc si
		cmp txt[si], 6eh 
		je Lo1
		cmp txt[si], 4eh 
		je Lo1

		jmp Lsalida

	Lo1:

		inc si
		cmp txt[si], 6FH 
	    je Lr
		cmp txt[si], 4FH 
	    je Lr
		jmp Lsalida

	Lr:
		inc si
		cmp txt[si], 72h 
		je menor
		cmp txt[si], 52h 
		je menor

		jmp Lsalida
	
	menor:
		GetPrint _ResultMenor
		GetPrint _MenorS
		GetPrint _salto

    Lsalida:

  		pop di 
  		pop si
  		pop ax

endm



GetExit macro txt
	local Lsalida, Lx, Li, Ltt, Lexit
	
	push ax
  	push si
  	push di 

  	xor si, si 
	xor di, di 
	xor ax, ax

	cmp txt[si], 65h 
	je Lx
	cmp txt[si], 45h 
	je Lx

	jmp Lsalida

    Lx:	

    	inc si
    	cmp txt[si], 78H 
	    je Li
		cmp txt[si], 58H 
	    je Li
    	jmp Lsalida

    Li:

		inc si
		cmp txt[si], 69H 
	    je Ltt
		cmp txt[si], 49H 
	    je Ltt
		jmp Lsalida

	Ltt:

		inc si
    	cmp txt[si], 74H 
	    je Lexit
		cmp txt[si], 54H 
	    je Lexit
    	jmp Lsalida

    Lexit:
    	pop di 
  		pop si
  		pop ax
  		jmp LMenu

    Lsalida:

  		pop di 
  		pop si
  		pop ax

endm

GetShowMedia macro txt
	local Lsalida, Lh, Lo, Lw, Lspace, Lm, Le, Ld, Li, La, media
	
	push ax
  push si
  push di 

  xor si, si 
	xor di, di 
	xor ax, ax

	cmp txt[si], 73H 
  je Lh
	cmp txt[si], 53H 
  je Lh	
  jmp Lsalida	

  Lh:		

  	inc si
  	cmp txt[si], 68H 
    je Lo
		cmp txt[si], 48H 
    je Lo
  	jmp Lsalida

  Lo:

		inc si
	  cmp txt[si], 6FH 
    je Lw
		cmp txt[si], 4FH 
    je Lw
		jmp Lsalida

	Lw:

		inc si
  	cmp txt[si], 77H ;
    je Lspace
		cmp txt[si], 57H ;
    je Lspace
  	jmp Lsalida

	Lspace:

		inc si
		cmp txt[si], 20H 
		je Lm

		jmp Lsalida

	Lm:
		inc si
		cmp txt[si], 6dh 
		je Le
		cmp txt[si], 4dh 
		je Le

		jmp Lsalida

	Le:
		inc si
		cmp txt[si], 65h 
		je Ld
		cmp txt[si], 45h 
		je Ld

		jmp Lsalida

	Ld:
		inc si
		cmp txt[si], 64h 
		je Li
		cmp txt[si], 44h 
		je Li

		jmp Lsalida

	Li:

		inc si
		cmp txt[si], 69H 
	    je La
		cmp txt[si], 49H 
	    je La
		jmp Lsalida

	La:
		inc si
		cmp txt[si], 61h 
		je media
		cmp txt[si], 41h 
		je media

		jmp Lsalida
	
	media:
		inc si
		cmp txt[si], 6eh 
		je Lsalida
		cmp txt[si], 4eh 
		je Lsalida
		GetPrint _ResultMedia
		GetPrint _MediaS
		GetPrint _salto

    Lsalida:

  		pop di 
  		pop si
  		pop ax

endm


GetShowMediana macro txt
	local Lsalida, Lh, Lo, Lw, Lspace, Lm, Le, Ld, Li, La, Ln, La1, mediana
	
	push ax
  push si
  push di 

  xor si, si 
	xor di, di 
	xor ax, ax

	cmp txt[si], 73H 
  je Lh
	cmp txt[si], 53H 
  je Lh	
  jmp Lsalida	

    Lh:	

    	inc si
    	cmp txt[si], 68H 
	    je Lo
		cmp txt[si], 48H 
	    je Lo
    	jmp Lsalida

    Lo:

		inc si
		cmp txt[si], 6FH 
	    je Lw
		cmp txt[si], 4FH 
	    je Lw
		jmp Lsalida

	Lw:

		inc si
    	cmp txt[si], 77H ;
	    je Lspace
		cmp txt[si], 57H ;
	    je Lspace
    	jmp Lsalida

	Lspace:

		inc si
		cmp txt[si], 20H 
		je Lm

		jmp Lsalida

	Lm:
		inc si
		cmp txt[si], 6dh 
		je Le
		cmp txt[si], 4dh 
		je Le

		jmp Lsalida

	Le:
		inc si
		cmp txt[si], 65h 
		je Ld
		cmp txt[si], 45h 
		je Ld

		jmp Lsalida

	Ld:
		inc si
		cmp txt[si], 64h 
		je Li
		cmp txt[si], 44h 
		je Li
		jmp Lsalida

	Li:

		inc si
		cmp txt[si], 69H 
	    je La
		cmp txt[si], 49H 
	    je La
		jmp Lsalida

	La:
		inc si
		cmp txt[si], 61h 
		je Ln
		cmp txt[si], 41h 
		je Ln

		jmp Lsalida

	Ln:
		inc si
		cmp txt[si], 6eh 
		je La1
		cmp txt[si], 4eh 
		je La1

		jmp Lsalida

	La1:
		inc si
		cmp txt[si], 61h 
		je mediana
		cmp txt[si], 41h 
		je mediana

		jmp Lsalida

	
	mediana:
		GetPrint _ResultMediana	
		GetPrint _MedianaS
		GetPrint _salto
		jmp Lsalida
  Lsalida:

  		pop di 
  		pop si
  		pop ax

endm


GetShowPadre macro txt
	local Lsalida, Lh, Lo, Lw, Lspace, padre, L0,LE
	
	push ax
  push si
  push di 

  xor si, si 
	xor di, di 
	xor ax, ax

	
	mov al, txt[si]
	cmp _padre[di], al
	je L0
	jne Lsalida

	L0:
		
		inc si
		inc di
		cmp _padre[si], 24h
		je LE

		xor ax, ax
		mov al, txt[si]
		cmp _padre[si], al
		je L0
		jne Lsalida


		jmp L0

	LE:

		GetPrint _salto
		GetPrint _Reporte00S
		reporte
		jmp Lsalida

  Lsalida:

  		pop di 
  		pop si
  		pop ax

endm