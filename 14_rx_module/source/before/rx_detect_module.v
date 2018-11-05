`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:47:33 08/01/2018 
// Design Name: 
// Module Name:    detect_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module rx_detect_module
(
    clk,
    rst_n,
    h2l_sig,
    rx_pin
);
    
    input clk;
    input rst_n;
    output h2l_sig;
    input rx_pin;
    
    /************************************************/
    
    parameter RX_DELAY = 4'd5;
    
    reg [RX_DELAY-1:0] rf_rx;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            rf_rx <= {RX_DELAY{1'b1}};
        else
            rf_rx <= {rf_rx[RX_DELAY-2:0], rx_pin};
    end
    
    /************************************************/
    
    reg rx_debounced;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            rx_debounced <= 1'b1;
        else
        begin
            if(&rf_rx[RX_DELAY-1:0] == 1'b1)
                rx_debounced <= 1'b1;
            else if(|rf_rx[RX_DELAY-1:0] == 1'b0)
                rx_debounced <= 1'b0;
        end
    end
    
    /************************************************/
    
    reg H2L_F1;
    reg H2L_F2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            H2L_F1 <= 1'b1;
            H2L_F2 <= 1'b1;
        end
        else begin
            H2L_F1 <= rx_debounced;
            H2L_F2 <= H2L_F1;
        end
    end
    
    
    assign h2l_sig = H2L_F2 & !H2L_F1;

endmodule

