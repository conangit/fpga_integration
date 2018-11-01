module c2a_module
(
    input clk,
    input rst_n,
    
    output q,
    
    output [4:0] sq_c2,
    output [1:0] sq_i
);

    reg [1:0] i;
    reg [4:0] c2;
    reg rq;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 2'd0;
            c2 <= 5'd0;
            rq <= 1'b0;
        end
        else
        begin
            case(i)
            
                0:
                if(c2 == 10) begin c2 <= 5'd0; i <= i + 1'b1; end
                else begin rq <= 1'b1; c2 <= c2 + 1'b1; end
                
                1:
                if(c2 == 10) begin c2 <= 5'd0; i <= i + 1'b1; end
                else begin rq <= 1'b0; c2 <= c2 + 1'b1; end
                
                2:
                if(c2 == 10) begin c2 <= 5'd0; i <= i + 1'b1; end
                else begin rq <= 1'b1; c2 <= c2 + 1'b1; end
                
                3:
                if(c2 == 10) begin c2 <= 5'd0; i <= 2'd0; end
                else begin rq <= 1'b0; c2 <= c2 + 1'b1; end
                
            endcase
        end
    
    end
    
    assign q = rq;
    assign sq_c2 = c2;
    assign sq_i = i;
    
    
endmodule

