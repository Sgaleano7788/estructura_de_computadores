# GaleanoSebastian_Menor.asm
# Este programa pide entre 3 y 5 n�meros al usuario, luego muestra el menor de ellos.

.data
    prompt_nums:      .asciiz "�Cu�ntos n�meros desea comparar (3 a 5)?: "
    prompt_input:     .asciiz "Ingrese un n�mero: "
    error_input:      .asciiz "Error, ingrese un n�mero v�lido entre 3 y 5.\n"
    result_msg:       .asciiz "El menor n�mero es: "
    newline:          .asciiz "\n"

.text
    .globl main

main:
    # Solicitar cu�ntos n�meros desea comparar
    li $v0, 4                # syscall para imprimir string
    la $a0, prompt_nums       # cargar la direcci�n del mensaje
    syscall                   # imprimir mensaje

    li $v0, 5                # syscall para leer un entero
    syscall                   # leer entero en $v0
    move $t0, $v0             # almacenar la cantidad de n�meros en $t0

    # Verificar si el n�mero es v�lido (entre 3 y 5)
    blt $t0, 3, error         # si $t0 < 3, ir a error
    bgt $t0, 5, error         # si $t0 > 5, ir a error

    # Inicializar variables
    li $t1, 2147483647        # $t1 almacena el menor n�mero, inicializado al mayor entero posible

    # Bucle para leer los n�meros
    li $t2, 0                 # contador para saber cu�ntos n�meros se han ingresado
read_numbers:
    li $v0, 4                # syscall para imprimir string
    la $a0, prompt_input      # cargar el mensaje de "Ingrese un n�mero"
    syscall                   # imprimir el mensaje

    li $v0, 5                # syscall para leer un entero
    syscall                   # leer entero en $v0
    move $t3, $v0             # almacenar el n�mero ingresado en $t3

    # Comparar el n�mero actual con el menor hasta ahora
    bge $t1, $t3, update_min  # si el n�mero actual es menor que el menor, actualizar

    # Incrementar contador y verificar si se alcanz� el l�mite
    addi $t2, $t2, 1
    bge $t2, $t0, show_result # si hemos le�do todos los n�meros, mostrar resultado
    b read_numbers            # si no, continuar leyendo m�s n�meros

update_min:
    move $t1, $t3             # actualizar el menor n�mero
    addi $t2, $t2, 1          # incrementar contador
    bge $t2, $t0, show_result # si hemos le�do todos los n�meros, mostrar resultado
    b read_numbers            # de lo contrario, seguir leyendo

show_result:
    # Mostrar el menor n�mero encontrado
    li $v0, 4                # syscall para imprimir string
    la $a0, result_msg        # cargar el mensaje de resultado
    syscall                   # imprimir el mensaje

    li $v0, 1                # syscall para imprimir entero
    move $a0, $t1            # mover el menor n�mero a $a0
    syscall                   # imprimir el menor n�mero

    li $v0, 4                # imprimir una nueva l�nea
    la $a0, newline
    syscall

    # Finalizar el programa
    li $v0, 10               # syscall para salir
    syscall

error:
    # Mostrar mensaje de error si el n�mero ingresado no est� en el rango
    li $v0, 4                # syscall para imprimir string
    la $a0, error_input       # cargar el mensaje de error
    syscall                   # imprimir el mensaje

    b main                    # volver a iniciar el programa
