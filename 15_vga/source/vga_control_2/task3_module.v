//ROM模块的输出需要1个clk
//task4根据rom_data和index输出rgb信号,故index需要延时1个clk

module task3_module
(
    input clk,
    input rst_n,
    input [2:0] index_in,
    output reg [2:0] index_out
);
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            index_out <= 3'd0;
        else
            index_out <= index_in;
    end
    
endmodule

