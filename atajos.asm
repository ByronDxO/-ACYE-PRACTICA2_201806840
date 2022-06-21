;atajos 
;mensajes 

;print 

getPrint macro buffer 
    MOV AX,@data
    MOV DS,AX
    MOV AH,09H
    MOV DX, OFFSET buffer
    INT 21h
endm

;capturar teclado 
getInput macro 
    MOV AH,01H
    int 21h
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

    ;;metodos 
    print macro cadena 
	MOV ax, @data
	MOV ds, ax
	MOV ah, 09h 
	MOV dx, offset cadena 
	int 21h
endm

getChar macro
	mov ah,01h
	int 21h
endm

Imprimir macro dato 
	mov al, dato
	mov var, al
	print var
endm

RutaDefinida macro buffer
 MOV buffer[0],99
 MOV buffer[1],58
 MOV buffer[2],92
 MOV buffer[3],74
 MOV buffer[4],83
 MOV buffer[5],79
 MOV buffer[6],78
 MOV buffer[7],83
 MOV buffer[8],92
endm

Limpiar macro buffer, numbytes
	LOCAL REPETIR
	MOV si,0
	MOV cx,0
	MOV cx,numbytes
	REPETIR:
	mov buffer[si],0
	inc si
	loop REPETIR
endm

ObtenerRuta macro buffer
	LOCAL ObtenerChar, FinDT
	MOV si,09
	ObtenerChar:
	getChar
	cmp al, 0dh
	je FinDT
	mov buffer[si],al
	inc si
	jmp ObtenerChar
	FinDT:
	mov al, 00h
	mov buffer[si],al
endm

ObtenerRutaReporte macro buffer
	LOCAL ObtenerChar, FinDT
	MOV si,09
	MOV di,00

	ObtenerChar:
	cmp id_padre[di], 24h
	je FinDT
	MOV cx, id_padre[di]
	MOV ch, 00
	MOV buffer[si], cl
	inc si
	inc di
	JMP ObtenerChar
	FinDT:
	MOV buffer[si],2Eh
	inc si
	MOV buffer[si],6Ah
	inc si
	MOV buffer[si],73h
	inc si
	MOV buffer[si],6Fh
	inc si
	MOV buffer[si],6Eh
	inc si
	mov al, 00h
	mov buffer[si],al
endm


ObtenerTexto macro buffer
	LOCAL ObtenerChar, FinDT
	MOV si,00
	ObtenerChar:
	getChar
	cmp al, 0dh
	je FinDT
	mov buffer[si],al
	inc si
	jmp ObtenerChar
	FinDT:
	mov al, 24h
	mov buffer[si+1],al
endm

ConvertirMinuscula macro buffer, numbytes
	LOCAL RECORRIDO, CONVERTIR, INCREMENTO, FIN
	MOV si,0
	MOV bl,0
	MOV bh, numbytes

	RECORRIDO:
	MOV al, buffer[si]
	CMP al, 91
	jb CONVERTIR
	JMP INCREMENTO
	CONVERTIR:
	CMP al, 64
	ja INCREMENTO
	MOV al, buffer[si]
	ADD al, 32
	MOV buffer[si],al
	JMP INCREMENTO

	INCREMENTO:
	INC si
	INC bl
	CMP bl, bh
	jne RECORRIDO
	FIN:
	MOV buffer[si], 36
	MOV si,0
	MOV bl,0
endm



LeerNumero macro arreglo
 LOCAL LECTURA, FINAL, NEGATIVO
 	mov si,0
 	mov di,0

 	LECTURA:
 	MOV cx, arreglo[si]
 	MOV ch, 00h

 	cmp cl, 24h
 	je FINAL

 	cmp cl, 2Dh
 	je NEGATIVO

 	inc si
 	JMP LECTURA

 	NEGATIVO:
 	inc si
 	inc di
 	jmp LECTURA

 	FINAL:
 	dec si
endm

ConversionNumero macro arreglo
 LOCAL INICIO, POSITIVO,NEGATIVO, FINAL, UNIDAD, DECENAS, CENTENAS, NUNIDAD, NDECENAS, NCENTENAS
	INICIO:
	cmp di,01
	je NEGATIVO
	jmp POSITIVO

	POSITIVO:
	cmp si,00h
	je UNIDAD
	cmp si,01h
	je DECENAS
	cmp si,02h
	je CENTENAS

	UNIDAD:
	MOV bx, arreglo[0]
	MOV bh, 00h
	sub bl, 30h
	mov ah, 00h
	mov al, bl
	mov tam_num, 0
	jmp FINAL

	DECENAS:
	MOV bx, arreglo[0]
	MOV bh, 00h
	sub bl, 30h
	mov ah, 00h
	mov al, bl
	mov bh, 10
	mul bh

	MOV bx, arreglo[1]
	MOV bh, 00h
	sub bl, 30h
	mov ch, 00h
	mov cl, bl

	add ax, cx
	mov tam_num, 1
	jmp FINAL

	CENTENAS:
	MOV bx, arreglo[0]
	MOV bh, 00h
	sub bl, 30h
	mov ah, 00h
	mov al, bl
	mov bh, 100
	mul bh

	mov dx, ax

	MOV bx, arreglo[1]
	MOV bh, 00h
	sub bl, 30h
	mov ah, 00h
	mov al, bl
	mov bh, 10
	mul bh

	add ax, dx
	mov dx, ax

	MOV bx, arreglo[2]
	MOV bh, 00h
	sub bl, 30h
	mov ch, 00h
	mov cl, bl

	add ax, cx
	mov tam_num, 2
	jmp FINAL

	NEGATIVO:
	cmp si,1
	je NUNIDAD
	cmp si,2
	je NDECENAS
	cmp si,3
	je NCENTENAS

	NUNIDAD:
	MOV bx, arreglo[1]
	MOV bh, 00h
	sub bl, 30h
	mov ah, 00h
	mov al, bl
	neg ax
	mov tam_num, 2
	jmp FINAL

	NDECENAS:
	MOV bx, arreglo[1]
	MOV bh, 00h
	sub bl, 30h
	mov ah, 00h
	mov al, bl
	mov bh, 10
	mul bh

	MOV bx, arreglo[2]
	MOV bh, 00h
	sub bl, 30h
	mov ch, 00h
	mov cl, bl
	add ax, cx

	neg ax
	mov tam_num, 3
	jmp FINAL

	NCENTENAS:
	MOV bx, arreglo[1]
	MOV bh, 00h
	sub bl, 30h
	mov ah, 00h
	mov al, bl
	mov bh, 100
	mul bh

	mov dx, ax

	MOV bx, arreglo[2]
	MOV bh, 00h
	sub bl, 30h
	mov ah, 00h
	mov al, bl
	mov bh, 10
	mul bh

	add ax, dx
	mov dx, ax

	MOV bx, arreglo[3]
	MOV bh, 00h
	sub bl, 30h
	mov ch, 00h
	mov cl, bl

	add ax, cx
	neg ax
	mov tam_num, 4
	jmp FINAL

	FINAL:
endm

