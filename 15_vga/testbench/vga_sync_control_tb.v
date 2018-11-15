`timescale 1ps/1ps

//若延时单位为1ns 则40MHz为 #12.5 clk = ~clk;
//存在小数

module vga_sync_control_tb();

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
    
    reg clk_160Mhz;
    
    initial
    begin
        clk_160Mhz = 1;
        forever #3125 clk_160Mhz = ~clk_160Mhz; //160MHz
    end
    
    reg clk_200Mhz;
    
    initial
    begin
        clk_200Mhz = 1;
        forever #2500 clk_200Mhz = ~clk_200Mhz; //200MHz
    end
    
    reg clk_280Mhz;
    
    initial
    begin
        clk_280Mhz = 1;
        forever #1786 clk_280Mhz = ~clk_280Mhz; //280MHz
    end
    
    /****************************************************/
    
    wire s1_hsync;
    wire s1_vsync;
    wire [10:0] s1_c1;
    wire [10:0] s1_c2;
    
    wire [2:0] rgb;
    wire [10:0] rom_addr;
    wire [7:0] rom_data;
    
    // wire hsync = s1_hsync;
    // wire vsync = s1_vsync;
    
    /****************************************************/
    
    vga_sync s1
    (
        .clk(clk),
        .rst_n(rst_n),
        .hsync(s1_hsync),
        .vsync(s1_vsync),
        .c1(s1_c1),
        .c2(s1_c2)
    );
    
    /****************************************************/
    
    rom_module r1
    (
        // .clk(clk),
        // .clk(clk_160Mhz),
        // .clk(clk_200Mhz),
        .clk(clk_280Mhz),
        .rst_n(rst_n),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    
    /****************************************************/
    
    /* 
     * 步骤形式
     * vga_control_1与vga_sync使用同频时钟
     * vga_control_1倍频4倍vga_sync时钟
     * 延时N=4,此时应提高4倍该模块时钟
     */
     
     
    vga_control_1 u1
    (
        // .clk(clk),
        // .clk(clk_160Mhz),
        // .clk(clk_200Mhz),
        .clk(clk_280Mhz),
        .rst_n(rst_n),
        .c1(s1_c1),
        .c2(s1_c2),
        .rgb(rgb),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    
    
    /****************************************************/
    
    /*
     * 流水形式
     * 目的:通过仿真查看u2/u3的rgb相比s1的hsync,vsync延时了N个clk
     * 则vga_sync模块的hsync,vsync需要N个bypass register
     */
    
    /*
    parameter Delay_N = 4'd4;
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
            bypass_h <= {bypass_h[Delay_N-2:0], s1_hsync};
            bypass_v <= {bypass_v[Delay_N-2:0], s1_vsync};
        end
    end
    
    wire hsync = bypass_h[Delay_N-1];
    wire vsync = bypass_v[Delay_N-1];
    */
    
    /****************************************************/
    
    //流水线形式(各步骤封装成模块)
    
    /*
    vga_control_2 u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(s1_c1),
        .c2(s1_c2),
        .rgb(rgb),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    */
    
    /****************************************************/
    
    //流水线形式(各步骤写在一个过程块形式)
    
    /*
    vga_control_3 u3
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(s1_c1),
        .c2(s1_c2),
        .rgb(rgb),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    */
    
endmodule


