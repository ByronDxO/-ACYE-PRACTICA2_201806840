;;;;; importaciones de diferentes archivos para poder tener acceso a los metodos 
include atajos.asm
include archivo.asm
;;;;; definicion de modelo a small debido a que es el modelo mas grande permitido para el proyecto 
.model small 
;;;;; definicion de segmento stack 
.stack 
;;;;; definicion de segmento de datos 

.data  
    ;;;;; string para inicio 
	_cadena0        db 0ah,0dh,               "===================================================","$"
	_cadena1        db 0ah,0dh,               "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA$","$"
	_cadena2        db 0ah,0dh,               "FACULTAD DE INGENIERIA$","$"
	_cadena3        db 0ah,0dh,               "ESCUELA DE CIENCIAS Y SISTEMAS", "$"
	_cadena4        db 0ah,0dh,               "ARQUITECTURA DE COMPILADORES Y ENSAMBLADORES 1", "$"
	_cadena5        db 0ah,0dh,               "SECCION A", "$"
	_cadena6        db 0ah,0dh,               "BYRON RUBEN HERNANDEZ DE LEON$"
	_cadena7        db 0ah,0dh,               "201806840$"
;;;; string para menu 
	_menu1          db 0ah,0dh,               "1) CARGAR ARCHIVO$"
	_menu2          db 0ah,0dh,               "2) CONSOLA$"
	_menu3        	db 0ah,0dh,               "3) SALIR$"
	
;;; eleccion 
	_salto         	db 0ah,0dh,               "$"
	_true           db 0ah,0dh,               "true$"
	_false          db 0ah,0dh,               "false$"
	_choose        	db        	              "Escoga Opcion: $"
	_RESULT        	db        	              "Resultado de $"
	_ResultMayor   	db        	              "Estadistico Mayor: $"
	_ResultMenor   	db        	              "Estadistico Menor: $"
	_ResultMedia   	db        	              "Estadistico Media: $"
	_ResultMediana 	db        	              "Estadistico Mediana: $"
	TK_DOSPUNTOS  	db 0ah,0dh, ": $"

;;; cargar archivo 
	_file0         	db 0ah,0dh,               "-------------- CARGAR ARCHIVO -------------- $"
	_file1         	db 0ah,0dh,               "Ingrese Ruta: $"
	_file2         	db 0ah,0dh,               "Archivo leido con exito!$"
	_console0     	db 0ah,0dh,               "-------------- CONSOLA -------------- $"
	_console1       db                        ">> $"

