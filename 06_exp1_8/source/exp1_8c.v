/*
时序循环

for(x = 0; x <10; x++)
{
    act2++;

    for(y = 0; y < 10; y++)
        act1 = act2;
}
*/

module exp1_8c
(
    input clk,
    input rst_n,
    
    output reg [7:0] c1,
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
                begin
                    if(x == c1)
                    begin
                        x <= x + 8'd10;
                        // act2 <= (x != 101-1) ? act2 + 1'b1 : act2; //控制act2什么时候递增,什么时候停止
                        act2 <= act2 + 1'b1;
                    end
                    
                    if(y+1 == c1)
                    begin
                        y <= y + 1'b1;
                        act1 <= act2;
                    end
                    
                    if(c1 == 101-1)
                    begin
                        i <= 4'd1;
                        c1 <= 8'd0;
                        x <= 8'd0;
                        y <= 8'd0;
                    end
                    else
                        c1 <= c1 + 1'b1;
                end
                
                1:
                begin
                    act1 <= 8'd0;
                    act2 <= 8'd0;
                    i <= 4'd0;
                end
                
            endcase
        end
    end
    
endmodule

