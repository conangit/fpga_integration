//显示标准800X600@60Hz
//VGA CLK 40MHz

/*
精确时序要求
HSYNC  128      88       800     40      (1056)
       3.2us    2.2us    20us    1us     26.4us

VSYNC  4        23       600     1       (628)
       105.6us  607.2us  15840us 26.4us  16579.2us
*/

module vga_sync
(
    input clk,
    input rst_n,
    output reg hsync,
    output reg vsync,
    output reg [10:0] c1,
    output reg [10:0] c2
);

    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            hsync <= 1'b1;
            vsync <= 1'b1;
            c1 <= 11'd0;
            c2 <= 11'd0;
        end
        else
        begin
            
            /*
            //alinx
            if(c1 == 1056) hsync <= 1'b0;
            else if(c1 == 128) hsync <= 1'b1;
            else if(c1 == 0) hsync <= 1'b0; //影响第一帧数据
            
            if(c2 == 628) vsync <= 1'b0;
            else if(c2 == 4) vsync <= 1'b1;
            else if(c2 == 0) vsync <= 1'b0; //影响第一帧数据
            
            if(c2 == 628) c2 <= 11'd1;
            else if(c1 == 1056) c2 <= c2 + 1'b1;
            
            if(c1 == 1056) c1 <= 11'd1;
            else c1 <= c1 + 1'b1;
            */
            
            
            //mine
            if(c1 == 0) hsync <= 1'b0;
            else if(c1 == 128) hsync <= 1'b1;
            else if(c1 == 1056) hsync <= 1'b0;
            
            if(c2 == 0) vsync <= 1'b0;
            else if(c2 == 4) vsync <= 1'b1;
            if(c2 == 628) vsync <= 1'b0;
            
            if(c2 == 628) c2 <= 11'd0;
            else if(c1 == 1056) c2 <= c2 + 1'b1;
            
            if(c1 == 1056) c1 <= 11'd1;
            else c1 <= c1 + 1'b1;
            
        end
    end
    
    
endmodule

