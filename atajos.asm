
 ; capturar entrada de documento 
 print macro texto 
    mov dx, offset texto
    mov ah, 09h 
    int 21h
endm 

getInputM macro _results 
    mov ah, 3fh
    mov bx , 00
    mov cx, 20
    mod dx , offset[_results]
    int 21h 
endm 

getCleanVariable macro tam,variable
    local Linicio, Lfinal
    xor SI,SI
    Linicio:
        mov variable[SI], 24H 
        inc SI 
        cmp SI , tam 
        je Lfinal 
        jmp Linicio
    Lfinal:
endm  
 ;manejo de contraseñas 
 getPasswordAnalitic macro 
    local e1,e2 
    e1: 
        mov ax,00h 
        mov ah,08h
        int 21h 
        cmp al, 0dh 
        je e2 
        cmp al, 1bh
        je Lmenu
        mov _contrasenia[SI], al 
        inc si 
        mov _contrasenia[SI], '$'
        mov ah,2h 
        mov dl , '*'
        int 21h
        jmp e1 
    e2:
 endm

 AbrirArchivo macro buffer, handler
    mov ah,3dh
    mov al, 02h
    lea dx, buffer 
    int 21h 
    jc Lerror1 
    mov handler,ax 
endm 

; metodo de ordenamiento 

COMMENT #
print macro cadena
    local etiqueta
    etiqueta:
        mov ah, 09h
        mov dx, @data
        mov ds, dx
        mov dx, offset cadena
        int 21h
endm

getChar macro
    mov ah, 01h
    int 21h
endm

abrirA macro ruta, handle
    mov ah,3dh
    mov al,0h
    lea dx, offset ruta
    int 21h
    mov handle,ax
endm

leerA macro buffer, handle
    mov ah, 3fh
    mov bx, handle
    lea dx, buffer
    mov cx, 100h
    int 21h
endm

cerrarA macro handle
    mov ah, 3eh
    mov handle, bx
    int 21h
endm

GuardarNumeros macro buffer,cantidad,arreglo,numero
	LOCAL INICIO,RECONOCER,GUARDAR,FIN,SALIR
	xor bx,bx
	xor si,si
	xor di,di
;--------------------------------------------------------------------------------------------	
	; metodo que va reconociendo palabras reservadas o caracteres especiales
	;hasta que encuentra un caracter de un numero, y poder iniciar a guardarlo. 
	INICIO:
		mov bl,buffer[si] ; lectura de archivo
		
		cmp bl,36   ; $
		je FIN      ; terminar
		cmp bl,48   ; 0
		jl SALIR    ; salta si es menor que 0
		cmp bl,57   ; 9
		jg SALIR    ; salta si es mayor que 9
		jmp RECONOCER	
;--------------------------------------------------------------------------------------------	
	; metodo que va reconociendo el numero, hasta que encuentra un caracter de finalizaci�n. 
	;Al encontrarlo procede a guardar dicho numero
	RECONOCER:
		mov bl,buffer[si]
		cmp bl,48
		jl GUARDAR
		cmp bl,57
		jg GUARDAR
		inc si
		mov numero[di],bl
		inc di
		jmp RECONOCER
;--------------------------------------------------------------------------------------------
	; metodo que guarda el numero reconocido en el arreglo
	GUARDAR:
		push si
		ConvertirDec numero
		xor bx,bx
		mov bl,cantidad
		mov arreglo[bx],al
		getChar
		xor ax,ax
		mov al,arreglo[bx]
		ConvertirString numero
		print numero
		Limpiarbuffer numero
		inc cantidad
		pop si
		xor bx,bx
		xor ax,ax
		jmp INICIO
;--------------------------------------------------------------------------------------------			
	SALIR:
		
		inc si
		xor di,di
		jmp INICIO
;--------------------------------------------------------------------------------------------			
	FIN: 
		xor ax,ax
		mov al,cantidad
		mov cantidad2,ax
endm