ConversionTexto macro numero, arreglo
 LOCAL INICIO, POSITIVO,NEGATIVO, FINAL, UNIDAD, DECENAS, CENTENAS, NUNIDAD, NDECENAS, NCENTENAS
	INICIO:
	cmp numero,00
	jl NEGATIVO
	jmp POSITIVO

	POSITIVO:
	cmp numero,09h
	jbe UNIDAD
	cmp numero,63h
	jbe DECENAS
	cmp numero,3E7h
	jbe CENTENAS

	UNIDAD:
	mov bx, numero
	add bx, 30h
	mov arreglo[0],bx
	mov arreglo[1],24h
	mov tam_num, 1
	jmp FINAL

	DECENAS:
	mov ax, numero
	cwd
	mov bx, 10
	div bx
	aam
	mov res,dx
	add al,'0'
	mov arreglo[0],ax

    mov ax,res
    aam
    add al,'0'
    mov arreglo[1],ax

    mov arreglo[2],24h
    mov tam_num, 2

	jmp FINAL

	CENTENAS:
	mov ax, numero
	cwd
	mov bx, 100
	div bx 
	aam
	mov res,dx
	mov ah, 00h
	add al, 30h
	mov arreglo[0],ax

	mov ax,res
	cwd
	mov bx, 10
	div bx
	aam
	mov res,dx
	mov ah, 00h
	add al, 30h
	mov arreglo[1],ax

    mov ax,res
    aam
	mov ah, 00h
	add al, 30h
    mov arreglo[2],ax

    mov arreglo[3],24h
   	mov tam_num, 3
	jmp FINAL

	NEGATIVO:
	mov ax, numero
	neg ax
	mov numero, ax
	mov arreglo[0],2Dh

	cmp numero,09h
	jbe NUNIDAD
	cmp numero,64h
	jbe NDECENAS
	cmp numero,3E7h
	jbe NCENTENAS

	NUNIDAD:
	mov bx, numero
	add bx, 30h
	mov arreglo[1],bx
	mov arreglo[2],24h
	mov tam_num, 2

	jmp FINAL

	NDECENAS:
	mov ax, numero
	cwd
	mov bx, 10
	div bx
	aam
	mov res,dx
	add al,'0'
	mov arreglo[1],ax

    mov ax,res
    aam
    add al,'0'
    mov arreglo[2],ax

    mov arreglo[3],24h
   	mov tam_num, 3
 
	jmp FINAL

	NCENTENAS:
	mov ax, numero
	cwd
	mov bx, 100
	div bx
	aam
	mov res,dx
	add al,'0'
	mov arreglo[1],ax

	mov ax,res
	cwd
	mov bx, 10
	div bx
	aam
	mov res,dx
	add al,'0'
	mov arreglo[2],ax

    mov ax,res
    aam
    add al,'0'
    mov arreglo[3],ax

    mov arreglo[4],24h
   	mov tam_num, 4
 
	jmp FINAL
	FINAL:
endm


; AUTOMATA APRUEBA DE TONTOS
M_automata macro arr
 LOCAL INICIO, SALTO, NADA, IMPRESION, RECORRIDO, ESPACIO, GUARDAR, TERM, FIN
	mov si, 0
	mov di, 0
	
	INICIO:
	MOV al, arr[si]
	cmp al, 00h
	je FIN
	cmp al, 09h
	je NADA
	cmp al, 0Ah
	je NADA
	cmp al, 0Dh
	je NADA
	cmp al, 7Bh
	je NADA
	cmp al, 7Dh
	je LLAVE
	cmp al, 5Bh
	je NADA
	cmp al, 5Dh
	je NADA
	cmp al, 22h
	je NADA
	cmp al, 23h
	je NADA2
	cmp al, 3Ah
	je ESPACIO
	cmp al, 2Ch
	je ESPACIO

	jmp RECORRIDO

	RECORRIDO:
	MOV cl, arr[si]
	MOV texto_auxiliar[di], cx
	inc di
	inc si
	JMP INICIO

	ESPACIO:
	MOV cl, 20h
	MOV texto_auxiliar[di], cx
	inc di
	inc si
	JMP INICIO

	LLAVE:
	CMP arr[si+1],00h
	je TERM
	CMP arr[si+3],5Dh
	je TERM
	MOV cl, 20h
	MOV texto_auxiliar[di], cx
	inc di
	MOV cl, arr[si]
	MOV texto_auxiliar[di], cx
	inc di
	inc si
	JMP INICIO
		

	TERM:
	inc si
	JMP INICIO

	NADA2:
	ADD si, 3
	JMP INICIO
	
	NADA:
	inc si
	JMP INICIO

	FIN:
	MOV texto_auxiliar[di], 20h
	inc di
	MOV texto_auxiliar[di], 7Dh
	inc di
	MOV cx, 00h
	MOV cl, 24h
	MOV texto_auxiliar[di], cx
endm

Analisis_Texto macro arreglo
	MOV di,0
	MOV si,0
	mov dl,0
	ANALISIS:
	MOV cx, arreglo[si]
	MOV ch, 00h
	CMP cl, 24h
	je FIN_ANALISIS
	JMP LECTURA
	
	LECTURA:
	MOV cx, arreglo[si]
	MOV palabra_auxiliar[di], cx
	MOV auxiliar_sensitive[di],cl
	inc si
	inc di
	inc dl
	MOV cx, arreglo[si]
	MOV ch, 00h
	CMP cl, 20h
	je GUARDAR
	JMP ANALISIS

	GUARDAR:
	MOV palabra_auxiliar[di],24h
	inc si
	mov aux_analisis, si
	mov tamanio_palabra, di
	;COMPARANDO EL PADRE
	MOV dx, palabra_padre
	CMP palabra_padre, 1
	je COMPARACION
	ADD palabra_padre, 1
	GuardarPadre palabra_auxiliar, id_padre, SIZEOF palabra_auxiliar
	mov si, aux_analisis
	mov di, 0
	JMP ANALISIS

	COMPARACION:
	;COMPARANDO QUE ES LO QUE VIENE
	Comparacion_Palabra palabra_auxiliar
	mov si, aux_analisis
	mov di, 0
	JMP ANALISIS
	
	FIN_ANALISIS:
	MOV palabra_padre, 0
	MOV di, indice_ids
	MOV ids_del_padre[di-1],24h
	MOV di, indice_valores
	MOV valores_padre[di],24h
	MOV di, indice_bytes
	MOV padre_bytes[di],24h
	print ids_del_padre
	print salto
endm

GuardarPadre macro arreglo1, arreglo2, numbytes
	LOCAL RECORRIDO, FIN
	mov si, 0
	mov di, numbytes

	RECORRIDO:
	cmp si, di
	je FIN
	MOV cx, arreglo1[si]

	MOV arreglo2[si], cx
	inc si
	JMP RECORRIDO

	FIN:
endm

