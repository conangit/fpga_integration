module task2_module
(
    input clk,
    input rst_n,
    input [6:0] x,
    input [6:0] y,
    input data_valid,
    output reg [10:0] rom_addr,
    output reg [2:0] index
);
    
    reg [2:0] index_before; //配合ROM输出延时1个clk
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            rom_addr <= 11'd0;
            index <= 3'd0;
            index_before <= 3'd0;
        end
        else
        begin
            rom_addr <= ((y << 4) + (x >> 3));
            // index <= x & 3'b111;
            index_before <= x & 3'b111;
            index <= index_before;
        end
    end
    
    
endmodule