ConvertirDec macro numero
  LOCAL INICIO,FIN
	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov bx,10	;multiplicador 10
	xor si,si
	INICIO:
		mov cl,numero[si] 
		cmp cl,48
		jl FIN
		cmp cl,57
		jg FIN
		inc si
		sub cl,48	;restar 48 para que me de el numero
		mul bx		;multplicar ax por 10
		add ax,cx	;sumar lo que tengo mas el siguiente
		jmp INICIO
	FIN:
endm

ConvertirString macro buffer
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
	xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx
	mov dl,0ah
	test ax,1000000000000000
	jnz NEGATIVO
	jmp Dividir2

	NEGATIVO:
		neg ax
		mov buffer[si],45
		inc si
		jmp Dividir2

	Dividir:
		xor ah,ah
	Dividir2:
		div dl
		inc cx
		push ax
		cmp al,00h
		je FinCr3
		jmp Dividir
	FinCr3:
		pop ax
		add ah,30h
		mov buffer[si],ah
		inc si
		loop FinCr3
		mov ah,24h
		mov buffer[si],ah
		inc si
	FIN:
endm

Limpiarbuffer macro buffer
    LOCAL INICIO, FIN
    xor bx, bx
    INICIO:
        mov buffer[bx], 36
        inc bx
        cmp bx, 20
        je FIN
        jmp INICIO
    FIN:
endm

Limpiarbuffer2 macro buffer
    LOCAL INICIO, FIN
    xor bx, bx
    INICIO:
        mov buffer[bx], 36
        inc bx
        cmp bx, 60
        je FIN
        jmp INICIO
    FIN:
endm

copiarArreglo macro fuente, destino
    LOCAL INICIO, FIN

    xor si, si
    xor bx, bx
    INICIO:
        mov bl, cantidad
        cmp si, bx
        je FIN
        mov al, fuente[si]
        mov destino[si], al
        inc si
        jmp INICIO
    FIN:
endm

DeterminarMayor macro 
    LOCAL BURBUJA, VERIFICARMENOR, RESETEAR, FIN, MENOR
    xor si, si
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    mov dx, cantidad2
    dec dx
    BURBUJA:
        mov al, arreglo[si]
        mov bl, arreglo[si + 1]
        cmp al, bl
        jl MENOR
        inc si
        inc cx
        cmp cx, dx
        jne BURBUJA
        mov cx, 0
        mov si, 0
        jmp VERIFICARMENOR
    MENOR:
        mov arreglo[si], bl
        mov arreglo[si + 1], al
        cmp al, bl
        inc si
        inc cx
        cmp dx, dx
        jne BURBUJA
        mov cx, 0
        mov si, 0
        jmp VERIFICARMENOR
    VERIFICARMENOR:
        mov al, arreglo[si]
        mov bl, arreglo[si + 1]
        cmp al, bl
        jl RESETEAR
        inc si
        inc cx
        cmp cx, dx
        jne VERIFICARMENOR
        jmp FIN
    RESETEAR:
        mov si, 0
        mov cx, 0
        jmp BURBUJA
    FIN:
        xor ax, ax
        mov al, arreglo[0]
        mov maximo, ax
endm

Burbuja macro
    ;Convertir velocidad en Hz
    mov cl, 16
    sub cl, velocidad1
    inc cl
    mov ax, 500
    mov bl, cl
    mul bl
    mov tiempo, ax
    BurbujaAsc
endm

BurbujaAsc macro
    LOCAL BURBUJA, VERIFICARMENOR, RESETEAR, FIN, MENOR
    xor si, si
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    mov dl, cantidad
    dec dx
    Graficar arreglo
    BURBUJA:
        mov al, arreglo[si]
        mov bl, arreglo[si + 1]
        cmp al, bl
        jl MENOR
        inc si
        inc cx
        cmp cx, dx
        jne BURBUJA
        mov cx, 0
        mov si, 0
        jmp VERIFICARMENOR
    MENOR:
        mov arreglo[si], bl
        mov arreglo[si + 1], al
        Graficar arreglo
        inc si
        inc cx
        cmp cx, dx
        jne BURBUJA
        mov cx, 0
        mov si, 0
        jmp VERIFICARMENOR
    VERIFICARMENOR:
        mov al, arreglo[si]
        mov bl, arreglo[si + 1]
        cmp al, bl
        jl RESETEAR
        inc si
        inc cx
        cmp cx, dx
        jne VERIFICARMENOR
        jmp FIN
    RESETEAR:
        mov si, 0
        mov cx, 0
        jmp BURBUJA
    FIN:
        GraficarFinal arreglo
