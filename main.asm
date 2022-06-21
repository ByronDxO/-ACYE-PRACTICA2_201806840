include atajos.asm
.model small
.stack
.data

; variables 
;almacenar datos claculadora 
_chainCal db 0ah , 0dh, "MODO CALCULADORA", "$"
_int1   dw 0        
_int2   dw 0       
_calres dw 0 
_salto          db 0ah,0dh,               "$"
_opcion         db 0ah,0dh,               "> Ingrese Opcion: $"
_regresar       db 0ah,0dh,               "1. regresar$"

_resultado      db 0ah,0dh,               "> resultado es ", "$"
_reporte        db 50 dup('$')

; menu 
_space db 0ah,0dh, "$"
_option db 0ah,0dh, "> INGRESAR DECISION: $"
_return db 0ah,0dh, "1. REGRESAR$"
_num db  ">", "$"
_result db 0ah,0dh, "> RESULTADO es ", "$"
_chain8 db 0ah,0dh, "SELECCIONE 1 CALCULADORA$"
_chain9 db 0ah,0dh, "SELECCIONE 2 ARCHIVO$"
_chain10 db 0ah,0dh, "SELECCIONE 3 EXIT$"
; mensaje de inicio variables 
_chain1 db 0ah,0dh, "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA$"
_chain2 db 0ah,0dh, "FACULTAD DE INGENIERIA$"
_chain3 db 0ah,0dh, "ESCUELA DE CIENCIAS Y SISTEMAS$"
_chain4 db 0ah,0dh, "ARQUITECTURA DE COPMILADORES Y ENSAMBLADORES$"
_chain5 db 0ah,0dh, "SECCION <A>$"
_chain6 db 0ah,0dh, "<BYRON RUBEN HERNANDEZ DE LEON>$"
_chain7 db 0ah,0dh, "<201806840>$"
; ERRORES 
_err1 db 0ah,0dh, "NO SE ENCONTRO EL ARCHIVO", "$"
_err2 db 0ah,0dh, "ERROR EN UNA GESTION DEL ARCHIVO", "$"
_err3 db 0ah,0dh, "PROBLEMAS CON LA RUTA DEL ARCHIVO", "$"
_error1         db 0ah,0dh,               "> Error al Abrir Archivo, no Existe ",   "$"
_error2         db 0ah,0dh,               "> Error al Cerrar Archivo",              "$"
_error3         db 0ah,0dh,               "> Error al Escribir el Archivo",         "$"
_error4         db 0ah,0dh,               "> Error al Crear el Archivo",            "$"
_error5         db 0ah,0dh,               "> Error al Leer al Archivo",             "$"
_error6         db 0ah,0dh,               "> Error en el Archivo",                  "$"
_error7         db 0ah,0dh,               "> Error al crear el Archivo",                  "$"
;OPERADORES

_cadena8        db 0ah,0dh,               "1. Calculadora$"
_cadena9        db 0ah,0dh,               "2. Archivo$"
_cadena10       db 0ah,0dh,               "3. Salir$"

_cadena11       db 0ah,0dh,               "+ Suma$"
_cadena12       db 0ah,0dh,               "- Resta$"
_cadena13       db 0ah,0dh,               "x Multiplicacion$"
_cadena14       db 0ah,0dh,               "/ Division$"
_cadena15       db 0ah,0dh,               "^ Potencia$"

_cadena16       db 0ah,0dh,               "> Ingrese la Ruta del Archivo: ", "$"
_cadena17       db 0ah,0dh,               "1. Cargar Archivo ",     "$"
_cadena18       db 0ah,0dh,               "2. Cerrar Archivo ",     "$"
_cadena19       db 0ah,0dh,               "3. Mostrar Contenido",   "$"
_cadena20       db 0ah,0dh,               "4. Regresar",            "$"
_chain11 db 0ah,0dh, "+ SUMA$"
_chain12 db 0ah,0dh, "- RESTA$"
_chain13 db 0ah,0dh, "x MULTIPLICACION$"
_chain14 db 0ah,0dh, "/ DIVISION$"
_chain15 db 0ah,0dh, "^ POTENCIA$"
;archivo 

