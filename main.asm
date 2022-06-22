;;; incluir librerios 
include atajos.asm
;; incluir modelo 
.model small
;; parte stack 
.stack
;;;parte datos 
.data
;;;; DEclaracion cadena inicio 

    _inicio0        db 0ah,0dh,               "===================================================","$"
	_inicio1        db 0ah,0dh,               "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA$","$"
	_inicio2        db 0ah,0dh,               "FACULTAD DE INGENIERIA$","$"
	_inicio3        db 0ah,0dh,               "ESCUELA DE CIENCIAS Y SISTEMAS", "$"
	_inicio4        db 0ah,0dh,               "ARQUITECTURA DE COMPILADORES Y ENSAMBLADORES 1", "$"
	_inicio5        db 0ah,0dh,               "SECCION A", "$"
	_inicio6        db 0ah,0dh,               "BYRON RUBEN HERNANDEZ DE LEON$"
	_inicio7        db 0ah,0dh,               "201806840$"

;;;; DECLARACION DE CADENA MENUS 
    _menu1          db 0ah,0dh,               "1) [CARGAR ARCHIVO]$"
	_menu2          db 0ah,0dh,               "2) [CONSOLA]$"
	_menu3        	db 0ah,0dh,               "3) [SALIR]$"
;;;; declracion de eventos especiales texto 
    _espacio        db 0ah,0dh,               "$"
    _true           db 0ah,0dh,               "true$"
    _false          db 0ah,0dh,               "false$"
    _escogerAccion  db                        "Escoger una opcion: $"


;;;;; PROCS 
inicio proc far 
    Imprimir _inicio0
    Imprimir _inicio1
    Imprimir _inicio2
    Imprimir _inicio3
    Imprimir _inicio4
    Imprimir _inicio5
    Imprimir _inicio6
    Imprimir _inicio7
    ret 
inicio endp



;;;;; parte de codigo bien recio 
.code 

main proc 
    MOV AX,@data ; llamamos a datos 
    MOV DS,AX; movemos a ds 
    MOV ES,AX ;movemos a ES 
    CALL inicio

    


end main