;;; erroresrs 
	_error1         db 0ah,0dh,               "> Error al Abrir Archivo, no Existe ",   "$"
	_error2         db 0ah,0dh,               "> Error al Cerrar Archivo",              "$"
	_error3         db 0ah,0dh,               "> Error al Escribir el Archivo",         "$"
	_error4         db 0ah,0dh,               "> Error al Crear el Archivo",            "$"
	_error5         db 0ah,0dh,               "> Error al Leer al Archivo",             "$"
	_error6         db 0ah,0dh,               "> Error en el Archivo",                  "$"
	_error7         db 0ah,0dh,               "> Error al crear el Archivo",                  "$"

	;;;; varibales para almacenar 
	_inputMax       db 50 dup(' '), "$"
	_operator       db 50 dup(' '), "$" 
	_operatorAux    db 50 dup('$') 
	_aritmethic     db 50 dup(' '), "$" 
	_padre          db 50 dup('reporte.jso$')
	_num1S    		db 50 dup(' '), "$" 
	_num2S    		db 50 dup(' '), "$" 
	_numResult    	db 50 dup(' '), "$" 
	_numero1        dw 0                
	_numero2        dw 0                
	_numero3        dw 0 
	_calcuResultado dw 0                


	; archivo 
	_bufferInput    db 50 dup('$')
	_handleInput    dw ? 
	_bufferInfo     db 50000 dup('$')
	contadorBuffer  dw 0 
	_Reporte00S     db 0ah,0dh,               "Reporte Generado",'$'
	_createFile     db 'reporte.jso' 
	_reporteHandle  dw ?
	_Reporte0S      db 0ah,0dh,               "{",'$'
	_Reporte1S      db 0ah,0dh,               '    "reporte":{ $'
	_Reporte2S      db 0ah,0dh,               '        "Datos":{ $'
	_Reporte3S      db 0ah,0dh,               '            "Nombre":"BYRON RUBEN HERNANDEZ DE LEON",$'
	_Reporte4S      db 0ah,0dh,               '            "Carnet":"201806840",$'
	_Reporte5S      db 0ah,0dh,               '            "Curso":"Arquitectura de compiladores y ensambladores 1",$'
	_Reporte6S      db 0ah,0dh,               '            "Seccion":"A"$'
	_Reporte7S      db 0ah,0dh,               '        }, $'
	_Reporte8S      db 0ah,0dh,               '        "Fecha":{ $'
	_Reporte9S      db 0ah,0dh,               '            "Dia":$'
	_Reporte10S     db 0ah,0dh,               '            "Mes":$'
	_Reporte11S     db 0ah,0dh,               '            "Año":$'
	_Reporte12S     db 0ah,0dh,               '        }, $'
	_Reporte13S     db 0ah,0dh,               '        "Hora":{ $'
	_Reporte14S     db 0ah,0dh,               '            "Hora":$'
	_Reporte15S     db 0ah,0dh,               '            "Minuto":$'
	_Reporte16S     db 0ah,0dh,               '            "Segundo":$'
	_Reporte17S     db 0ah,0dh,               '        }, $'
	_Reporte18S     db 0ah,0dh,               '        "Resultados":{ $'
	_Reporte19S     db 0ah,0dh,               '            "Media":$'
	_Reporte20S     db 0ah,0dh,               '            "Mediana":$'
	_Reporte21S     db 0ah,0dh,               '            "Menor":$'
	_Reporte22S     db 0ah,0dh,               '            "Mayor":$'
	_Reporte25S     db 0ah,0dh,               '        }, $'
	_Reporte26S     db 0ah,0dh,               '        "Operaciones":{ $'
	_Reporte27S     db 0ah,0dh,               '        }$'
	_Reporte28S     db 0ah,0dh,               '    }$'
	_Reporte29S     db 0ah,0dh,               '}$'
	_Reporte30S     db                        '"$'
	_Reporte31S     db                        ',$'

	_digito1 db 0
	_digito2 db 0
;;; reporte estadisticas 
	_Media 	 dw 0
	_Mediana dw 0
	_Menor   dw 0 
	_Mayor   dw 0 
;;;;; reporte hora 
	_MediaS  	db 10 dup(' '), "$" 
	_MedianaS   db 10 dup(' '), "$" 
	_MenorS  	db 10 dup(' '), "$" 
	_MayorS  	db 10 dup(' '), "$" 

	_digitoFDia1  db 0
	_digitoFDia2  db 0
	_digitoFMes1  db 0
	_digitoFMes2  db 0
	_digitoFYear1 db 0
	_digitoFYear2 db 0

	_digitoHHora1 db 0
	_digitoHHora2 db 0
	_digitoHMin1  db 0
	_digitoHMin2  db 0
	_digitoHSec1  db 0
	_digitoHSec2  db 0


; variables 
; mensajes claves 
_enter db 0ah,0dh, "$"
_separador db 0ah,0dh, "-------------------------------------$"
_mensaje_predeterminado db 0ah,0dh, "ingresar seleccion: $"
; mensajes inicio 
_chain1 db 0ah,0dh, "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA$"
_chain2 db 0ah,0dh, "FACULTAD DE INGENIERIA$"
_chain3 db 0ah,0dh, "ESCUELA DE CIENCIAS Y SISTEMAS$"
_chain4 db 0ah,0dh, "ARQUITECTURA DE COPMILADORES Y ENSAMBLADORES$"
_chain5 db 0ah,0dh, "SECCION <A>$"
_chain6 db 0ah,0dh, "<BYRON RUBEN HERNANDEZ DE LEON>$"
_chain7 db 0ah,0dh, "<201806840>$"
; mensajes de menu  
_chain8 db 0ah,0dh, "Login  F1$"
_chain9 db 0ah,0dh, "Registrarse  F2$"
_chain10 db 0ah,0dh, "salir   F3$"
; mensajes para inicio de login  
_chain11 db 0ah,0dh, "nombre de usuario:$"
_chain12 db "contraseña: $"
 ;vairblaes de login 
 _usuario db 100 dup('$')
 _contrasenia db 100 dup('$')
 _usuarioSave db 100 dup('$')
 _contraseniaSave  db 100 dup('$')
 _tamfile dw 0
 _handle dw ?
 _ifBool dw 0
 ;permisos denegados 
