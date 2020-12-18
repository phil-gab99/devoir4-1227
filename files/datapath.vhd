library IEEE; use IEEE.STD_LOGIC_1164.all; use
IEEE.STD_LOGIC_ARITH.all;

entity datapath is -- MIPS datapath
	port(	clk, reset: in STD_LOGIC;
			memtoreg: in STD_LOGIC_VECTOR(1 downto 0);
			pcsrc: in STD_LOGIC;
			alusrc, regdst: in STD_LOGIC_VECTOR(1 downto 0);
			regwrite: in STD_LOGIC;
			jump: in STD_LOGIC_VECTOR(1 downto 0);
			alucontrol: in STD_LOGIC_VECTOR (5 downto 0);
			zero, overflow, neg: out STD_LOGIC;
			pc: buffer STD_LOGIC_VECTOR (31 downto 0);
			instr: in STD_LOGIC_VECTOR(31 downto 0);
			aluout, writedata: buffer STD_LOGIC_VECTOR (31 downto 0);
			readdata: in STD_LOGIC_VECTOR(31 downto 0));
end;

architecture struct of datapath is
	component alu
		port(	a, b: in STD_LOGIC_VECTOR(31 downto 0);
				f: in STD_LOGIC_VECTOR (5 downto 0);
				shamt: in STD_LOGIC_VECTOR (4 downto 0);
				z, o, n : out STD_LOGIC;
				y: buffer STD_LOGIC_VECTOR(31 downto 0));
	end component;
	component regfile
		port(	clk: in STD_LOGIC;
				we3: in STD_LOGIC;
				ra1, ra2, wa3: in STD_LOGIC_VECTOR (4 downto 0);
				wd3: in STD_LOGIC_VECTOR (31 downto 0);
				rd1, rd2: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component adder
		port(	a, b: in STD_LOGIC_VECTOR (31 downto 0);
				y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component sl2
		port(	a: in STD_LOGIC_VECTOR (31 downto 0);
				y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component signext
		port(	a: in STD_LOGIC_VECTOR (15 downto 0);
				y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component zeroext
		port(	a: in STD_LOGIC_VECTOR (15 downto 0);
				y: out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	component flopr generic (width: integer);
		port(	clk, reset: in STD_LOGIC;
				d: in STD_LOGIC_VECTOR (width-1 downto 0);
				q: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	component mux2 generic (width: integer);
		port(	d0, d1: in STD_LOGIC_VECTOR (width-1 downto 0);
				s: in STD_LOGIC;
				y: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	component mux4 generic (width: integer);
		port(	d0, d1, d2, d3: in STD_LOGIC_VECTOR(width-1 downto 0);
				s: in STD_LOGIC_VECTOR(1 downto 0);
				y: out STD_LOGIC_VECTOR(width-1 downto 0));
	end component;
	signal writereg: STD_LOGIC_VECTOR (4 downto 0);
	signal pcjump, pcnext, pcnextbr, pcplus4, pcbranch: STD_LOGIC_VECTOR (31 downto 0);
	signal signimm, signimmsh, zeroimm: STD_LOGIC_VECTOR (31 downto 0);
	signal srca, srcb, srcash, result: STD_LOGIC_VECTOR (31 downto 0);
	
begin
-- next PC logic
    pcjump <= pcplus4 (31 downto 28) & instr (25 downto 0) & "00";
	pcreg: flopr generic map(32) port map(clk, reset, pcnext, pc);
	pcadd1: adder port map(pc, X"00000004", pcplus4);
	immsh: sl2 port map(signimm, signimmsh);
	pcadd2: adder port map(pcplus4, signimmsh, pcbranch);
	pcbrmux: mux2 generic map(32) port map(pcplus4, pcbranch, pcsrc, pcnextbr);
    pcsrca: sl2 port map(srca, srcash);
	pcmux: mux4 generic map(32) port map(pcnextbr, pcjump, srcash, X"00000000", jump, pcnext);
-- register file logic
	wrmux: mux4 generic map(5) port map(instr(20 downto 16), instr(15 downto 11), "11111", "00000", regdst, writereg);
	rf: regfile port map(clk, regwrite, instr(25 downto 21),instr(20 downto 16), writereg, result, srca, writedata);
	resmux: mux4 generic map(32) port map(aluout, readdata, pcplus4, X"00000000", memtoreg, result);
	se: signext port map(instr(15 downto 0), signimm);
	ze: zeroext port map(instr(15 downto 0), zeroimm);
-- ALU logic
	srcbmux: mux4 generic map (32) port map(writedata, signimm, zeroimm, X"00000000", alusrc, srcb);
	mainalu: alu port map(srca, srcb, alucontrol, instr(10 downto 6), zero, overflow, neg, aluout);
end;