module rx_module
#(parameter BPS = 13'd434)
(
    clk,
    rst_n,
    rx_pin,
    rx_en_sig,
    rx_done,
    rx_data
);

    input clk;
    input rst_n;
    input rx_pin;
    input rx_en_sig;
    output reg rx_done;
    output reg [7:0] rx_data;
    
    /******************/
    wire [7:0] sq_c1;
    wire sq_f1;
    wire sq_f2;
    /******************/

    /***********************/
    
    reg f1;
    reg f2;
    
    //将异步信号同化
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            f1 <= 1'b1;
            f2 <= 1'b1;
        end
        else
        begin
            f1 <= rx_pin;
            f2 <= f1;
        end
    end
    
    /***********************/
    /*
    //每个bit所占用的clk个数
    localparam BPS_50MHz_9600   = 13'd5208;
    localparam BPS_50MHz_115200 = 13'd434;
    localparam BPS_12MHz_9600   = 13'd1250;
    localparam BPS_12MHz_115200 = 13'd104;
    */
    /***********************/
    
    
    reg [3:0] i;
    reg [7:0] c1;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 4'd0;
            c1 <= 8'd0;
            rx_data <= 8'd0;
            rx_done <= 1'b0;
        end
        else if(rx_en_sig)
        begin
            case(i)
            
                0:
                if(f2 == 1'b0) begin i <= i + 1'b1; c1 <= c1 + 8'd2; end
                
                1: //start
                if(c1 == BPS-1) begin c1 <= 8'd0; i <= i + 1'b1; end
                else c1 <= c1 + 1'b1;
                
                2,3,4,5,6,7,8,9: //data
                begin
                    if(c1 == BPS>>1) rx_data[i-2] <= f2; //LSB
                    if(c1 == BPS-1) begin c1 <= 8'd0; i <= i + 1'b1; end
                    else c1 <= c1 + 1'b1;
                end
                
                10: //stop
                if(c1 == BPS-1) begin c1 <= 8'd0; i <= i + 1'b1; end
                else c1 <= c1 + 1'b1;
                
                11:
                begin rx_done <= 1'b1; i <= i + 1'b1; end
                
                12:
                begin rx_done <= 1'b0; i <= 4'd0; end
            
            endcase
        end
    end
    
    
    assign sq_c1 = c1;
    assign sq_f1 = f1;
    assign sq_f2 = f2;

endmodule

