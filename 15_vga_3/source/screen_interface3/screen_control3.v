module screen_control3
(
    input clk,
    input rst_n,
    output wr_en,
    output [10:0] wr_addr,
    output [7:0] wr_data
);

    
    reg [10:0] i;
    reg isWrite;
    reg [10:0] rAddr;
    reg [7:0] rData;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 11'd0;
            isWrite <= 1'b0;
            rAddr <= 11'd0;
            rData <= 8'd0;
        end
        else
        begin
            //绘制血条边框
            if( ((29<<4)+2 <= i && i <= (29<<4)+2+11) || ((38<<4)+2 <= i && i <= (38<<4)+2+11) )
            begin
                
                isWrite <= 1'b1;
                rAddr <= i;
                rData <= 8'hff;
                
            end
            else
            begin
                
                // if(i==(29<<4)+2+12 || i==(38<<4)+2+12 || i==(31<<4)+2+12 || i==(33<<4)+2+12 || i==(35<<4)+2+12 || i==(37<<4)++2+12) begin isWrite <= 1'b1; rAddr <= i; rData <= 8'h01; end
                if(i==(29<<4)+2+11 || i==(38<<4)+2+11 || i==(31<<4)+2+11 || i==(33<<4)+2+11 || i==(35<<4)+2+11 || i==(37<<4)++2+11) begin isWrite <= 1'b1; rAddr <= i; rData <= 8'h80; end
                else begin isWrite <= 1'b0; rData <= 8'h00; end
                
            end
            
            if(i == 2047) i <= 11'd0;
            else i <= i + 1'b1;
            
        end
    end
    
    
    /********************************************/
    
    /*
    // localparam XOFF=8'd15, YOFF=8'd22; //y=30 ~ 23
    localparam XOFF=8'd15, YOFF=8'd29; //y=30 ~ 37
    
    reg [4:0] i;
    reg [10:0] t1, t2;
    reg isWrite;
    reg [10:0] rAddr;
    reg [7:0] rData;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 5'd0;
            t1 <= 11'd0;
            t2 <= 11'd0;
            isWrite <= 1'b0;
            rAddr <= 11'd0;
            rData <= 8'd0;
        end
        else
        begin
            case(i)
                
                0: //上边框(y=22)
                begin
                    t1 <= (YOFF<<4) + (XOFF>>3) + 1;  //466
                    t2 <= (YOFF<<4) + (XOFF>>3) + 11; //477
                    i <= i + 1'b1;
                end
                
                1:
                if(t1 > t2) begin i <= i + 1'b1; rData <= 8'h00; isWrite <= 1'b0; end
                else begin t1 <= t1 + 1'b1; rAddr <= t1; rData <= 8'hff; isWrite <= 1'b1; end
                
                2,3,4,5,6,7,8,9,10,11: //左边框
                begin
                    rAddr<= ((YOFF+(i-2))<<4) + (XOFF>>3);
                    rData <= 8'h80;
                    isWrite <= 1'b1;
                    i <= i + 1'b1;
                end
                
                12,13,14,15,16,17,18,19,20,21: //右边框
                begin
                    rAddr<= ((YOFF+(i-12))<<4) + (XOFF>>3) + (11+1);
                    rData <= 8'h01;
                    isWrite <= 1'b1;
                    i <= i + 1'b1;
                end
                
                22: //下边框(y=21)
                begin
                    t1 <= ((YOFF+9)<<4) + (XOFF>>3) + 1;  //610
                    t2 <= ((YOFF+9)<<4) + (XOFF>>3) + 11; //621
                    i <= i + 1'b1;
                end
                
                23:
                if(t1 > t2) begin i <= i + 1'b1; rData <= 8'h00; isWrite <= 1'b0; end
                else begin t1 <= t1 + 1'b1; rAddr <= t1; rData <= 8'hff; isWrite <= 1'b1; end
                
                24:
                i <= 5'd0;
                
            endcase
        end
    end
    */
    
    
    /********************************************/
    
    assign wr_en = isWrite;
    assign wr_addr = rAddr;
    assign wr_data = rData;
    
    
endmodule

