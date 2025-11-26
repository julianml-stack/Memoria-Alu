library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
    Port (
        address   : in  std_logic_vector(7 downto 0);
        data_in   : in  std_logic_vector(7 downto 0);
        writen    : in  std_logic;
        clock     : in  std_logic;
        reset     : in  std_logic;

        port_in_00 : in  std_logic_vector(7 downto 0);
        port_in_01 : in  std_logic_vector(7 downto 0);

        port_out_00 : out std_logic_vector(7 downto 0);
        port_out_01 : out std_logic_vector(7 downto 0);

        data_out : out std_logic_vector(7 downto 0)
    );
end memory;

architecture arch of memory is

    signal rom_data_out : std_logic_vector(7 downto 0);
    signal rw_data_out  : std_logic_vector(7 downto 0);
	 
	 component rom_128x8_sync is
    port (
        clock   : in  std_logic;
        address : in  std_logic_vector(7 downto 0);
        data_out: out std_logic_vector(7 downto 0)
    );
	end component;
	
	component rw_96x8_sync is
    port (
        clock    : in  std_logic;
		  writen   : in  std_logic;
        address  : in  std_logic_vector(7 downto 0);
        data_in  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
	end component;
	
	component ouput_ports is
    Port (
        clock       : in  STD_LOGIC;
        reset       : in  STD_LOGIC;                 
        writen      : in  STD_LOGIC;
        address     : in  STD_LOGIC_VECTOR(7 downto 0);
        data_in     : in  STD_LOGIC_VECTOR(7 downto 0);
        port_out_00 : out STD_LOGIC_VECTOR(7 downto 0);
        port_out_01 : out STD_LOGIC_VECTOR(7 downto 0)
    );
	end component;
	
	component memory_mux is
    Port (
        address      : in  STD_LOGIC_vector(7 downto 0);
        rom_data_out : in  STD_LOGIC_vector(7 downto 0);
        rw_data_out  : in  STD_LOGIC_vector(7 downto 0);
        port_in_00   : in  STD_LOGIC_vector(7 downto 0);
        port_in_01   : in  STD_LOGIC_vector(7 downto 0);
        data_out     : out STD_LOGIC_vector(7 downto 0)
    );
	end component;
begin

    U_ROM : rom_128x8_sync
        port map (
            address   => address,  
            clock     => clock,
            data_out  => rom_data_out
        );

    U_RAM : rw_96x8_sync
        port map (
            clock    => clock,
            writen   => writen,
            address  => address,
            data_in  => data_in,
            data_out => rw_data_out
        );



    U_OUTPUT_PORTS : ouput_ports
    port map(
        clock       => clock,
        reset       => reset,
        writen      => writen,      
        address     => address,
        data_in     => data_in,
        port_out_00 => port_out_00,
        port_out_01 => port_out_01
    );


    U_MUX : memory_mux
        port map(
            address      => address,
            rom_data_out => rom_data_out,
            rw_data_out  => rw_data_out,
            port_in_00   => port_in_00,
            port_in_01   => port_in_01,
            data_out     => data_out
        );

end arch;
