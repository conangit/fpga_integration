module exp1_5
(
    input clk,
    input rst_n,
    
    output [7:0] sq_c1,
    output [7:0] sq_x,
    output [1:0] sq_i,
    output [7:0] sq_act
);
    
    reg [7:0] c1;
    reg [7:0] x;
    reg [1:0] i;
    reg [7:0] act;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            c1 <= 8'd0;
            x <= 8'd0;
            i <= 2'd0;
            act <= 8'd0;
        end
        else
        begin
            case(i)
                
                0:
                begin
                    
                    if(x == c1)
                    begin
                        x <= x + 1'b1;          //t9时刻
                        act <= act + 1'b1;
                    end
                    
                    if(c1 == 10-1) //步骤许10个时钟,且在t9到来清零x和c1
                    begin
                        x <= 8'd0;              //t9时刻
                        c1 <= 8'd0;
                        i <= i + 1'b1;
                    end
                    else
                        c1 <= c1 + 1'b1;
                    
                end
                
                1:
                begin
                    i <= 2'd0;
                    c1 <= 8'd10;
                    x <= 8'd20;
                    act <= 8'd30;
                end
                
            endcase
        end
    end

    assign sq_c1 = c1;
    assign sq_x = x;
    assign sq_act = act;
    assign sq_i = i;
    
endmodule

