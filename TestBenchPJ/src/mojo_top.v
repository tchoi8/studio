module basic_and #(parameter WIDTH = 1)(
	input [WIDTH-1:0] a,
	input [WIDTH-1:0] b,
	output [WIDTH-1:0] out
	);
	
	assign out =a & b;
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