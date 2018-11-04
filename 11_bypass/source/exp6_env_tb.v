`timescale 1ps/1ps

module exp6_env_tb();

    reg clk;
    reg rst_n;
    
    initial
    begin
        clk = 1;
        forever #5 clk = ~clk;
    end
    
    initial
    begin
        rst_n = 0;
        #1000 rst_n = 1;
    end
    
    /*************************/
    
    reg start_sig;
    wire done_sig;
    wire write_en;
    wire [3:0] ram_addr;
    wire [7:0] rom_data;

    exp6_env u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .done_sig(done_sig),
        .write_en(write_en),
        .ram_addr(ram_addr),
        .rom_data(rom_data)
    );
    
    reg [3:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 4'd0;
            start_sig <= 1'b0;
        end
        else
        begin
            case(i)
            
                0:
                if(done_sig) begin start_sig <= 1'b0; i <= i + 1'b1; end
                else begin start_sig <= 1'b1; end
                
                1:
                    i <= 0;
                
            endcase
        end
    end

endmodule

