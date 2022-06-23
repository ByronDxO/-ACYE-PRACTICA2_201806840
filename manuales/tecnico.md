# [Manual Ténico]()
______

___
## Metodos a Utilizar
____

### Assembler 
El lenguaje ensamblador o assembly es un lenguaje de programación de bajo nivel. Consiste en un conjunto de mnemónicos que representan instrucciones básicas para los computadores, microprocesadores, microcontroladores y otros circuitos integrados programables.



Metodo enseñar media 
```GetShowMedia macro txt
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
```

Metodo para pasa int a string 

```
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
```

_Metodo para enseñar la mediana 
_
```GetShowMediana macro txt
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
```


Metodo para mostrar y luego concatenar por hijos nodos 
```GetShowPadre macro txt
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
```
inicio de metodo menu 
```main proc

    Lstart:
    call funcIdentificar
    getInput
    cmp al,0Dh 
    je Lmenu 
    jmp Lstart

    Lmenu: 
        call functionMenu
        getInput
        cmp al,31H ; 1 en hexa decimal 
        cmp al,32H ; 2 en hexa 
        cmp al,33H ; 3 en hexa 
        je Lexit
        jmp Lmenu

    Lexit:
    mov ax,4c00h
    int 21h

    Lsum:; suma 
        mov dx , _int1
        add dx , _int2
        mov _calres , dx 
        mov ax , _calres

main endp
end main
```

Declaraciones inicilaes para el proyecto
``` menu 
_space db 0ah,0dh, "$"
_option db 0ah,0dh, "> INGRESAR DECISION: $"
_return db 0ah,0dh, "1. REGRESAR$"
_num db  ">", "$"
_result db 0ah,0dh, "> RESULTADO es ", "$"
_chain8 db 0ah,0dh, "1. CALCULADORA$"
_chain9 db 0ah,0dh, "2. ARCHIVO$"
_chain10 db 0ah,0dh, "3. EXIT$"
; mensaje de inicio variables 
_chain1 db 0ah,0dh, "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA$"
_chain2 db 0ah,0dh, "FACULTAD DE INGENIERIA$"
_chain3 db 0ah,0dh, "ESCUELA DE CIENCIAS Y SISTEMAS$"
_chain4 db 0ah,0dh, "ARQUITECTURA DE COPMILADORES Y ENSAMBLADORES$"
_chain5 db 0ah,0dh, "SECCION <A>$"
_chain6 db 0ah,0dh, "<BYRON RUBEN HERNANDEZ DE LEON>$"
_chain7 db 0ah,0dh, "<201806840>$"
```

Meotod para poder escribir el reporte 
```mov _reporteHandle,0
        GetCreateFile _createFile, _reporteHandle


        ; DATOS 
        GetWriteFile _reporteHandle, _Reporte0S
        GetWriteFile _reporteHandle, _Reporte1S
        GetWriteFile _reporteHandle, _Reporte2S
        GetWriteFile _reporteHandle, _Reporte3S
        GetWriteFile _reporteHandle, _Reporte4S
        GetWriteFile _reporteHandle, _Reporte5S
        GetWriteFile _reporteHandle, _Reporte6S
        GetWriteFile _reporteHandle, _Reporte7S
        GetWriteDate _reporteHandle, _digito1, _digito2
        
      
        ; ESTADISTICOS
        GetWriteFile _reporteHandle, _Reporte18S
        GetWriteFile _reporteHandle, _Reporte19S
        GetWriteFile _reporteHandle, _Reporte20S
        GetWriteFile _reporteHandle, _Reporte21S
        ; IMPAR
        GetWriteFile _reporteHandle, _Reporte22S
        GetWriteFile _reporteHandle, _numeroImparS
        GetWriteFile _reporteHandle, _Reporte31S
        
        ; PAR
        GetWriteFile _reporteHandle, _Reporte23S
        GetWriteFile _reporteHandle, _numeroParS
        GetWriteFile _reporteHandle, _Reporte31S
        ; PRIMO
        GetWriteFile _reporteHandle, _Reporte24S
        GetWriteFile _reporteHandle, _numeroPrimoS
        GetWriteFile _reporteHandle, _Reporte25S
        ; OPERACIONES
        GetWriteFile _reporteHandle, _Reporte26S
        GetWriteFile _reporteHandle, _Reporte27S
        GetWriteFile _reporteHandle, _Reporte28S
        GetWriteFile _reporteHandle, _Reporte29S
```
