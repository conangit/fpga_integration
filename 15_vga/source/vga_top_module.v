

module vga_top_module
(
    input clk,
    input rst_n,
    output VSYNC_Sig,
    output HSYNC_Sig,
    output [4:0] Red_Sig,
    output [5:0] Green_Sig,
    output [4:0] Blue_Sig
);
    
    wire clk_40MHz;
    wire clk_120MHz;
    
    pll_ip pll
    (
        .CLK_IN1(clk),
        .CLK_OUT1(clk_40MHz),
        .CLK_OUT2(clk_120MHz),
        .RESET(~rst_n)
    );
    
    
    wire [2:0] rgb;
    
    vga_module vga
    (
        .clk(clk_40MHz),
        .clk_3x(clk_120MHz),
        .rst_n(rst_n),
        .hsync(HSYNC_Sig),
        .vsync(VSYNC_Sig),
        .rgb(rgb)
    );
    
    assign Red_Sig   = {5{rgb[2]}};
    assign Green_Sig = {6{rgb[1]}};
    assign Blue_Sig  = {5{rgb[0]}};
    
    
    
endmodule


