

module screen_module
(
    input clk,
    input rst_n,
    input [10:0] c1,
    input [10:0] c2,
    output [2:0] rgb
);
    
    
    wire [10:0] rom_addr;
    wire [7:0]  rom_data;
    
    
    rom_ip u1
    (
        .clka(clk),
        .addra(rom_addr),
        .douta(rom_data)
    );
    
    vga_control u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(c1),
        .c2(c2),
        .rgb(rgb),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    
    
    
endmodule


