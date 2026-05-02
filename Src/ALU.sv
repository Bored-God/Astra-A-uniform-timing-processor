import def_cpu::*;

module ALU(Op_code,op1,op2,out,en,flagsin,flagsout);
    input math_op Op_code;
    input [7:0] op1,op2;
    input logic [3:0] flagsin;
    input en;
    output logic [7:0] out;
    output logic [3:0] flagsout;
    logic [8:0] temp;
    always_comb begin
        flagsout = 4'b0000;
        out = 8'd0;
        if(en) begin
                     case(Op_code)
                          op_add: begin
                                  temp = op1 + op2;
                                  out = temp[7:0];
                                  flagsout[0] = temp[8];
                                  flagsout[1] = 0;
                                  flagsout[2] = 0;
                                  flagsout[3] = (out == 8'd0);
                                  end
                          op_sub: begin
                                  temp = op1 - op2;
                                  out = temp[7:0];
                                  flagsout[0] = ~temp[8];
                                  flagsout[1] = 0;
                                  flagsout[2] = 0;
                                  flagsout[3] = (out == 8'd0);
                                  end
                          op_and: begin 
                                  out = op1 & op2; 
                                  flagsout[0] = 0;                                        //carry
                                  flagsout[1] = out[7];                                  //negative
                                  flagsout[2] = 0;                                        //overflow
                                  flagsout[3] = (out == 8'd0);
                                  end
                          op_or : begin 
                                  out = op1 | op2; 
                                  flagsout[0] = 0;                                        //carry
                                  flagsout[1] = out[7];                                  //negative
                                  flagsout[2] = 0;                                        //overflow
                                  flagsout[3] = (out == 8'd0);
                                  end
                          op_not: begin 
                                  out = ~op1; 
                                  flagsout[0] = 0;                                        //carry
                                  flagsout[1] = out[7];                                  //negative
                                  flagsout[2] = 0;                                        //overflow
                                  flagsout[3] = (out == 8'd0);
                                  end
                          op_xor: begin 
                                  out = op1 ^ op2;
                                  flagsout[0] = 0;                                        //carry
                                  flagsout[1] = out[7];                                  //negative
                                  flagsout[2] = 0;                                        //overflow
                                  flagsout[3] = (out == 8'd0);
                                  end
                          op_cmp: begin
                                  temp = op1-op2;  
                                  flagsout[0] = ~temp[8];                                  //carry
                                  flagsout[1] = temp[7];                                  //negative
                                  flagsout[2] = (op1[7] == op2[7] && op1[7] != temp[7]);   //overflow                               
                                  flagsout[3] = (temp == 8'd0);
                                  end
                         op_adds: begin
                                  temp = op1 + op2;
                                  out = temp[7:0];
                                  flagsout[0] = temp[8];                                  //carry
                                  flagsout[1] = out[7];                                   //negative
                                  flagsout[2] = (op1[7] == op2[7] && op1[7] != out[7]);   //overflow  
                                  flagsout[3] = (out == 8'd0);
                                  end
                         op_subs: begin
                                  temp = op1 - op2;
                                  out = temp[7:0];
                                  flagsout[0] = ~temp[8];                                 //carry
                                  flagsout[1] = out[7];                                   //negative
                                  flagsout[2] = (op1[7] != op2[7] && op1[7] != out[7]);   //overflow 
                                  flagsout[3] = (out == 8'd0);
                                  end 
                          op_adc: begin 
                                  temp = op1 + op2 + flagsin[0];
                                  out = temp[7:0];
                                  flagsout[0] = temp[8];
                                  flagsout[1] = 0;
                                  flagsout[2] = 0; 
                                  flagsout[3] = (out == 8'd0);  
                                  end
                          op_sbb: begin
                                  temp = op1 - op2 - ~flagsin[0];
                                  out = temp[7:0];
                                  flagsout[0] = ~temp[8];
                                  flagsout[1] = 0;
                                  flagsout[2] = 0;
                                  flagsout[3] = (out == 8'd0);  
                                  end
                         default: begin
                                  out = 8'b0;
                                  flagsout[0] = 0;                                        //carry
                                  flagsout[1] = out[7];                                  //negative
                                  flagsout[2] = 0;                                        //overflow
                                  flagsout[3] = (out == 8'd0);  
                                  end
                     endcase               
            end
         end        
endmodule
