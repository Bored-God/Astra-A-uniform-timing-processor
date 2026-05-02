module Ram(sv,s,clk,out,read,en);
    input   logic   [7:0]   sv, s; // sv = save value, s = save loc
    input   logic           clk,read,en; //read = 1 -> out; read = 0 -> save
    output  logic   [7:0]   out;
            logic   [7:0]   sram    [255:0];
    
    always_ff @ (posedge clk) begin
        if(en && !read)
                sram[s] <= sv;
        end
    always_comb begin
        if(en) begin  
            out = 8'd0;
            if(read)
                out = sram[s];
        end
        else
            out = 8'd0;
    end          
endmodule