endm

Graficar macro arreglo
    pushear
    obtenerNumeros
    DeterminarTamano tamanoX, espacio, cantidad2, espaciador
    pushearVideo arreglo
    ModoGrafico
    imprimirVN numerosMos, 16h, 02h
    poppearVideo arreglo
    graBar cantidad2, espacio2, arreglo
    ModoTexto
    poppear
endm

GraficarFinal macro arreglo
    pushear
    obtenerNumeros
    DeterminarTamano tamanoX, espacio, cantidad2, espaciador
    pushearVideo arreglo
    ModoGrafico
    imprimirVN numerosMos, 16h, 02h
    poppearVideo arreglo
    graBar cantidad2, espacio2, arreglo
    getChar
    getChar
    ModoTexto
    poppear
endm

ModoGrafico macro
    mov ax, 013h
    int 10h
    mov ax, 0A000h
    mov ds, ax
endm

obtenerNumeros macro
    LOCAL INICIO, FIN
    xor si, si
    xor dx, dx
    mov dl, cantidad
    Limpiarbuffer2 numerosMos
    INICIO:
        Limpiarbuffer resultado
        cmp si, dx
        je FIN
        push si
        push dx
        xor ax, ax
        mov al, arreglo[si]
        ConvertirString resultado
        insertarNumero resultado
        Limpiarbuffer resultado
        pop dx
        pop si
        inc si
        jmp INICIO
    FIN:
endm

insertarNumero macro cadena
    LOCAL INICIO, FIN, SIGUIENTE
    xor si, si
    xor di, di
    INICIO: 
        cmp si, 60
        je FIN
        mov al, numerosMos[si]
        cmp al, 36
        je SIGUIENTE
        inc si
        jmp INICIO
    SIGUIENTE:
        mov al, cadena[di]
        cmp al, 36
        je FIN
        mov numerosMos[si], al
        inc di
        inc si
        jmp SIGUIENTE
    FIN:
        mov numerosMos[si], 32
endm

DeterminarTamano macro tamanoX, espacio, cantidad, espaciador
    mov ax, 260  ; tamaño para dibujar de largo o en x
    mov bx, cantidad
    xor bh, bh
    div bl
    xor dx, dx
    mov dl, al
    mov espaciador, dx
    xor ah, ah
    mov bl, 25
    mul bl
    mov bl, 100
    div bl

    mov espacio, al
    mov bx, espaciador
    sub bl, espacio
    mov tamanoX, bx
endm

imprimirVN macro cadena, fila, columna
    push ds
    push dx
    xor dx, dx
    mov ah, 02h
    mov bx, 0
    mov dh, fila
    mov dl, columna
    int 10h

    mov ax, @data
    mov ds, ax
    mov ah, 09
    mov dx, offset cadena
    int 21h
    pop dx
    pop ds
endm

graBar macro cantidad, espacio, arreglo
    LOCAL INICIO, FIN
    xor cx, cx
    INICIO:
        cmp cx, cantidad
        je FIN
        push cx
        mov si, cx
        xor ax, ax
        mov al, arreglo[si]
        mov valor, al
        push ax
        DeterminarColor
        xor ax, ax
        mov ax, maximo
        mov max, al
        dibujarBarra espacio, valor, max
        pop ax
        mov valor, al
        DetSon
        pop cx
        inc cx
        jmp INICIO
    FIN:
endm

