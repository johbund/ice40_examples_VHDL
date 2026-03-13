library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity uart_tx_helloworld_top is
  port (
    i_clk : in std_logic;
    o_data : out std_logic
  );
end uart_tx_helloworld_top;

architecture behavioral of uart_tx_helloworld_top is
    constant C_CLK_FREQ : integer := 12000000; -- Hz
    constant C_BAUDRATE : integer := 9600; -- words / s
    constant C_CYCLES_PER_BIT : integer := C_CLK_FREQ / C_BAUDRATE; 

    constant C_CLK_DIV : integer := C_CLK_FREQ / 4;

    signal s_send_data : std_logic := '0';
    signal s_tx_ready: std_logic;
    signal r_tx_ready: std_logic := '0';
    signal r_current_byte : std_logic_vector(7 downto 0) := (others => '0');

    type t_string_rom is array (natural range <>) of std_logic_vector(7 downto 0);
    constant C_HELLO_WORLD : t_string_rom := (
        x"48",  -- 'H'
        x"65",  -- 'e'
        x"6C",  -- 'l'
        x"6C",  -- 'l'
        x"6F",  -- 'o'
        x"2C",  -- ','
        x"20",  -- ' '
        x"57",  -- 'W'
        x"6F",  -- 'o'
        x"72",  -- 'r'
        x"6C",  -- 'l'
        x"64",  -- 'd'
        x"21",  -- '!'
        x"20"   -- ' '
    );
    constant C_MSG_LENGTH : integer := C_HELLO_WORLD'LENGTH;
    signal r_index: integer range 0 to C_MSG_LENGTH - 1 := 0;
  
begin

process (i_clk)
  variable v_counter : integer range 0 to C_CLK_DIV - 1 := 0;
begin
  if rising_edge(i_clk) then
    s_send_data <= '0';
    if v_counter = C_CLK_DIV then
      v_counter := 0;
      s_send_data <= '1';
    else
      v_counter := v_counter + 1;
    end if;
  end if;
end process;

process (i_clk)
begin
  if rising_edge(i_clk) then
    r_tx_ready <= s_tx_ready;
  end if;  
end process;

process (i_clk)
begin
  if rising_edge(i_clk) then
    if s_tx_ready = '1' and r_tx_ready = '0' then
      r_current_byte <= C_HELLO_WORLD(r_index);
      if r_index = C_MSG_LENGTH - 1 then
        r_index <= 0;
      else 
        r_index <= r_index + 1;
      end if;
    end if;
  end if;
end process;

uart_t : entity work.UART_TX
  generic map (
    G_CLKS_PER_BIT => C_CYCLES_PER_BIT
  )
  port map (
    i_Clk => i_clk,
    i_TX_DV => s_send_data,
    i_TX_Byte => r_current_byte,
    o_TX_Active => open,
    o_TX_Serial => o_data,
    o_TX_Done => s_tx_ready
  );
end behavioral;
