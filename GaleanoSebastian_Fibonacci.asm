# GaleanoSebastian_Fibonacci.asm
# Este programa pide al usuario cu�ntos n�meros de la serie Fibonacci desea generar,
# genera la serie, la imprime y calcula la suma de todos los n�meros en la serie.

.data
    prompt_input:     .asciiz "Ingrese la cantidad de n�meros de la serie Fibonacci: "
    result_msg:       .asciiz "Serie Fibonacci: "
    sum_msg:          .asciiz "La suma de los n�meros es: "
    newline:          .asciiz "\n"
    error_input:      .asciiz "Error, ingrese un n�mero positivo.\n"
    comma:            .asciiz ", "

.text
    .globl main

main:
    # Solicitar la cantidad de n�meros de la serie Fibonacci
    li $v0, 4                # syscall para imprimir string
    la $a0, prompt_input      # cargar la direcci�n del mensaje
    syscall                   # imprimir el mensaje

    li $v0, 5                # syscall para leer un entero
    syscall                   # leer entero en $v0
    move $t0, $v0             # almacenar la cantidad de n�meros en $t0

    # Verificar si el n�mero es positivo
    blt $t0, 1, error         # si $t0 < 1, ir a error

    # Inicializar variables
    li $t1, 0                 # $t1 = 0 (primer n�mero de Fibonacci)
    li $t2, 1                 # $t2 = 1 (segundo n�mero de Fibonacci)
    li $t3, 0                 # $t3 = 0 (suma de los n�meros)
    li $t4, 0                 # $t4 = 0 (contador de n�meros generados)
    li $t5, 0                 # $t5 = 0 (variable temporal para el siguiente n�mero)
    
    # Imprimir mensaje de la serie
    li $v0, 4                 # syscall para imprimir string
    la $a0, result_msg        # cargar el mensaje de resultados
    syscall                   # imprimir el mensaje

print_fibonacci:
    bge $t4, $t0, show_sum    # si hemos generado todos los n�meros, mostrar suma

    # Imprimir el n�mero actual
    li $v0, 1                # syscall para imprimir entero
    move $a0, $t1            # mover el n�mero actual a $a0
    syscall                   # imprimir el n�mero

    # Imprimir coma despu�s del n�mero (excepto para el �ltimo n�mero)
    li $v0, 4                # syscall para imprimir string
    la $a0, comma            # cargar la direcci�n del mensaje de coma
    syscall                   # imprimir la coma

    # Actualizar suma
    add $t3, $t3, $t1         # $t3 = $t3 + $t1

    # Calcular el siguiente n�mero de Fibonacci
    move $t5, $t2            # $t5 = $t2
    add $t2, $t1, $t2        # $t2 = $t1 + $t2
    move $t1, $t5            # $t1 = $t5 (anterior $t2)
    addi $t4, $t4, 1         # incrementar contador de n�meros
    j print_fibonacci        # volver a imprimir el siguiente n�mero

show_sum:
    # Imprimir una nueva l�nea antes del resultado
    li $v0, 4                # syscall para imprimir string
    la $a0, newline           # cargar la direcci�n del mensaje de nueva l�nea
    syscall                   # imprimir nueva l�nea

    # Imprimir la suma de los n�meros
    li $v0, 4                # syscall para imprimir string
    la $a0, sum_msg           # cargar el mensaje de suma
    syscall                   # imprimir el mensaje

    li $v0, 1                # syscall para imprimir entero
    move $a0, $t3            # mover la suma a $a0
    syscall                   # imprimir la suma

    li $v0, 10               # syscall para salir
    syscall

error:
    # Mostrar mensaje de error si el n�mero ingresado no es v�lido
    li $v0, 4                # syscall para imprimir string
    la $a0, error_input       # cargar el mensaje de error
    syscall                   # imprimir el mensaje

    li $v0, 10               # syscall para salir
    syscall
