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
    reg [2:0] index, index_del;
    reg data_valid, data_valid_del_1, data_valid_del_2;
    reg [2:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            x <= 7'd0;
            y <= 7'd0;
            index <= 3'd0;
            index_del <= 3'd0;
            data_valid <= 1'b0;
            data_valid_del_1 <= 1'b0;
            data_valid_del_2 <= 1'b0;
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
                    data_valid_del_1 <= data_valid;
                    i <= i + 1'b1;
                end
                
                2: //从rom取得数据需要1个clk
                begin
                    index_del <= index;
                    data_valid_del_2 <= data_valid_del_1;
                    i <= i + 1'b1;
                end
                
                3:
                begin
                    rgb <= data_valid_del_2 ? {rom_data[index_del], rom_data[index_del], rom_data[index_del]} : 3'b000;
                    i <= 2'd0;
                end
                
            endcase
        end
    end

endmodule

/*
<1>总结：
相同的VGA时钟下,用步骤来处理VGA本身就是"错误的"
因为每个clk的到来c1,c2都更新
而每个c1,c2的更新应当都引起x,y的更新,引起rom_addr的更新,从而引起rgb的更新
即本质上要求c1,c2的更新应该是无延时的影响到rgb(c1,c2与rgb数据同步)
但在本实验中x,y的值将保留4个时钟,但每个时钟c1,c2是更新的,从而引起错误！
<2>解决办法:
(由于本模块步骤消耗了4个时钟--相比c1,c2输出,rgb的输出慢了3个clk)
如果用步骤写法,犹如《时序篇》则应提高本模块时钟为(3+1)倍(此时相当于c1,c2,rbg同步更新)
<3>注意:
模块沟通需要消耗1个clk
*/

/*
同时也注意在同一模块中,注意各个信号之间的同步关系
rgb --> rom_data
rgb --> --> index
rgb --> --> --> data_valid
*/

