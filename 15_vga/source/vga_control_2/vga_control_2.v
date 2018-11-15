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
    
    wire [2:0] index;
    wire [2:0] index_del;
    
    /*************************************************/
    reg data_valid_del_1;
    reg data_valid_del_2;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            data_valid_del_1 <= 1'b0;
            data_valid_del_2 <= 1'b0;
        end
        else
        begin
            data_valid_del_1 <= data_valid;
            data_valid_del_2 <= data_valid_del_1;
        end
    end
    
    /*************************************************/
    
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
    
    task2_module t2
    (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y),
        .rom_addr(rom_addr),
        .index(index)
    );
    
    //step2
    task3_module t3
    (
        .clk(clk),
        .rst_n(rst_n),
        .index_in(index),
        .index_out(index_del)
    );
    
    //step3
    task4_module t4
    (
        .clk(clk),
        .rst_n(rst_n),
        .rom_data(rom_data),
        .data_valid(data_valid_del_2),
        .index(index_del),
        .rgb(rgb)
    );

endmodule

