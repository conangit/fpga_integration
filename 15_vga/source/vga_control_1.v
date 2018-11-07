module vga_control_1
(
    input clk,
    input rst_n,
    input [10:0] c1,
    input [10:0] c2,
    output reg [2:0]rgb,
    output reg [10:0] rom_addr,
    input [7:0] rom_data
);

    /**************************/
    
    //显示屏幕的大小和位置
    parameter _X = 8'd128;
    parameter _Y = 8'd128;
    parameter _XOFF = 10'd0;
    parameter _YOFF = 10'd0;
    
    /**************************/
    
    reg [6:0] x;
    reg [6:0] y;
    reg [2:0] index;
    reg data_valid;
    reg [2:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            x <= 7'd0;
            y <= 7'd0;
            index <= 3'd0;
            data_valid <= 1'b0;
            i <= 2'd0;
            rom_addr <= 11'd0;
            rgb <= 3'b000;
        end
        else
        begin
            case(i)
                
                0: //计算数据有效区
                if((c1 > (128+88+_XOFF) && c1 <= (128+88+_XOFF+_X)) &&
                    (c2 > (4+23+_YOFF) && c2 <= (4+23+_YOFF+_Y))) //数据有效区
                begin
                    x <= c1 - (128+88+_XOFF) - 1;    //0~127
                    y <= c2 - (4+23+_YOFF) - 1;      //0~127
                    data_valid <= 1'b1;
                    i <= i + 1'b1;
                end
                else
                begin //数据无效区,必须让屏幕保持"黑暗"
                    x <= 7'd0;
                    y <= 7'd0;
                    data_valid <= 1'b0;
                    i <= i + 1'b1;
                end
                
                1: //求得rom_addr和data[index]
                begin
                    rom_addr <= ((y << 4) + (x >> 3));
                    //16个0~7
                    index <= x & 3'b111;
                    i <= i + 1'b1;
                end
                
                2: //从rom取得数据需要1个clk
                    i <= i + 1'b1;
                
                3:
                begin
                    rgb <= data_valid ? {rom_data[index], rom_data[index], rom_data[index]} : 3'b000;
                    i <= 2'd0;
                end
                
            endcase
        end
    end

endmodule

/*
总结：
用步骤来处理VGA本身就是"错误的"
因为每个clk的到来c1,c2都更新
而每个c1,c2的更新应当都引起x,y的更新,引起rom_addr的更新,从而引起rgb的更新
本之上要求c1,c2的更新应该是无延时的影响到rom_addr,rgb
但在本实验中x,y的值将保留4个时钟,但每个时钟c1,c2是更新的,从而引起错误！
解决办法(由于步骤消耗了4个时钟--相比c1,c2输出,rgb的输出慢了3个clk)
--如果坚持用步骤写法,犹如《时序篇》提高本模块时钟为3倍(此时相当于c1,c2,rbg同步更新--但仍比hsync,vsync慢1个clk)
*/