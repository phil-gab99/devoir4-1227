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
            
            -- Test #9 - sub
            when 68 => if(conv_integer(writedata) = 11) then
                report "test 9 réussi";
            else
                report "test 9 échoué";
            end if;
            
            -- Test #10 - lw
            when 69 => if(conv_integer(writedata) = 11) then
                report "test 10 réussi";
            else
                report "test 10 échoué";
            end if;
            
            -- Test #11 - andi
            when 70 => if(conv_integer(writedata) = 9) then
                report "test 11 réussi";
            else
                report "test 11 échoué";
            end if;
            
            -- Test #12 - ori
            when 71 => if(conv_integer(writedata) = 11) then
                report "test 12 réussi";
            else
                report "test 12 échoué";
            end if;
            
            -- Test #13 - beq
            when 72 => if(conv_integer(writedata) = 14) then
                report "test 13 réussi";
            else
                report "test 13 échoué";
            end if;
            
            -- Test #14 - beq
            when 73 => if(conv_integer(writedata) = 1) then
                report "test 14 réussi";
            else
                report "test 14 échoué";
            end if;
            
            -- Test #15 - j
            when 74 => if(conv_integer(writedata) = 1) then
                report "test 15 réussi";
            else
                report "test 15 échoué";
            end if;
            
            -- Test #16 - jal
            when 75 => if(conv_integer(writedata) = 1) then
                report "test 16 réussi";
            else
                report "test 16 échoué";
            end if;
            
            -- Test #17 - jal
            when 76 => if(conv_integer(writedata) = 37) then
                report "test 17 réussi";
            else
                report "test 17 échoué";
            end if;
            
            -- Test #18 - bNal and jr
            when 77 => if(conv_integer(writedata) = -1) then
                report "test 18 réussi";
            else
                report "test 18 échoué";
            end if;
            
            -- Test #19 - bNal
            when 78 => if(conv_integer(writedata) = 37) then
                report "test 19 réussi";
            else
                report "test 19 échoué";
            end if;
            
            -- Test #20 - bNal
            when 79 => if(conv_integer(writedata) = -1) then
                report "test 20 réussi";
            else
                report "test 20 échoué";
            end if;
            
            -- Test #21 - bNal
            when 80 => if(conv_integer(writedata) = 48) then
                report "test 21 réussi";
            else
                report "test 21 échoué";
            end if;
	    when others => report "";
	  end case;       
	end if;
end process;
end;