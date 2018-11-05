`timescale 1ps/1ps

module exp2_4a_tb();

    reg clk;
    reg rst_n;
    
    initial
    begin
        clk = 1;
        forever #5 clk = ~clk;
    end
    
    initial
    begin
        rst_n = 0;
        #10 rst_n = 1;
    end
    
    /*************************/
    
    reg pin_in;
    reg [3:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 4'd0;
            pin_in <= 1'b1;
        end
        else
        begin
            case(i)
                
                0,1:
                begin pin_in <= 1'b1; i <= i + 1'b1; end
                
                2,3:
                begin pin_in <= 1'b0; i <= i + 1'b1; end
                
                4,5:
                begin pin_in <= 1'b1; i <= i + 1'b1; end
                
                6,7:
                begin pin_in <= 1'b0; i <= i + 1'b1; end
                
                8,9:
                begin pin_in <= 1'b1; i <= i + 1'b1; end
                
                10:
                begin pin_in <= 1'b0; i <= 10; end
                
            endcase
        end
    end

    /*************************/
    
    reg f1;
    reg f2;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            f1 <= 1'b1;
            f2 <= 1'b1;
        end
        else
        begin
            f1 <= pin_in;
            f2 <= f1;
        end
    end
    
    wire h2l_sig = f2 && !f1;
    wire l2h_sig = !f2 && f1;
    
    /*************************/
    
    reg [3:0] j;
    reg [1:0] q;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            j <= 4'd0;
            q <= 2'd0;
        end
        else
        begin
            case(j)
            
                0:
                if(h2l_sig) begin q <= 2'd1; j <= j + 1'b1; end
                
                1:
                if(l2h_sig) begin q <= 2'd2; j <= j + 1'b1; end
                
                2:
                if(f2 == 1 && f1 == 0) begin q <= 2'd3; j <= j + 1'b1; end
                
                3:
                if(f2 == 0 && f1 == 1) begin q <= 2'd0; j <= j + 1'b1; end
                
                4:
                    j <= j;
            
            endcase
        end
    end
    
    
endmodule

