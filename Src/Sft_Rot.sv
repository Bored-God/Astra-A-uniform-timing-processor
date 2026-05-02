import def_cpu::*;
module Xtra(op1,op,op2,out,en,flagsin,flagsout);
    input                   en;
    input   xtr_op          op;
    input   logic   [3:0]   flagsin;
    input   logic   [7:0]   op1,op2;
    output  logic   [7:0]   out;
    output  logic   [3:0]   flagsout;
    logic           [2:0]   sh;
    logic           [8:0]   ext;
    always_comb begin
        if(en) begin
            sh = op2[2:0];
            case(op)
                op_shr: begin
                        out = op1 >> sh;
                        end 
                op_shl: begin
                        out = op1 << sh;
                        end
                op_ror: begin
                        out = (op1 << (8-sh)) | (op1 >> sh);
                        end
                op_rol: begin
                        out = (op1 >> (8-sh)) | (op1 << sh);
                        end
               default: out = op1;
            endcase
        end
    end
endmodule