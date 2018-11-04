module exp5_env
(
    input clk,
    input rst_n,
    
    input start_sig,
    output done_sig,
    
    output write_en,
    output [3:0] ram_addr,
    output [7:0] rom_data
);

    wire [3:0] rom_addr;

    control_module u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .done_sig(done_sig),
        .rom_addr(rom_addr),
        .write_en(write_en),
        .ram_addr(ram_addr)
    );
    
    rom_module u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .rom_addr(rom_addr),
        .rom_data(rom_data)
    );
    
endmodule

