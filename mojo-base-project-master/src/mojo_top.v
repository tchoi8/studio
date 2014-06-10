 module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
	   output[7:0]led,
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

//create clock 
reg [23:0] cnt;
always @(posedge clk) cnt <= cnt+24'h1;
wire cntovf = &cnt;
 
reg [3:0] BCD;
always @(posedge clk) if(cntovf) BCD <= (BCD==4'h9 ? 4'h0 : BCD+4'h1); // what is this? 

reg [7:0] SevenSeg;
always @(*)
case(BCD) // segment outputs, not BCD . that is BCD inputs 
    4'h0: SevenSeg = 8'b11111100; // 1111111 => 0
    4'h1: SevenSeg = 8'b01100000; // 0110000 => 1 
    4'h2: SevenSeg = 8'b11011010; // 1101101 => 2
    4'h3: SevenSeg = 8'b11110010; // 1111001 => 3
    4'h4: SevenSeg = 8'b01100110; // 0110011 => 4
    4'h5: SevenSeg = 8'b10110110; // 1011011 => 5
    4'h6: SevenSeg = 8'b10111110; // 1011111 => 6
    4'h7: SevenSeg = 8'b11100000; //         => 7 
    4'h8: SevenSeg = 8'b11111110; //         => 8
    4'h9: SevenSeg = 8'b11110110;//          => 9
    default: SevenSeg = 8'b00000000;
endcase 

assign led[7:0] = SevenSeg; 

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