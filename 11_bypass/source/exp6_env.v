module exp6_env
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
    wire u1_write_en;
    wire [3:0] u1_ram_addr;

    control_module u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .done_sig(done_sig),
        .rom_addr(rom_addr),
        .write_en(u1_write_en),    //output to top
        .ram_addr(u1_ram_addr)     //output to top
    );
    
    rom_module u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .rom_addr(rom_addr),
        .rom_data(rom_data)     //output to top (one clk delay compare with write_en & ram_addr)
    );
    
    
    reg rBy1;
    reg [3:0] rBy2;
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            rBy1 <= 1'b0;
            rBy2 <= 4'd0;
        end
        else
        begin
            rBy1 <= u1_write_en;
            rBy2 <= u1_ram_addr;
        end
    end
    
    assign write_en = rBy1;
    assign ram_addr = rBy2;
    
endmodule

