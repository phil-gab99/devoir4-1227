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
		mem(0) := X"20080006";	--		  addi    $8, $0, 6       # $8(0) = $0(0) + 6 = 6
		mem(1) := X"ac08003c";	--		  sw      $8, 60($0)      # $8(6) -> M[60 + $0(0) = 60] Test #1 - addi
        
		mem(2) := X"";	--		  addi    $9, $8, -5      # $9(0) = $8(6) - 5 = 1
		mem(3) := X"";	--		  sw      $8, 60($9)      # $8(6) -> M[60 + $9(1) = 61] Test #2 - addi and sw
        
		mem(4) := X"";	--		  add     $8, $8, $9      # $8(6) = $8(6) + $9(1) = 7
		mem(5) := X"";	--		  sw      $8, 62($0)      # $8(7) -> M[62 + $0(0) = 62] Test #3 - add
        
		mem(6) := X"";	--		  and     $8, $8, $9      # $8(7) = $8(7) & $9(1) = 1
		mem(7) := X"";	--		  sw      $8, 63($0)      # $8(1) -> M[63 + $0(0) = 63] Test #4 - and
        
		mem(8) := X"";	--        addi    $8, $8, 4       # $8(1) = $8(1) + 4 = 5
		mem(9) := X"";	--        nor     $8, $8, $9      # $8(5) = ~ ($8(5) | $9(1)) = -6
		mem(10) := X"";	--        sw      $8, 64($0)      # $8(-6) -> M[64 + $0(0) = 64] Test #5 - nor
        
		mem(11) := X"";	--		  addi    $8, $0, 2       # $8(-6) = $0(0) + 2 = 2
		mem(12) := X"";	--		  or      $8, $8, $9      # $8(2) = $8(2) | $9(1) = 3
		mem(13) := X"";	--		  sw      $8, 65($0)      # $8(3) -> M[65 + $0(0) = 65] Test #6 - or
        
		mem(14) := X"";	--		  slt     $10, $9, $8     # $10(0) = ($9(1) < $8(3) ? 1 : 0) = 1
		mem(15) := X"";	--		  sw      $10, 66($0)     # $10(1) -> M[66 + $0(0) = 66] Test #7 - slt
        
		mem(16) := X"";	--		  sll     $8, $8, 2       # $8(3) = $8(3) << 2 = 12
		mem(17) := X"";	--   	  sw      $8, 67($0)      # $8(12) -> M[67 + $0(0) = 67] Test #8 - sll
        
		mem(18) := X""; -- 		  sub     $8, $8, $9      # $8(12) = $8(12) - $9(1) = 11
		mem(19) := X""; -- 		  sw      $8, 68($0)      # $8(11) -> M[68 + $0(0) = 68] Test #9 - sub
        
		mem(20) := X""; -- 		  lw      $10, 68($0)     # $10(1) <- M[68 + $0(0) = 68] = 11
		mem(21) := X""; -- 		  sw      $10, 69($0)     # $10(11) -> M[69 + $0(0) = 69] Test #10 - lw
        
		mem(22) := X""; -- 		  andi    $8, $8, 13      # $8(11) = $8(11) & 13 = 9
		mem(23) := X""; -- 		  sw      $8, 70($0)      # $8(9) -> M[70 + $0(0) = 70] Test #11 - andi
        
		mem(24) := X""; -- 		  ori     $8, $8, 3       # $8(9) = $8(9) | 3 = 11
		mem(25) := X""; --  	  sw      $8, 71($0)      # $8(11) -> M[71 + $0(0) = 71] Test #12 - ori
        
		mem(26) := X""; --        beq     $8, $9, tag1    # if $8(11) == $9(1) goto tag1
		mem(27) := X"";	--        addi    $8, $8, 3       # $8(11) = $8(11) + 3 = 14
		mem(28) := X"";	--tag1:   sw      $8, 72($0)      # $8(14) -> M[72 + $0(0) = 72] Test #13 - beq
		mem(29) := X"";	--        add     $8, $0, $9      # $8(14) = $0(0) + $9(1) = 1
		mem(30) := X"";	--        beq     $8, $9, tag2    # if $8(1) == $9(1) goto tag2
		mem(31) := X"";	--        addi    $8, $8, 5       # $8(1) = $8(1) + 5 = 6 EXPTECTED TO SKIP
		mem(32) := X"";	--tag2:   sw      $8, 73($0)      # $8(1) -> M[73 + $0(0) = 73] Test #14 - beq
        
		mem(33) := X"";	--        j       tag3            # goto tag3
        mem(34) :=              --        addi    $8, $8, 5       # $8(1) = $8(1) + 5 = 6 EXPTECTED TO SKIP
        mem(35) := 			    --tag3:   sw      $8, 74($0)      # $8(1) -> M[74 + $0(0) = 74] Test $15 - j
        
        mem(36) :=              --        addi    $9, $0, 0       # $9(1) = $0(0) + 0 = 0
        mem(37) :=              --        jal     tag4            # goto tag4
        mem(38) :=              --        addi    $8, $8, 5       # $8(1) = $8(1) + 5 = 6 EXPTECTED TO SKIP ON FIRST RUNTHROUGH
        mem(39) :=              --tag4:   sw      $8, 75($9)      # $8(1) -> M[75 + $9(0) = 75] and $8(6) -> M[75 + $9(1) = 76] Test #16 - jal and jr
        mem(40) :=              --        beq     $8, 6, tag5     # if $8(6) == 6 goto tag5
        mem(41) :=              --        addi    $9, $0, 1       # $9(0) = $0(0) + 1 = 1
        mem(42) :=              --        jr      $31             # goto $31
        
        mem(36) :=              --tag5:   bNal    $8, tag6        # if $8(6) is negative, goto tag6
        mem(36) :=              --        addi    $8, $0, -5      # $8(6) = $0(0) - 5 = -5
        mem(36) :=              --tag6:   sw      $8, 77($0)      # $8(-5) -> M[77 + $0(0) = 77] Test #17 - bNal
        mem(36) :=              --        bNal    $8, tag7        # if $8(-5) is negative, goto tag7
        mem(36) :=              --        addi    $8, $0, 5       # $8(6) = $0(0) - 5 = 5 EXPECTED TO SKIP
        mem(36) :=              --tag7:   sw      $8, 78($0)      # $8(-5) -> M[78 + $0(0) = 78] Test #18 - bNal
	-- read memory
		rd <= mem(CONV_INTEGER(a));
end process;
end;