DeterminarColor macro 
    LOCAL SEGUNDO, TERCERO, CUARTO, QUINTO, FIN
    cmp valor, 1
    jb FIN
    cmp valor, 20
    ja SEGUNDO
    mov dl, 4
    jmp FIN
    SEGUNDO:
        cmp valor, 40
        ja TERCERO
        mov dl, 1
        jmp FIN
    TERCERO:
        cmp valor, 60
        ja CUARTO
        mov dl, 44
        jmp FIN
    CUARTO:
        cmp valor, 80
        ja QUINTO
        mov dl, 2
        jmp FIN
    QUINTO:
        cmp valor, 99
        ja FIN
        mov dl, 15
        jmp FIN
    FIN:
endm

dibujarBarra macro espacio, valor, max
    LOCAL INICIO, FIN 
    xor cx, cx
    DeterminarTamanoY valor, max
    INICIO:
        cmp cx, tamanoX
        je FIN
        push cx
        mov ax, 170
        mov bx, ax
        sub bl, valor
        xor bh, bh
        mov si, bx
        mov bx, 30
        add bx, espacio
        add bx, cx
        PintarY
        pop cx
        inc cl
        jmp INICIO
    FIN:
        mov ax, espaciador
        add espacio, ax
endm

DeterminarTamanoY macro valor, max
    xor ax, ax
    mov al, valor
    mov bl, 130
    mul bl
    mov bl, max
    div bl
    mov valor, al
endm

PintarY macro
    LOCAL ejey, FIN
    mov cx, si
    ejey:
        cmp cx, ax
        je FIN
        mov di, cx
        push ax
        push dx
        mov ax, 320
        mul di
        mov di, ax
        pop dx
        pop ax
        mov [di + bx], dl
        inc cx
        jmp ejey
    FIN:
endm

DetSon macro
    LOCAL SEGUNDO, TERCERO, CUARTO, QUINTO, FIN
    cmp valor, 1
    jb FIN
    cmp valor, 20
    ja SEGUNDO
    delay 500
    jmp FIN
    SEGUNDO:
        cmp valor, 40
        ja TERCERO
        delay 750
        jmp FIN
    TERCERO:
        cmp valor, 60
        ja CUARTO
        delay 1000
        jmp FIN
    CUARTO:
        cmp valor, 80
        ja QUINTO
        delay 1250
        jmp FIN
    QUINTO:
        cmp valor, 99
        ja FIN
        delay 1500
        jmp FIN
    FIN:
endm
delay macro constante
    LOCAL D1, D2, FIN
    push si
    push di

    mov si, constante
    D1:
        dec si
        jz FIN
        mov di, constante
    D2:
        dec di
        jnz D2
        jmp D1
    FIN:
        pop di
        pop si
endm

limpiarpantalla macro
    mov ah, 0
    mov al, 13h
    int 10h
endm

ModoTexto macro
    mov dx, @data
    mov ds, dx
    mov ax, 0003h
    int 10h
endm

pushear macro
    push ax
    push bx
    push cx
    push dx
    push si
    push di
endm

poppear macro
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
endm

pushearVideo macro arreglo
    pushArreglo arreglo
    push maximo
    push tamanoX
    push espaciador
    push cantidad2
    push tiempo
endm

poppearVideo macro arreglo
    pop tiempo
    pop cantidad2
    pop espaciador
    pop tamanoX
    pop maximo
    popArreglo arreglo
endm

pushArreglo macro arreglo
    LOCAL INICIO, FIN
    xor si, si
    INICIO:
        xor ax, ax
        cmp si, cantidad2
        je FIN
        mov al, arreglo[si]
        push ax
        inc si
        jmp INICIO
    FIN:
endm

popArreglo macro arreglo
    LOCAL INICIO, FIN
    xor si, si
    mov si, cantidad2
    dec si
    INICIO:
        cmp si, 0
        jl FIN
        pop ax
        mov arreglo[si], al
        dec si
        jmp INICIO
    FIN:
endm
#

;cerrar paths for files in sistem stacks  

