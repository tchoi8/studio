 module pwm #(parameter CTR_LEN = 8) (
    input clk,
    input rst,
    input [CTR_LEN - 1 : 0] compare,
    output pwm
);
 
reg pwm_d, pwm_q;
reg [CTR_LEN - 1: 0] ctr_d, ctr_q;
 
assign pwm = pwm_q;
 
always @(*) begin
    ctr_d = ctr_q + 1'b1;
 
    if (compare > ctr_q)
        pwm_d = 1'b1;
    else
        pwm_d = 1'b0;
end
 
always @(posedge clk) begin
    if (rst) begin
        ctr_q <= 1'b0;
    end else begin
        ctr_q <= ctr_d;
    end
 
    pwm_q <= pwm_d;
end
 
endmodule










/*module counter (clk, reset, enable, count);  
input clk, reset, enable;
output [3:0] count;
reg [3:0] count; 

always @ (posedge clk)
if (reset == 1'b1) begin
	count <= 0;
end else if (enable == 1'b1) begin
	count <= count+1; 
end 

endmodule 

*/