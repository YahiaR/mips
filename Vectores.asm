.text
main:

addi  $t1, $0, 0 ##Guardamos la 'i'
lw $t0, N ##Guardamos el valor de 'N'

for: ##Comprobamos la condición
slt $t2, $t1, $t0 ## i<N
beq $zero, $t2, while ## Si $t2 vale 0 no se cumple y sale del programa, no entra en el for 
##Ahora hacemos la operación del bucle
sll $s0, $t1, 2 ##Multiplicamos la i por 4
lw $t3, A($s0) ##Leemos de memoria y guardamos en los registros A Y B
lw $t4, B($s0)
sll $t5, $t4, 3 ##Multiplicamos la B por 8
sub $t6, $t3, $t5 ##Hacemos la operación de resta
sw $t6, C($s0) ##Guardamos la operación en C
addi $t1, $t1, 1 ## i++
j for ##salta si todo ha ido bien para volver a realizar el bucle

while: j while

################# Segmento de datos #################
.data
N: 6
A: 2,4,6,8,10,12
B: -1,-5,4,10,1,-5
C:


