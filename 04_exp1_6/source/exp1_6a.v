/*
C: 循环嵌套,一种动作

for(x = 0; x < 10; x++)
    for(y = 0; y < 10; y ++)
        act++;
*/


module exp1_6a
(
    input clk,
    input rst_n,

    output reg [7:0] c1,
    output reg [7:0] x,
    output reg [7:0] act,
    output reg [1:0] i
);

    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            c1 <= 8'd0;
            x <= 8'd0;
            act <= 8'd0;
            i <= 2'd0;
        end
        else
        begin
            case(i)
            
                
                0:
                begin
                
                    if(x == c1)
                    begin
                        x <= x + 1'b1;
                        act <= act + 1'b1;
                    end
                    
                    if(c1 == 100-1)
                    begin
                        c1 <= 8'd0;
                        x <= 8'd0;
                        i <= i + 1'b1;
                    end
                    else
                        c1 <= c1 + 1'b1;
                
                end
                    
                1:
                 begin
                    act <= 8'd0;
                    i <= 0;
                end
                
                /*
                0:
                begin
                
                    if(x == c1)
                    begin
                        x <= x + 1'b1;
                        act <= act + 1'b1;
                    end
                    
                    if(c1 == 100-1)
                    begin
                        // act <= 8'd0; //将计数到99
                        c1 <= 8'd0;
                        x <= 8'd0;
                        i <= 0;
                    end
                    else
                        c1 <= c1 + 1'b1;
                
                end
                */
                
            endcase
        end
    end
    
   
endmodule

