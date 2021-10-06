.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:
	addi sp, sp, -4
    sw ra, 0(sp)
    addi t0, x0, 1
    blt a1, t0, quit
    # Prologue
    addi t0, x0, 0 # index of length
    addi t1, x0, 4 # multiple of 4
    lw t2, 0(a0) # current largest element
    addi t3, x0, 0 # index of largest element


loop_start:
	lw t4, 0(a0)
    bge t2, t4, loop_continue
    add t3, x0, t0
    add t2, x0, t4


loop_continue:
	addi t0, t0, 1
    add a0, a0, t1
    blt t0, a1, loop_start

loop_end:
	lw ra, 0(sp)
    addi sp, sp, 4
    add a0, t3, x0

    # Epilogue


    ret

quit:
	li a1 57
    call exit2