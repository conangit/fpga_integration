module tx_module_before
#(parameter BPS_CLK = 13'd433)
(
    clk,
    rst_n,
    tx_en_sig,
    tx_data,
    tx_done,
    tx_pin
);
    
    input clk;
    input rst_n;
    
    input tx_en_sig;
    input [7:0]tx_data;
    
    output tx_done;
    output tx_pin;
    
    /***********************/
    /*
    parameter BPS_50MHz_9600   = 13'd5207;
    parameter BPS_50MHz_115200 = 13'd433;
    parameter BPS_12MHz_9600   = 13'd1249;
    parameter BPS_12MHz_115200 = 13'd103;
    */
    
    wire tx_bps_clk;

    tx_bps_module #(.BPS(BPS_CLK)) u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .tx_count_sig(tx_en_sig),
        .tx_bps_clk(tx_bps_clk)
    );
    
    tx_control_module u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_bps_clk(tx_bps_clk),
        .tx_done(tx_done),
        .tx_pin(tx_pin)
    );

endmodule