Comparacion_Palabra macro comando
	LOCAL FIN, GUARDAR, NUMERO
	CMP bandera_id, 1
	je VALOR_ID

	;NUMERO
	NUMERO:
	MOV cx, comando[0]
	MOV ch, 00h
	CMP cl, 2Dh
	je COMPARAR_NEGATIVO
	CMP cl, 30h
	jae COMPARAR_NUMERO
	JMP FIN_NUMERO

	COMPARAR_NEGATIVO:
	MOV cx, comando[1]
	MOV ch, 00h
	CMP cl, 30h
	jae COMPARAR_NUMERO
	JMP FIN_NUMERO

	COMPARAR_NUMERO:
	CMP cx, 39h
	jbe NUMERITO
	JMP FIN_NUMERO

	NUMERITO:
	LeerNumero comando
	ConversionNumero comando
	PUSH ax
	ADD cont_push, 1
	JMP FIN_COMPARACION


	FIN_NUMERO:

	;SUMA
	mov cx,3
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_sumar
	repe cmpsb
	jne FIN_SUMA
	MOV ax, 01h
	MOV ah, 00h
	PUSH ax
	ADD cont_push, 1
	JMP FIN_COMPARACION
	FIN_SUMA:
	
	;RESTA
	mov cx,3
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_resta
	repe cmpsb
	jne FIN_RESTA
	MOV ax, 02h
	MOV ah, 00h
	PUSH ax
	ADD cont_push, 1	
	JMP FIN_COMPARACION
	FIN_RESTA:

	;MULTIPLICACION
	mov cx,3
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_multi
	repe cmpsb
	jne FIN_MULTI
	MOV ax, 03h
	MOV ah, 00h
	PUSH ax
	ADD cont_push, 1
	JMP FIN_COMPARACION
	FIN_MULTI:


	;DIVISION
	mov cx,3
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_divis
	repe cmpsb
	jne FIN_DIVISION
	MOV ax, 04h
	MOV ah, 00h
	PUSH ax
	ADD cont_push, 1
	JMP FIN_COMPARACION
	FIN_DIVISION:

	;IDENTIFICADOR
	mov cx,2
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_id
	repe cmpsb
	jne FIN_IDENTIFICADOR
	ADD bandera_id, 1
	JMP FIN_COMPARACION
	FIN_IDENTIFICADOR:

	;SIGNO SUMA
	mov cx,1
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_Ssuma
	repe cmpsb
	jne FIN_SIGNO_SUMA
	MOV ax, 01h
	PUSH ax
	ADD cont_push, 1
	JMP FIN_COMPARACION
	FIN_SIGNO_SUMA:

	;SIGNO RESTA
	mov cx,1
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_Srest
	repe cmpsb
	jne FIN_SIGNO_RESTA
	MOV ax, 02h
	PUSH ax
	ADD cont_push, 1	
	JMP FIN_COMPARACION
	FIN_SIGNO_RESTA:

	;SIGNO MULTIPLICACION
	mov cx,1
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_Smult
	repe cmpsb
	jne FIN_SIGNO_MULTI
	MOV ax, 03h
	PUSH ax
	ADD cont_push, 1	
	JMP FIN_COMPARACION
	FIN_SIGNO_MULTI:

	;SIGNO DIVISION
	mov cx,1
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_Sdivi
	repe cmpsb
	jne FIN_SIGNO_DIVISION
	MOV ax, 04h
	PUSH ax
	ADD cont_push, 1	
	JMP FIN_COMPARACION
	FIN_SIGNO_DIVISION:

	;SIGNO LLAVE
	mov cx,1
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_llave
	repe cmpsb
	jne FIN_SIGNO_LLAVE
	
	CMP cont_push, 00h
	je GUARDAR

	POP num2
	POP num1
	SUB cont_push, 2

	POP operando
	SUB cont_push, 1

	MOV cx, operando
	MOV ch, 00h
	CMP operando, 01h
	je OP_SUMA
	CMP operando, 02h
	je OP_RESTA
	CMP operando, 03h
	je OP_MULTI
	CMP operando, 04h
	je OP_DIVIS
	JMP FIN_COMPARACION

	OP_SUMA:
	SumarNumeros num1, num2
	MOV total, ax
	PUSH ax
	ADD cont_push, 1	
	JMP FIN_COMPARACION

	OP_RESTA:
	RestarNumeros num1, num2
	MOV total, ax
	PUSH ax
	ADD cont_push, 1	
	JMP FIN_COMPARACION
	
	OP_MULTI:
	MultiplicarNumeros num1, num2
	MOV total, ax
	PUSH ax
	ADD cont_push, 1	
	JMP FIN_COMPARACION
	
	OP_DIVIS:
	DividirNumeros num1, num2
	MOV total, ax
	PUSH ax
	ADD cont_push, 1	
	JMP FIN_COMPARACION
	FIN_SIGNO_LLAVE: 

	;IDENTIFICADORES
	mov cx, aux_analisis
	mov di, tamanio_palabra
	sub cx, di
	PUSH cx
	add cx, di
	PUSH cx
	ADD cont_push, 2
	JMP FIN_COMPARACION

	GUARDAR:
	MOV cx, num2
	MOV total, cx
	MOV cx, num1
	MOV si, operando
	MOV di, indice_ids

	PROCESO:
	CMP si, cx
	je FIN_PROCESO
	MOV ax, texto_auxiliar[si-1]
	MOV ids_del_padre[di],ax
	inc si
	inc di
	JMP PROCESO

	FIN_PROCESO:
	MOV ids_del_padre[di],3AH
	inc di
	MOV si, indice_valores
	MOV cx, total


	MOV valores_padre[si], cx
	ADD indice_valores, 1

	mov total, cx
	ConversionTexto total, number
	mov ax, total


	MOV cx, number[0]
	MOV ch, 00h
	cmp cl, 2Dh
	je NEGAR
	JMP PASAR

	NEGAR:
	neg ax
	JMP PASAR

	PASAR:
	MOV si, indice_bytes
	mov padre_bytes[si], ah
	inc si
	mov padre_bytes[si], al
	inc indice_bytes
	inc indice_bytes
	mov si, 0


	PROCESO2:
	MOV cx, number[si]
	cmp cx, 24h
 	je FIN_PROCESO2
 	MOV ax, number[si]
 	MOV ids_del_padre[di], ax
 	inc si
 	inc di
 	JMP PROCESO2

 	FIN_PROCESO2:
 	MOV ids_del_padre[di],2Ch
 	inc di
	mov cont_push, 0
	MOV indice_ids, di
	MOV di, 0
	JMP FIN_COMPARACION

	VALOR_ID:
	MOV si, 0
	MOV di, 0
	REC_VALORES:
	MOV cx, ids_del_padre[si]
	MOV ch, 00h
	CMP cx, 3Ah
	je COMPARAR
	CMP cx, 2Ch
	je COMPARAR
	CMP cx, 24h
	je NO_EXISTE
	MOV comparador_id[di], cx
	inc si
	inc di
	JMP REC_VALORES

	COMPARAR:
	MOV comparador_id[di], 24h
	MOV comp_final, si
	add tamanio_palabra,1
	mov cx, tamanio_palabra
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, comparador_id
	repe cmpsb
	jne COMPARAR_SIGUIENTE
	
	GUARDAR_NUMERO:
	MOV si, comp_final
	MOV di, 0
	inc si

	COMPARAR_GUARDAR_NUMERO:
	MOV cx, ids_del_padre[si]
	MOV ch, 00h
	CMP cl, 2Ch
	je FIN_GUARDAR_NUMERO
	MOV cx, ids_del_padre[si]
	MOV comando[di], cx
	inc si
	inc di
	JMP COMPARAR_GUARDAR_NUMERO


	FIN_GUARDAR_NUMERO:
	MOV comando[di], 24h
	SUB bandera_id, 1
	JMP NUMERO

	COMPARAR_SIGUIENTE:
	mov di,0
	mov si, comp_final
	inc si
	JMP REC_VALORES

	NO_EXISTE:
	SUB bandera_id, 1

	FIN_COMPARACION:
endm


; METODOS PARA HACER LOS CALCULOS
SumarNumeros macro num1, num2
	MOV ax, num1
	MOV bx, num2
	ADD ax, bx
endm

RestarNumeros macro num1, num2
	MOV ax, num1
	MOV bx, num2
	SUB ax, bx
endm

MultiplicarNumeros macro num1, num2
	MOV ax, num1
	MOV cx, num2
	IMUL cx
endm

DividirNumeros macro num1, num2
	LOCAL COMPARACION2, NEGATIVA1, NEGATIVA2, OPERAR, DIV_NEG, DIVISION, FINAL
	MOV dx, 0
	MOV ax, num1
	MOV cx, num2
	
	cmp ax, 00
	jl NEGATIVA1
	
	COMPARACION2:
	cmp cx, 00
	jl NEGATIVA2	
	JMP OPERAR
	
	NEGATIVA1:
	neg ax
	ADD aux_division, 1
	JMP COMPARACION2
	
	NEGATIVA2:
	neg cx
	ADD aux_division, 1
	JMP OPERAR
	
	OPERAR:
	CMP aux_division, 1
	je DIV_NEG
	CMP aux_division, 2
	je DIVISION
	JMP DIVISION
	
	DIV_NEG:
	DIV cx
	neg ax
	JMP FINAL
	DIVISION:
	DIV cx
	JMP FINAL
	FINAL:
	mov aux_division, 0
endm


OrdenamientoBurbuja macro arreglo, tamanio
		mov cx, 0
		mov bx, 0
		mov si, 0 
		mov di, tamanio 

		ORDEN:
		mov ch,arreglo[si] 
		mov cl,arreglo[si+1] 
		mov bh,arreglo[si+2]
		mov bl,arreglo[si+3]

		cmp cx,bx 
		jl NO_CAMBIO 
		
		mov arreglo[si+2],ch 
		mov arreglo[si+3],cl 

		mov arreglo[si],bh
		mov arreglo[si+1],bl 

		NO_CAMBIO: 
		inc si 
		inc si
		cmp si,di
		jb ORDEN
		dec di
		mov si,0
		cmp di,01h 
		ja ORDEN
endm

; METODOS PARA SACAR LOS ESTADISTICOS

