module Clk_test;
logic clk,a;
Clock m0(clk);
initial begin
    #10
    #2 $stop;
end  
endmodule
