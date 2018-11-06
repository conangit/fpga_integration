module task3_module
(
    input clk,
    input rst_n,
    input [7:0] rom_data,
    input data_valid,
    input [2:0] index,
    output reg [2:0] rgb
);
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            rgb <= 3'b000;
        else
            rgb <= data_valid ? {rom_data[index], rom_data[index], rom_data[index]} : 3'b000;
    end
    
    
endmodule

