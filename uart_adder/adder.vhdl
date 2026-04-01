-- -----------------------------------------------------------------------------
-- Module      : adder
-- Description : Generic-width unsigned combinatorial adder.
--               Computes the sum of two inputs in the same clock cycle.
--               Overflow wraps silently (modulo 2^G_BITS).
--
-- Standard    : VHDL-2008
-- -----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity adder is
  generic (
    G_BITS : integer := 8
  );
  port (
    i_add1 : in  std_logic_vector(G_BITS-1 downto 0);
    i_add2 : in  std_logic_vector(G_BITS-1 downto 0);
    o_sum  : out std_logic_vector(G_BITS-1 downto 0)
  );
end adder;

architecture behavioral of adder is
begin

  o_sum <= std_logic_vector(unsigned(i_add1) + unsigned(i_add2));

end behavioral;