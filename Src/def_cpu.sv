package def_cpu;

    typedef enum logic [3:0]{
    op_add,             // a + b 
    op_sub,             // a - b
    op_and,             // a & b
    op_or,              // a | b
    op_not,             // ~a
    op_xor,             // a ^ b
    op_cmp,             // a _ b (updates flags)
    op_adds = 4'b1000,  // a + b 
    op_subs = 4'b1001,  // a - b
    op_adc  = 4'b1010,  // add with carry
    op_sbb  = 4'b1011   // sub with borrow
    }math_op;
    
    typedef enum logic [3:0]{ //always in the form a __ b 
    op_jmp,         //jump regardless
    op_jnz,         //jump if a not zero
    op_jez,         //jump if a is zero
    op_less,        //jump if a <  b
    op_lesse,       //jump if a <= b
    op_great,       //jump if a >  b
    op_greate       //jump if a >= b
    }cmp_op;
    
    typedef enum logic [2:0]{
    op_shr, //shift right
    op_shl, //shift left
    op_ror, //roll right
    op_rol //roll left
    }xtr_op;
      
    localparam int REG_COUNT = 8;
    
    
endpackage

