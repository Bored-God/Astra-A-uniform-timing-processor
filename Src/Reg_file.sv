module Reg_file(w_en,save,sav_loc,sel1,sel2,out1,out2,clk);
    input   logic           w_en,clk;             // en = enable; any -> enable save/output = save => 1,out => 0; clock -> clk = clock
    input   logic   [7:0]   save;               // any -> save = save value;
    input   logic   [2:0]   sel1, sel2, sav_loc;// Program -> sel1,sel2,sav_loc = select lines 1,2 and save location
    output  logic   [7:0]   out1, out2;         // any <- out1,out2 = output data from regs[sel1,sel2] to wherever 
            logic   [7:0]   regs [7:0];         // reg list. 8 regs of width 8

        always_comb begin   //instant reads
                    out1 = regs[sel1]; //outputs to bus1
                    out2 = regs[sel2]; //outputs to bus2
                end
        always_ff @ (posedge clk)begin  //clocked writes
                if(w_en) begin
                    regs[sav_loc] <= save;
                end
                else
                    regs[sav_loc] <= regs[sav_loc];
            end
endmodule