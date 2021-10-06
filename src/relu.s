.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)
    
    addi t0, x0, 0 # index for length
    addi t1, x0, 4 # multiple of four
    addi t2, x0, 1
    
    blt a1, t2, quit
	addi t2, x0, 0

loop_start:
	lw t3, 0(a0)
    bge t3, t2, loop_continue
    addi t3, x0, 0
    sw t3, 0(a0)

loop_continue:
	addi t0, t0, 1
    add a0, a0, t1
    blt t0, a1, loop_start
    
loop_end:
	lw ra, 0(sp)
    addi sp, sp, 4
    

    # Epilogue


	ret

quit:
	lw ra, 0(sp)
    addi sp, sp, 4
    li a1, 57
    call exit2
    