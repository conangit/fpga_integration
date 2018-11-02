
module tx_module_real
(
    input clk,
    input rst_n,
    output tx_pin
);

    parameter BPS_50MHz_9600   = 13'd5208;
    parameter BPS_50MHz_115200 = 13'd434;
    parameter BPS_12MHz_9600   = 13'd1250;
    parameter BPS_12MHz_115200 = 13'd104;
    
    
    reg tx_en_sig;
    reg [7:0] tx_data;
    wire tx_done;
    
    
    tx_module_3 #(.BPS(BPS_12MHz_115200)) u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_done(tx_done),
        .tx_pin(tx_pin)
    );
    
    
    /*************************/

    reg [3:0]i;

    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 4'd0;
            tx_en_sig <= 1'b0;
            tx_data <= 8'd0;
        end
        else
        begin
            case(i)
                
                0:
                if(tx_done) begin
                    i <= i + 1'b1;
                    tx_en_sig <= 1'b0;
                end
                else begin
                    tx_en_sig <= 1'b1;
                    tx_data <= 8'h55;
                end
                
                1:
                if(tx_done) begin
                    i <= i + 1'b1;
                    tx_en_sig <= 1'b0;
                end
                else begin
                    tx_en_sig <= 1'b1;
                    tx_data <= 8'hAA;
                end
                
                2:
                if(tx_done) begin
                    i <= i + 1'b1;
                    tx_en_sig <= 1'b0;
                end
                else begin
                    tx_en_sig <= 1'b1;
                    tx_data <= 8'hBF;
                end
                
                3:
                    i <= 4'd3;
                
            endcase
        end
    end

endmodule
