library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memoria_prueba is
    Port (
        
        address   : in  std_logic_vector(7 downto 0);
        data_in   : in  std_logic_vector(7 downto 0);
        writen    : in  std_logic;
        clock     : in  std_logic;
        reset     : in  std_logic; 
        sw_port00 : in std_logic;
        sw_port01 : in std_logic;
		  
        led_port00 : out std_logic;
        led_port01 : out std_logic;
        dis1 : out std_logic_vector(6 downto 0);
        dis2 : out std_logic_vector(6 downto 0);
        dis3 : out std_logic_vector(6 downto 0);
        dis4 : out std_logic_vector(6 downto 0)
    );
end memoria_prueba;


architecture arch of memoria_prueba is
    signal data_out : std_logic_vector(7 downto 0);
    signal port_in_00 : std_logic_vector(7 downto 0);
    signal port_in_01 : std_logic_vector(7 downto 0);

begin
    port_in_00 <= (7 downto 1 => '0') & sw_port00;
    port_in_01 <= (7 downto 1 => '0') & sw_port01;

    MEM : entity work.memory
        port map(
            clock       => clock,
            reset       => reset,
            writen      => writen,
            address     => address,
            data_in     => data_in,
            data_out    => data_out,
            port_in_00  => port_in_00,
            port_in_01  => port_in_01,
            port_out_00 => open,
            port_out_01 => open
        );
    led_port00 <= '1' when 
                     (address = x"E0" and writen = '1' and data_in /= x"00")
                  else '0';

    led_port01 <= '1' when 
                     (address = x"E1" and writen = '1' and data_in /= x"00")
                  else '0';
    U_H1 : entity work.deco7seg port map(
        hex => address(7 downto 4),
        seg => dis1
    );

    U_H0 : entity work.deco7seg port map(
        hex => address(3 downto 0),
        seg => dis2
    );

    U_H3 : entity work.deco7seg port map(
        hex => data_out(7 downto 4),
        seg => dis3
    );

    U_H2 : entity work.deco7seg port map(
        hex => data_out(3 downto 0),
        seg => dis4
    );

end arch;
