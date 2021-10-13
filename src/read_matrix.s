.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)
    sw a1, 28(sp)
    sw a2, 32(sp)

	add a1, a0, x0
	addi a2, x0, 0
    jal ra, fopen
    addi t0, x0, -1
    beq a0, t0, err89
    add s0, x0, a0 #file descriptor
    
    addi a0, x0, 4 #read 4 bytes or 1 integer
    jal ra, malloc #call malloc
    addi t0, x0, 0
    beq a0, t0, err88
    add s1, x0, a0 #pointer to buffer for integer 1
    
    addi a0, x0, 4 #read 4 bytes or 1 integer
    jal ra, malloc #call malloc
    addi t0, x0, 0
    beq a0, t0, err88
    add s5, x0, a0 #pointer to buffer for integer 2
    
    add a1, s0, x0
    add a2, s1, x0
    addi a3, x0, 4
    addi sp, sp, -4
    sw a3, 0(sp)
    jal ra, fread
    lw a3, 0(sp)
    addi sp, sp, 4
    bne a0, a3, err91
    
    add a1, s0, x0
    add a2, s5, x0
    addi a3, x0, 4
    addi sp, sp, -4
    sw a3, 0(sp)
    jal ra, fread
    lw a3, 0(sp)
    addi sp, sp, 4
    bne a0, a3, err91
    
    lw a1, 0(s1)
    lw a2, 0(s5)
    add s3, a1, x0 #number of rows
    add s4, a2, x0 #number of columns
    mul t0, a1, a2
    addi t1, x0, 4

    mul a0, t0, t1
    jal ra, malloc
    addi t0, x0, 0
    beq a0, t0, err88
    
    add s2, a0, x0 # pointer to buffer of matrix
    addi t0, x0, 0
    addi t1, x0, 0
    mul t2, s3, s4
    
    add a1, s0, x0
    add a2, s2, x0
    addi t3, x0, 4
    mul a3, t2, t3
    addi sp, sp, -16
    sw a3, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    jal ra, fread
    lw a3, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    addi sp, sp, 16
    bne a0, a3, err91
    

#    loop:
 #   	add a1, s0, x0
  #      add a2, s2, t0
   #     addi a3, x0, 4
    #    addi sp, sp, -16
     #   sw a3, 0(sp)
      #  sw t0, 4(sp)
       # sw t1, 8(sp)
       # sw t2, 12(sp)
       # jal ra, fread
       # lw a3, 0(sp)
       # lw t0, 4(sp)
       # lw t1, 8(sp)
       # lw t2, 12(sp)
       # addi sp, sp, 16
       # bne a0, a3, err91
       # addi t0, t0, 4
       # addi t1, t1, 1
       # blt t1, t2, loop

    add a1, s0, x0
    jal ra, fclose
    addi t0, x0, -1
    beq a0, t0, err90
        
    add a0, s2, x0
    lw t0, 0(s1)
    lw t1, 0(s5)

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    lw a1, 28(sp)
    lw a2, 32(sp)
    addi sp, sp, 36
    
    sw t0, 0(a1)
    sw t1, 0(a2)

    ret
    
err89:

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    lw a1, 28(sp)
    lw a2, 32(sp)
    addi sp, sp, 36
    li a1, 89
    call exit2
    
err88:
    add a1, s0, x0
    jal ra, fclose
    addi t0, x0, -1
    beq a0, t0, err90

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    lw a1, 28(sp)
    lw a2, 32(sp)
    addi sp, sp, 36
    li a1, 88
    call exit2 
    
err90:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    lw a1, 28(sp)
    lw a2, 32(sp)
    addi sp, sp, 36
    li a1, 90
    call exit2
    
err91:
    add a1, s0, x0
    jal ra, fclose
    addi t0, x0, -1
    beq a0, t0, err90

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    lw a1, 28(sp)
    lw a2, 32(sp)
    addi sp, sp, 36
    li a1, 91
    call exit2 