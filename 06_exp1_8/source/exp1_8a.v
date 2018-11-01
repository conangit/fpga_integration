/*
步骤循环

for(x = 0; x <10; x++)
{
    act2++;

    for(y = 0; y < 10; y++)
        act1 = act2;
}
*/

module exp1_8a
(
    input clk,
    input rst_n,
    
    output reg [7:0] c1, //完全使用步骤i,时钟计数c1没有用到
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] act1,
    output reg [7:0] act2,
    output reg [3:0] i
);

    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            c1 <= 8'd0;
            x <= 8'd0;
            y <= 8'd0;
            act1 <= 8'd0;
            act2 <= 8'd0;
            i <= 4'd0;
        end
        else
        begin
            
            case(i)
            
                0:
                if(x == 10)
                begin
                    x <= 8'd0;
                    i <= 4'd2;
                end
                else
                begin
                    act2 <= act2 + 1'b1;
                    x <= x + 1'b1;
                    i <= i + 1'b1;
                end
                
                1:
                if(y == 10)
                begin
                    y <= 8'd0;
                    i <= i - 1'b1;
                end
                else
                begin
                    act1 <= act2;
                    y <= y + 1'b1;
                end
                
                2:
                begin
                    act1 <= 8'd0;
                    act2 <= 8'd0;
                    i <= 4'd0;
                end
            
            endcase
        end
    end
    
endmodule

