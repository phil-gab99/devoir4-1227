library IEEE; use IEEE.STD_LOGIC_1164.all;

entity mux4 is -- four-input multiplexer
    generic (width: integer);
	port (d0, d1, d2, d3: in STD_LOGIC_VECTOR(width-1 downto 0);
			s: in STD_LOGIC_VECTOR(1 downto 0);
			y: out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture struct of mux4 is
    component mux2
        generic(width: integer);
        port(d0, 
            d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
            s:  in  STD_LOGIC;
            y:  out  STD_LOGIC_VECTOR(width-1 downto 0));
    end component; 
    signal low, hi: STD_LOGIC_VECTOR(width-1 downto 0);
begin
    lowmux: mux2 generic map(width) port map(d0, d1, s(0), low);
    himux: mux2 generic map(width) port map(d2, d3, s(0), hi);
    outmux: mux2 generic map(width) port map(low, hi, s(1), y);
end;