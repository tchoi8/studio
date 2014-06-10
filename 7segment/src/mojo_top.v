module LEDblink(clk, led);
input clk;     // clock typically from 10MHz to 50MHz
output led;

// create a binary counter
reg [31:0] cnt;
always @(posedge clk) cnt <= cnt+1;

assign led = cnt[22];    // blink the LED at a few Hz (using the 23th bit of the counter, use a different bit to modify the blinking rate)
endmodule