Estadistico_Media macro arreglo, tamanio
	LOCAL SUMATORIA_MEDIA, RESULTADO_MEDIA
	MOV si, 0
	MOV res_media, 0
	
	SUMATORIA_MEDIA:
	cmp si, tamanio
	je RESULTADO_MEDIA

	MOV ah, arreglo[si]
	MOV al, arreglo[si+1]
	ADD res_media, ax
	add si, 2
	add cantidad_num, 1
	JMP SUMATORIA_MEDIA

	RESULTADO_MEDIA:
	MOV ax, res_media
	MOV bl, cantidad_num
	DIV bl
	MOV res_media, ax

	ConversionTexto res_media, number
endm

Estadistico_Menor macro arreglo
	MOV si, 0
	MOV ah, arreglo[si]
	MOV al, arreglo[si+1]
	
	MOV res_menor, ax
	ConversionTexto res_menor, number	
endm

Estadistico_Mayor macro arreglo
	MOV si, indice_bytes
	MOV ah, arreglo[si-2]
	MOV al, arreglo[si-1]
	
	MOV res_mayor, ax
	ConversionTexto res_mayor, number	
endm

Estadistico_Mediana macro arreglo, tamanio
 LOCAL CANTIDAD, RESULTADO_MEDIANA, IMPAR, PAR, FIN_MEDIANA
	MOV si, 0
	MOV di, tamanio
	MOV res_mediana, 0
	
	CANTIDAD:
	cmp si, di
	je RESULTADO_MEDIANA
	add si, 2
	add cantidad_num, 1
	JMP CANTIDAD

	RESULTADO_MEDIANA:
	TEST cantidad_num, 1
	jnz IMPAR
	jz PAR

	IMPAR:
	MOV dx, 00h
	MOV ax, indice_bytes
	SUB ax, 1
	MOV bl, 02h
	DIV bl
	MOV ah, 00h
	MOV si, ax

	MOV bh, arreglo[si]
	MOV bl, arreglo[si+1]

	MOV res_mediana, bx

	JMP FIN_MEDIANA
	PAR:
	MOV dx, 00h
	MOV ax, indice_bytes
	SUB ax, 1
	MOV bl, 02h
	DIV bl
	MOV ah, 00h
	MOV si, ax

	MOV bh, arreglo[si-1]
	MOV bl, arreglo[si]

	MOV ch, arreglo[si+1]
	MOV cl, arreglo[si+2]

	MOV ax, bx
	ADD ax, cx

	MOV dx, 00h
	MOV bl, 02h
	DIV bl
	MOV ah, 00h
	MOV res_mediana, ax

	JMP FIN_MEDIANA

	FIN_MEDIANA:
	ConversionTexto res_mediana, number
endm

; METODOS PARA CREAR EL ARCHIVO

Abrir macro buffer,handler
 LOCAL ERROR
	mov ah, 3dh
	mov al, 02h
	lea dx, buffer
	int 21h
	jc ERROR
	mov handler, ax
	print MsgAExito
	print Salto
	JMP FIN
	ERROR:
	print Salto
	print MsgAError 
	print Salto
	FIN:
endm

Cerrar macro handler
 LOCAL FIN
	mov ah, 3eh
	mov bx, handler
	int 21h
	jnc FIN
	print Salto
	print MsgCError 
	print Salto
	FIN:
endm

Crear macro buffer, handler
 LOCAL FIN, ERROR
	mov ah, 3ch
	mov cx, 00h
	lea dx, buffer
	int 21h 
	jc ERROR
	mov handler, ax
	JMP FIN
	ERROR:
	print Salto
	print MsgCrError 
	print Salto
	FIN:
endm

Leer macro handler, buffer, numbytes
 LOCAL ERROR, FIN
	mov ah, 3Fh
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	jc ERROR
	print MsgRExito
	print Salto
	JMP FIN
	ERROR:
	print Salto
	print MsgRError
	print Salto
	jmp Menu
	FIN:
endm

EscribirReporte macro handler, buffer, numbytes
 LOCAL FIN, ERROR
	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h 
	jc ERROR
	JMP FIN
	ERROR:
	print Salto
	print MsgEError 
	print Salto
	FIN:
endm

CrearReporte macro
	Limpiar rutaReporte, SIZEOF rutaReporte
	RutaDefinida rutaReporte
	ObtenerRutaReporte rutaReporte


	ObtenerHora
	ObtenerFecha
	Crear rutaReporte, handlerentrada

	; INICIO Y ALUMNNO
	EscribirReporte handlerentrada, reporte1, SIZEOF reporte1-1
	EscribirReporte handlerentrada, reporte2, SIZEOF reporte2-1

	; FECHA
	EscribirReporte handlerentrada, reporte3, SIZEOF reporte3-1
	EscribirReporte handlerentrada, d, SIZEOF d
	EscribirReporte handlerentrada, reporte4, SIZEOF reporte4-1
	EscribirReporte handlerentrada, m, SIZEOF m
	EscribirReporte handlerentrada, reporte5, SIZEOF reporte5-1
	EscribirReporte handlerentrada, a, SIZEOF a
	EscribirReporte handlerentrada, reporte6, SIZEOF reporte6-1

	;HORA
	EscribirReporte handlerentrada, reporte7, SIZEOF reporte7-1
	EscribirReporte handlerentrada, hor, SIZEOF hor
	EscribirReporte handlerentrada, reporte8, SIZEOF reporte8-1
	EscribirReporte handlerentrada, min, SIZEOF min
	EscribirReporte handlerentrada, reporte9, SIZEOF reporte9-1
	EscribirReporte handlerentrada, segu, SIZEOF segu
	EscribirReporte handlerentrada, reporte6, SIZEOF reporte6-1

	;RESULTADOS
	EscribirReporte handlerentrada, reporte10, SIZEOF reporte10-1
	
	Estadistico_Media padre_bytes, indice_bytes
	EscribirReporte handlerentrada, number, tam_num

	EscribirReporte handlerentrada, reporte11, SIZEOF reporte11-1

	Estadistico_Mediana padre_bytes, indice_bytes
	EscribirReporte handlerentrada, number, tam_num

	EscribirReporte handlerentrada, reporte12, SIZEOF reporte12-1



	EscribirReporte handlerentrada, reporte13, SIZEOF reporte13-1

	Estadistico_Menor padre_bytes
	EscribirReporte handlerentrada, number, tam_num	

	EscribirReporte handlerentrada, reporte14, SIZEOF reporte14-1	

	Estadistico_Mayor padre_bytes
	EscribirReporte handlerentrada, number, tam_num	

	EscribirReporte handlerentrada, reporte16, SIZEOF reporte16-1


	;VARIABLES PADRE
	EscribirReporte handlerentrada, reporte17, SIZEOF reporte17-1
	EscribirReporte handlerentrada, repo_comillas, SIZEOF repo_comillas-1
	
	MOV si,0
	VUELTA:
	CMP id_padre[si], 24h
	je ESCRIBIR
	inc si
	JMP VUELTA

	ESCRIBIR:
	EscribirReporte handlerentrada, id_padre, si
	EscribirReporte handlerentrada, repo_comillas, SIZEOF repo_comillas-1
	EscribirReporte handlerentrada, reporte18, SIZEOF reporte18-1




	Limpiar comparador_id, SIZEOF comparador_id
	MOV si,0
	MOV di,0

	VUELTA2:
	MOV cx, ids_del_padre[si]
	MOV ch, 00h
	CMP cl, 3Ah
	je ESCRIBIR1
	CMP cl, 2Ch
	je ESCRIBIR2
	CMP cl, 24h
	je ESCRIBIR3
	MOV comparador_id[di], cx
	inc si
	inc di
	JMP VUELTA2

	ESCRIBIR1:
	EscribirReporte handlerentrada, reporte19, SIZEOF reporte19-1
	EscribirReporte handlerentrada, repo_comillas, SIZEOF repo_comillas-1
	EscribirReporte handlerentrada, comparador_id, di
	EscribirReporte handlerentrada, repo_comillas2, SIZEOF repo_comillas2-1
	inc si
	MOV di,0
	JMP VUELTA2

	ESCRIBIR2:
	EscribirReporte handlerentrada, comparador_id, di
	EscribirReporte handlerentrada, reporte20, SIZEOF reporte20-1
	MOV di,0
	inc si
	JMP VUELTA2

	ESCRIBIR3:
	EscribirReporte handlerentrada, comparador_id, di
	EscribirReporte handlerentrada, reporte21, SIZEOF reporte21-1


	;FIN DEL ARCHIVO
	EscribirReporte handlerentrada, reporte22, SIZEOF reporte22-1
	EscribirReporte handlerentrada, reporte15, SIZEOF reporte15-1

	Cerrar handlerentrada
