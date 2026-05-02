import def_cpu::*;

module Cond(Op_code,flagsin,flagsout,en,jmp);
    input cmp_op Op_code;
    input logic en;
    input  logic [3:0] flagsin;
    output logic [3:0] flagsout;
    output logic jmp;
    logic g1;
    xor (g1,flagsin[1],flagsin[2]);
    always_comb begin
    jmp=0;
        if(en) begin        
            case(Op_code)
                op_jmp   : jmp=1;
                op_jnz   : if(~flagsin[3])begin jmp=1;end      
                op_jez   : if(flagsin[3])begin jmp=1;end
                op_less  : if(flagsin[1] ^ flagsin[2])begin jmp=1;end 
                op_lesse : if((flagsin[1] ^ flagsin[2])|| flagsin[3])begin jmp=1;end
                op_great : if(!flagsin[3] && !g1)begin jmp=1;end
                op_greate: if(flagsin[3] || g1)begin jmp=1;end
            endcase
        end
        flagsout = 4'b0;
    end
endmodule
