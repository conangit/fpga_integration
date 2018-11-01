`timescale 1ps/1ps

module exp1_8_tb();

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
    
    
    wire [7:0] c1;
    wire [7:0] x;
    wire [7:0] y;
    wire [7:0] act1;
    wire [7:0] act2;
    wire [1:0] i;
    
    /*
    exp1_8a u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(c1),
        .x(x),
        .y(y),
        .act1(act1),
        .act2(act2),
        .i(i)
    );
    */
    
    /*
    exp1_8b u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(c1),
        .x(x),
        .y(y),
        .act1(act1),
        .act2(act2),
        .i(i)
    );
    */
    
    exp1_8c u3
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(c1),
        .x(x),
        .y(y),
        .act1(act1),
        .act2(act2),
        .i(i)
    );
    
    
endmodule

