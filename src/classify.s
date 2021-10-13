.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
	addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)
    
    addi t0, x0, 5
    bne a0, t0, err72

	# =====================================
    # LOAD MATRICES
    # =====================================
    lw s0, 4(a1) #m0, first matrix filename
    lw s1, 8(a1) #m1, second matrix filename
    lw s2, 12(a1) #input, input matrix filename
    lw s3, 16(a1) #filepath of output file
    add s4, a2, x0 #classification 0 or 1
    
    addi a0, x0, 4 # 4 bytes to malloc for int pointers
    jal ra, malloc
    addi t0, x0, 0
    beq a0, t0, err88
    add a1, a0, x0 # pointer to num of rows
    addi sp, sp, -4
    sw a1, 0(sp)
    addi a0, x0, 4
    jal ra, malloc
    addi t0, x0, 0
    beq a0, t0, err88
    
    lw a1, 0(sp)
    addi sp, sp, 4
    add a2, a0, x0 # pointer to num of columns
    add a0, s0, x0 # filename for m0
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    jal ra, read_matrix
    
    add s0, a0, x0 # set s0 to the actual start of the matrix m0
    lw a1, 0(sp)
    lw a2, 4(sp)
    addi sp, sp, 8
    lw s5, 0(a1) # number of rows in m0
    lw s6, 0(a2) # num of columns in m0
    
    add a0, a1, x0
    addi sp, sp, -4
    sw a2, 0(sp)
    jal ra, free
    lw a2, 0(sp)
    addi sp, sp, 4
    add a0, a2, x0
    jal ra, free
    
    addi a0, x0, 4 # 4 bytes to malloc for int pointers
    jal ra, malloc
    addi t0, x0, 0
    beq a0, t0, err88
    add a1, a0, x0 # pointer to num of rows
    addi sp, sp, -4
    sw a1, 0(sp)
    addi a0, x0, 4
    jal ra, malloc
    addi t0, x0, 0
    beq a0, t0, err88
    lw a1, 0(sp)
    addi sp, sp, 4
    add a2, a0, x0 # pointer to num of columns
    add a0, s1, x0 # filename for m1
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    jal ra, read_matrix
    
    add s1, a0, x0 # set s1 to the actual start of matrix m1
    lw a1, 0(sp)
    lw a2, 4(sp)
    addi sp, sp, 8
    lw s7, 0(a1) # num rows in m1
    lw s8, 0(a2) # num columns in m1
    
    add a0, a1, x0
    addi sp, sp, -4
    sw a2, 0(sp)
    jal ra, free
    lw a2, 0(sp)
    addi sp, sp, 4
    add a0, a2, x0
    jal ra, free
    
    addi a0, x0, 4 # 4 bytes to malloc for int pointers
    jal ra, malloc
    addi t0, x0, 0
    beq a0, t0, err88
    add a1, a0, x0 # pointer to num of rows
    addi sp, sp, -4
    sw a1, 0(sp)
    addi a0, x0, 4
    jal ra, malloc
    addi t0, x0, 0
    beq a0, t0, err88
    lw a1, 0(sp)
    addi sp, sp, 4
    add a2, a0, x0 # pointer to num of columns
    add a0, s2, x0 # filename for input matrix
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    jal ra, read_matrix
    
    add s2, a0, x0 # set s2 to the actual start of matrix input
    lw a1, 0(sp)
    lw a2, 4(sp)
    addi sp, sp, 8
    lw s9, 0(a1) # num rows in input
    lw s10, 0(a2) # num columns in input
    
    add a0, a1, x0
    addi sp, sp, -4
    sw a2, 0(sp)
    jal ra, free
    lw a2, 0(sp)
    addi sp, sp, 4
    add a0, a2, x0
    jal ra, free
    

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    mul a0, s10, s5
    addi sp, sp, -4
    sw a0, 0(sp)
    addi t0, x0, 4
    mul a0, a0, t0
    jal ra, malloc
    addi t0, x0, 0
    beq a0, t0, err88
    add s11, a0, x0 # malloc'ed
    add a6, a0, x0 # result stored array
    add a0, s0, x0 # pointer to m0
    add a1, s5, x0 # m0 numrows
    add a2, s6, x0 # m0 numcolumns
    add a3, s2, x0 # pointer to input
    add a4, s9, x0 # input numrows
    add a5, s10, x0 # input numcolumns
    addi sp, sp, -4
    sw a6, 0(sp)
    jal ra, matmul

    # h = relu(h)
    lw a6, 0(sp)
    addi sp, sp, 4
    lw a1, 0(sp)
    addi sp, sp, 4

    add a0, a6, x0
    jal ra, relu
    addi sp, sp, -4
    sw a0, 0(sp) # store a0, which is pointer to h
    
    # o = matmul(m1, h)
    mul a0, s7, s10
    addi t0, x0, 4
    mul a0, a0, t0
    jal ra, malloc
    addi t0, x0, 0
    beq a0, t0, err88
    add a6, a0, x0 # pointer to result
    lw a0, 0(sp) # h
    addi sp, sp, 4
    
    add a3, a0, x0 # h
    addi sp, sp, -4
    sw a3, 0(sp)
    add a0, s1, x0 # start of m1
    add a1, s7, x0 # numrows m1
    add a2, s8, x0 # numcolumns m1
    add a4, s5, x0 # numrows h
    add a5, s10, x0 # numcolumns h
    addi sp, sp, -4
    sw a6, 0(sp)
    jal ra, matmul

    lw a6, 0(sp)
    addi sp, sp, 4
    add a0, a6, x0 # pointer to o   
    addi sp, sp, -4
    sw a0, 0(sp)
    
    add a1, a0, x0
    add a0, s3, x0
    add a2, s7, x0
    add a3, s10, x0
    jal ra, write_matrix    
    ebreak
    lw a0, 0(sp)
    mul a1, s7, s10 # num items in o
    jal ra, argmax
    
    ebreak
    addi t0, x0, 0
    bne s4, t0, noprint
    
    addi sp, sp, -4
    sw a0, 0(sp)
    
    add a1, a0, x0
    jal ra, print_int
    
    li a1, 10
    jal ra, print_char 
    
    
    
noprint:    
    lw a0, 4(sp)
    jal ra, free
    lw a0, 8(sp)
    #jal ra, free
    add a0, s0, x0
    jal ra, free
    add a0, s1, x0
    jal ra, free
    add a0, s2, x0
    jal ra, free
    
    lw a0, 0(sp)
    addi sp, sp, 12

    # epilogue
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52









    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax




    # Print classification




    # Print newline afterwards for clarity




    ret

err72:
    # free up memory
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52
    
    li a1 72
    call exit2
    
err88:
    #free up memory
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52
    
    li a1 88
    call exit2