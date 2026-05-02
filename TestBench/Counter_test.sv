module Counter_test;
    logic clk,jen;
    logic [7:0] jmp,PC;

    initial 
    begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    
    initial begin
        #1  jen = 0;jmp = 8'd10;
        #6  jen = 1;jmp = 8'd78;
        #1  jen = 0;jmp = 8'd21;
        #8  jen = 1;jmp = 8'd4;
        #2  jen = 0;
        #10
        #1 $stop;
    end
    Counter mo(.clk(clk),.jmp(jmp),.PC(PC),.jmp_en(jen));
endmodule
