import def_cpu::*;

module comp_tester;
    cmp_op code;
    logic en;
    logic [3:0] flagsin,flagsout;
    logic out;
   
    initial begin
        en = 1;
        code = op_jmp;    flagsin =4'b1100;
    #1  code = op_jnz;    flagsin =4'b1100;
    #1  code = op_jez;    flagsin =4'b1011;
    #1  code = op_less;   flagsin =4'b0001;
    #1  code = op_lesse;  flagsin =4'b0011;
    #1  code = op_great;  flagsin =4'b0101;
    #1  code = op_greate; flagsin =4'b1011; 
    #1  code = op_jmp; en=0;
    #1  code = op_less;   flagsin =4'b0001;
    #1  $stop;
   end
Cond m0(.Op_code(code),.jmp(out),.flagsin(flagsin),.flagsout(flagsout),.en(en));

endmodule
