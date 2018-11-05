`timescale 1ns/1ps


module exp09_env_tb();

    reg clk;
    reg rst_n;
    
    initial
    begin
        clk = 1;
        forever #25 clk = ~clk; //20MHz
    end
    
    initial
    begin
        rst_n = 0;
        #1000 rst_n = 1;
    end
    
    /*************************/
    
    reg tx_en_sig;
    reg [7:0] tx_data;
    wire tx_done;
    
    reg rx_en_sig;
    wire rx_done;
    wire [7:0] rx_data;
    
    wire pin;
    
    exp09_env u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_done(tx_done),
        .rx_en_sig(rx_en_sig),
        .rx_done(rx_done),
        .rx_data(rx_data),
        .sq_pin(pin)
    );
    
    /*************************/
    
    reg [3:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 4'd0;
            tx_en_sig <= 1'b0;
            tx_data <= 8'd0;
            rx_en_sig <= 1'b0;
        end
        else
        begin
            case(i)
            
                0:
                begin rx_en_sig <= 1'b1; i <= i + 1'b1; end
                
                1:
                if(tx_done) begin tx_en_sig <= 1'b0; i <= i + 1'b1; end
                else begin tx_data <= 8'h55; tx_en_sig <= 1'b1; end
                
                2:
                if(rx_done) begin rx_en_sig <= 1'b0; i <= i + 1'b1; end
                
                3:
                    i <= i;
            
            endcase
        end
    end
    
endmodule
