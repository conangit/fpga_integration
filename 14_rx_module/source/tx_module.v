/*
 * 循环保留设计方式
 */

module tx_module
#(parameter BPS = 13'd434)
(
    clk,
    rst_n,
    tx_en_sig,
    tx_data,
    tx_done,
    tx_pin
);
    
    input clk;
    input rst_n;
    
    input tx_en_sig;
    input [7:0]tx_data;
    
    output reg tx_done;
    output reg tx_pin;
    
    /***********************/
    /*
    //每个bit所占用的clk个数
    localparam BPS_50MHz_9600   = 13'd5208;
    localparam BPS_50MHz_115200 = 13'd434;
    localparam BPS_12MHz_9600   = 13'd1250;
    localparam BPS_12MHz_115200 = 13'd104;
    */
    /***********************/
    
    reg [12:0] c1; //循环保留--max为每bit数据的clk个数
    reg [3:0] i;
    reg [9:0] rData; //完整的一帧数据 1bit start + 8bit data + 1bit stop
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            tx_done <= 1'b0;
            tx_pin <= 1'b1;
            c1 <= 13'd0;
            i <= 4'd0;
            rData <= 10'd0;
        end
        else if(tx_en_sig)
        begin
            case(i)
                
                0: //加载要发送的数据
                begin
                    rData <= {1'b1, tx_data, 1'b0};
                    i <= i + 1'b1;
                end
                
                1,2,3,4,5,6,7,8,9,10: //start + data + stop
                if(c1 == BPS-1)
                begin
                    c1 <= 13'd0;
                    i <= i + 1'b1;
                end
                else
                begin
                    tx_pin <= rData[i-1]; //LSB
                    c1 <= c1 + 1'b1;
                end
                
                11:
                begin
                    tx_done <= 1'b1;
                    i <= i + 1'b1;
                end
                
                12:
                begin
                    tx_done <= 1'b0;
                    i <= 4'd0;
                end
            
            endcase
        end
    end
    
    
endmodule

//以50Mhz 115200bps为例
//1clk = 20ns
//1bit = 8.68us
//发送一帧数据需要1+10*(434)+2=4343clk = 86.86us
