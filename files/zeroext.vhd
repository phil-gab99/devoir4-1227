library IEEE; use IEEE.STD_LOGIC_1164.all;

entity zeroext is -- zero extender
	port(	a: in STD_LOGIC_VECTOR (15 downto 0);
			y: out STD_LOGIC_VECTOR (31 downto 0));
end;

architecture behave of zeroext is
begin
	y <= X"0000" & a;
end;