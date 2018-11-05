`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:48:54 08/01/2018 
// Design Name: 
// Module Name:    rx_control_module 
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
module rx_control_module
(
    clk,
    rst_n,
    rx_en_sig,
    h2l_sig,
    bps_clk,
    rx_pin,
    rx_count_sig,
    rx_done,
    rx_data
);
    
    input clk;
    input rst_n;
    
    input rx_en_sig;
    input h2l_sig;
    input bps_clk;
    input rx_pin;

    output reg rx_count_sig;
    output reg rx_done;
    output reg [7:0]rx_data;
    
    /*******************************/
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n) begin
            i <= 4'd0;
            rx_count_sig <= 1'b0;
            rx_done <= 1'b0;
            rx_data <= 8'd0;
        end
        else if (rx_en_sig)
        begin
            case (i)
                
                4'd0:   // 检测到开始信号
                if (h2l_sig)
                begin
                    i <= i + 1'b1;
                    rx_count_sig <= 1'b1;    // rx_bps模块开始产生波特率定时
                end
                
                4'd1:   // 起始位
                if (bps_clk) begin
                    i <= i + 1'b1;
                end
                
                4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9:     // 数据位
                if (bps_clk) begin
                    i <= i + 1'b1;
                    rx_data[i-2] <= rx_pin; //LSB
                end
                
                4'd10:   // 停止位
                if (bps_clk) begin
                    i <= i + 1'b1;
                end
                
                4'd11:   // 一帧数据采集完成
                begin
                    i <= i + 1'b1;
                    rx_count_sig <= 1'b0;
                    rx_done <= 1'b1;
                end
                
                4'd12:   // 回到初态
                begin
                    i <= 1'b0;
                    rx_done <= 1'b0;
                end
                
            endcase
        end
    end
    
endmodule