endm


;COMANDOS

Comandos macro
	LOCAL SHOW, SALIR, ERROR, INICIO, FIN, SHOW

	OrdenamientoBurbuja padre_bytes, indice_bytes

	INICIO:
	print MsgComd
	getChar
	MOV comando[0], al
	getChar
	MOV comando[1], al
	getChar
	MOV comando[2], al
	getChar
	MOV comando[3], al
	ConvertirMinuscula comando, SIZEOF comando
	
	;COMANDO EXIT
	ComandoExit comando

	;COMANDO SHOW
	ComandoShow comando

	;ERROR
	CMP C_bandera,1
	je ERROR


	;COMANDO MEDIANA
	MEDIANA:
	mov cx,7
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_mediana
	repe cmpsb
	jne MEDIA
	print MsgMediana
	Estadistico_Mediana padre_bytes, indice_bytes
	print number	
	print Salto
	print Salto
	Limpiar comando, SIZEOF comando
	jmp INICIO


	;COMANDO MEDIA
	MEDIA:
	mov cx,5
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_media
	repe cmpsb
	jne MENOR
	print MsgMedia
	Estadistico_Media padre_bytes, indice_bytes
	print number	
	print Salto
	print Salto
	Limpiar comando, SIZEOF comando
	jmp INICIO

	;COMANDO MENOR
	MENOR:
	mov cx,5
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_menor
	repe cmpsb
	jne MAYOR
	print MsgMenor
	Estadistico_Menor padre_bytes
	print number	
	print Salto	
	print Salto
	Limpiar comando, SIZEOF comando	
	jmp INICIO

	;COMANDO MAYOR
	MAYOR:
	mov cx,5
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_mayor
	repe cmpsb
	jne MODA
	print MsgMayor
	Estadistico_Mayor padre_bytes
	print number	
	print Salto	
	print Salto
	Limpiar comando, SIZEOF comando	
	jmp INICIO


	;COMANDO MODA
	MODA:
	mov cx,4
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_moda
	repe cmpsb
	jne PADRE
	print MsgModa
	print Salto	
	print Salto
	Limpiar comando, SIZEOF comando	
	jmp INICIO


	;COMANDO PADRE
	PADRE:
	mov si,0
	RECORRIDO_PADRE:
	cmp id_padre[si], 24h
	je COMPARAR_PADRE
	inc si
	JMP RECORRIDO_PADRE

	COMPARAR_PADRE:
	mov cx,si
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, id_padre
	repe cmpsb
	jne ID

	CrearReporte
	print MsgReporte
	print Salto	
	print Salto
	Limpiar comando, SIZEOF comando	
	jmp INICIO

	;COMANDO ID
	ID:
	MOV si, 0
	MOV di, 0
	MOV tamanio_palabra, 0
	SHOW_VALORES:
	MOV cx, ids_del_padre[si]
	MOV ch, 00h
	CMP cx, 3Ah
	je SHOW_COMPARAR
	CMP cx, 2Ch
	je SHOW_COMPARAR
	CMP cx, 24h
	je ERROR
	MOV comparador_id[di], cx
	inc si
	inc di
	inc tamanio_palabra
	JMP SHOW_VALORES

	SHOW_COMPARAR:
	MOV comparador_id[di], 24h
	MOV comp_final, si
	mov cx, tamanio_palabra
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, comparador_id
	repe cmpsb
	jne SHOW_COMPARAR_SIGUIENTE
	
	SHOW_GUARDAR_NUMERO:

	MOV si, comp_final
	MOV di, 0
	inc si

	SHOW_COMPARAR_GUARDAR_NUMERO:
	MOV cx, ids_del_padre[si]
	MOV ch, 00h
	CMP cl, 2Ch
	je SHOW_FIN_GUARDAR_NUMERO
	MOV cx, ids_del_padre[si]
	MOV show_auxiliar[di], cx
	inc si
	inc di
	JMP SHOW_COMPARAR_GUARDAR_NUMERO


	SHOW_FIN_GUARDAR_NUMERO:
	MOV show_auxiliar[di], 24h	
	print salto
	print MsgId
	print show_auxiliar
	print salto
	JMP INICIO

	SHOW_COMPARAR_SIGUIENTE:
	mov di,0
	mov si, comp_final
	inc si
	MOV tamanio_palabra, 0
	JMP SHOW_VALORES




	ERROR:
	print MsgError
	print Salto
	MOV C_bandera,0
	Limpiar comando, SIZEOF comando
	jmp INICIO
endm

ComandoExit macro comando
	LOCAL FIN
	mov cx,4
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_exit
	repe cmpsb
	jne FIN
	print Salto
	jmp Menu
	FIN:
endm

ComandoShow macro comando
	LOCAL FIN, ERROR
	mov cx,4
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, C_show
	repe cmpsb
	jne ERROR
	print espacio
	Limpiar comando, SIZEOF comando
	ObtenerTexto comando
	jmp FIN

	ERROR:
	ADD C_bandera, 1

	FIN:
endm



 
;METODOS QUE NO QUIERO VOLVER A VER :v

ObtenerHora macro
	MOV si, 0
	MOV AH,2CH
	INT 21H
	div10 CH
	mov hora[si] , ':'
	inc si
	div10 CL
	mov hora[si], ':'
	inc si
	div10 DH

	mov al, hora[0]
	mov hor[0], al
	mov al, hora[1]
	mov hor[1], al

	mov al, hora[3]
	mov min[0], al
	mov al, hora[4]
	mov min[1], al

	mov al, hora[6]	
	mov segu[0], al
	mov al, hora[7]
	mov segu[1], al
endm

div10 macro n
	mov ah, 0
	mov al, n
	mov bl, 10d
	div bl 
	add al , 48
	add ah , 48
	mov hora[si] , al
	inc si
	mov hora[si] , ah
	inc si
endm

ObtenerFecha macro
 	mov ah,2AH  
  	int 21h
    mov dia,dl    
    mov mes,dh 
    mov anio,cx
    Conv_dia
    Conv_mes
    Conv_anio
endm	

Conv_dia macro
	mov al, dia
	aam
	add al, '0'
	mov d[1],al
	add ah, '0'
	mov d[0],ah
endm

Conv_mes macro
	mov al, mes
	aam
	add al, '0'
	mov m[1],al
	add ah, '0'
	mov m[0],ah
endm

Conv_anio macro
	mov ax, anio
	cwd
	mov bx, 1000
	div bx
	aam
	mov res,dx
	add al,'0'
	mov a[0],al

	mov ax,res
	cwd
	mov bx, 100
	div bx
	aam
	mov res,dx
	add al,'0'
	mov a[1],al

	mov ax,res
    cwd
    mov bx, 10
    div bx
    aam
    mov res,dx
    add al,'0'
    mov a[2],al

    mov ax,res
    aam
    add al,'0'
    mov a[3],al
endm

;
; ************** [IMPRIMIR] **************
GetPrint macro buffer
	MOV AX,@data
	MOV DS,AX
	MOV AH,09H
	MOV DX,OFFSET buffer
	INT 21H
endm
; ************** [CAPTURAR ENTRADA] **************
GetInput macro
	MOV AH,01H
	int 21H
endm

GetInputMax macro _resultS
	mov ah, 3fh 					; int21 para leer fichero o dispositivo
	mov bx, 00 						; handel para leer el teclado
	mov cx, 10 						; bytes a leer (aca las definimos con 10)
	mov dx, offset[_resultS]
	int 21h
endm
; ************** [VARIABLE][GET] **************
GetText macro buffer
	LOCAL Ltext, Lout
	xor si,si  ; Es igual a mov si,0

	Ltext:
		GetInput
		cmp al,0DH ; Codigo ASCCI [\n -> Hexadecimal]
		je Lout
		mov buffer[si],al ; mov destino,fuente
		inc si ; si = si + 1
		jmp Ltext

	Lout:
		mov al,24H ; Codigo ASCCI [$ -> Hexadecimal]
		mov buffer[si],al
