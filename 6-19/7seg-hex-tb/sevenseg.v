module sevenseg(
    
	 input wire clk, reset, 
	 input wire [3:0] hex3, hex2, hex1, hex0,
	 input wire [3:0] dp_in,
	 
	 output reg [3:0] an,
	 output reg [7:0] sseg
	 );
	 

localparam N = 18;
//internal signal declaration
reg [N-1:0] q_reg; 
wire [N-1:0] q_next;
reg [3:0] hex_in;
reg dp;



//N-bit counter
always @(posedge clk, posedge reset)
	if (reset)
		q_reg <= 0;
	else 
		q_reg <= q_next;
		
	//	next state logic 
		assign q_next = q_reg + 1;
  

 //2 MSBs of counter to control 4 to 1 mux and generate active low ensable signal 
always @(*)
	case (q_reg[N-1:N-2])
		2'b00:
			begin
				an = 4'b1110;
				hex_in = hex0;
				dp = dp_in[0];
			end
		2'b01:
			begin 
				an = 4'b1101;
				hex_in = hex1;
				dp = dp_in[1];
			end
		2'b10:
			begin
				an = 4'b1011;
				hex_in = hex2;
				dp = dp_in[2];
			end
		default:
			begin
				an=4'b0111;
				hex_in = hex3;
				dp = dp_in[3];
			end
		endcase
		 
always @(*)
 begin
case(hex_in)
 
  4'h0: sseg[6:0] = 7'b0000001; // 1111111 => 0
    4'h1: sseg[6:0] = 7'b1001111; // 0110000 => 1 
    4'h2: sseg[6:0] = 7'b0010010; // 1101101 => 2
    4'h3: sseg[6:0] = 7'b0001100; // 1111001 => 3
    4'h4: sseg[6:0] = 7'b1001100; // 0110011 => 4
    4'h5: sseg[6:0] = 7'b0100100; // 1011011 => 5
    4'h6: sseg[6:0] = 7'b0100000; // 1011111 => 6
    4'h7: sseg[6:0] = 7'b0001111; //         => 7 
    4'h8: sseg[6:0] = 7'b0000000; //         => 8
    4'h9: sseg[6:0] = 7'b0000100;//          => 9
    default: sseg[6:0] = 7'b0111000;
 
  endcase
 
 sseg[7] = dp;
 end 
	endmodule