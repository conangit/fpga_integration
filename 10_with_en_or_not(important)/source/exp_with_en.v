module exp_with_en
(
    input clk,
    input rst_n,
    
    input start_sig
);

    reg [3:0] c1;
    reg en;
    reg [1:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            c1 <= 4'd0;
            en <= 1'b0;
            i <= 2'd0;
        end
        else if(start_sig)
        begin
            case(i)
                
                
                0:
                if(c1 == 10-1) begin  c1 <= 4'd0; en <= 1'b0; i <= i + 1'b1; end
                else begin c1 <= c1 + 1'b1; en <= 1'b1; end
                
                /*
                0,1:
                if(c1 == 10-1) begin  c1 <= 4'd0; en <= 1'b0; i <= i + 1'b1; end
                else begin c1 <= c1 + 1'b1; en <= 1'b1; end
                */
                
                1:
                begin i <= 2'd0; end
                
            endcase
        end
    end
    
endmodule

