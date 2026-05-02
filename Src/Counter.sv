module Counter(jmp_en,jmp,PC,clk);
    input jmp_en,clk;
    input [7:0] jmp;
    logic [7:0] count = 8'b0;
    output [7:0] PC;
    
    always_ff @ (posedge clk) begin
        if(jmp_en) 
            begin
            count <= jmp; 
            end
        else begin
            count <= count + 8'd3; //default instruction size is 3 bytes, hence counter increases by 3 to run properly
            end
    end
    assign PC = count;
endmodule
