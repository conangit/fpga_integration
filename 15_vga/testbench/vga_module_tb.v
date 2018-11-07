`timescale 1ps/1ps

//若延时单位为1ns 则40MHz为 #12.5 clk = ~clk;
//存在小数

module vga_module_tb();

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
    
    wire u1_hsync;
    wire u1_vsync;
    wire [10:0] c1;
    wire [10:0] c2;
    
    vga_sync u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .hsync(u1_hsync),
        .vsync(u1_vsync),
        .c1(c1),
        .c2(c2)
    );
    
    parameter Delay_N = 4'd2;
    reg [Delay_N-1:0] bypass_h;
    reg [Delay_N-1:0] bypass_v;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            bypass_h <= {Delay_N{1'b1}};
            bypass_v <= {Delay_N{1'b1}};
        end
        else
        begin
            bypass_h <= {bypass_h[Delay_N-2:0], u1_hsync};
            bypass_v <= {bypass_v[Delay_N-2:0], u1_vsync};
        end
    end
    
    wire hsync = bypass_h[Delay_N-1];
    wire vsync = bypass_v[Delay_N-1];
    
    
    /****************************************************/
    wire [2:0] rgb;
    wire [10:0] rom_addr;
    wire [7:0] rom_data;
    
    /*
     * 目的:通过仿真查看rgb相比hsync,vsync慢了N个clk
     * 则vga_sync模块的hsync,vsync需要N个bypass register
     */
    
    /****************************************************/
    //步骤形式 N=7
    
    vga_control_1 u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(c1),
        .c2(c2),
        .rgb(rgb),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    
    /****************************************************/
    //流水线形式(各步骤封装成模块) N=2
    /*
    vga_control_2 u3
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(c1),
        .c2(c2),
        .rgb(rgb),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    */
    /****************************************************/
    //流水线形式(各步骤写在一个过程块形式) N=2
    /*
    vga_control_3 u4
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(c1),
        .c2(c2),
        .rgb(rgb),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    */
    /****************************************************/
    
    rom_module rom
    (
        .clk(clk),
        .rst_n(rst_n),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    
    /****************************************************/
    
endmodule