endm
; ************** [PATH][GET] **************
GetRoot macro buffer
	LOCAL Ltext, Lout
	xor si,si  ; Es igual a mov si,0

	Ltext:
		GetInput
		cmp al,0DH ; Codigo ASCCI [\n -> Hexadecimal]
		je Lout
		mov buffer[si],al ; mov destino,fuente
		inc si ; si = si + 1
		jmp Ltext

	Lout:
		mov al,00H ; Codigo ASCCI [null -> Hexadecimal]
		mov buffer[si],al
endm
; ************** [PATH][OPEN] **************
GetOpenFile macro buffer,handler
	mov ah,3dh
	mov al,02h
	lea dx,buffer
	int 21h
	jc Lerror1
	mov handler,ax
endm
; ************** [PATH][CLOSE] **************
GetCloseFile macro handler
	mov ah,3eh
	mov bx,handler
	int 21h
	jc Lerror2
endm
; ************** [PATH][READ] **************
GetReadFile macro handler,buffer,numbytes
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc Lerror5
endm


; ************** [PATH][CREATE] **************
GetCreateFile macro buffer,handler
    MOV AX,@data
    MOV DS,AX
    MOV AH,3ch
    MOV CX,00h
    LEA DX,buffer
    INT 21h
    ;jc Error4
    MOV handler, AX
endm
; ************** [PATH][WRITE] **************
GetWriteFile macro handler, buffer
    LOCAL ciclo_Ini, ciclo_Fin
    MOV AX,@data
    MOV DS,AX
    ; MOV AH,40h
    ; MOV BX,handler
    ; MOV CX, SIZEOF buffer 

    XOR BX, BX
    XOR AX, AX 
    ciclo_Ini:
      MOV AL, buffer[ BX ]
      CMP AL, '$'
      JE ciclo_Fin

      INC BX 
      JMP ciclo_Ini
    ciclo_Fin:
    XOR AX, AX

    MOV contadorBuffer, BX
    XOR BX, BX
    
    MOV AH,40h
    MOV BX,handler
    MOV CX, contadorBuffer
    LEA DX, buffer
    INT 21h
endm

GetWriteFileN macro handler, buffer
    LOCAL ciclo_Ini, ciclo_Fin
    MOV AX,@data
    MOV DS,AX

    MOV AH,40h
    MOV BX, handler
    MOV CX, SIZEOF buffer 
    LEA DX, buffer
    INT 21h
endm

; ************** [DATE][WRITE] **************
GetWriteDate macro handler, digito1, digito2

  MOV AH, 2AH 
  INT 21H 
  MOV digito1, 0
  MOV digito2, 0
  MOV AL, DL 

	; FECHA
  GetWriteFile handler, _Reporte8S
  ; DIA ---- 9
  GuardarDigitos digito1, digito2

	GetWriteFile handler, _Reporte9S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _Reporte31S
  GetWriteFile handler, _salto
  ; WriteFile handler, diagonal

  ; MES ---- 10
  MOV AH, 2AH 
  INT 21H 
  MOV digito1, 0 
  MOV digito2, 0
  MOV AL, DH 

  GuardarDigitos digito1, digito2

  GetWriteFile handler, _Reporte10S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _Reporte31S
  GetWriteFile handler, _salto

  ; AÑO --- 11
  MOV AH, 2AH 
  INT 21H
  MOV digito1, 0
  MOV digito2, 0
  ADD CX, 0F830h
  MOV AX, CX 

  GuardarDigitos digito1, digito2 
  
  GetWriteFile handler, _Reporte11S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _salto

  
  GetWriteFile handler, _Reporte12S

  ; HORA
  GetWriteFile handler, _Reporte13S
  MOV AH, 2Ch
  INT 21H 

  ; HORA -------- 14 
  MOV AL, CH 
  GuardarDigitos digito1, digito2
  
  GetWriteFile handler, _Reporte14S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _Reporte31S
  GetWriteFile handler, _salto

  ; MINUTOS	------- 15
  MOV AH, 2Ch
  INT 21h
  MOV digito1, 0
  MOV digito2, 0
  MOV AL, CL 

  GuardarDigitos digito1, digito2
  
  GetWriteFile handler, _Reporte15S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _Reporte31S
  GetWriteFile handler, _salto

  ; SEGUNDOS -------- 16
  MOV AH, 2Ch
  INT 21H
  MOV digito1, 0
  MOV digito2, 0
  MOV AL, DH 

  GuardarDigitos digito1, digito2
  
  GetWriteFile handler, _Reporte16S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _salto


  GetWriteFile handler, _Reporte17S
endm

GuardarDigitos MACRO _digito1, _digito2
  AAM
  MOV BX, AX
  ADD BX, 3030h

  MOV _digito1, BH
  MOV _digito2, BL
endm

; *************** [CALCULADORA] **************************

;convierte un NUMERO a CADENA que esta guardado en AX 
Int_String macro intNum
  local div10, signoN, unDigito, obtenerDePila
  ;Realizando backup de los registros BX, CX, SI
  push ax
  push bx
  push cx
  push dx
  push si
  xor si,si
  xor cx,cx
  xor bx,bx
  xor dx,dx
  mov bx,0ah 				; Divisor: 10
  test ax,1000000000000000 	; veritficar si es numero negativo (16 bits)
  jnz signoN
  unDigito:
      cmp ax, 0009h
      ja div10
      mov intNum[si], 30h 	; Se agrega un CERO para que sea un numero de dos digitos
      inc si
      jmp div10
  signoN:					; Cambiar de Signo el numero 
  	  neg ax 				; Se niega el numero para que sea positivo
  	  mov intNum[si], 2dh 	; Se agrega el signo negativo a la cadena de salida
  	  inc si
  	  jmp unDigito
  div10:
      xor dx, dx 			; Se limpia el registro DX; Este simulará la parte alta del registro
      div bx 				; Se divide entre 10
      inc cx 				; Se incrementa el contador
      push dx 				; Se guarda el residuo DX
      cmp ax,0h 			; Si el cociente es CERO
      je obtenerDePila
	  jmp div10
  obtenerDePila:
      pop dx 				; Obtenemos el top de la pila
      add dl,30h 			; Se le suma '0' en su valor ascii para numero real
      mov intNum[si],dl 	; Metemos el numero al buffer de salida
      inc si
      loop obtenerDePila
      mov ah, '$' 			; Se agrega el fin de cadena
      mov intNum[si],ah
      						; Restaurando registros
      pop si
      pop dx
      pop cx
      pop bx
      pop ax
endm

;convierte una CADENA A NUMERO, este es guardado en AX.
String_Int macro stringNum
  local ciclo, salida, verificarNegativo, negacionRes
  push bx
  push cx
  push dx
  push si
  ;Limpiando los registros AX, BX, CX, SI
  xor ax, ax
  xor bx, bx
  xor dx, dx
  xor si, si
  mov bx, 000Ah						;multiplicador 10
  ciclo:
      mov cl, stringNum[si]
      inc si
      cmp cl, 2Dh 					; compara para ignorar el "-"
      jz ciclo    					; Se ignora el simbolo '-' de la cadena
      cmp cl, 30h 					; Si el caracter es menor a '0', implica que es negativo (verificacion)
      jb verificarNegativo 			; ir para cuando es un negativo 
      cmp cl, 39h 					; Si el caracter es mayor a '9', implica que es negativo (verificacion)
      ja verificarNegativo
  	  sub cl, 30h					; Se le resta el ascii '0' para obtener el número real
  	  mul bx      					; multplicar ax
      mov ch, 00h
   	  add ax, cx  					; sumar para obtener el numero total
  	  jmp ciclo
  negacionRes:
      neg ax 						; negacion por si es negativo el resultado
      jmp salida
  verificarNegativo: 
      cmp stringNum[0], 2Dh 		; Si existe un signo al inicio del numero, negamos el numero
      jz negacionRes
  salida:
      								; Restaurando los registros AX, BX, CX, SI
      pop si
      pop dx
      pop cx
      pop bx
endm