_chain16 db 0ah,0dh, "INGRESAR RUTA DE ARCHIVO :" ,"$"
_chain17 db 0ah,0dh, "1 PARA CARGAR ARCHIVO " ,"$"
_chain18 db 0ah,0dh, "2 PARA CERRAR ARCHIVO " ,"$"
_chain19 db 0ah,0dh, "3 PARA MOSTRAR CONTENIDO " ,"$"
_chain20 db 0ah,0dh, "4 PARA REGRESAR " ,"$"
;calculadora 
_PAR            db 0ah,0dh, "Cantidad de Numeros Pares Reconocidos: $"
_IMPAR          db 0ah,0dh, "Cantidad de Numeros Impares Reconocidos: $"
_PRIMO          db 0ah,0dh, "Cantidad de Numeros Primos Reconocidos: $"
_cadena21       db 0ah,0dh,               "Calculadora",            "$"
_cadena22       db 0ah,0dh,               "==============================",  "$"
_resultS        db 10 dup(' '), "$" 
_numero1S       db 10 dup(' '), "$" 
_numero2S       db 10 dup(' '), "$" 
_numero3S       db 10 dup(' '), "$" 
_numeroParS     db 10 dup(' '), "$" 
_numeroImparS   db 10 dup(' '), "$" 
_numeroPrimoS   db 10 dup(' '), "$"
_numeroMediaS   db 10 dup(' '), "$"
_OPERAS         db 50 dup(' '), "$" 
_OPERASCompare  db 50 dup(' '), "$" 
_cadenaParImpar db 50 dup(' '), "$" 
_indice0        dw 0
_indicef        dw 0
_numero1        dw 0                
_numero2        dw 0               
_numero3        dw 0                
_numeroPar      dw 0                
_numeroImpar    dw 0                
_numeroPrimo    dw 0 
_numeroMedia    dw 0 
_contPrimo      dw 0
_numeroTemp     dw 0                
_calcuResultado dw 0                

_createFile     db 'reporte.jso' 
_reporteHandle  dw ?
_Reporte0S      db 0ah,0dh,               "{",'$'
_Reporte1S      db 0ah,0dh,               '     "reporte":[ $'
_Reporte2S      db 0ah,0dh,               '         "Datos":{ $'
_Reporte3S      db 0ah,0dh,               '             "nombre":"BYRON RUBEN HERNANDEZ DE LEON",$'
_Reporte4S      db 0ah,0dh,               '             "carnet":"201806840",$'
_Reporte5S      db 0ah,0dh,               '             "curso":"ARQUITECTURA DE COMPILADORES Y ENSAMBLADORES 1",$'
_Reporte6S      db 0ah,0dh,               '             "seccion":"A"$'
_Reporte7S      db 0ah,0dh,               '         }, $'
_Reporte8S      db 0ah,0dh,               '         "Fecha":{ $'
_Reporte9S      db 0ah,0dh,               '             "Dia":$'
_Reporte10S     db 0ah,0dh,               '             "Mes":$'
_Reporte11S     db 0ah,0dh,               '             "Año":$'
_Reporte12S     db 0ah,0dh,               '         }, $'
_Reporte13S     db 0ah,0dh,               '         "Hora":{ $'
_Reporte14S     db 0ah,0dh,               '             "hora":$'
_Reporte15S     db 0ah,0dh,               '             "minuto":$'
_Reporte16S     db 0ah,0dh,               '             "segundo":$'
_Reporte17S     db 0ah,0dh,               '         }, $'
_Reporte18S     db 0ah,0dh,               '         "Estadísticos":{ $'
_Reporte19S     db 0ah,0dh,               '             "media":"",$'
_Reporte20S     db 0ah,0dh,               '             "mediana":"",$'
_Reporte21S     db 0ah,0dh,               '             "moda":"",$'
_Reporte22S     db 0ah,0dh,               '             "impares":$'
_Reporte23S     db 0ah,0dh,               '             "pares":$'
_Reporte24S     db 0ah,0dh,               '             "primos":$'
_Reporte25S     db 0ah,0dh,               '         }, $'
_Reporte26S     db 0ah,0dh,               '         "Operaciones":[ $'
_Reporte27S     db 0ah,0dh,               '         ]$'
_Reporte28S     db 0ah,0dh,               '    ]$'
_Reporte29S     db 0ah,0dh,               '}$'
_Reporte30S     db                        '"$'
_Reporte31S     db                        ',$'



