import def_cpu::*;

module Top();
math_op alu_op;
cmp_op comp_op;
xtr_op xtra_op;
logic clk,jmp_cond,en1,en2,en3,en4,jmp,w_en,call,pp,s_en,c_en,a_en,x_en,ram_en,ram_read;
logic [7:0] op_code,op1,op2,jmp_loc,res_alu,res_salu,res_sft,SP,stack_out,ramsave,ramloc;
logic [7:0] count,out1,out2,out_ram,sav_val,sav_loc;
logic [3:0] flagsin,flagsalu,flagscond,flagsxtra,flagsout;     //flags = 0000 -> z,o,n,c
Clock       m0(.clk(clk));                                                                                                              //clk
Counter     m1(.jmp_en(jmp),.jmp(jmp_loc),.PC(count),.clk(clk));                                                                        //jmp_en,jmp,PC,clk
Programme   m2(.count(count),.op_code(op_code),.op1(op1),.op2(op2));                                                                    //count,op_code,op1,op2
Reg_file    m3(.w_en(w_en),.save(sav_val),.sav_loc(sav_loc[2:0]),.sel1(op1[2:0]),.sel2(op2[2:0]),.out1(out1),.out2(out2),.clk(clk));    //w_en,save,sav_loc,sel1,sel2,out1,out2,clk
ALU         m4(.en(a_en),.Op_code(alu_op),.op1(out1),.op2(out2),.out(res_alu),.flagsin(flagsin),.flagsout(flagsalu));                   //(Op_code,op1,op2,out,en,flagsin,flagsout)
Cond        m6(.en(c_en),.Op_code(comp_op),.flagsin(flagsin),.flagsout(flagscond),.jmp(jmp_cond));                                      //Op_code,flagsin,flagsout,en,jmp
Xtra        m7(.op(xtra_op),.op1(out1),.op2(out2),.out(res_sft),.flagsin(flagsin),.flagsout(flagsxtra),.en(x_en));                      //op1,op,op2,out,en,flagsin,flagsout
Stack       m8(.val(out1),.clk(clk),.en(s_en),.op(op_code),.out(stack_out));                                                                 //op_code,val,cntr,clk,en,out
Ram         m9(.sv(ramsave),.s(ramloc),.clk(clk),.out(out_ram),.read(ram_read),.en(ram_en));                                            //sv,s,clk,out,s_o,en

always_ff @ (posedge clk) begin
    flagsin <= flagsout; //flags set for next cycle
    end

always_comb begin
    alu_op = math_op'(4'd0); comp_op = cmp_op'(4'd0); xtra_op = xtr_op'(3'd0);
    a_en = 0;c_en = 0;s_en = 0;x_en = 0; //enable pins initialization
    ram_en = 0; ramsave = 8'd0;ramloc=8'd0; ram_read=0; //mov initialization
    sav_val=8'd0;w_en=0;sav_loc = 'x; //regs initialization
    jmp=0;jmp_loc=8'd0; //stack initialization
    flagsout = flagsin; //flags initialization for cycle
    if (!op_code[7]) // calc mode
        begin
            case(op_code[5:4])
            2'b00:  begin 
                        alu_op = math_op'(op_code[3:0]);
                        a_en = 1'b1;
                        sav_val = res_alu;
                        sav_loc = op1;
                        flagsout = flagsalu;
                        if(op_code[3:0] == 4'b0110)
                            w_en=0;
                        else
                            w_en=1;
                    end
            2'b01:  begin 
                        w_en = 0;
                        comp_op = cmp_op'(op_code[3:0]);
                        c_en = 1'b1;
                        jmp = jmp_cond;
                        jmp_loc = op1; 
                        flagsout = flagscond;
                    end
            2'b10:  begin 
                        xtra_op = xtr_op'(op_code[2:0]);
                        x_en = 1'b1;
                        sav_val = res_sft;
                        sav_loc = op1;
                        w_en = 1;
                        flagsout = flagsxtra;
                    end
            2'b11:  begin 
                    w_en = 0;
                    s_en = 1'b1;
                    if(op_code[1:0] == 2'b11)   begin 
                            jmp = 1;
                            jmp_loc = stack_out;
                            end
                    else if(op_code[1:0] == 2'b01)    begin 
                            w_en = 1;
                            sav_val = stack_out;
                            sav_loc = op1;
                            end
                    end
        endcase
    
        end
    else begin //mov mode
           case(op_code[1:0])
           2'b00:   begin 
                        w_en = 1;
                        sav_loc = op2;
                        sav_val = out1;
                    end
           2'b01:   begin 
                        w_en = 0;
                        ram_en = 1;
                        ramloc = out1;
                        ram_read=0;
                        ramsave = out2;
                    end
           2'b10:   begin 
                        ram_en = 1;
                        ramloc = out1;
                        ram_read = 1;
                        w_en = 1;
                        sav_loc = op2;
                        sav_val = out_ram;
                    end
           2'b11:   begin 
                        w_en = 1;
                        sav_val = op1;
                        sav_loc = op2;
                    end
        endcase
    end
end

endmodule
