module detect_module
(
    input clk,
    input rst_n,
    input pin_in,
    output h2l_sig,
    output l2h_sig,
    
    /************/
    output sq_f1,
    output sq_f2
    /************/
);

    reg f1;
    reg f2;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            f1 <= 1'b1;
            f2 <= 1'b1;
        end
        else
        begin
            f1 <= pin_in;
            f2 <= f1;
        end
    end
    
    assign h2l_sig = f2 && !f1;
    assign l2h_sig = !f2 && f1;
    
    assign sq_f1 = f1;
    assign sq_f2 = f2;
    
endmodule

