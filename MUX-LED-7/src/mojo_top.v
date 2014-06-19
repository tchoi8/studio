module mojo_top(
    
	 input clk, reset,
    input [7:0] in3, in2, in1, in0,
	 output reg [3:0] an, // enable, 1 out of 4 asserted low 
	 output reg [7:0] sseg, //seven segment 
	 
	 // Input from reset button (active low)
    // cclk input from AVR, high when AVR is ready
   
    // Outputs to the 8 onboard LEDs
	   
	 
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
reg [N-1:0] q_reg; 
wire [N-1:0] q_next;


always @(posedge clk, posedge reset)
	if (reset)
		q_reg <= 0;
	else 
		q_reg <= q_next;
		
		assign q_next = q_reg + 1;
 
// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz; 

always @(*)
	case (q_reg[N-1:N-2])
		2'b00:
			begin
				an = 4'b0001;
				sseg = in0;
			end
		2'b01:
			begin 
				an = 4'b0010;
				sseg = in1;
			end
		2'b10:
			begin
				an = 4'b0100;
				sseg = in2;
			end
		default:
			begin
				an=4'b1000;
				sseg = in3;
			end
		endcase
	endmodule
  