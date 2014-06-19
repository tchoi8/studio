// (c) fpga4fun.com 2006

// Here's a counter design that drives a multiplexed 8-digits 7-segments display.
// The counter goes from 00000000 to 99999999, then rolls-over.
//
// The design uses 3 modules:
//
//   1. BCD1: BCD counter (single digit)
//   2. BCD8: BCD counter (holds 8 digits)
//   3. LED_BCD8x7seg: top-level that drives the display by multiplexing 8 digits

module LED_BCD8x7seg(clk, segA, segB, segC, segD, segE, segF, segG, segDP, seg_cathode);
input clk;
output segA, segB, segC, segD, segE, segF, segG, segDP;
output [7:0] seg_cathode;

reg [23:0] cnt;
always @(posedge clk) cnt<=cnt+24'h1;
wire cntovf = &cnt;

// cathode driver
wire [2:0] digitScan = cnt[18:16];
assign seg_cathode[0] = ~(digitScan==3'h0);
assign seg_cathode[1] = ~(digitScan==3'h1);
assign seg_cathode[2] = ~(digitScan==3'h2);
assign seg_cathode[3] = ~(digitScan==3'h3);
assign seg_cathode[4] = ~(digitScan==3'h4);
assign seg_cathode[5] = ~(digitScan==3'h5);
assign seg_cathode[6] = ~(digitScan==3'h6);
assign seg_cathode[7] = ~(digitScan==3'h7);

// 8 BCD digits
wire [8*4-1:0] BCD_digits;
BCD8 BCD(.clk(clk), .ena(cntovf), .BCD_digits(BCD_digits));  // BCD8 is defined below

// multiplexer
reg [3:0] BCDdigit;
always @(*)
case(digitScan)
    3'd0: BCDdigit = BCD_digits[ 3: 0];
    3'd1: BCDdigit = BCD_digits[ 7: 4];
    3'd2: BCDdigit = BCD_digits[11: 8];
    3'd3: BCDdigit = BCD_digits[15:12];
    3'd4: BCDdigit = BCD_digits[19:16];
    3'd5: BCDdigit = BCD_digits[23:20];
    3'd6: BCDdigit = BCD_digits[27:24];
    3'd7: BCDdigit = BCD_digits[31:28];
endcase

// 7-segments decoder
reg [7:0] SevenSeg;
always @(*)
case(BCDdigit)
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

assign {segA, segB, segC, segD, segE, segF, segG, segDP} = SevenSeg;
endmodule

// BCD8 holds 8 digits.
// It creates 8 single counts and wire them together so that when one overflows, the next is incremented.

module BCD8(clk, ena, BCD_digits);
input clk, ena;
output [8*4-1:0] BCD_digits;

wire [7:0] carryout;
assign carryout[0] = ena;
BCD1 digit0(.clk(clk), .ena(carryout[0]), .BCD_digit(BCD_digits[ 3: 0]), .BCD_carryout(carryout[1]));
BCD1 digit1(.clk(clk), .ena(carryout[1]), .BCD_digit(BCD_digits[ 7: 4]), .BCD_carryout(carryout[2]));
BCD1 digit2(.clk(clk), .ena(carryout[2]), .BCD_digit(BCD_digits[11: 8]), .BCD_carryout(carryout[3]));
BCD1 digit3(.clk(clk), .ena(carryout[3]), .BCD_digit(BCD_digits[15:12]), .BCD_carryout(carryout[4]));
BCD1 digit4(.clk(clk), .ena(carryout[4]), .BCD_digit(BCD_digits[19:16]), .BCD_carryout(carryout[5]));
BCD1 digit5(.clk(clk), .ena(carryout[5]), .BCD_digit(BCD_digits[23:20]), .BCD_carryout(carryout[6]));
BCD1 digit6(.clk(clk), .ena(carryout[6]), .BCD_digit(BCD_digits[27:24]), .BCD_carryout(carryout[7]));
BCD1 digit7(.clk(clk), .ena(carryout[7]), .BCD_digit(BCD_digits[31:28]));
endmodule

// BCD1 holds 1 digit, with overflow logic.

module BCD1(clk, ena, BCD_digit, BCD_carryout);
input clk, ena;
output [3:0] BCD_digit;
output BCD_carryout;

reg [3:0] BCD_digit;
wire BCDrollover = (BCD_digit==4'd9);
always @(posedge clk)
if(ena)
begin
    if(BCDrollover) BCD_digit<=4'd0; else BCD_digit<=BCD_digit+4'd1;
end

assign BCD_carryout = ena & BCDrollover;
endmodule