; recibe una cadena y lo convierte en numero
Solicitar_Numero macro cadenaNumero, numeroConvertido
	mov ah, 3fh 					; int21 para leer fichero o dispositivo
	mov bx, 00 						; handel para leer el teclado
	mov cx, 20 						; bytes a leer (aca las definimos con 10)
	mov dx, offset[cadenaNumero]
	int 21h
	GetAC cadenaNumero
	GetEND cadenaNumero
	GetEVAL cadenaNumero,numeroConvertido
	GetPrintCommand cadenaNumero
	;cmp cadenaNumero,'d7h'  ; Codigo ASCCI [END -> Hexadecimal] salir del programa
	;je Lmenu
	
	; Convertimos la cadena a numero es guardado en AX
	String_Int cadenaNumero
	mov numeroConvertido, ax 		; Guardar en el "int"
	GetImparPar
	GetPrimo numeroConvertido
endm

;limpiar variables
GetClean macro _numero1, _numero2, _calcuResultado
    mov _numero1, 0
    mov _numero1, ax
    mov _calcuResultado, 0
    mov _numero2, 0
endm



GetAC macro palabra
	LOCAL ac1, ac2
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx 
  
	; 13
	cmp palabra[SI], 41h
	je ac1	
	jmp ac2

	ac1:
		INC SI
		cmp palabra[SI], 43h
		je Loperacion
		jmp ac1

	ac2:
		push ax
  		push cx
  		push bx
  		push dx 

endm

GetPotencia macro _result, _num1S, _num1I, _num2I, _numTemp
	LOCAL _Lout, _L0, _Lpote
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	inc SI ; incremento 1° vez
	inc SI ; incremento 2° vez
	mov ax,_num1I
	mov _numTemp, ax
	cmp _num2I,0
	je _L0
	jmp _Lpote

	_L0:

		mov _num1I,1
		mov _num1S,'1'
		jmp _Lout

	_Lpote:
		mov ax, _numTemp
    mov bx, _num1I
    imul bx
    mov _result,ax
    mov ax,_result
    Int_String _num1S ; convierte el numero guardado en ax
    mov _numTemp,ax
    cmp SI,_num2I
   	je _Lout
   	inc SI
    jmp _Lpote

	_Lout:
		GetPrint _resultado
    GetPrint _num1S
	
endm