Cerrar_Archivo macro handler
    mov ah,3eh 
    mov bx,handler 
    int 21h
    jc Lerror2
endm 

; leer camino 

getLeerArchivo macro handlerm,buffer,numbytes 
    mov ah,3fh
    mov bx,handler
    mov cx,numbytes
    lea dx,buffer
    int 21h
    jc Lerror5
endm 

getLogin macro 
    local e1,e2,e3,e4

    getPrint _enter
    getPrint _chain11
    getInputM _usuario

    getPrint _chain12
    getPasswordAnalitic

    e1:
        getCleanVariable 100, _usuarioSave
        getCleanVariable 100, _contraseniaSave
        GuardarUsuarios
        verificarUsuarios _usuario,_usuarioSave
        cmp _ifBool,1
        je 2 
        jmp e3 
    e2:
        verificarUsuarios _contrasenia,_contraseniaSave
        cmp _ifBool , 0 
        je errorContrasenia
        mov _tamfile,0
        jmp ingresarsist ; verificar main 

    e3: 
        mov si, _tamfile
        cmp _bufferInfo[si], 24h 
        je sinerror ;verificar en main 
        jmp e1
        
endm 

GuardarUsuarios macro 
    local e1,e2,e3,e4
    mov si, _tamfile
    xor bx,bx 
    e1:
        cmp _bufferInfo[SI],','
        je e2
        mov al, _bufferInfo[SI]
        mov _usuarioSave[bx] , al 
        INC si 
        INC bx 
        jmp e1 

    e2:
        INC si 
        xor bx,bx
    e3:
        cmp _bufferInfo[si], 0Ah 
        je e4
        mov al, _bufferInfo[si]
        mov _contraseniaSave[bx],al 
        INC si 
        INc bx 
        jmp e3 
    e4: 
        getPrint _enter
        getPrint _usuario
        getPrint _separador
        inc si 
        mov _tamfile ,si 

endm 


verificarUsuarios macro p1,p2 
    local e1,e2,e3,e4,e5
    xor si,si 
    xor al,al

    e1: 
        mov al , p1[si]
        cmp al, 24h 
        je e2 
        jmp e3 
    
    e3:
        mov al, p2[si]
        cmp al ,24h 
        je e4 
        cmp al,p1[si]
        jne e2 
        inc si 
        jmp e3 

    e4: 
        mov _ifBool,1 
        jmp e5
    e2: 
        mov _ifBool,0
        jmp e5
    e5:



endm 


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

; operaciones 
INT_to_STRINg macro intNum
    local divTen, signoN ,Digito,getStack
    push ax 
    push bx 
    push cx 
    push dx 
    push si 
    xor si,si
    xor cx,cx 
    xor bx,bx
    xor dx,dx
    mov bx, 0ah 
    test ax , 1000000000000000
    jnz signoN
    Digito:
        cmp ax, 0009h
        ja divTen
        mov intNum[si],30h
        inc si 
        jmp divTen
    signoN:
        neg ax 
        ja divTen
        mov intNum[si], 30h
        inc si 
        jmp divTen
    divTen: 
        xor dx,dx 
        div bx 
        inc cx 
        push cx 
        cmp ax,0h 
        je getStack
            jmp divTen
    getStack:
        pop dx 
        add dl,30h
        mov intNum[si],dl
        inc si 
        loop getStack
        mov ah,'$'
        mov intNum[si],ah

        pop si 
        pop dx 
        pop cx 
        pop bx 
        pop ax 
    endm 
	;prints 
getPrint macro buffer 
    MOV AX,@data
    MOV DS, AX
    MOV AH,09H
    MOV DX, OFFSET buffer
    INT 21h
endm 
; capturardor de teclado 
 getInput macro
 MOV AH, 01H
 int 21h
 endm 

 getKeyboard macro
 mov ax , 0h 
 mov ah,0h 
 int 16h 
 endm

 getClean macro 
 mov ah , 00h
 mov al , 03h
 int 10h
 endm 
