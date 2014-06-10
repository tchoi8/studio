library verilog;
use verilog.vl_types.all;
entity first_counter is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        counter_out     : out    vl_logic_vector(3 downto 0)
    );
end first_counter;
