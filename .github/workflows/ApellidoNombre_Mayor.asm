# ApellidoNombre_Mayor.asm
# Este programa pide entre 3 y 5 números al usuario, luego muestra el mayor de ellos.

.data
    prompt_nums:      .asciiz "¿Cuántos números desea comparar (3 a 5)?: "
    prompt_input:     .asciiz "Ingrese un número: "
    error_input:      .asciiz "Error, ingrese un número válido entre 3 y 5.\n"
    result_msg:       .asciiz "El mayor número es: "
    newline:          .asciiz "\n"

.text
    .globl main

main:
    # Solicitar cuántos números desea comparar
    li $v0, 4                # syscall para imprimir string
    la $a0, prompt_nums       # cargar la dirección del mensaje
    syscall                   # imprimir mensaje

    li $v0, 5                # syscall para leer un entero
    syscall                   # leer entero en $v0
    move $t0, $v0             # almacenar la cantidad de números en $t0

    # Verificar si el número es válido (entre 3 y 5)
    blt $t0, 3, error         # si $t0 < 3, ir a error
    bgt $t0, 5, error         # si $t0 > 5, ir a error

    # Inicializar variables
    li $t1, -2147483648       # $t1 almacena el mayor número, inicializado al menor entero posible

    # Bucle para leer los números
    li $t2, 0                 # contador para saber cuántos números se han ingresado
read_numbers:
    li $v0, 4                # syscall para imprimir string
    la $a0, prompt_input      # cargar el mensaje de "Ingrese un número"
    syscall                   # imprimir el mensaje

    li $v0, 5                # syscall para leer un entero
    syscall                   # leer entero en $v0
    move $t3, $v0             # almacenar el número ingresado en $t3

    # Comparar el número actual con el mayor hasta ahora
    ble $t1, $t3, update_max  # si el número actual es mayor que el mayor, actualizar

    # Incrementar contador y verificar si se alcanzó el límite
    addi $t2, $t2, 1
    bge $t2, $t0, show_result # si hemos leído todos los números, mostrar resultado
    b read_numbers            # si no, continuar leyendo más números

update_max:
    move $t1, $t3             # actualizar el mayor número
    addi $t2, $t2, 1          # incrementar contador
    bge $t2, $t0, show_result # si hemos leído todos los números, mostrar resultado
    b read_numbers            # de lo contrario, seguir leyendo

show_result:
    # Mostrar el mayor número encontrado
    li $v0, 4                # syscall para imprimir string
    la $a0, result_msg        # cargar el mensaje de resultado
    syscall                   # imprimir el mensaje

    li $v0, 1                # syscall para imprimir entero
    move $a0, $t1            # mover el mayor número a $a0
    syscall                   # imprimir el mayor número

    li $v0, 4                # imprimir una nueva línea
    la $a0, newline
    syscall

    # Finalizar el programa
    li $v0, 10               # syscall para salir
    syscall

error:
    # Mostrar mensaje de error si el número ingresado no está en el rango
    li $v0, 4                # syscall para imprimir string
    la $a0, error_input       # cargar el mensaje de error
    syscall                   # imprimir el mensaje

    b main                    # volver a iniciar el programa
