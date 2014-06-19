module mojo_top(
    
	 input wire clk, reset,
	 input wire [3:0] btn,
	 input wire [7:0] sw,
	 output wire [3:0] an,
	 output wire [7:0] sseg, 
  	 
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
 
reg [7:0] d3_reg, d2_reg, d1_reg, d0_reg; 
 
mojo_top disp_unit
 (.clk(clk), .reset(1'b0), .in0(d0_reg), .in1(d1_reg), .in2(d2_reg), .in3(d3_reg), .an(an), .sseg(sseg)); 
 
// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz; 
 
 
always @(posedge clk)
 begin
	if (btn[3])
		d3_reg <= sw;
	if (btn[2])
		d2_reg <= sw;
	if (btn[1])
		d1_reg <= sw;
	if (btn[0])
		d0_reg <= sw;
	end
endmodule
