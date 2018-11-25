module screen_control2
(
    input clk,
    input rst_n,
    output wr_en,
    output [10:0] wr_addr,
    output [7:0] wr_data
);

    reg [11:0] i;
    reg isWrite;
    reg [10:0] rAddr;
    reg [7:0] rData;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 12'd0;
            isWrite <= 1'b0;
            rAddr <= 11'd0;
            rData <= 8'd0;
        end
        else
        begin
            //绘制边框
            if(i <= 16 || i >= 2033 )
            begin
                
                isWrite <= 1'b1;
                rAddr <= i-1;
                rData <= 8'hff;
                
            end
            else
            begin
            
                if(((i-1)%16 == 0)) begin isWrite <= 1'b1; rAddr <= i-1; rData <= 8'h01; end
                else begin isWrite <= 1'b0; rData <= 8'h00; end
                
                if((i%16 == 0)) begin isWrite <= 1'b1; rAddr <= i-1; rData <= 8'h80; end
                else begin isWrite <= 1'b0; rData <= 8'h00; end
                
            end
            
            if(i == 2048) i <= 12'd0;
            else i <= i + 1'b1;
            
        end
    end
    
    /********************************************/
    
    assign wr_en = isWrite;
    assign wr_addr = rAddr;
    assign wr_data = rData;
    
    
endmodule

