module vga_control_2
(
    input clk,
    input rst_n,
    input [10:0] c1,
    input [10:0] c2,
    output [2:0] rgb,
    output [10:0] rom_addr,
    input [7:0] rom_data
);
    
    wire [6:0] x;
    wire [6:0] y;
    wire data_valid;
    
    //step0
    task1_module t1
    (
        .clk(clk),
        .rst_n(rst_n),
        .c1(c1),
        .c2(c2),
        .x(x),
        .y(y),
        .data_valid(data_valid)
    );
    
    //step1
    wire [2:0] index;
    
    task2_module t2
    (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y),
        .data_valid(data_valid),
        .rom_addr(rom_addr),
        .index(index)
    );
    
    //step2
    //相比vga_control_2,这里没有step2
    //故task2_module的输出应该延时1个clk
    
    //step3
    task3_module t3
    (
        .clk(clk),
        .rst_n(rst_n),
        .rom_data(rom_data),
        .data_valid(data_valid),
        .index(index),
        .rgb(rgb)
    );

endmodule

