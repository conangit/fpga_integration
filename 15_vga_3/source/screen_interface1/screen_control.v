module screen_control
(
    input clk,
    input rst_n,
    input [7:0] hp,
    input [7:0] maxhp,
    output wr_en,
    output [10:0] wr_addr,
    output [7:0] wr_data
);

    //采样hp和maxhp 检测两者的变化
    reg [7:0] f1, f2;
    reg [7:0] f3, f4;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            f1 <= 8'd0;
            f2 <= 8'd0;
            f3 <= 8'd0;
            f4 <= 8'd0;
        end
        else
        begin
            f1 <= hp;
            f2 <= f1;
            f3 <= maxhp;
            f4 <= f3;
        end
    end
    
    /********************************************/
    
    //hp显示位置
    localparam XOFF=8'd16, YOFF=8'd30;
    
    reg [4:0] i;
    reg [4:0] go;
    reg isWrite;
    reg [10:0] rAddr;
    reg [7:0] rData;
    reg [7:0] t1, t2, t3;
    reg [7:0] result;
    reg [15:0] temp;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 5'd0;
            go <= 5'd0;
            isWrite <= 1'b0;
            rAddr <= 11'd0;
            rData <= 8'd0;
            t1 <= 8'd0;
            t2 <= 8'd0;
            t3 <= 8'd0;
            result <= 8'd0;
            temp <= 16'd0;
        end
        else
        begin
            case(i)
            
                0:
                if(f1 != f2 || f3 != f4) begin t1 <= hp; t2 <= maxhp; t3 <= 8'd96; i <= i + 1'b1; end
                
                1: //传统乘法器 hp*96
                if(t3 == 0) i <= i + 1'b1;
                else begin temp <= temp + t1; t3 <= t3 - 1'b1; end
                
                2: //传统除法器 (hp*96)/maxhp
                if(temp < t2) i <= i + 1'b1;
                else begin temp <= temp - t2; result <= result + 1'b1; end
                
                /*
                 * 为什么是96？
                 * 显示空间为128*128, XOFF偏移了16,(同时收尾在减少16[血条对称设计]),那么x方向的显示范围即为128-16-16=96
                 * 也即满血状态位96
                 * 故通过步骤1和2将0~255空间映射到0~95
                 * 如hp=128,那么(hp/maxhp)*96=48,即(128/255)等价于(48/96),都为50%
                 */
                
                3,4,5,6,7,8,9,10: //绘制8行的hp血条
                // begin t1 <= result; t2 <= YOFF + (3-i); i<= 5'd12; go <= i + 1'b1; end
                begin t1 <= result; t2 <= {YOFF + (i-3)}[7:0]; i <= 5'd12; go <= i + 1'b1; end
                //t1表示的为0~95中需要的0~t1
                //t2表示要绘制的y行(0~7)共8行
                //t2 <= YOFF + (3-i);表示绘制为(y=30 ~ y=23)
                //t2 <= YOFF + (i-3);表示绘制为(y=30 ~ y=37)
                
                
                11:
                begin i <= 5'd0; end
                
                12,13,14,15,16,17,18,19,20,21,22,23: //绘制某一行血条
                begin
                    if(t1 >= 8) begin rData <= 8'hff; t1 <= t1 - 8; end
                    else if(t1 == 1) begin rData <= 8'b0000_0001; t1 <= 8'd0; end
                    else if(t1 == 2) begin rData <= 8'b0000_0011; t1 <= 8'd0; end
                    else if(t1 == 3) begin rData <= 8'b0000_0111; t1 <= 8'd0; end
                    else if(t1 == 4) begin rData <= 8'b0000_1111; t1 <= 8'd0; end
                    else if(t1 == 5) begin rData <= 8'b0001_1111; t1 <= 8'd0; end
                    else if(t1 == 6) begin rData <= 8'b0011_1111; t1 <= 8'd0; end
                    else if(t1 == 7) begin rData <= 8'b0111_1111; t1 <= 8'd0; end
                    else rData <= 8'd0;
                    
                    isWrite <= 1'b1;
                    rAddr <= {(t2<<4) + (XOFF>>3) + (i-12)}[10:0]; //ram_addr=y*16+x/8, ((i-12))表示对i的偏移
                    i <= i + 1'b1;
                end
                
                24:
                begin isWrite <= 1'b0; i <= go; end
                
            endcase
        end
    end
    
    /********************************************/
    
    assign wr_en = isWrite;
    assign wr_addr = rAddr;
    assign wr_data = rData;
    
endmodule

