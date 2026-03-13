
-- -----------------------------------------------------------------------------
-- Module      : uart_rx_leds_top
-- Description : Top-level entity for the UART RX LED demo on the
--               Lattice iCE40-HX8K breakout board.
--
-- Clock       : i_clk  -- 12 MHz onboard oscillator
-- Baud rate   : 9600 baud
-- UART        : receive 8 BIT of serial data
-- -----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.ALL;
  use ieee.numeric_std.all;

entity uart_rx_leds_top is
  port (
    i_clk : in std_logic;
    i_data : in std_logic;
    o_leds : out std_logic_vector(7 downto 0)
  );
end uart_rx_leds_top;

architecture behavioral of uart_rx_leds_top is
  constant C_CLK_FREQ : integer := 12000000; -- Hz
  constant C_BAUDRATE : integer := 9600; -- words / s
  constant C_CYCLES_PER_BIT : integer := C_CLK_FREQ / C_BAUDRATE;

  signal r_leds : std_logic_vector(7 downto 0) := (others => '0');
  signal r_rx_byte : std_logic_vector(7 downto 0) := (others => '0');
  signal s_rx_ready : std_logic;
begin

o_leds  <= r_leds;

process (i_clk) begin
  if rising_edge(i_clk) && s_rx_ready = '1' then
    case r_rx_byte is
        when x"30" => r_leds(0) <= not r_leds(0);  -- '0'
        when x"31" => r_leds(1) <= not r_leds(1);  -- '1'
        when x"32" => r_leds(2) <= not r_leds(2);  -- '2'
        when x"33" => r_leds(3) <= not r_leds(3);  -- '3'
        when x"34" => r_leds(4) <= not r_leds(4);  -- '4'
        when x"35" => r_leds(5) <= not r_leds(5);  -- '5'
        when x"36" => r_leds(6) <= not r_leds(6);  -- '6'
        when x"37" => r_leds(7) <= not r_leds(7);  -- '7'
        when x"61" => r_leds <= (others => '1');  -- 'a' all
        when x"72" => r_leds <= (others => '0');  -- 'r' reset
        when others => null;
    end case;    	
  end if;
end process;

i_uart_rx : entity work.uart_rx
    generic map (
        G_CLKS_PER_BIT => C_CYCLES_PER_BIT
    )
    port map (
        i_Clk => i_clk,
        i_RX_Serial => i_data,
        o_RX_DV => s_rx_ready,
        o_RX_Byte => r_rx_byte
    );

end behavioral;
