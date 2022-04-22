--#################################################
--#* UNIVERSIDADE DE BRASÍLIA                     #               
--#* DEPARTAMENTO DE CIÊNCIA DA COMPUTAÇÃO        #                            
--#* ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES    #
--#*                                              #
--#* Trab V: Testbench Banco de Registradores 	  #
--#*                                              # 
--#* Aluno: João Pedro de Oliveira Silva          #
--#* Matrícula: 190057807                         #
--#*                                              #
--#################################################
ENTITY testbench IS END;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE std.textio.ALL;

entity testbench is
    generic (WSIZE : natural := 32);
end testbench;

ARCHITECTURE testb OF testbench IS
    
    
    -- Declaração do componente.
    component XREGS
    port (
        clk, wren, rst  : in std_logic;
        rs1, rs2, rd    : in std_logic_vector(4 downto 0);
        data            : in std_logic_vector(WSIZE-1 downto 0);
        ro1, ro2        : out std_logic_vector(WSIZE-1 downto 0)
    );
    end component;

	-- Sinais auxiliares 
    signal clk          : std_logic := '1';
    signal wren, rst    : std_logic := '0';
    signal rs1, rs2, rd : std_logic_vector(4 downto 0);
	signal data         : std_logic_vector(WSIZE-1 downto 0);
    signal ro1, ro2     : std_logic_vector(WSIZE-1 downto 0);  

    -- Variavel que finaliza a variação do clock quando em  false.
    shared variable enable : boolean := true;
begin

    trabalho5: XREGS port map(clk  => clk, wren => wren, rst  => rst, rs1  => rs1, rs2  => rs2, rd   => rd, ro1  => ro1, ro2  => ro2, data => data);

    -- Processo de geração do clock
    clock_process: process
    begin
        while enable loop
            wait for 0.5 ns;
            clk <= not clk;
        end loop;
        wait;
    end process clock_process;

    PROCESS 

        procedure write_to(
            f_rd   : std_logic_vector( 4 downto 0);
            f_data : std_logic_vector(31 downto 0)
        ) is
            begin
                wait until falling_edge(clk);
                wait for 0.25 ns;
                wren <= '1';
                rst  <= '0';
                rd   <= f_rd;
                data <= f_data;
                wait until rising_edge(clk);
                wait for 0.25 ns;
					wren <= '0';
        end procedure; 

        begin
            -- Inicialização
            wren <= '0';
            rd   <= "00000";
            rs1  <= "00000";
            rs2  <= "00000";
            data <= x"00000000";
            data <= x"00000000";

            -- Teste de reset
            rst  <= '1';
            wait until rising_edge(clk);
            wait for 0.25 ns;
			rst  <= '0';

            -- Teste de escrita em x0
            write_to("00000", x"ffff0002");
            assert ro1 = x"00000000" report "Escrita invalida no registrador x0" severity warning;
            assert ro2 = x"00000000" report "Escrita invalida no registrador x0" severity warning;
            
            rs1 <= "00001";
            rs2 <= "00010";

            -- Teste de escrita em x1
            write_to("00001", x"ffff0001");
            assert ro1 = x"ffff0001" report "Erro de escrita em x1" severity warning;

            -- Teste de escrita em x2
            write_to("00010", x"ffff0002");
            assert ro2 = x"ffff0002" report "Erro de escrita em x2" severity warning;
            
            -- Teste de reset
            rst  <= '1';
            wait until rising_edge(clk);
            wait for 0.25 ns;
			assert ro1 = x"00000000" report "Erro em reset" severity warning;
			assert ro2 = x"00000000" report "Erro em reset" severity warning;

            enable := false;
            wait;
    end PROCESS; 

end testb;