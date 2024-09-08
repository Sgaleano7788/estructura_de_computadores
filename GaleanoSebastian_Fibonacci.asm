# GaleanoSebastian_Fibonacci.asm
# Este programa pide al usuario cuántos números de la serie Fibonacci desea generar,
# genera la serie, la imprime y calcula la suma de todos los números en la serie.

.data
    prompt_input:     .asciiz "Ingrese la cantidad de números de la serie Fibonacci: "
    result_msg:       .asciiz "Serie Fibonacci: "
    sum_msg:          .asciiz "La suma de los números es: "
    newline:          .asciiz "\n"
    error_input:      .asciiz "Error, ingrese un número positivo.\n"
    comma:            .asciiz ", "

.text
    .globl main

main:
    # Solicitar la cantidad de números de la serie Fibonacci
    li $v0, 4                # syscall para imprimir string
    la $a0, prompt_input      # cargar la dirección del mensaje
    syscall                   # imprimir el mensaje

    li $v0, 5                # syscall para leer un entero
    syscall                   # leer entero en $v0
    move $t0, $v0             # almacenar la cantidad de números en $t0

    # Verificar si el número es positivo
    blt $t0, 1, error         # si $t0 < 1, ir a error

    # Inicializar variables
    li $t1, 0                 # $t1 = 0 (primer número de Fibonacci)
    li $t2, 1                 # $t2 = 1 (segundo número de Fibonacci)
    li $t3, 0                 # $t3 = 0 (suma de los números)
    li $t4, 0                 # $t4 = 0 (contador de números generados)
    li $t5, 0                 # $t5 = 0 (variable temporal para el siguiente número)
    
    # Imprimir mensaje de la serie
    li $v0, 4                 # syscall para imprimir string
    la $a0, result_msg        # cargar el mensaje de resultados
    syscall                   # imprimir el mensaje

print_fibonacci:
    bge $t4, $t0, show_sum    # si hemos generado todos los números, mostrar suma

    # Imprimir el número actual
    li $v0, 1                # syscall para imprimir entero
    move $a0, $t1            # mover el número actual a $a0
    syscall                   # imprimir el número

    # Imprimir coma después del número (excepto para el último número)
    li $v0, 4                # syscall para imprimir string
    la $a0, comma            # cargar la dirección del mensaje de coma
    syscall                   # imprimir la coma

    # Actualizar suma
    add $t3, $t3, $t1         # $t3 = $t3 + $t1

    # Calcular el siguiente número de Fibonacci
    move $t5, $t2            # $t5 = $t2
    add $t2, $t1, $t2        # $t2 = $t1 + $t2
    move $t1, $t5            # $t1 = $t5 (anterior $t2)
    addi $t4, $t4, 1         # incrementar contador de números
    j print_fibonacci        # volver a imprimir el siguiente número

show_sum:
    # Imprimir una nueva línea antes del resultado
    li $v0, 4                # syscall para imprimir string
    la $a0, newline           # cargar la dirección del mensaje de nueva línea
    syscall                   # imprimir nueva línea

    # Imprimir la suma de los números
    li $v0, 4                # syscall para imprimir string
    la $a0, sum_msg           # cargar el mensaje de suma
    syscall                   # imprimir el mensaje

    li $v0, 1                # syscall para imprimir entero
    move $a0, $t3            # mover la suma a $a0
    syscall                   # imprimir la suma

    li $v0, 10               # syscall para salir
    syscall

error:
    # Mostrar mensaje de error si el número ingresado no es válido
    li $v0, 4                # syscall para imprimir string
    la $a0, error_input       # cargar el mensaje de error
    syscall                   # imprimir el mensaje

    li $v0, 10               # syscall para salir
    syscall
