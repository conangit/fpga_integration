/*
C: 循环嵌套,两种动作

for(x = 0; x < 10; x++)
{
    act1++;
    
    for(y = 0; y < 10; y ++)
        act2++;
}
*/


module exp1_6c
(
    input clk,
    input rst_n,

    output reg [7:0] c1,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] act1,
    output reg [7:0] act2,
    output reg [1:0] i
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
            i <= 2'd0;
        end
        else
        begin
            case(i)
            
                
                0:
                begin
                
                    if(x == c1)
                    begin
                        x <= x + 8'd10;
                        act1 <= act1 + 1'b1;
                    end
                    
                    if(y == c1)
                    begin
                        y <= y + 1'b1;
                        act2 <= act2 + 1'b1;
                    end
                    
                    if(c1 == 100-1)
                    begin
                        c1 <= 8'd0;
                        x <= 8'd0;
                        y <= 8'd0;
                        i <= i + 1'b1;
                    end
                    else
                        c1 <= c1 + 1'b1;
                
                end
                    
                1:
                 begin
                    act1 <= 8'd0;
                    act2 <= 8'd0;
                    i <= 0;
                end
                
            endcase
        end
    end
    
    
endmodule

