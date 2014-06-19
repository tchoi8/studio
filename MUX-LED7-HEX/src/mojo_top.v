module mojo_top(
    
	 input wire clk, reset, 
	 input wire [3:0] hex3, hex2, hex1, hex0,
	 input wire [3:0] dp_in,
	 
	 output reg [3:0] an,
	 output reg [7:0] sseg, 
  	 
	 //  output segA, segB, segC, segD, segE, segF, segG, segDP,
    // AVR SPI connections
   output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy // AVR Rx buffer full
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
  
  
// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz; 
 
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
		
//reg [7:0] SevenSeg;
always @(*)
 begin
case(hex_in)
 
 // 4'h0: sseg[6:0] = 7'b0000001; // 1111111 => 0
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
 
/* 
    4'h0: sseg[7:0] = 7'b1111110; // 1111111 => 0
    4'h1: sseg[7:0] = 7'b0110000; // 0110000 => 1 
    4'h2: sseg[7:0] = 7'b1101101; // 1101101 => 2
    4'h3: sseg[7:0] = 7'b1111001; // 1111001 => 3
    4'h4: sseg[7:0] = 7'b0110011; // 0110011 => 4
    4'h5: sseg[7:0] = 7'b1011011; // 1011011 => 5
    4'h6: sseg[7:0] = 7'b1011111; // 1011111 => 6
    4'h7: sseg[7:0] = 7'b1110000; //         => 7 
    4'h8: sseg[7:0] = 7'b1111111; //         => 8
    4'h9: sseg[7:0] = 7'b1111011;//          => 9
    default: sseg[7:0] = 7'b111111;
	 */
 endcase
 
 sseg[7] = dp;
 end
//assign sseg[7:0] =SevenSeg; 
	endmodule
	
	 