_permiso1 db 0ah,0dh , "permission denied$"
_permiso2 db 0ah,0dh, "there where 3 failed login attempts$"
_permiso3 db 0ah,0dh, "Please contact the administrator$"
_permiso4 db 0ah,0dh, "Press Enter to go back to menu$"
_permiso5 db 0ah,0dh, "wait 18 seconds and try again$"
;mensajes validaciones contraselas 
_validacion1 db 0ah,0dh, "Action Rejected$"
_validacion2 db 0ah,0dh, "missed requirements:$"
_validacion3 db 0ah,0dh, "username begins with a letter $"
_validacion4 db 0ah,0dh ,"username length between 8 and 15 characters$"
_validacion5 db 0ah,0dh, "Password must contain at least one number$"
_validacion6 db 0ah,0dh, "Password length at least 16 character$"
_validacion7 db 0ah,0dh, " Press Enter to go to back menu$"
;menu jugador
_jugador1 db 0ah,0dh, "F2. Play game$"
_jugador2 db 0ah,0dh, "F3. Show to top 10 scoreboards$"
_jugador3 db 0ah,0dh, "F5. shoy my top 10 scoreboard$"
_jugador4 db 0ah,0dh,"F9. Logout$"

;menu administrador
_menuAdmin1 db 0ah,0dh, "F1. unlock user $"
_menuAdmin2 db 0ah,0dh, "F2. Promote user to admin$"
_menuAdmin3 db 0ah,0dh, "F3. Demote user from admin$"
_menuAdmin4 db 0ah,0dh, "F5. Bubble sort$"
_menuAdmin5 db 0ah,0dh, "F6. Heap sort$"
_menuAdmin6 db 0ah,0dh, "F7. Tim sort$"
_menuAdmin7 db 0ah,0dh, "F9. Logout$"
; MENU ADMINISTRADOR NORMAL
_normalAdmin1 db 0ah,0dh, "F1. unlock user $"
_normalAdmin2 db 0ah,0dh, "F2. Show to top 10 scoreboards$"
_normalAdmin3 db 0ah,0dh, "F3. Show my top 10 scoreboards$"
_normalAdmin4 db 0ah,0dh, "F4. Play Game$"
_normalAdmin5 db 0ah,0dh, "F5. Bubble sort$"
_normalAdmin6 db 0ah,0dh, "F6. Heap sort$"
_normalAdmin7 db 0ah,0dh, "F7. Tim sort$"
_normalAdmin8 db 0ah,0dh, "F9. Logout$"
;unlock user  sin errorres 
_unlock1 db 0ah,0dh, "succesfully unlock user$"
_unlock2 db 0ah,0dh, "Press enter go to back Menu$"
;unlock user con errores 
_unlock3 db 0ah,0dh, "error, wasn't locked$"
_unlock4 db 0ah,0dh, "Press enter go to bakc Menu$"

;menu estadisticas 
;menu ordenamientos 
;buffers 
_bufferInput    db 50 dup('$')
_handleInput    dw ? 
_bufferInfo     db 2000 dup('$')
_BufferCount  dw 0 
_reporteHandle  dw ?

; procs 
; mensaje de inicio de sistema 
funcIdentificar proc far 
    getPrint _chain1
    getPrint _chain2
    getPrint _chain3
    getPrint _chain4
    getPrint _chain5
    getPrint _chain6
    getPrint _chain7
    getPrint _separador
    ret 
