library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
    port(clk   :   in std_logic;
         instruction:in std_logic_vector(15 downto 0);
         regDst, regWrite   :in std_logic;
	     data_write:in 	std_logic_vector(15 downto 0);
         read_data1:out std_logic_vector(15 downto 0);
         read_data2:out std_logic_vector(15 downto 0));
end regfile;

architecture simple of regfile is

    
    type reg_type is array (0 to 7) of std_logic_vector(15 downto 0);
    signal reg_arr : reg_type := (others => (others => '0'));
    signal read_reg1 : std_logic_vector(2 downto 0);
    signal read_reg2 : std_logic_vector(2 downto 0);
    signal reg_address: std_logic_vector(2 downto 0);
    begin

        decode : process(clk, regDst, regWrite)
            begin
                if rising_edge(clk) then             
                    if regWrite = '1' then
                        reg_arr(to_integer(unsigned(reg_address))) <= data_write;  -- data to get written back to array if regWrite = '1';
                    end if;
                    if regDst = '1' then 
                        reg_address <= instruction(5 downto 3); -- rd index(populate the register array with rd)
                    elsif regDst = '0' then
                        reg_address <= instruction(8 downto 6); -- rt index(populate the register array with rt)
                    end if;
                        read_reg1 <= instruction(11 downto 9); -- rs (address in register array) index for reading
                        read_reg2 <= instruction(8 downto 6);  -- rt (address in register array) index for reading    
                        -- read from register array                      
                end if;
        end process decode;
        read_data1 <= reg_arr(to_integer(unsigned(read_reg1)));
        read_data2 <= reg_arr(to_integer(unsigned(read_reg2)));          
end simple;
         
         
         