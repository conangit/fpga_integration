module control_module
(
    input clk,
    input rst_n,
    
    input start_sig,
    output reg done_sig,
    
    output reg [3:0] rom_addr,
    output reg write_en,
    output reg [3:0] ram_addr
);


    reg [4:0] c1;
    reg [4:0] x;
    reg [4:0] y;
    reg [1:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 2'd0;
            c1 <= 5'd0;
            x <= 5'd0;
            y <= 5'd0;
            done_sig <= 1'b0;
            rom_addr <= 4'd0;
            write_en <= 1'b0;
            ram_addr <= 4'd0;
        end
        else if(start_sig)
        begin
            case(i)
                 
                 //由于rom_data的输出需要1个clk,故rom_addr超前ram_addr和write_en 1个clk
                 //注意这里有一层隐含的含义:rom_addr取得的是x的过去值,ram_addr取得的是y的过去值
                 //c1=16,即y=15时,ram_addr=14,下一个clk,y=0,ram_addr=15,此时间段write_en必须还是有效的
                 //故write_en不在c1=16时刻决定拉低(即y=15到0后,write_en还必须有效)
                0:
                begin
                
                if(x == c1) begin x <= x + 1'b1; rom_addr <= x; end
                
                if(y+1 == c1) begin y <= y + 1'b1; ram_addr <= y; write_en <= 1'b1; end
                
                if(c1 == 16) begin c1 <= 5'd0; x <= 5'd0; y <= 5'd0; i <= i + 1'b1; end
                else begin c1 <= c1 + 1'b1; end
                
                end
                
                1:
                begin write_en <= 1'b0; i <= i + 1'b1; end //注意write_en信号的拉低时间
                
                2:
                begin done_sig <= 1'b1; i <= i + 1'b1; end
                
                3:
                begin done_sig <= 1'b0; i <= 2'd0; end
            
            endcase
        end
    end
    
    
    
endmodule

