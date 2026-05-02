module Stack(val,clk,en,out,op);
    input [7:0] val,op; // any -> val = input value; counter -> cntr = counter value for call/ret functions 
    input en,clk; //cond -> en = enable; clock -> clk = clock; pp = 0 => push, 1 => pop;
    logic [7:0] sp = 8'd0; //stack pointer
    logic [7:0] regs [255:0]; //reg_file 255 regs with 8 bit storage 
    output logic [7:0] out; //jump loc -> program Counter 
   always_ff @ (posedge clk) 
    begin
        if(en) begin
                 case(op[1:0]) 
                 2'b00:   begin //push
                        if(sp < 8'd255) 
                            begin
                                regs[sp] <= val; //stores input
                                sp <= sp + 1; //update stack pointer
                            end
                          end 
                 2'b01:begin //pop
                        if(sp > 8'd0) 
                            begin
                                out <= regs[sp-1];
                                sp <= sp - 1;
                            end
                    end  
                2'b11:begin //pop counter
                        if(sp > 8'd0) 
                            begin
                                out <= regs[sp-1];
                                sp <= sp - 1;
                            end
                    end
            endcase
        end
    end
endmodule
