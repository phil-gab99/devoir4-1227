library IEEE; use IEEE.STD_LOGIC_1164.all;
entity controller is -- single cycle control decoder
	port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
			zero, neg: in STD_LOGIC;
			memtoreg: out STD_LOGIC_VECTOR(1 downto 0);
			memwrite: out STD_LOGIC;
			pcsrc: out STD_LOGIC;
			alusrc, regdst: out STD_LOGIC_VECTOR(1 downto 0);
			regwrite: out STD_LOGIC;
			jump: out STD_LOGIC_VECTOR(1 downto 0);
			alucontrol: out STD_LOGIC_VECTOR (5 downto 0));
end;

architecture struct of controller is
	component maindec
		port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
				memtoreg: out STD_LOGIC_VECTOR(1 downto 0);
				memwrite: out STD_LOGIC;
				branch, branchneg: out STD_LOGIC;
				alusrc, regdst: out STD_LOGIC_VECTOR(1 downto 0);
				regwrite: out STD_LOGIC;
				jump: out STD_LOGIC_VECTOR(1 downto 0);
				aluop: out STD_LOGIC_VECTOR (1 downto 0));
	end component;
	component aludec
		port (funct: in STD_LOGIC_VECTOR (5 downto 0);
				aluop: in STD_LOGIC_VECTOR (2 downto 0);
				alucontrol: out STD_LOGIC_VECTOR (5 downto 0));
	end component;
	signal aluop: STD_LOGIC_VECTOR (2 downto 0);
	signal branch, branchneg: STD_LOGIC;
	signal pcbranch, pcbranchneg: STD_LOGIC;
	signal regwritetemp: STD_LOGIC
begin
	
	md: maindec port map (op, funct, memtoreg, memwrite, branch, branchneg, alusrc, regdst, regwritetemp, jump, aluop);
	ad: aludec port map (funct, aluop, alucontrol);
	pcbranch <= branch and zero;
	pcbranchneg <= branchneg and neg;
	pcsrc <= pcbranch or pcbranchneg;
	regwrite <= regwritetemp or pcbranchneg;
end;