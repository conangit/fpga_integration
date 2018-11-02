`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:27:20 08/02/2018 
// Design Name: 
// Module Name:    tx_control_module 
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
module tx_control_module
(
    clk,
    rst_n,
    tx_en_sig,
    tx_data,
    tx_bps_clk,
    tx_done,
    tx_pin
);
    
    input clk;
    input rst_n;
    
    input tx_en_sig;
    input [7:0]tx_data;
    input tx_bps_clk;
    
    output tx_done;
    output tx_pin;
    
    /********************************/
    
    reg [3:0]i;
    reg rTx;
    reg isDone;
    
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            i <= 4'd0;
            rTx <= 1'b1; // rx线默认高电平
            isDone <= 1'b0;
        end
        else if (tx_en_sig)
        begin
            case (i)
            
                4'd0:
                begin
                    if (tx_bps_clk) begin  //错误:造成了半个bit时钟的延时
                        i <= i + 1'b1;
                        rTx <= 1'b0; // 开始信号
                    end
                end
                
                4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8: // 发送数据
                begin
                    if (tx_bps_clk) begin
                        i <= i + 1'b1;
                        rTx <= tx_data[i-1]; //LSB
                    end
                end
                
                4'd9: // 停止位
                begin
                    if (tx_bps_clk) begin
                        i <= i + 1'b1;
                        rTx <= 1'b1;
                    end
                end
                
                4'd10:
                begin
                    i <= i + 1'b1;
                    isDone <= 1'b1;
                end

                4'd11:
                begin
                    i <= 4'd0;
                    isDone <= 1'b0;
                end
                
            endcase
        end
    end

    assign tx_done = isDone;
    assign tx_pin = rTx;

endmodule

