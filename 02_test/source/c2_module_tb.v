`timescale 1ps/1ps

module c2_module_tb();

    reg clk;
    reg rst_n;
    
    wire q;
    wire [4:0] sq_c2;
    wire [1:0] sq_i;
    
    /*
    c2a_module u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .q(q),
        .sq_c2(sq_c2),
        .sq_i(sq_i)
    );
    */
    
    c2b_module u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .q(q),
        .sq_c2(sq_c2),
        .sq_i(sq_i)
    );
    
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
    
endmodule

