module Clock(clk);
 output logic clk;
initial begin
    clk = 0;
    forever #1 clk = ~clk;
    end
endmodule
