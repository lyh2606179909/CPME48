----------------------------------------------------------------------------------
-- Company: Harbin Institute of Technology
-- Engineer: DeathKing<dk@hit.edu.cn>
-- 
-- Create Date:    15:13:38 07/09/2014 
-- Design Name: 
-- Module Name:    memctrl - Behavioral 
-- Project Name:   CPME48
-- Target Devices: 
-- Tool versions: 
-- Description: memctrl.vhd is memory control modular.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ABUS:  Address bus between memctrl and memory.
-- DBUS:  Data bus between memctrl and memory.
-- nMREQ: Memory selected.
-- nRD:   Memory read action.
-- nWR:   Memory write action.
-- nBHE:  Memory high byte access enable.
-- nLHE:  Memory low byte access enable.
entity memctrl is
    Port ( PC     : in    STD_LOGIC_VECTOR(15 downto 0);
           Addr   : in    STD_LOGIC_VECTOR(15 downto 0);
           ALUout : in    STD_LOGIC_VECTOR(7 downto 0);
           bst    : in    STD_LOGIC_VECTOR(3 downto 0);
			  rst    : in    STD_LOGIC;
           niRD   : in    STD_LOGIC;
           niWR   : in    STD_LOGIC;
           IRnew  : out   STD_LOGIC_VECTOR(15 downto 0);
           Rtemp  : out   STD_LOGIC_VECTOR(7 downto 0);
           nRD    : out   STD_LOGIC;
           nWR    : out   STD_LOGIC;
           nBHE   : out   STD_LOGIC;
           nLHE   : out   STD_LOGIC;
           nMREQ  : out   STD_LOGIC;
           ABUS   : out   STD_LOGIC_VECTOR(15 downto 0);
           DBUS   : inout STD_LOGIC_VECTOR(15 downto 0));
end memctrl;

architecture Behavioral of memctrl is

begin


	process (bst, PC, ADDR, DBUS, rst, niRD, niWR, ALUout)
	begin
		if rst = '1' then
			ABUS <= "0000000000000000";
			DBUS <= "ZZZZZZZZZZZZZZZZ";
		else
			case bst is
				when "1000" => nMREQ <= '0'; nLHE <= '0'; nBHE <= '0'; nRD <= '0'; nWR <= '1';
									ABUS  <= PC; IRnew(15 downto 0) <= DBUS(15 downto 0);
									DBUS <= (others => 'Z');
				when "0100" => DBUS  <= "ZZZZZZZZZZZZZZZZ";
									nMREQ <= '1'; nLHE <= '1'; nBHE <= '1'; nRD <= '1'; nWR <= '1';
				when "0010" => nMREQ <= '0'; nLHE <= '0'; nBHE <= '1'; ABUS <= ADDR; nRD <= niRD; nWR <= niWR;
					if niWR = '0' then
						DBUS(7 downto 0) <= ALUout(7 downto 0);
					elsif niRD = '0' then
						Rtemp(7 downto 0) <= DBUS(7 downto 0);
						DBUS <= (others => 'Z');
					end if;
				when "0001" => DBUS  <= "ZZZZZZZZZZZZZZZZ";
									nMREQ <= '1'; nLHE <= '1'; nBHE <= '1'; nRD <= '1'; nWR <= '1';
			when others => NULL;
			end case;
		end if;
	end process;
	
	

end Behavioral;

