import def_cpu::*;


module ALU_test;
    math_op code;
    logic [7:0] op1,op2,out;
    logic [3:0] flags_in,flags_out;
    logic en;
    
    ALU m0(.Op_code(code),.op1(op1),.op2(op2),.out(out),.en(en),.flagsin(flags_in),.flagsout(flags_out));    
    
    initial begin
    forever #2 flags_in = flags_out;
    end
    initial begin
        en = 1;
        #2 code = op_add;  op1 = 8'd20; op2 = 8'd10;
        #2 code = op_sub;  op1 = 8'd60; op2 = 8'd42;
        #2 code = op_and;  op1 = 8'd2;  op2 = 8'd20;
        #2 code = op_or;   op1 = 8'd24; op2 = 8'd06;
        #2 code = op_not;  op1 = 8'd78; op2 = 8'd20;
        #2 code = op_xor;  op1 = 8'd158; op2 = 8'd231;
        #2 code = op_cmp;  op1 = 8'd120; op2 = 8'd206; 
        #2 code = op_adds; op1 = 8'd122; op2 = 8'd19;
        #2 code = op_subs; op1 = 8'd68; op2 = 8'd75;
        #2 code = op_adc;  op1 = 8'd2;  op2 = 8'd20;
        #2 code = op_sbb;  op1 = 8'd24; op2 = 8'd06;
        #2 en = 0;
        #2 code = op_add; op1 = 8'd122; op2 = 8'd19;
        #2 code = op_sub; op1 = 8'd68; op2 = 8'd75;
        #2 $stop;        
    end

endmodule
