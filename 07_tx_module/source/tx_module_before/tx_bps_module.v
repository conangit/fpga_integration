`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:19:23 08/02/2018 
// Design Name: 
// Module Name:    tx_bps_module 
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
module tx_bps_module
#(parameter BPS = 13'd433)
(
    clk,
    rst_n,
    tx_count_sig,
    tx_bps_clk
);
    
    input clk;
    input rst_n;
    
    input tx_count_sig;
    output tx_bps_clk;
    
    /***********************/
    
    //tx_count_sig由外来模块引入 假设模块的沟通需要一个时钟
    
    //50MHz
    //115200bps -- 434-1
    //9600bps -- 5208-1
    
    //12MHz
    //115200bps -- 104-1
    //9600bps -- 1250-1
    
    reg [12:0]Count_BPS;
    
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            Count_BPS <= 13'd0;
        else if (Count_BPS == BPS)
            Count_BPS <= 13'd0;
        else if (tx_count_sig)
            Count_BPS <= Count_BPS + 1'b1;
        else
            Count_BPS <= 13'd0;
    end
    
    assign tx_bps_clk = (Count_BPS == (BPS>>1)) ? 1'b1: 1'b0;

endmodule

