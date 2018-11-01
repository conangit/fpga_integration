module clb_module
(
    input clk,
    input rst_n,
    
    output q,
    
    output [4:0] sq_c1,
    output [1:0] sq_i
);

    reg [1:0] i;
    reg [4:0] c1;
    reg rQ;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 2'd0;
            c1 <= 5'd0;
            rQ <= 1'b0;
        end
        else
        begin
            case(i)
            
                0:
                if(c1 == 10-1)
                begin
                    c1 <= 5'd0;
                    i <= 1;
                end
                else
                begin
                    c1 <= c1 + 1'b1;
                    rQ <= 1'b1;
                end
                
                1:
                if(c1 == 10-1)
                begin
                    c1 <= 5'd0;
                    i <= 2;
                end
                else
                begin
                    c1 <= c1 + 1'b1;
                    rQ <= 1'b0;
                end
                
                2:
                if(c1 == 10-1)
                begin
                    c1 <= 5'd0;
                    i <= 3;
                end
                else
                begin
                    c1 <= c1 + 1'b1;
                    rQ <= 1'b1;
                end
                
                3:
                if(c1 == 10-1)
                begin
                    c1 <= 5'd0;
                    i <= 0;
                end
                else
                begin
                    c1 <= c1 + 1'b1;
                    rQ <= 1'b0;
                end
            
            endcase
        end
    end
    
    assign q = rQ;
    
    assign sq_i = i;
    assign sq_c1 = c1;
    
endmodule

