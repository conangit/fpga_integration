`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:21:36 08/02/2018 
// Design Name: 
// Module Name:    rx_module 
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
module rx_module
(
    input clk,
    input rst_n,
    input rx_en_sig,
    input rx_pin,
    output rx_done,
    output [7:0]rx_data
);
    
    parameter BPS_50MHz_9600   = 13'd5207;
    parameter BPS_50MHz_115200 = 13'd433;
    parameter BPS_12MHz_9600   = 13'd1249;
    parameter BPS_12MHz_115200 = 13'd103;
    
    
    wire h2l_sig;
    wire rx_count_sig;
    wire bps_clk;

    
    rx_detect_module u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .h2l_sig(h2l_sig),
        .rx_pin(rx_pin)
    );
    
    rx_bps_module #(.BPS(BPS_12MHz_115200)) u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .rx_count_sig(rx_count_sig),
        .bps_clk(bps_clk)
    );
    
    rx_control_module u3
    (
        .clk(clk),
        .rst_n(rst_n),
        .rx_en_sig(rx_en_sig),
        .h2l_sig(h2l_sig),
        .bps_clk(bps_clk),
        .rx_pin(rx_pin),
        .rx_count_sig(rx_count_sig),
        .rx_done(rx_done),
        .rx_data(rx_data)
    );


endmodule
