.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:
	addi t0, x0, 1
    # Error checks
	blt a1, t0, quit
    blt a2, t0, quit
    blt a4, t0, quit
    blt a5, t0, quit
    bne a2, a4, quit
    # Prologue
	addi sp, sp, -12
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    addi t0, x0, 0 # looping over m index

outer_loop_start:
	addi sp, sp, -12
    sw a0, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    addi t4, x0, 4 # multiple of 4
    mul t1, t0, a2
    mul t1, t1, t4
    add a0, a0, t1 # picking out correct row
    add t3, a3, x0 # saving address of second array into t3
    addi a3, x0, 1 # stride of first array
    addi t2, x0, 0 # looping over p index
    



inner_loop_start:
	addi sp, sp, -28
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw a4, 12(sp)
    sw a5, 16(sp)
    sw a6, 20(sp)
    sw a0, 24(sp)
    mul t5, t2, t4
    add a1, t3, t5 # pointer to second array
    add a4, a5, x0 # stride of second array
    
    addi sp, sp, -28
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    sw t6, 24(sp)
    jal ra, dot
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    lw t6, 24(sp)
    addi sp, sp, 28
    
    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw a4, 12(sp)
    lw a5, 16(sp)
    lw a6, 20(sp)
    addi sp, sp, 24
    
	sw a0, 0(a6)
    lw a0, 0(sp)
    addi sp, sp, 4
    addi a6, a6, 4
    addi t2, t2, 1
    blt t2, a5, inner_loop_start









inner_loop_end:
	addi t0, t0, 1
    lw a0, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    addi sp, sp, 12
    blt t0, a1, outer_loop_start



outer_loop_end:
	lw ra, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi, sp, sp, 12

    # Epilogue


    ret
    
quit:
	li a1, 59
    call exit2
