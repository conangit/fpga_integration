`timescale 1ps/1ps

module exp_tb();

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
        #1000 rst_n = 1;
    end
    
    /*************************/
    
    /*
    exp_without_en u1
    (
        .clk(clk),
        .rst_n(rst_n)
    );
    */
    
    /*
    exp_with_en u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(1'b1)
    );
    */
    
    
    
    reg start_sig;
    
    exp_with_en u3
    (
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig)
    );
    
    reg [3:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 4'd0;
            start_sig <= 1'b0;
        end
        else
        begin
            case(i)
            
                0:
                begin
                    start_sig <= 1'b1;
                    i <= 0;
                end
                
            endcase
        end
    end
    
    
    
endmodule

