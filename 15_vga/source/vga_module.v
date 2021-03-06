

module vga_module
(
    input clk,
    input clk_other,
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
    
    wire [10:0] rom_addr;
    wire [7:0] rom_data;
    
    vga_sync sync_mod
    (
        .clk(clk),
        .rst_n(rst_n),
        .hsync(u1_hsync),
        .vsync(u1_vsync),
        .c1(c1),
        .c2(c2)
    );
    
    rom_ip rom_mod
    (
        .clka(clk),         // input clka
        // .clka(clk_other),         // input clka
        .addra(rom_addr),   // input [10 : 0] addra
        .douta(rom_data)    // output [7 : 0] douta
    );
    
    /****************************************************/
    
    /*
    vga_control_1 u1
    (
        // .clk(clk),
        .clk(clk_other),
        .rst_n(rst_n),
        .c1(c1),
        .c2(c2),
        .rgb(rgb),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    */
    
    /****************************************************/
    
    
    parameter Delay_N = 4'd4;
    
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
            // bypass_h <= {bypass_h[Delay_N-2:0], u1_hsync};
            // bypass_v <= {bypass_v[Delay_N-2:0], u1_vsync};
            // hsync <= bypass_h[Delay_N-1];
            // vsync <= bypass_v[Delay_N-1];
            
            //流水线的本质:将需要4个clk的过程"压缩"到1个clk
            hsync <= u1_hsync;
            vsync <= u1_vsync;
        end
    end
    
    
    /****************************************************/
    
    //流水线形式(各步骤封装成模块)
    
    
    vga_control_2 u2
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
    
    //流水线形式(各步骤写在一个过程块形式)
    
    /*
    vga_control_3 u3
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
    
endmodule