GetEND macro palabra
	LOCAL _Lend1, _Lend2, _Lout
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx 
  
	; 13
	cmp palabra[SI], 45h ; Codigo ASCCI [E -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 4eh ; Codigo ASCCI [N -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 44h ; Codigo ASCCI [D -> Hexadecimal]
		je Lmenu
		jmp _Lout

	_Lout:

endm


GetEVAL macro palabra, numeroConvertido
	LOCAL _Lend1, _Lend2, _Lend3, _Lend4, _Lout, _Lout2, _Lconca
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor BX, BX ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx  

	; 13
	cmp palabra[SI], 45h ; Codigo ASCCI [E -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 56h ; Codigo ASCCI [V -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 41h ; Codigo ASCCI [A -> Hexadecimal]
		je _Lend3
		jmp _Lout

	_Lend3:
		INC SI
		Cmp palabra[SI], 4ch ; Codigo ASCCI [L -> Hexadecimal]
		je _Lend4
		jmp _Lout


	_Lend4:
		INC SI
		cmp palabra[SI], 20h ; Codigo ASCCI [space -> Hexadecimal]
		je _Lend4
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout
		
	

		XOR AX, AX
		mov al,palabra[SI]
		mov _OPERAS[BX], AL
		INC BX
		
		jmp _Lconca

	_Lconca:
		INC SI
		XOR AX, AX
		mov al,palabra[SI]
		
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout2
		mov _OPERAS[BX], AL
		INC BX
		jmp _Lconca
	_Lout2:
		
		GetPrint _OPERAS
		GetPrint _salto
		GetAnalizador _bufferInfo


		
		jmp _Lout
	_Lout:
		push ax
	  push cx
	  push bx
	  push dx 

endm




GetAnalizador macro text
	local _Lout, _Lerror, _Linput, _Linput2, _LcalculosL, _L0, Lllavea,_calculo1, _calculo2, _calculo3, _calculo4, _calculo5, _calculo6, _calculo7, _calculo8, _calculo9, _calculo10, _calculo11
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor BX, BX ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx 
	; GetPrint text
	Lllavea:

		cmp text[SI],7bh  ; Codigo ASCCI [{ -> Hexadecimal]
		je _Linput
		INC SI
		jmp Lllavea

	_Linput:

		inc SI
		cmp text[SI],22h ;Codigo ASCCI [" -> Hexadecimal]
		je _Linput2
		jmp _Linput

	_Linput2:

		inc SI

		cmp text[SI],63h	 ; Codigo ASCCI [c -> Hexadecimal]
		je _calculo1
		jmp _Lout

	_calculo1:
		inc SI

		cmp text[SI],61h	 ; Codigo ASCCI [a -> Hexadecimal]
		je _calculo2
		jmp _Lout

	_calculo2:
		inc SI

		cmp text[SI],6ch	 ; Codigo ASCCI [l -> Hexadecimal]
		je _calculo3
		jmp _Lout

	_calculo3:

		inc SI
		cmp text[SI],63h	 ; Codigo ASCCI [c -> Hexadecimal]
		je _calculo4
		jmp _Lout

	_calculo4:
		inc SI
		cmp text[SI],75h	 ; Codigo ASCCI [u -> Hexadecimal]
		je _calculo5
		jmp _Lout

	_calculo5:
		inc SI
		cmp text[SI],6ch	 ; Codigo ASCCI [l -> Hexadecimal]
		je _calculo6
		jmp _Lout

	_calculo6:
		inc SI
		cmp text[SI],6fh	 ; Codigo ASCCI [o -> Hexadecimal]
		je _calculo7
		jmp _Lout

	_calculo7:
		inc SI
		cmp text[SI],73h	 ; Codigo ASCCI [s -> Hexadecimal]
		je _calculo8
		jmp _Lout

	_calculo8:
		inc SI
		cmp text[SI],22h	 ; Codigo ASCCI [" -> Hexadecimal]
		je _calculo9
		jmp _Lout


	_calculo9:
		inc SI
		cmp text[SI],3ah	 ; Codigo ASCCI [: -> Hexadecimal]
		je _calculo10
		jmp _calculo9

	_calculo10:
		inc SI
		cmp text[SI],3ah	 ; Codigo ASCCI [: -> Hexadecimal]
		je _calculo11
		jmp _calculo10

	_calculo11:
		inc SI
		cmp text[SI],5bh	 ; Codigo ASCCI [: -> Hexadecimal]
		je _LcalculosL
		jmp _calculo11

	_LcalculosL:
		
		inc SI

		GetPrint _resultado
		jmp _Lout

	_L0:
		; inc SI

		mov _indice0, SI
		GetOperacion text
		jmp _Lout

	_Lerror:
		GetPrint _error6
		jmp _Lout
	_Lout:
			push ax
	  	push cx
	  	push bx
	  	push dx 

endm



GetOperacion macro text
	LOCAL L0, Lin, Lout, Lcompare
	push ax
  push cx
  push bx
  push dx
	xor BX, BX ; contador para posiciones

	L0:
		INC SI
	  mov SI,_indice0

		cmp text[SI], 22h ; Codigo ASCCI [" -> Hexadecimal]
		je Lin
		jmp L0

	Lin:
		INC SI
		XOR AX, AX
		mov al,text[SI]
		cmp text[SI], 22h ; Codigo ASCCI [" -> Hexadecimal]
		je Lout

		mov _OPERASCompare[BX],al 
		jmp Lin



	Lcompare:
			GetPrint _OPERAS 
			GetPrint _salto
			GetPrint _OPERASCompare
			GetPrint _salto
			jmp Lout

	Lout:

		push ax
	  push cx
	  push bx
	  push dx


endm


GetCleanConsole macro
	mov ah, 00
	mov al, 03h
	int 10h

endm



GetImparPar macro
	local par, impar, salir

	mov bl,2
	div bl
	;compara
	cmp ah,0
	jp par
	jnp impar

	par:
		; GetPrint _PAR
		mov dx, _numeroPar
    add dx, 1
    mov _numeroPar, dx
    mov ax, _numeroPar
    Int_String _numeroParS
    ; GetPrint _numeroParS
    ; GetPrint _salto
		jmp salir
	
	
	impar:
		; GetPrint _IMPAR
		mov dx, _numeroImpar
    add dx, 1
    mov _numeroImpar, dx
    mov ax, _numeroImpar
    Int_String _numeroImparS
    ; GetPrint _numeroImparS
    ; GetPrint _salto
		jmp salir
	
	salir: 
	
	
endm

GetPrimo macro num
	local ciclo, primo, noPrimo, salir, isPrimo, notPrimo
 	mov _contPrimo,0
 	mov BX,1

    ciclo:
 
      cmp BX,num
      jg salir
      xor ax,ax
       mov ax,num
      div bl
      ; ;compara

      cmp ah,0
      je primo
      jne noPrimo


      primo:
         inc _contPrimo
         inc BX
         jmp ciclo
      
      noPrimo:
          inc BX
          jmp ciclo

    salir: 


    cmp _contPrimo,2
    jz isPrimo
    jnz notPrimo


    isPrimo:
    	mov dx, _numeroPrimo
	    add dx, 1
	    mov _numeroPrimo, dx
	    mov ax, _numeroPrimo
	    Int_String _numeroPrimoS
        
    notPrimo:

        
endm


GetPrintCommand macro palabra
LOCAL _Lend1, _Lend2, _Lend3, _Lend4, _Lend5,_Lout, _Lout2, _Lconca
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor BX, BX ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx  

	; 13
	cmp palabra[SI], 50h ; Codigo ASCCI [P -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 52h ; Codigo ASCCI [R -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 49h ; Codigo ASCCI [I -> Hexadecimal]
		je _Lend3
		jmp _Lout

	_Lend3:
		INC SI
		Cmp palabra[SI], 4eh ; Codigo ASCCI [N -> Hexadecimal]
		je _Lend4
		jmp _Lout

	_Lend4:
		INC SI
		Cmp palabra[SI], 54h ; Codigo ASCCI [T -> Hexadecimal]
		je _Lend5
		jmp _Lout

	_Lend5:
		INC SI
		cmp palabra[SI], 20h ; Codigo ASCCI [space -> Hexadecimal]
		je _Lend5
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout
		
	

		XOR AX, AX
		mov al,palabra[SI]
		mov _cadenaParImpar[BX], AL
		INC BX
		
		jmp _Lconca

	_Lconca:
		INC SI
		XOR AX, AX
		mov al,palabra[SI]
		
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout2

		mov _cadenaParImpar[BX], AL
		INC BX
		jmp _Lconca
	_Lout2:
		
		GetPrintPar _cadenaParImpar
		GetPrintImpar _cadenaParImpar	
		GetPrintPrimo	_cadenaParImpar
		jmp _Lout

	_Lout:
		push ax
	  push cx
	  push bx
	  push dx

endm


GetPrintPar macro palabra
LOCAL _Lend1, _Lend2, _Lend3, _Lend4, _Lend5, _Lout, _Lout2, _Lconca
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor BX, BX ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx  

	; 13
	cmp palabra[SI], 50h ; Codigo ASCCI [P -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 41h ; Codigo ASCCI [A -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 52h ; Codigo ASCCI [R -> Hexadecimal]
		je _Lend3
		jmp _Lout

	_Lend3:
		INC SI
		Cmp palabra[SI], 45h ; Codigo ASCCI [E -> Hexadecimal]
		je _Lend4
		jmp _Lout

	_Lend4:
		INC SI
		Cmp palabra[SI], 53h ; Codigo ASCCI [T -> Hexadecimal]
		je _Lend5
		jmp _Lout

	_Lend5:
		INC SI
		cmp palabra[SI], 20h ; Codigo ASCCI [space -> Hexadecimal]
		je _Lend5
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout
		
	

		XOR AX, AX
		mov al,palabra[SI]
		mov _cadenaParImpar[BX], AL
		INC BX
		
		jmp _Lconca

	_Lconca:
		INC SI
		XOR AX, AX
		mov al,palabra[SI]
		
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout2

		mov _cadenaParImpar[BX], AL
		INC BX
		jmp _Lconca
	_Lout2:
		
		
		GetPrint _salto
		GetPrint _PAR
		GetPrint _numeroParS
		GetPrint _salto
		
		
	  jmp Lmenu
	_Lout:
		push ax
	  push cx
	  push bx
	  push dx 
endm

GetPrintImpar macro palabra
LOCAL _Lend1, _Lend2, _Lend3, _Lend4, _Lend5, _Lend6, _Lend7, _Lout, _Lout2, _Lconca
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor BX, BX ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx  

	; 13
	cmp palabra[SI], 49h ; Codigo ASCCI [I -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 4dh ; Codigo ASCCI [M -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 50h ; Codigo ASCCI [P -> Hexadecimal]
		je _Lend3
		jmp _Lout

	_Lend3:
		INC SI
		Cmp palabra[SI], 41H ; Codigo ASCCI [A -> Hexadecimal]
		je _Lend4
		jmp _Lout

	_Lend4:
		INC SI
		Cmp palabra[SI], 52H ; Codigo ASCCI [R -> Hexadecimal]
		je _Lend5
		jmp _Lout

	_Lend5:
		INC SI
		Cmp palabra[SI], 45H ; Codigo ASCCI [E -> Hexadecimal]
		je _Lend6
		jmp _Lout

	_Lend6:
		INC SI
		Cmp palabra[SI], 53H ; Codigo ASCCI [S -> Hexadecimal]
		je _Lend7
		jmp _Lout

	_Lend7:
		INC SI
		cmp palabra[SI], 20h ; Codigo ASCCI [space -> Hexadecimal]
		je _Lend7
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout
		
	

		XOR AX, AX
		mov al,palabra[SI]
		mov _cadenaParImpar[BX], AL
		INC BX
		
		jmp _Lconca

	_Lconca:
		INC SI
		XOR AX, AX
		mov al,palabra[SI]
		
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout2

		mov _cadenaParImpar[BX], AL
		INC BX
		jmp _Lconca
	_Lout2:
		
		
		GetPrint _salto
		GetPrint _IMPAR
		GetPrint _numeroImparS
		GetPrint _salto
		
		
	  jmp Lmenu
	_Lout:
		push ax
	  push cx
	  push bx
	  push dx 
endm


GetPrintPrimo macro palabra
LOCAL _Lend1, _Lend2, _Lend3, _Lend4, _Lend5,  _Lend6, _Lout, _Lout2, _Lconca
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor BX, BX ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx  

	; 13
	cmp palabra[SI], 50h ; Codigo ASCCI [P -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 52h ; Codigo ASCCI [R -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 49h ; Codigo ASCCI [I -> Hexadecimal]
		je _Lend3
		jmp _Lout

	_Lend3:
		INC SI
		Cmp palabra[SI], 4dh ; Codigo ASCCI [M -> Hexadecimal]
		je _Lend4
		jmp _Lout

	_Lend4:
		INC SI
		Cmp palabra[SI], 4fh ; Codigo ASCCI [O -> Hexadecimal]
		je _Lend5
		jmp _Lout

	_Lend5:
		INC SI
		Cmp palabra[SI], 53h ; Codigo ASCCI [S -> Hexadecimal]
		je _Lend6
		jmp _Lout

	_Lend6:
		INC SI
		cmp palabra[SI], 20h ; Codigo ASCCI [space -> Hexadecimal]
		je _Lend6
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout
		
	

		XOR AX, AX
		mov al,palabra[SI]
		mov _cadenaParImpar[BX], AL
		INC BX
		
		jmp _Lconca

	_Lconca:
		INC SI
		XOR AX, AX
		mov al,palabra[SI]
		
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout2

		mov _cadenaParImpar[BX], AL
		INC BX
		jmp _Lconca
	_Lout2:
		
		
		GetPrint _salto
		GetPrint _PRIMO
		GetPrint _numeroPrimoS
		GetPrint _salto
		
		
	  jmp Lmenu
	_Lout:
		push ax
	  push cx
	  push bx
	  push dx 
endm