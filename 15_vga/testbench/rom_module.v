module rom_module
(
    input clk,
    input rst_n,
    input [10:0] rom_addr,
    output reg [7:0] rom_data
);
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            rom_data <= 8'h00;
        else
            case(rom_addr[0])
            
                0: rom_data <= 8'hFF;
                1: rom_data <= 8'h00;
            
            endcase
    end
    
    
endmodule

