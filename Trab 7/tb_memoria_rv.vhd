--#################################################
--#* UNIVERSIDADE DE BRASÍLIA                     #               
--#* DEPARTAMENTO DE CIÊNCIA DA COMPUTAÇÃO        #                            
--#* ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES    #
--#*                                              #
--#* Trab VII: Testbench Memória RISC-V 		  #
--#*                                              # 
--#* Aluno: João Pedro de Oliveira Silva          #
--#* Matrícula: 190057807                         #
--#*                                              #
--#################################################

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity testbench is end;

architecture testb_mem of testbench is

	component rom_rv is 
		 port (
			address : in std_logic_vector(11 downto 0);;
			dataout : out std_logic_vector(31 downto 0);
		 );
	end component;

		component ram_rv is
		 port (
			clock : in std_logic;
			we : in std_logic;
			address : in std_logic_vector(11 downto 0);
			datain : in std_logic_vector(31 downto 0);;
			dataout : out std_logic_vector(31 downto 0)
		 );
	end component;
   
   	constant ram_depth : natural := 4096;
    constant ram_width : natural := 32;
    
    type ram_type is array (0 to ram_depth - 1)
  	of std_logic_vector(ram_width - 1 downto 0);

    impure function init_ram_hex(arquivo: string) return ram_type is
        file text_file : text open read_mode is arquivo;
        
        variable text_line : line;
        variable ram_content : ram_type;
        variable i : integer := 0;
        
      begin
         while not endfile(text_file) loop
            readline(text_file, text_line);
            hread(text_line, ram_content(i));
            i := i + 1;
        end loop;
        
        return ram_content;
    end function;

    signal ram_texto_hex : ram_type := init_ram_hex("texto.txt");
    signal ram_data_hex : ram_type := init_ram_hex("data.txt");

    signal clock: std_logic := '0';
    signal we: std_logic;
    signal address: std_logic_vector(11 downto 0);
    signal datain: std_logic_vector(31 downto 0);
    signal dataout: std_logic_vector(31 downto 0);

    begin
        trab7: ram_rv PORT MAP (clock => clock, we => we, address => address, datain => datain, dataout => dataout);

        clock <= not clock after 5 ns;
    
    estimulo: process
        begin
            address <= 12x"800";
            wren <= '1';
            for i in 0 to 2048 loop
                address <= std_logic_vector(to_unsigned(i, 12));
                datain <= ram_texto_hex(i);
                wait for 1 ns;
            end loop; 
            
            for i in 0 to 2048 loop
                address <= std_logic_vector(to_unsigned(2048 + i, 12));
                datain <= ram_data_hex(i);
                wait for 1 ns;
            end loop; 
        wait;
    end process;
end testb_mem;