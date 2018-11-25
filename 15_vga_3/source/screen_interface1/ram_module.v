module ram_module
(
    input clk,
    // input rst_n,
    input write_en,
    input [10:0] wr_addr,
    input [7:0] wr_data,
    input [10:0] rd_addr,
    output [7:0] rd_data
);


    ram_ip u0
    (
        .clka(clk),
        .wea(write_en),
        .addra(wr_addr),
        .dina(wr_data),
        .clkb(clk),
        .addrb(rd_addr),
        .doutb(rd_data)
    );
    
endmodule

