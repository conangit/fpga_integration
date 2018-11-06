`timescale 1ps/1ps

//若延时单位为1ns 则40MHz为 #12.5 clk = ~clk;
//存在小数

module vga_sync_tb;

    reg clk;
    reg rst_n;
    
    initial
    begin
        rst_n = 0;
        #1000000;         //1us
        rst_n = 1;
    end
    
    initial
    begin
        clk = 1;
        forever #12500 clk = ~clk; //40MHz
    end
    
    /****************************************************/
    
    wire hsync;
    wire vsync;
    wire [10:0] c1;
    wire [10:0] c2;
    
    vga_sync u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .hsync(hsync),
        .vsync(vsync),
        .c1(c1),
        .c2(c2)
    );
    
    
endmodule

