

module vga_module
(
    input clk,
    input rst_n,
    output reg hsync,
    output reg vsync,
    output [2:0] rgb
);
    
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
    
    parameter Delay_N = 4'd3;
    reg [Delay_N-1:0] bypass_h;
    reg [Delay_N-1:0] bypass_v;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            bypass_h <= {Delay_N{1'b1}};
            bypass_v <= {Delay_N{1'b1}};
            hsync <= 1'b1;
            vsync <= 1'b1;
        end
        else
        begin
            bypass_h <= {bypass_h[Delay_N-2:0], u1_hsync};
            bypass_v <= {bypass_v[Delay_N-2:0], u1_vsync};
            hsync <= bypass_h[Delay_N-1];
            vsync <= bypass_v[Delay_N-1];
        end
    end
    
    
    /****************************************************/
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
    /*
    rom_module rom
    (
        .clk(clk),
        .rst_n(rst_n),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    */
    
    rom_ip rom (
        .clka(clk),         // input clka
        .addra(rom_addr),   // input [10 : 0] addra
        .douta(rom_data)    // output [7 : 0] douta
    );
    
    /****************************************************/
    
endmodule


