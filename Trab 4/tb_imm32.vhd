--#################################################
--#* UNIVERSIDADE DE BRASÍLIA                     #               
--#* DEPARTAMENTO DE CIÊNCIA DA COMPUTAÇÃO        #                            
--#* ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES    #
--#*                                              #
--#* Trab IV: Testbench 						  #
--#*                                              # 
--#* Aluno: João Pedro de Oliveira Silva          #
--#* Matrícula: 190057807                         #
--#*                                              #
--#################################################
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity testbench is end;

architecture testb of testbench is


component genImm32 is port(
	instr: in std_logic_vector(31 downto 0);
    imm32: out signed(31 downto 0);
);

end component;

-- Sinais auxiliares para conectar nas entradas e saídas

signal instrut: std_logic_vector(31 downto 0);
signal imm: signed(31 downto 0);

begin

  trabalho4: genImm32 port map(instr => instrut, imm32 => imm);

  process
  begin
  	report "****Inicio do testbench****";
    
	-- Teste R-Type
    instrut <= x"000002b3";
    wait for 1 ns;
	assert(imm= x"00000000") report "Falha Teste R-Type";
    
	-- Teste I-Type0
    instrut <= x"01002283";
    wait for 1 ns;
	assert(imm = x"00000010") report "Falha Teste I-Type0 (lw)";
    
	-- Teste I-Type1
    instrut <= x"f9c00313";
    wait for 1 ns;
	assert(imm = x"ffffff9c") report "Falha Teste I-Type1(addi negativo)"; 
    
	-- Teste I-Type1
    instrut <= x"fff2c293";
    wait for 1 ns;
	assert(imm = x"ffffffff") report "Falha Teste I-Type1 (xori)";
    
	-- Teste I-Type1
    instrut <= x"16200313";
    wait for 1 ns;
	assert(imm = x"00000162") report "Falha Teste I-Type1 (addi)";
    
	-- Teste I-Type2
    instrut <= x"01800067";
    wait for 1 ns;
	assert(imm = x"00000018") report "Falha Teste I-Type2 (jalr)";
    
	-- Teste U-Type
    instrut <= x"00002437";
    wait for 1 ns;
	assert(imm = x"00002000") report "Falha Teste U-Type (lui)";
    
	-- Teste S-Type
    instrut <= x"02542e23";
    wait for 1 ns;
	assert(imm = x"000003c") report "Falha Teste S-Type (sw)";
    
	-- Teste SB-Type
    instrut <= x"fe5290e3";
    wait for 1 ns;
	assert(imm = x"ffffffe0") report "Falha Teste SB-Type (bne)";
    
	-- Teste UJ-Type
    instrut <= x"00c000ef";
    wait for 1 ns;
	assert(imm = x"0000000c") report "Falha Teste UJ-Type (jal)";    
    
	--
	instrut <= x"00000000";
    assert false report "****Fim dos testes****" severity note;
    wait;
  end process;
end testb;
