`timescale 1ns/1ps

module tx_module_tb();

    reg clk;
    reg rst_n;
    
    initial
    begin
        clk = 1;
        forever #10 clk = ~clk; //50MHz
    end
    
    initial
    begin
        rst_n = 0;
        #1000 rst_n = 1; //1us复位事件
    end
    
    /*****************/
    
    parameter BPS_50MHz_9600   = 13'd5208;
    parameter BPS_50MHz_115200 = 13'd434;
    parameter BPS_12MHz_9600   = 13'd1250;
    parameter BPS_12MHz_115200 = 13'd104;
    
    reg tx_en_sig;
    reg [7:0] tx_data;
    wire tx_pin;
    
    /*
    tx_module #(.BPS(BPS_50MHz_115200)) u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_pin(tx_pin)
    );
    */
    
    /*
    tx_module_2 #(.BPS(BPS_50MHz_115200)) u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_pin(tx_pin)
    );
    */
    
    
    wire tx_done;
    
    tx_module_3 #(.BPS(BPS_50MHz_115200)) u3
    (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_done(tx_done),
        .tx_pin(tx_pin)
    );
    
    
    /*****************/

    reg [3:0]i;
    reg [15:0] c1;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 4'd0;
            c1 <= 16'd0;
            tx_en_sig <= 1'b0;
            tx_data <= 8'd0;
        end
        else
        begin
            case(i)
                
                0:
                // if(c1 == BPS_50MHz_115200*10+2) //由于模块的耗时明确 这里使用clk代替了之前的done
                if(tx_done)
                begin
                    i <= i + 1'b1;
                    tx_en_sig <= 1'b0;
                    c1 <= 16'd0;
                end
                else
                begin
                    tx_en_sig <= 1'b1;
                    tx_data <= 8'h55;
                    c1 <= c1 + 1'b1;
                end
                
                1:
                // if(c1 == BPS_50MHz_115200*10+2)
                if(tx_done)
                begin
                    i <= i + 1'b1;
                    tx_en_sig <= 1'b0;
                    c1 <= 16'd0;
                end
                else
                begin
                    tx_en_sig <= 1'b1;
                    tx_data <= 8'hAA;
                    c1 <= c1 + 1'b1;
                end
                
                2:
                // if(c1 == BPS_50MHz_115200*10+2)
                if(tx_done)
                begin
                    i <= i + 1'b1;
                    tx_en_sig <= 1'b0;
                    c1 <= 16'd0;
                end
                else
                begin
                    tx_en_sig <= 1'b1;
                    tx_data <= 8'h3B;
                    c1 <= c1 + 1'b1;
                end
                
                3:
                    i <= 4'd3;
                
            endcase
        end
    end

endmodule
