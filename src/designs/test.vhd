--simple test entity, features both clocked and combinatorial signal outputs

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test is
    Port ( 
        clk_i   : in  STD_LOGIC;
        a_i, b_i : in  STD_LOGIC;
        combinatorial_o, clocked_o : out STD_LOGIC
    );
end test;

architecture rtl of test is
begin
    -- combinatorial operation
    combinatorial_o <= a_i and b_i;
    
    -- clocked operation
    process (clk_i)
    begin
        if (rising_edge(clk_i)) then
            clocked_o <= a_i and b_i;
        end if;
    end process;
end rtl;