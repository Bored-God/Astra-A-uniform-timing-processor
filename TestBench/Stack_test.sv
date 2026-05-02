module Stack_test;
    logic [7:0] val,out,op; //val,clk,en,out,op
    logic en,clk;
    
    initial begin
    clk = 1;
    forever #1 clk = ~clk;
    end 
    initial begin
      en = 1; op=8'b00; val = 8'h12;    
    #2                  val = 8'h43;    
    #2                  val = 8'h65;    
    #2                  val = 8'h6c;    
    #2                  val = 8'h8a;    
    #2        op=8'b01; val = 8'h4;    
    #2                  val = 8'h67;
    #2                  val = 8'h90;    
    #2                  val = 8'h43;
    #2                  val = 8'h5;    
    #2 en = 0;op=8'b00; val = 8'h43;   
    #2        op=8'b01; val = 8'h43;
    #2 en = 1;op=8'b00; val = 8'h52;
    #2        op=8'b01; val = 8'hf4;
    #2        op=8'b00; val = 8'h12;
    #2        op=8'b01; val = 8'h6e;
    #2  $finish;
    end
    Stack mo(.clk(clk),.val(val),.op(op),.en(en),.out(out));    
endmodule
