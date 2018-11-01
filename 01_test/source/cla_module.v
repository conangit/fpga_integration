module cla_module
(
    input clk,
    input rst_n,
    
    output q,
    
    output [4:0] sq_c1,
    output [1:0] sq_i
);

    reg [4:0] c1;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            c1 <= 5'd0;
        else if(c1 == 10-1)
            c1 <= 5'd0;
        else
            c1 <= c1 + 1'b1;
    end
    
    
    reg [1:0] i;
    reg rQ;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 2'd0;
            rQ <= 1'b0;
        end
        else
        begin
            case(i)
            
                0:
                if(c1 == 10-1)
                    i <= i + 1'b1;
                else
                    rQ <= 1'b1;
                    
                1:
                if(c1 == 10-1)
                    i <= i + 1'b1;
                else
                    rQ <= 1'b0;
                    
                2:
                if(c1 == 10-1)
                    i <= i + 1'b1;
                else
                    rQ <= 1'b1;
                    
                3:
                if(c1 == 10-1)
                    i <= 2'd0;
                else
                    rQ <= 1'b0;
            endcase
        end
    end
    
    assign q = rQ;
    
    assign sq_i = i;
    assign sq_c1 = c1;
    
endmodule

