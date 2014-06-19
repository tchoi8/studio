/*module LEDglow(clk, segA);
input clk;
output segA;

reg [23:0] cnt;
always @(posedge clk) cnt<=cnt+1;
wire [3:0] PWM_input = cnt[23] ? cnt[22:19] : ~cnt[22:19];    // ramp the PWM input up and down

reg [4:0] PWM;
always @(posedge clk) PWM <= PWM[3:0]+PWM_input;

assign segA = PWM[4];
endmodule
*/
  module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
	   
		output[7:0]led,
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

wire rst = ~rst_n; // make reset active high
 
// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;
 
 
 reg [23:0] cnt;
always @(posedge clk) cnt <= cnt+24'h1;
wire cntovf = &cnt;

reg [3:0] BCD_new, BCD_old;
always @(posedge clk) if(cntovf) BCD_new <= (BCD_new==4'h9 ? 4'h0 : BCD_new+4'h1);
always @(posedge clk) if(cntovf) BCD_old <= BCD_new;

reg [4:0] PWM;
wire [3:0] PWM_input = cnt[22:19];
always @(posedge clk) PWM <= PWM[3:0]+PWM_input;
wire [3:0] BCD = (cnt[23] | PWM[4]) ? BCD_new : BCD_old;

reg [7:0] SevenSeg;
always @(*)
case(BCD)
    4'h0: SevenSeg = 8'b11111100;
    4'h1: SevenSeg = 8'b01100000;
    4'h2: SevenSeg = 8'b11011010;
    4'h3: SevenSeg = 8'b11110010;
    4'h4: SevenSeg = 8'b01100110;
    4'h5: SevenSeg = 8'b10110110;
    4'h6: SevenSeg = 8'b10111110;
    4'h7: SevenSeg = 8'b11100000;
    4'h8: SevenSeg = 8'b11111110;
    4'h9: SevenSeg = 8'b11110110;
    default: SevenSeg = 8'b00000000;
endcase


assign led[7:0] = SevenSeg; 
//assign {segA, segB, segC, segD, segE, segF, segG, segDP} = SevenSeg;

endmodule
 
  
 /*  
wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

//create clock 
reg [23:0] cnt;
always @(posedge clk) cnt <= cnt+1;

reg toggle;
always @(posedge clk) toggle <= ~toggle;     // toggles at half the clk frequency (at least 100Hz)

assign led[7:0] = 7'b1111111;;
//7'b1;
*/