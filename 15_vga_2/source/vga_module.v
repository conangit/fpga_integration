

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
    wire [10:0] u1_c1;
    wire [10:0] u1_c2;
    
    vga_sync v1
    (
        .clk(clk),
        .rst_n(rst_n),
        .hsync(u1_hsync),
        .vsync(u1_vsync),
        .c1(u1_c1),
        .c2(u1_c2)
    );
    
    
    /****************************************************/
    
    wire [10:0] r1_rom_addr;
    wire [7:0]  r1_rom_data;
    wire [2:0]  c1_rgb;
    
    rom1_ip r1
    (
        .clka(clk),             // input clka
        .addra(r1_rom_addr),    // input [10 : 0] addra
        .douta(r1_rom_data)     // output [7 : 0] douta
    );
    
    vga_control_1 c1
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(u1_c1),
        .c2(u1_c2),
        .rgb(c1_rgb),
        .rom_addr(r1_rom_addr),
        .rom_data(r1_rom_data)
    );
    
    /****************************************************/
    
    
    wire [10:0] r2_rom_addr;
    wire [7:0]  r2_rom_data;
    wire [2:0]  c2_rgb;
    
    rom2_ip r2
    (
        .clka(clk),         // input clka
        .addra(r2_rom_addr),   // input [10 : 0] addra
        .douta(r2_rom_data)    // output [7 : 0] douta
    );
    
    vga_control_2 c2
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(u1_c1),
        .c2(u1_c2),
        .rgb(c2_rgb),
        .rom_addr(r2_rom_addr),
        .rom_data(r2_rom_data)
    );
    
    /****************************************************/
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            hsync <= 1'b1;
            vsync <= 1'b1;
        end
        else
        begin
            //流水线的本质:将需要4个clk的过程"压缩"到1个clk
            hsync <= u1_hsync;
            vsync <= u1_vsync;
        end
    end
    
    assign rgb = c1_rgb | c2_rgb;
    
    
    /****************************************************/
    
    
endmodule


