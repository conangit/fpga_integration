module task2_module
(
    input clk,
    input rst_n,
    input [6:0] x,
    input [6:0] y,
    output reg [10:0] rom_addr,
    output reg [2:0] index
);
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            rom_addr <= 11'd0;
            index <= 3'd0;
        end
        else
        begin
            rom_addr <= ((y << 4) + (x >> 3));
            index <= x & 3'b111;
        end
    end
    
    
endmodule

