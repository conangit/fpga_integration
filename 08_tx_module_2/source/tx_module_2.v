/*
 * 循环操作设计方式
 */

//以50Mhz 115200bps为例
//1clk = 20ns
//1bit = 8.68us
//发送一帧数据需要10*(434)=4340clk = 37671.2us
//不使用即时结果+1个clk,共为4341



module tx_module_2
#(parameter BPS = 13'd434)
(
    clk,
    rst_n,
    tx_en_sig,
    tx_data,
    tx_pin
);
    
    input clk;
    input rst_n;
    
    input tx_en_sig;
    input [7:0]tx_data;
    
    output reg tx_pin;
    
    /***********************/
    /*
    //每个bit所占用的clk个数
    localparam BPS_50MHz_9600   = 13'd5208;     *10 = 52080(16bit)
    localparam BPS_50MHz_115200 = 13'd434;      *10 = 4340
    localparam BPS_12MHz_9600   = 13'd1250;     *10 = 12500
    localparam BPS_12MHz_115200 = 13'd104;      *10 = 1040
    */
    /***********************/
    
    reg [15:0] c1;      //循环操作--max为一帧数据的clk个数
    reg [15:0] x;       //控制每bit数据的发送
    reg [9:0] rData;    //完整的一帧数据 1bit start + 8bit data + 1bit stop
    reg [3:0] index;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            tx_pin <= 1'b1;
            c1 <= 16'd0;
            x <= 16'd0;
            rData <= 10'd0;
            index <= 4'd0;
        end
        else if(tx_en_sig)
        begin
            rData <= {1'b1, tx_data, 1'b0}; //相当于每个clk都动作(且恒定--即不涉及什么时候开始,什么时候停止)
            
            if(x+1 == c1) //tx_pin依赖rData,延时1个clk
            begin
                x <= x + BPS;
                tx_pin <= rData[index];
                index <= index + 1'b1;
            end
            
            if(c1 == BPS*10) //共需要BSP*10+1个clk
            begin
                c1 <= 16'd0;
                x <= 16'd0;
                index <= 4'd0;
            end
            else
                c1 <= c1 + 1'b1;
        end
    end
    
    
endmodule

