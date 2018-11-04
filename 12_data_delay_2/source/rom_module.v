module rom_module
(
    input clk,
    input rst_n,
    
    input [3:0] rom_addr,
    output reg [7:0] rom_data
);

    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            rom_data <= 8'd0;
        else
            case(rom_addr)
            
                0: rom_data <= 8'h5a;
                1: rom_data <= 8'h7e;
                2: rom_data <= 8'h7e;
                3: rom_data <= 8'h7e;
                4: rom_data <= 8'h7e;
                5: rom_data <= 8'h7e;
                6: rom_data <= 8'h7e;
                7: rom_data <= 8'h7e;
                8: rom_data <= 8'h7e;
                9: rom_data <= 8'h7e;
                10: rom_data <= 8'h7e;
                11: rom_data <= 8'h7e;
                12: rom_data <= 8'h7e;
                13: rom_data <= 8'h7e;
                14: rom_data <= 8'h7e;
                15: rom_data <= 8'h6b;
            
            endcase
    end
    
    
endmodule

