--#################################################
--#* UNIVERSIDADE DE BRASÍLIA                     #               
--#* DEPARTAMENTO DE CIÊNCIA DA COMPUTAÇÃO        #                            
--#* ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES    #
--#*                                              #
--#* Trab VI: Testbench ULA RISC-V 				  #
--#*                                              # 
--#* Aluno: João Pedro de Oliveira Silva          #
--#* Matrícula: 190057807                         #
--#*                                              #
--#################################################

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;

entity testbench is end;

architecture testb_ula of testbench is
    
    -- componente ULA
    component ulaRV is 
        generic (WSIZE : natural := 32);
        port (
          opcode : in std_logic_vector(3 downto 0);
          A, B : in std_logic_vector(WSIZE-1 downto 0);
          Z : out std_logic_vector(WSIZE-1 downto 0);
          zero : out std_logic
        );
    end component;

    --sinais auxiliares
    signal opcode: std_logic_vector(3 downto 0);
    signal A, B :std_logic_vector(31 downto 0);
    signal Z :std_logic_vector(31 downto 0);
    signal zero :std_logic;

    begin
    
        trab6: ulaRV PORT MAP (opcode => opcode, A => A, B => B, Z => Z, zero => zero);

    process
        begin
		-- ADD POSITIVO
            A <= 32x"4"; 
            B <= 32x"1";

            opcode <= "0000";
            wait for 1 ns;
            assert(Z = 32x"5") report "ERRO NO ADD POSITIVO";
			
		-- SUB POSITIVO
            opcode <= "0001";
            wait for 1 ns;
            assert(Z = 32x"3") report "ERRO NO SUB POSITIVO";
    ----------------------------------------------------------------------    
		-- ADD NEGATIVOS
            A <= x"FFFFAAAA"; 
            B <= x"FFFFBBBB";

            opcode <= "0000";
            wait for 1 ns;
            assert(Z = x"FFFF6665") report "ERRO NO ADD NEGATIVO";
			
		-- SUB NEGATIVO
            opcode <= "0001";
            wait for 1 ns;
            assert(Z = x"FFFFEEEF") report "ERRO NO SUB NEGATIVO";
	------------------------------------------------------------------------
        -- ADD ZERO
            A <= x"FFFF0000";
            B <= 32x"10000";
            
            opcode <= "0000";
            wait for 1 ns;
            assert(Z = 32x"0") report "ERRO NO ADD ZERO";
    ------------------------------------------------------------------------        
        -- SUB ZERO
        	A <= x"0000000F";
            B <= x"0000000F";
	
            opcode <= "0001";
            wait for 1 ns;
            assert(Z = 32x"0") report "ERRO NO SUB ZERO";             
    -------------------------------------------------------------------------                 
        -- AND
            A <= x"000000AA";
            B <= x"000000BB";
            
            opcode <= "0010";
            wait for 1 ns;
            assert(Z = x"000000AA") report "ERRO NO AND";
	-------------------------------------------------------------------------
        -- OR
            A <= x"00000055";
            B <= x"000002BB";
            
            opcode <= "0011";
            wait for 1 ns;
            assert(Z = x"000002FF") report "ERRO NO OR";
    -------------------------------------------------------------------------    
        -- XOR
            A <= x"00000CAA";
            B <= x"00000CBB";
            
            opcode <= "0100";
            wait for 1 ns;
            assert(Z = x"00000011") report "ERRO NO XOR";
    -------------------------------------------------------------------------    
        -- SLL
        	A <= x"00000AAF";
            B <= x"00000002";
            
            opcode <= "0101";
            wait for 1 ns;
            assert(Z = x"00002ABC") report "ERRO NO SLL";
    -------------------------------------------------------------------------    
        -- SRL
        	A <= x"0000BBBF";
            B <= x"00000003";
            
            opcode <= "0110";
            wait for 1 ns;
            assert(Z = x"00001777") report "ERRO NO SRL";
    --------------------------------------------------------------------------   
       -- SRA
        	A <= x"0000CCCF";
            B <= x"00000002";
            
            opcode <= "0111";
            wait for 1 ns;
            assert(Z = x"00003333") report "ERRO NO SRL";
    --------------------------------------------------------------------------   
       -- SLT
        	A <= x"FFFFFFC9";
            B <= x"FFFFFFD3";
            
            opcode <= "1000";
            wait for 1 ns;
            assert(Z = x"00000001") report "ERRO NO SLT";
    --------------------------------------------------------------------------    
       -- SLTU 
       		A <= 32x"15"; 
            B <= 32x"E21A";
               	            
            opcode <= "1001";
            wait for 1 ns;
            assert(Z = x"00000001") report "ERRO NO SLTU";
    --------------------------------------------------------------------------        
      -- SGE
      		A <= x"FFFFFF92";
            B <= x"FFFFFF2D";
               	            
            opcode <= "1010";
            wait for 1 ns;
            assert(Z = x"00000001") report "ERRO NO SGE";
    --------------------------------------------------------------------------  
      -- SGEU
      		A <= x"FFFFE21A"; 
            B <= 32x"15";
               	            
            opcode <= "1011";
            wait for 1 ns;
            assert(Z = x"00000001") report "ERRO NO SGEU";
    --------------------------------------------------------------------------        
      -- SEQ
      		A <= 32x"3E";
            B <= 32x"3E";
               	            
            opcode <= "1100";
            wait for 1 ns;
            assert(Z = x"00000001") report "ERRO NO SEQ";
    --------------------------------------------------------------------------        
      -- SNE
      		A <= 32x"3";
            B <= 32x"3E";
               	            
            opcode <= "1101";
            wait for 1 ns;
            assert(Z = x"00000001") report "ERRO NO SNE";
    --------------------------------------------------------------------------        	
            wait;
        end process;

end testb_ula;