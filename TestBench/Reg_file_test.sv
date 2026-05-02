module Reg_file_test;
    logic   [7:0]   sV, out1, out2;
    logic   [2:0]   sel1, sel2,sL;
    logic           w_en, clk;

    initial begin
    clk = 1;
    forever #1 clk = !clk;
    end
    
    initial begin
        w_en = 1; sL = 0; sV = 8'h55;
        #2          sL = 1  ; sV = 8'h42;
        #2          sL = 2  ; sV = 8'h90;
        #2          sel1 = 1; sel2 = 2; sL = 3; sV = 8'h12;
        #2          sel1 = 1; sel2 = 1;sV = 8'h42; sL = 4;
        #2          sel1 = 3; sel2 = 0;sV = 8'h98; sL = 5;
        #2          sel1 = 4; sel2 = 2;sV = 8'h83; sL = 6;
        #2          sel1 = 6; sel2 = 5;sV = 8'h42; sL = 7;
        #2          sel1 = 7; sel2 = 1;sV = 8'h13; sL = 4; 
    #2  w_en = 0;   sel1 = 5; sel2 = 3; sL = 6; sV = 8'hd2;
    #2              sel1 = 1; sel2 = 2; sL = 3; sV = 8'he6;
    #2              sel1 = 4; sel2 = 7; sL = 0; sV = 8'hc3; 
    #2 $finish;
    end
    //en,save,sav_loc,sel1,sel2,out1,out2,clk
    Reg_file mo (.w_en(w_en),.clk(clk),.sel1(sel1),.sel2(sel2),.sav_loc(sL),.save(sV),.out1(out1),.out2(out2));
endmodule