funcIdentificar endp
;menu jugador 
functionMenuJugador proc far 
    getPrint _jugador1
    getPrint _jugador2
    getPrint _jugador3
    getPrint _jugador4
    getPrint _separador
    ret
functionMenuJugador endp
;menu adminadmin
functionMenuAdminAdmin proc far
    getPrint _menuAdmin1
    getPrint _menuAdmin2
    getPrint _menuAdmin3
    getPrint _menuAdmin4
    getPrint _menuAdmin5
    getPrint _menuAdmin6
    getPrint _menuAdmin7
    getPrint _separador
    ret 
functionMenuAdminAdmin endp
; menu admin normal 
functionMenuAdminNormal proc far
    getPrint _normalAdmin1
    getPrint _normalAdmin2
    getPrint _normalAdmin3
    getPrint _normalAdmin4
    getPrint _normalAdmin5
    getPrint _normalAdmin6 
    getPrint _normalAdmin7
    getPrint _normalAdmin7
    getPrint _normalAdmin8
    getPrint _separador
    ret 
functionMenuAdminNormal endp

; login errores 
functionLoginError proc far 
    getPrint _unlock1
    getPrint _unlock2
    getPrint _separador
    ret
functionLoginError endp 
; menu  
functionMenu proc far 
    getPrint _chain8
    getPrint _chain9
    getPrint _chain10
    getPrint _separador
    ret 
functionMenu endp
;funcion de login 

functionLogin proc far 
    getPrint _chain11
    getPrint _separador
    getPrint _enter
    ret 
    functionLogin endp 

funcionRechazo proc far
ret 
funcionRechazo endp

; code 
	
	;;;;; procedimientos 

	;inicio
	identificador proc far
	    GetPrint _cadena0
	    GetPrint _cadena1
	    GetPrint _cadena2
	    GetPrint _cadena3
	    GetPrint _cadena4
	    GetPrint _cadena5
	    GetPrint _cadena6
	    GetPrint _cadena7
	    ret
	identificador endp
;;; menu
	menu proc far
		GetPrint _menu1
		GetPrint _menu2
		GetPrint _menu3
	    GetPrint _salto
	    GetPrint _choose
	    ret
	menu endp
;;; saltar proc
	jump proc far
		GetPrint _salto
		ret
	jump endp
;;;; enviar conla 
	sendConsole proc far
		GetPrint _console0
		GetPrint _salto
		GetPrint _console1
		ret
	sendConsole endp

;codigo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.code 
	main proc

		MOV AX, @data 
		MOV DS, AX 
		MOV ES, AX

		CALL identificador

		LMenu:
			CALL jump
			CALL menu			
        	GetInput
			cmp al,31H ;;;;1
	        je LFile
	        cmp al,32H ;;;;;;2
            je LConsole
	        cmp al,33H ;;;;;;3
	        je Lout 
	        jmp LMenu

	    LFile:
	    	CALL jump
	    	GetPrint _file0
	    	CALL jump
	    	GetPrint _file1
	    	CALL jump	    	
	    	GetRoot _bufferInput  
	        GetOpenFile _bufferInput,_handleInput                         
	        GetReadFile _handleInput,_bufferInfo,SIZEOF _bufferInfo 
	        GetPrint _file2   
	        GetCloseFile _handleInput   
	        jmp LMenu

	    LConsole:
	    	GetPrint _salto
	    	CALL sendConsole
	    	GetInputMax _inputMax
	    	GetExit _inputMax
	    	GetShowMayor _inputMax
	    	GetShowMenor _inputMax
	    	GetShowMedia _inputMax
	    	GetShowMediana _inputMax
	    	GetShow _inputMax, _operator, _bufferInfo, _operatorAux
	    	GetShowPadre _inputMax
	    	jmp LConsole

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
	        jmp Lout

		Lout:
			;GetPrint _salto

			reporte

			MOV ah,4ch
			int 21h

	main endp

end main