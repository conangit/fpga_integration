

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
    
    pll_ip u0
    (
        .CLK_IN1(clk),
        .CLK_OUT1(clk_40MHz),
        .RESET(~rst_n)
    );
    
    wire u1_hsync;
    wire u1_vsync;
    wire [10:0] c1;
    wire [10:0] c2;
    
    vga_sync u1
    (
        .clk(clk_40MHz),
        .rst_n(rst_n),
        .hsync(u1_hsync),
        .vsync(u1_vsync),
        .c1(c1),
        .c2(c2)
    );
    
    wire [2:0] u2_rgb;
    
    screen_module u2
    (
        .clk(clk_40MHz),
        .rst_n(rst_n),
        .c1(c1),
        .c2(c2),
        .rgb(u2_rgb)
    );
    
    //绘制血条
    wire [2:0] u3_rgb;
    
    screen_interface1 u3
    (
        .clk(clk_40MHz),
        .rst_n(rst_n),
        .c1(c1),
        .c2(c2),
        // .hp(8'd64),
        // .hp(8'd128),
        .hp(8'd192),
        // .hp(8'd255),
        .maxhp(8'd255),
        .rgb(u3_rgb)
    );
    
    //绘制边框
    wire [2:0] u4_rgb;
    
    screen_interface2 u4
    (
        .clk(clk_40MHz),
        .rst_n(rst_n),
        .c1(c1),
        .c2(c2),
        .rgb(u4_rgb)
    );
    
    
    //绘制血条边框
    wire [2:0] u5_rgb;
    
    screen_interface3 u5
    (
        .clk(clk_40MHz),
        .rst_n(rst_n),
        .c1(c1),
        .c2(c2),
        .rgb(u5_rgb)
    );
    
    /**********************************************/
    
    reg hsync;
    reg vsync;
    
    /* 注意此处的clk信号 */
    always @(posedge clk_40MHz or negedge rst_n)
    begin
        if(~rst_n)
        begin
            hsync <= 1'b1;
            vsync <= 1'b1;
        end
        else
        begin
            hsync <= u1_hsync;
            vsync <= u1_vsync;
        end
    end
    
    /**********************************************/
    
    wire [2:0] rgb = u2_rgb | u3_rgb | u4_rgb | u5_rgb;
    
    assign HSYNC_Sig = hsync;
    assign VSYNC_Sig = vsync;
    
    //黄色皮卡丘
    assign Red_Sig   = {5{rgb[2]}};
    assign Green_Sig = {6{rgb[1]}};
    assign Blue_Sig  = {5{rgb[0]}};
    // assign Blue_Sig  = {5{1'b0}};
    
    
    
endmodule


