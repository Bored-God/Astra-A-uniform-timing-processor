module Programme(count,op_code,op1,op2);
    input   logic   [7:0]   count;
    output  logic   [7:0]   op_code,op1,op2;
            logic   [7:0]   prog [255:0];
    initial begin
    $readmemb("programme.mem", prog);
    end
        
    assign  op_code =   prog[count];
    assign  op1     =   prog[count+1]; 
    assign  op2     =   prog[count+2];
endmodule
