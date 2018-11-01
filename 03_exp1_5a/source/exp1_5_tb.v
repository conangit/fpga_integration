`timescale 1ps/1ps

module exp1_5_tb();

    reg clk;
    reg rst_n;
    
    initial
    begin
        clk = 1;
        forever #5 clk = ~clk;
    end
    
    initial
    begin
        rst_n = 0;
        #1000 rst_n = 1;
    end
    
    
    wire [7:0] sq_c1;
    wire [7:0] sq_x;
    wire [1:0] sq_i;
    wire [7:0] sq_act;
    
    
    exp1_5 u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .sq_c1(sq_c1),
        .sq_x(sq_x),
        .sq_i(sq_i),
        .sq_act(sq_act)
    );
    
    
endmodule

