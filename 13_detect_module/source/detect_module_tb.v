`timescale 1ps/1ps

module detect_module_tb();

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

    reg pin_in;
    wire h2l_sig;
    wire l2h_sig;
    wire sq_f1;
    wire sq_f2;

    detect_module u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .pin_in(pin_in),
        .h2l_sig(h2l_sig),
        .l2h_sig(l2h_sig),
        /************/
        .sq_f1(sq_f1),
        .sq_f2(sq_f2)
        /************/
    );

    /*************************/
    
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
                
                2:
                begin pin_in <= 1'b0; i <= i + 1'b1; end
                
                3,4:
                begin i <= i + 1'b1; end
                
                5:
                begin pin_in <= 1'b1; i <= 5; end
                
            endcase
        end
    end

    
endmodule

