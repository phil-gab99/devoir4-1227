library IEEE;
use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_UNSIGNED.all;

entity testbench is --Tp4 H19
end;

architecture test of testbench is
	component mips
		port(	clk, reset: in STD_LOGIC;
				writedata, dataadr: out STD_LOGIC_VECTOR(31 downto 0);
				memwrite: out STD_LOGIC);
	end component;
	signal writedata, dataadr: STD_LOGIC_VECTOR(31 downto 0);
	signal clk, reset, memwrite: STD_LOGIC;
begin
-- instantiate device to be tested
	dut: mips port map (clk, reset, writedata, dataadr, memwrite);
-- Generate clock with 10 ns period
process begin
	clk <= '1';
	wait for 5 ns;
	clk <= '0';
	wait for 5 ns;
end process;

-- Generate reset for first two clock cycles
process begin
	reset <= '1';
	wait for 22 ns;
	reset <= '0';
	wait;
end process;

-- autoverification
process (clk) begin
	if (clk'event and clk = '0' and memwrite = '1') then
        case conv_integer(dataadr) is
            -- Test #1 - addi
            when 60 => if(conv_integer(writedata) = 6) then
                report "test 1 réussi";
            else
                report "test 1 échoué";
            end if;
            
            -- Test #2 - addi and sw
            when 61 => if(conv_integer(writedata) = 6) then
                report "test 2 réussi";
            else
                report "test 2 échoué";
            end if;
            
            -- Test #3 - add
            when 62 => if(conv_integer(writedata) = 7) then
                report "test 3 réussi";
            else
                report "test 3 échoué";
            end if;
            
            -- Test #4 - and
            when 63 => if(conv_integer(writedata) = 1) then
                report "test 4 réussi";
            else
                report "test 4 échoué";
            end if;
            
            -- Test #5 - nor
            when 64 => if(conv_integer(writedata) = -6) then
                report "test 5 réussi";
            else
                report "test 5 échoué";
            end if;
            
            -- Test #6 - or
            when 65 => if(conv_integer(writedata) = 3) then
                report "test 6 réussi";
            else
                report "test 6 échoué";
            end if;
            
            -- Test #7 - slt
            when 66 => if(conv_integer(writedata) = 1) then
                report "test 7 réussi";
            else
                report "test 7 échoué";
            end if;
            
            -- Test #8 - sll
            when 67 => if(conv_integer(writedata) = 12) then
                report "test 8 réussi";
            else
                report "test 8 échoué";
            end if;
	    when others => report "";
	  end case;       
	end if;
end process;
end;