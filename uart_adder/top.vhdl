-- -----------------------------------------------------------------------------
-- Module      : uart_adder_top
-- Description : Top-level entity for the UART adder demo on the
--               Lattice iCE40-HX8K breakout board.
--               Receives two unsigned bytes over UART, computes their sum
--               using a combinatorial adder, and transmits the result back.
--
-- Board       : Lattice iCE40-HX8K breakout board
-- Toolchain   : Yosys + GHDL-synth + nextpnr-ice40
-- Standard    : VHDL-2008
--
-- Clock       : i_clk  -- 12 MHz onboard oscillator
-- Baud rate   : 9600 baud, 8N1
--
-- Dependencies: work.adder    (combinatorial adder, see adder.vhdl)
--               work.uart_rx  (proprietary, not included)
--               work.UART_TX  (proprietary, not included)
--
-- Pin mapping : see pinmap.pcf
-- -----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity uart_adder_top is
  generic (
    G_BITS : integer := 8
  );
  port (
    i_clk    : in  std_logic;
    i_data   : in  std_logic;
    o_data   : out std_logic
  );
end uart_adder_top;

architecture behavioral of uart_adder_top is

  -- Clock and UART timing constants
  constant C_CLK_FREQ_HZ    : integer := 12_000_000;
  constant C_BAUDRATE       : integer := 9_600;
  constant C_CYCLES_PER_BIT : integer := C_CLK_FREQ_HZ / C_BAUDRATE;

  -- UART RX signals
  signal s_rx_ready : std_logic;
  signal r_rx_ready : std_logic := '0';
  signal s_rx_byte  : std_logic_vector(7 downto 0);

  -- UART TX signals
  signal s_tx_dv     : std_logic := '0';
  signal s_tx_active : std_logic;
  signal r_tx_byte   : std_logic_vector(7 downto 0) := (others => '0');
  signal s_tx_done   : std_logic;

  -- Adder signals
  signal r_add1 : std_logic_vector(G_BITS-1 downto 0) := (others => '0');
  signal r_add2 : std_logic_vector(G_BITS-1 downto 0) := (others => '0');
  signal s_sum  : std_logic_vector(G_BITS-1 downto 0);

  -- State machine
  type t_state is (IDLE, WAIT_BYTE2, SEND_RESULT, WAIT_TX_DONE);
  signal r_state : t_state := IDLE;

begin

  -- Register s_rx_ready to detect its rising edge in the state machine
  process (i_clk)
  begin
    if rising_edge(i_clk) then
      r_rx_ready <= s_rx_ready;
    end if;
  end process;

  -- State machine: capture two bytes, trigger adder, transmit result
  process (i_clk)
  begin
    if rising_edge(i_clk) then
      s_tx_dv <= '0';  -- default: tx trigger is a single-cycle pulse

      case r_state is

        when IDLE =>
          -- Wait for the first byte to arrive
          if s_rx_ready = '1' and r_rx_ready = '0' then
            r_add1  <= s_rx_byte;
            r_state <= WAIT_BYTE2;
          end if;

        when WAIT_BYTE2 =>
          -- Wait for the second byte to arrive
          if s_rx_ready = '1' and r_rx_ready = '0' then
            r_add2  <= s_rx_byte;
            r_state <= SEND_RESULT;
          end if;

        when SEND_RESULT =>
          -- Adder output is combinatorial and already valid this cycle.
          -- Latch the result and trigger the UART transmitter for one cycle.
          r_tx_byte <= s_sum;
          s_tx_dv   <= '1';
          r_state   <= WAIT_TX_DONE;

        when WAIT_TX_DONE =>
          -- Hold until UART transmission is complete, then accept a new pair
          if s_tx_done = '1' then
            r_state <= IDLE;
          end if;

      end case;
    end if;
  end process;

  i_adder : entity work.adder
    generic map (
      G_BITS => G_BITS
    )
    port map (
      i_add1 => r_add1,
      i_add2 => r_add2,
      o_sum  => s_sum
    );

  i_uart_tx : entity work.UART_TX
    generic map (
      g_CLKS_PER_BIT => C_CYCLES_PER_BIT
    )
    port map (
      i_Clk       => i_clk,
      i_TX_DV     => s_tx_dv,
      i_TX_Byte   => r_tx_byte,
      o_TX_Active => s_tx_active,
      o_TX_Serial => o_data,
      o_TX_Done   => s_tx_done
    );

  i_uart_rx : entity work.uart_rx
    generic map (
      g_CLKS_PER_BIT => C_CYCLES_PER_BIT
    )
    port map (
      i_Clk      => i_clk,
      i_RX_Serial => i_data,
      o_RX_DV    => s_rx_ready,
      o_RX_Byte  => s_rx_byte
    );

end behavioral;