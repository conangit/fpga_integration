`timescale 1ns/1ps


module exp09_env_tb
(
    input clk,
    input rst_n,
    input rx_pin,
    output tx_pin
);

    reg tx_en_sig;
    reg [7:0] tx_data;
    wire tx_done;
    
    reg rx_en_sig;
    wire rx_done;
    wire [7:0] rx_data;
    
    
    exp09_env u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_done(tx_done),
        .rx_en_sig(rx_en_sig),
        .rx_done(rx_done),
        .rx_data(rx_data),
        .rx_pin(rx_pin),
        .tx_pin(tx_pin)
    );
    
    /*************************/
    
    reg [3:0] i;
    reg [7:0] rData;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 4'd0;
            tx_en_sig <= 1'b0;
            tx_data <= 8'd0;
            rx_en_sig <= 1'b0;
            rData <= 8'd0;
        end
        else
        begin
            case(i)
            
                0:
                if(rx_done) begin i <= i + 1'b1; rx_en_sig <= 1'b0; rData <= rx_data; end
                else begin rx_en_sig <= 1'b1; end
                
                1:
                if(tx_done) begin tx_en_sig <= 1'b0; i <= 4'd0; end
                else begin tx_data <= rData; tx_en_sig <= 1'b1; end
                
            
            endcase
        end
    end
    
endmodule