_bufferInput    db 50 dup('$')
_handleInput    dw ? 
_bufferInfo     db 2000 dup('$')
contadorBuffer dw 0 


_digito1 db 0
_digito2 db 0

; PROCS 

functionMenu proc far 
    getPrint _space
    getPrint _chain8
    getPrint _chain9
    getPrint _chain10
    getPrint _option
    ret 
functionMenu endp

funcIdentificar proc far 
    getPrint _chain1
    getPrint _chain2
    getPrint _chain3
    getPrint _chain4
    getPrint _chain5
    getPrint _chain6
    getPrint _chain7
    ret 
funcIdentificar endp

; operacion 
funcOperation proc far
    GetPrint _space
    GetPrint _chain11
    GetPrint _chain12
    GetPrint _chain13
    GetPrint _chain14
    GetPrint _chain15
    GetPrint _return
    GetPrint _option
    ret
funcOperation endp

;path 
funcPath proc far 
    GetPrint _space
    GetPrint _chain17
    GetPrint _chain18
    GetPrint _chain19
    GetPrint _chain20
    GetPrint _option
    ret
funcPath endp
;calc 
funcCalculadora proc far 
    GetPrint _space
    GetPrint _cadena21
    GetPrint _cadena22
    GetPrint _space
    ret
funcCalculadora endp


