module exp09_env
(
    input clk,
    input rst_n,
    
    input tx_en_sig,
    input [7:0] tx_data,
    output tx_done,
    
    input rx_en_sig,
    output rx_done,
    output [7:0] rx_data,

    output tx_pin,
    input rx_pin
);


    localparam BPS_50MHz_9600   = 13'd5208;
    localparam BPS_50MHz_115200 = 13'd434;
    localparam BPS_12MHz_9600   = 13'd1250;
    localparam BPS_12MHz_115200 = 13'd104;
    
    localparam BPS_20MHz_115200 = 13'd174;
    
    
    tx_module #(.BPS(BPS_12MHz_115200)) u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_done(tx_done),
        .tx_pin(tx_pin)
    );
    
    rx_module #(.BPS(BPS_12MHz_115200)) u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .rx_pin(rx_pin),
        .rx_en_sig(rx_en_sig),
        .rx_done(rx_done),
        .rx_data(rx_data)
    );
    
    
endmodule

