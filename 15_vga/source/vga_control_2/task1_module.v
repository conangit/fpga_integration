module task1_module
(
    input clk,
    input rst_n,
    input [10:0] c1,
    input [10:0] c2,
    output reg [6:0] x,
    output reg [6:0] y,
    output reg data_valid
);


    /**************************/
    
    //显示屏幕的大小和位置
    parameter _X = 8'd128;
    parameter _Y = 8'd128;
    parameter _XOFF = 10'd0;
    parameter _YOFF = 10'd0;
    
    /**************************/
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            x <= 7'd0;
            y <= 7'd0;
            data_valid <= 1'b0;
        end
        else
        begin
            if((c1 > (128+88+_XOFF) && c1 <= (128+88+_XOFF+_X)) &&
                (c2 > (4+23+_YOFF) && c2 <= (4+23+_YOFF+_Y))) //数据有效区
            begin
                x <= c1 - (128+88+_XOFF) - 1;    //0~127
                y <= c2 - (4+23+_YOFF) - 1;      //0~127
                data_valid <= 1'b1;
            end
            else
            begin //数据无效区,必须让屏幕保持"黑暗"
                x <= 7'd0;
                y <= 7'd0;
                data_valid <= 1'b0;
            end
        end
    end
    
    
endmodule

