.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:

    # Prologue
	addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)
    
    add s0, a1, x0 # pointer to matrix in memory
    add s1, a2, x0 # number of rows in matrix
    add s2, a3, x0 # number of columns in matrix
    
    #fopen
    add a1, a0, x0 # setting params for fopen
    addi a2, x0, 1 # write-only setting
    jal ra, fopen
    addi t0, x0, -1
    beq a0, t0, err89 # checks whether fopen returned error
    add s3, a0, x0 # file descriptor
    
    #fwrite row and column
    
    add a1, s3, x0 # file descriptor
    addi a3, x0, 2
    addi a4, x0, 4
    addi sp, sp, -4
    sw a3, 0(sp)
    addi sp, sp, -8
    sw s1, 0(sp)
    sw s2, 4(sp)
    add a2, x0, sp
    jal ra, fwrite
    lw s1, 0(sp)
    lw s2, 4(sp)
    addi sp, sp, 8
    lw a3, 0(sp)
    addi sp, sp, 4
    bne a0, a3, err92

    #fwrite data
    add a1, s3, x0
    add a2, s0, x0
    mul a3, s1, s2
    addi a4, x0, 4
    addi sp, sp, -4
    sw a3, 0(sp)
    jal ra, fwrite
    lw a3, 0(sp)
    addi sp, sp, 4
    bne a0, a3, err92
    
    #fclose
    add a1, s3, x0
    jal ra, fclose
    addi t0, x0, -1
    beq a0, t0, err90

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

err89:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    
    li a1 89
    call exit2
    
err92:
    #fclose
    add a1, s3, x0
    jal ra, fclose
    addi t0, x0, -1
    beq a0, t0, err90

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    
    li a1 92
    call exit2
    
err90:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    
    li a1 90
    call exit2