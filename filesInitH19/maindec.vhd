library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
	port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg: out STD_LOGIC_VECTOR(1 downto 0);
			memwrite: out STD_LOGIC;
			branch, branchneg: out STD_LOGIC;
			alusrc, regdst: out STD_LOGIC_VECTOR(1 downto 0);
			regwrite: out STD_LOGIC;
			jump: out STD_LOGIC_VECTOR(1 downto 0);
			aluop: out STD_LOGIC_VECTOR (2 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(14 downto 0);
begin
process(op) begin
	case op is
		when "000000" => 
			if funct = "001000" then	-- jr
				controls <= "000000000010000";
			else						-- Rtype
				controls <= "101000000000101";
			end if;
		when "100011" => controls <= "100010000100000"; -- LW
		when "101011" => controls <= "000010010000000"; -- SW
		when "000100" => controls <= "000001000000001"; -- BEQ
		when "001000" => controls <= "100010000000000"; -- ADDI
		when "000010" => controls <= "000000000001000"; -- J
		when "001100" => controls <= "100100000000010"; -- andi
		when "000011" => controls <= "110000001001000"; --jal
		when "001101" => controls <= "100100000000011"; --ori
		when "100100" => controls <= "010000101000000"; -- bNal
		when others => controls <= "---------------"; -- illegal op
	end case;
end process;

	regwrite <= controls(14);
	regdst <= controls(13 downto 12);
	alusrc <= controls(11 downto 10);
	branch <= controls(9);
	branchneg <= controls(8);
	memwrite <= controls(7);
	memtoreg <= controls(6 downto 5);
	jump <= controls(4 downto 3);
	aluop <= controls(2 downto 0);
end;