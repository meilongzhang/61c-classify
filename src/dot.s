.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:
	addi sp, sp, -4
    sw ra, 0(sp)
    addi t0, x0, 1
    blt a2, t0, quit1
    blt a3, t0, quit2
    blt a4, t0, quit2
    # Prologue
    addi t0, x0, 0 # index of length
    addi t1, x0, 4 # multiple of 4
    mul t2, a3, t1 # stride in address of v0
    mul t3, a4, t1 # stride in address of v1
    addi t1, x0, 0 # sum


loop_start:
	lw t4, 0(a0)
    lw t5, 0(a1)
    mul t6, t4, t5
    add t1, t1, t6
	addi t0, t0, 1
    add a0, a0, t2
    add a1, a1, t3
    blt t0, a2, loop_start


loop_end:
	lw ra, 0(sp)
    addi sp, sp, 4
    add a0, t1, x0

    # Epilogue


    ret

quit1:
	li a1, 57
    call exit2
quit2:
	li a1, 58
    call exit2
