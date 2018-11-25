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
    reg [2:0] index_del;
    reg data_valid;
    reg data_valid_del_1;
    reg data_valid_del_2;
    
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
            rom_addr <= 11'd0;
            rgb <= 3'b000;
        end
        else
        begin
            
            /*
             * pipeline形式(只不过没有把每个步骤封装成流水线)
             */
            
            //step 0
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
            
            //step 1
            rom_addr <= ((y << 4) + (x >> 3));
            index <= x & 3'b111;
            data_valid_del_1 <= data_valid;
            
            //step2 -- output rom_data need 1 clk
            index_del <= index;
            data_valid_del_2 <= data_valid_del_1;
            
            //step3
            rgb <= data_valid_del_2 ? {rom_data[index_del], rom_data[index_del], rom_data[index_del]} : 3'b000;
            
        end
    end

endmodule