; code 
.code 
main proc

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
        je Loperacion
        cmp al,32H ; 2 en hexa 
        je Lfile
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
    
     Lfile:
        ; LLamamos path 
        call funcPath
        GetInput
        cmp al,31H 
        je LreadFile
        cmp al,32H 
        je LcloseFile
        cmp al,33H 
        je LmostrarFile 
        cmp al,34H 
        je Lmenu 
        jmp Lmenu
        

    LreadFile:
        GetPrint    _salto
        GetPrint    _cadena16                                         
        ; GetInput
        GetRoot     _bufferInput                                        
        GetOpenFile _bufferInput,_handleInput                        
      ;  GetReadFile _handleInput,_bufferInfo,SIZEOF _bufferInfo       
        GetInput
        jmp Lfile

    LmostrarFile:
        GetPrint _salto
        GetPrint _bufferInfo
        GetPrint _salto
        GetInput

        jmp Lfile

    LcloseFile:
        GetCloseFile _handleInput
        GetInput
        jmp Lfile

    Loperacion:
        call funcCalculadora 
        GetClean _numero1,_numero1,_calcuResultado
        GetPrint _num 
        Solicitar_Numero _numero1S, _numero1
        
        
        GetPrint _num 
        Solicitar_Numero _numero2S, _numero2
     
        GetPrint _num
        GetInputMax _resultS
        GetAC _resultS
        GetEND _resultS
        GetPrintCommand _resultS

        cmp _resultS,2BH 
        je Lsuma
        cmp _resultS,2DH 
        je Lresta
        cmp _resultS,78H 
        je Lmultiplicacion
        cmp _resultS,2FH 
        je Ldivision
        cmp _resultS,5EH 
        je Lpotencia
        cmp _resultS,65h  
        je Lmenu

        String_Int _resultS
        mov _numero3,ax

        GetPrint _num
        GetInputMax _resultS
        cmp _resultS,5EH 
        je Lpotencia2

        jmp Loperacion


    Loperacion2:
        call funcCalculadora 
        
        GetPrint _num 
        GetPrint _numero1S
        GetPrint _salto
        String_Int _numero1S
        mov _numero1, ax
        GetImparPar
        GetPrimo _numero1
        
        
        GetPrint _num 
        Solicitar_Numero _numero2S, _numero2
    
        GetPrint _num
        GetInputMax _resultS

        cmp _resultS,2BH ; Codigo ASCCI [+ -> Hexadecimal]
        je Lsuma
        cmp _resultS,2DH ; Codigo ASCCI [- -> Hexadecimal]
        je Lresta
        cmp _resultS,78H ; Codigo ASCCI [x -> Hexadecimal]
        je Lmultiplicacion
        cmp _resultS,2FH ; Codigo ASCCI [/ -> Hexadecimal]
        je Ldivision
        cmp _resultS,5EH ; Codigo ASCCI [^ -> Hexadecimal]
        je Lpotencia
        cmp _resultS,65h  ; Codigo ASCCI [e -> Hexadecimal] salir del programa
        je Lmenu


        String_Int _resultS
        mov _numero3,ax

        GetPrint _num
        GetInputMax _resultS
        GetAC _resultS
        GetEND _resultS
        GetPrintCommand _resultS
        cmp _resultS,5EH ; Codigo ASCCI [^ -> Hexadecimal]
        je Lpotencia2

        jmp Loperacion

    Loperacion3:
        call funcCalculadora ; LLamamos calculadora 
        
        GetPrint _num ; Obtenemos el primer número
        GetPrint _numero1S
        String_Int _numero1S
        mov _numero1, ax
        GetImparPar
        GetPrimo _numero1
        GetPrint _salto
        GetPrint _num ; Obtenemos el primer número
        GetPrint _numero2S
        String_Int _numero2S
        mov _numero2, ax
        GetImparPar
        GetPrimo _numero2
        GetPrint _salto

    
        GetPrint _num
        GetInputMax _resultS


        cmp _resultS,2BH 
        je Lsuma
        cmp _resultS,2DH 
        je Lresta
        cmp _resultS,78H 
        je Lmultiplicacion
        cmp _resultS,2FH 
        je Ldivision
        cmp _resultS,5EH 
        je Lpotencia
        cmp _resultS,65h  
        je Lmenu

        jmp Loperacion2

    Lsuma: ; operación suma
    
        mov dx, _numero1
        add dx, _numero2
        mov _calcuResultado, dx
        mov ax, _calcuResultado
        Int_String _numero1S 
        GetPrint _resultado
        GetPrint _numero1S

        
           
        jmp Loperacion2


    Lresta: ; operación resta

        mov dx, _numero1
        sub dx, _numero2
        mov _calcuResultado, dx
        mov ax, _calcuResultado
        Int_String _numero1S 
        GetPrint _resultado
        GetPrint _numero1S
           
        jmp Loperacion2

    Lmultiplicacion: 

        mov ax, _numero1
        mov bx, _numero2
        imul bx
        mov _calcuResultado,ax
        mov ax,_calcuResultado
        Int_String _numero1S 
        GetPrint _resultado
        GetPrint _numero1S

           
        jmp Loperacion2

    Ldivision:

        mov ax,_numero1    
        cwd                
        mov bx,_numero2    
        idiv bx            

        mov _calcuResultado,ax  
        Int_String _numero1S 
        GetPrint _resultado
        GetPrint _numero1S
        jmp Loperacion2

    Lpotencia:
        
        GetPotencia _calcuResultado, _numero1S, _numero1, _numero2, _numeroTemp
        jmp Loperacion2

    Lpotencia2:


        GetPotencia _calcuResultado, _numero2S, _numero2, _numero3, _numeroTemp

        jmp Loperacion3
    


    Lerror1:
        GetPrint _salto
        GetPrint _error1
        jmp Lmenu
    Lerror2:
        GetPrint _salto
        GetPrint _error2
        jmp Lmenu
    Lerror3:
        GetPrint _salto
        GetPrint _error3
        jmp Lmenu
    Lerror4:
        GetPrint _salto
        GetPrint _error4
        jmp Lmenu
    Lerror5:
        GetPrint _salto
        GetPrint _error5
        jmp Lmenu
    Lerror7:
        GetPrint _salto
        GetPrint _error7
        jmp Lsalir
    Lsalir:


        mov _reporteHandle,0
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

        GetPrint _numeroPrimoS
        

        mov ax,4c00h
        int 21h


main endp
end main