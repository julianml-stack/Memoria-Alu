library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ouput_ports is
    Port (
        clock       : in  STD_LOGIC;
        reset       : in  STD_LOGIC;                 
        writen      : in  STD_LOGIC;
        address     : in  STD_LOGIC_VECTOR(7 downto 0);
        data_in     : in  STD_LOGIC_VECTOR(7 downto 0);
        port_out_00 : out STD_LOGIC_VECTOR(7 downto 0);
        port_out_01 : out STD_LOGIC_VECTOR(7 downto 0)
    );
end ouput_ports;

architecture arch of ouput_ports is
begin

    process (clock, reset)
    begin
        if (reset = '0') then
            port_out_00 <= (others => '0');
        elsif (clock'event and clock = '1') then
            if (address = x"E0" and writen = '1') then
                port_out_00 <= data_in;
            end if;
        end if;
    end process;

    process (clock, reset)
    begin
        if (reset = '0') then
            port_out_01 <= (others => '0');
        elsif (clock'event and clock = '1') then
            if (address = x"E1" and writen = '1') then
                port_out_01 <= data_in;
            end if;
        end if;
    end process;

end arch;
