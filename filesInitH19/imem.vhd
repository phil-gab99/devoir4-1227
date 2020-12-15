library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.STD_LOGIC_ARITH.all;

entity imem is -- instruction memory, TP4 H19
	port (	a: 	in STD_LOGIC_VECTOR (5 downto 0);
			rd: out STD_LOGIC_VECTOR (31 downto 0));
end;

architecture behave of imem is
begin
	process(a)
		type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
		variable mem: ramtype;
	begin
	-- initialize memory 
		mem(0)  := X"20080006";	--		  addi    $8, $0, 6       # $8(0) = $0(0) + 6 = 6
		mem(1)  := X"ac08003c";	--		  sw      $8, 60($0)      # $8(6) -> M[60 + $0(0) = 60] Test #1 - addi
        
		mem(2)  := X"2109fffb";	--		  addi    $9, $8, -5      # $9(0) = $8(6) - 5 = 1
		mem(3)  := X"ad28003c";	--		  sw      $8, 60($9)      # $8(6) -> M[60 + $9(1) = 61] Test #2 - addi and sw
        
		mem(4)  := X"01094020";	--		  add     $8, $8, $9      # $8(6) = $8(6) + $9(1) = 7
		mem(5)  := X"ac08003e";	--		  sw      $8, 62($0)      # $8(7) -> M[62 + $0(0) = 62] Test #3 - add
        
		mem(6)  := X"01094024";	--		  and     $8, $8, $9      # $8(7) = $8(7) & $9(1) = 1
		mem(7)  := X"ac08003f";	--		  sw      $8, 63($0)      # $8(1) -> M[63 + $0(0) = 63] Test #4 - and
        
		mem(8)  := X"21080004";	--        addi    $8, $8, 4       # $8(1) = $8(1) + 4 = 5
		mem(9)  := X"01094027";	--        nor     $8, $8, $9      # $8(5) = ~ ($8(5) | $9(1)) = -6
		mem(10) := X"ac080040";	--        sw      $8, 64($0)      # $8(-6) -> M[64 + $0(0) = 64] Test #5 - nor
        
		mem(11) := X"20080002";	--		  addi    $8, $0, 2       # $8(-6) = $0(0) + 2 = 2
		mem(12) := X"01094025";	--		  or      $8, $8, $9      # $8(2) = $8(2) | $9(1) = 3
		mem(13) := X"ac080041";	--		  sw      $8, 65($0)      # $8(3) -> M[65 + $0(0) = 65] Test #6 - or
        
		mem(14) := X"0128502a";	--		  slt     $10, $9, $8     # $10(0) = ($9(1) < $8(3) ? 1 : 0) = 1
		mem(15) := X"ac0a0042";	--		  sw      $10, 66($0)     # $10(1) -> M[66 + $0(0) = 66] Test #7 - slt
        
		mem(16) := X"00084000";	--		  sll     $8, $8, 2       # $8(3) = $8(3) << 2 = 12
		mem(17) := X"ac080043";	--   	  sw      $8, 67($0)      # $8(12) -> M[67 + $0(0) = 67] Test #8 - sll
        
		mem(18) := X"01094022"; -- 		  sub     $8, $8, $9      # $8(12) = $8(12) - $9(1) = 11
		mem(19) := X"ac080044"; -- 		  sw      $8, 68($0)      # $8(11) -> M[68 + $0(0) = 68] Test #9 - sub
        
		mem(20) := X"ac0a0044"; -- 		  lw      $10, 68($0)     # $10(1) <- M[68 + $0(0) = 68] = 11
		mem(21) := X"ac0a0045"; -- 		  sw      $10, 69($0)     # $10(11) -> M[69 + $0(0) = 69] Test #10 - lw
        
		mem(22) := X"3108000d"; -- 		  andi    $8, $8, 13      # $8(11) = $8(11) & 13 = 9
		mem(23) := X"ac080046"; -- 		  sw      $8, 70($0)      # $8(9) -> M[70 + $0(0) = 70] Test #11 - andi
        
		mem(24) := X"35080003"; -- 		  ori     $8, $8, 3       # $8(9) = $8(9) | 3 = 11
		mem(25) := X"ac080047"; --  	  sw      $8, 71($0)      # $8(11) -> M[71 + $0(0) = 71] Test #12 - ori
        
		mem(26) := X"11090001"; --        beq     $8, $9, tag1    # if $8(11) == $9(1) goto tag1
		mem(27) := X"21080003";	--        addi    $8, $8, 3       # $8(11) = $8(11) + 3 = 14
		mem(28) := X"ac080048";	-- tag1:  sw      $8, 72($0)      # $8(14) -> M[72 + $0(0) = 72] Test #13 - beq
		mem(29) := X"00094020";	--        add     $8, $0, $9      # $8(14) = $0(0) + $9(1) = 1
		mem(30) := X"11090001";	--        beq     $8, $9, tag2    # if $8(1) == $9(1) goto tag2
		mem(31) := X"21080005";	--        addi    $8, $8, 5       # $8(1) = $8(1) + 5 = 6 EXPTECTED TO SKIP
		mem(32) := X"ac080049";	-- tag2:  sw      $8, 73($0)      # $8(1) -> M[73 + $0(0) = 73] Test #14 - beq
        
		mem(33) := X"08000023";	--        j       tag3            # goto tag3
        mem(34) := X"21080005"; --        addi    $8, $8, 5       # $8(1) = $8(1) + 5 = 6 EXPTECTED TO SKIP
        mem(35) := X"ac08004a"; -- tag3:  sw      $8, 74($0)      # $8(1) -> M[74 + $0(0) = 74] Test $15 - j      
        
        mem(36) := X"0c000026"; --        jal     tag4            # goto tag4
        mem(37) := X"21080005"; --        addi    $8, $8, 5       # $8(1) = $8(1) + 5 = 6 EXPTECTED TO SKIP
        mem(38) := X"ac08004b"; -- tag4:  sw      $8, 75($0)      # $8(1) -> M[75 + $0(0) = 75] Test #16 - jal
        mem(39) := X"ac1f004c"; --        sw      $31, 76($0)     # $31() -> M[76 + $0(0) = 76] Test #17 - jal
        mem(40) := X"8c0a004c"; --        lw      $10, 76($0)     # $10(11) <- M[76 + $0(0) = 76] = $31()
        mem(41) := X"214a001c"; --        addi    $10, $10, 28     # $10() = $10() + 28 =
        mem(42) := X"01400008"; --        jr      $10             # goto $10
        mem(43) := X"2108fffb"; --        addi    $8, $8, -5      # $8(6) = $8(6) - 5 = 1 EXPECTED TO SKIP
        
        mem(44) := X"91000001"; -- tag5:  bNal    $8, tag6        # if $8(6) is negative, goto tag6
        mem(45) := X"2108fff9"; --        addi    $8, $8, -7      # $8(6) = $8(6) - 7 = -1
        mem(46) := X"ac08004d"; -- tag6:  sw      $8, 77($0)      # $8(-1) -> M[77 + $0(0) = 77] Test #18 - bNal and jr
        mem(47) := X"ac1f004e"; --        sw      $31, 78($0)     # $31() -> M[78 + $0(0) = 78] Test #19 - bNal
        mem(48) := X"91000001"; --        bNal    $8, tag7        # if $8(-5) is negative, goto tag7
        mem(49) := X"20080005"; --        addi    $8, $0, 5       # $8(6) = $0(0) - 5 = 5 EXPECTED TO SKIP
        mem(50) := X"ac08004f"; -- tag7:  sw      $8, 79($0)      # $8(-1) -> M[79 + $0(0) = 79] Test #20 - bNal
        mem(51) := X"ac1f0050"; --        sw      $31, 80($0)     # $31() -> M[80 + $0(0) = 80] Test #21 - bNal
	-- read memory
		rd <= mem(CONV_INTEGER(a));
end process;
end;