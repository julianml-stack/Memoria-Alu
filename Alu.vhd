library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Alu is
    Port (
        A       : in  std_logic_vector(7 downto 0);
        B       : in  std_logic_vector(7 downto 0);
        Alu_sel : in  std_logic_vector(1 downto 0);
        
        O_flag  : out std_logic; 
        N_flag  : out std_logic;   
        Z_flag  : out std_logic;  
        C_flag  : out std_logic;  
        Z       : out std_logic_vector(7 downto 0); 
        
        dip0    : out std_logic_vector(6 downto 0);  
        dip1    : out std_logic_vector(6 downto 0); 
        dip2    : out std_logic_vector(6 downto 0); 
        dip3    : out std_logic_vector(6 downto 0) 
    );
end Alu;

architecture arch of Alu is
    
    function hex_to_7seg(hex : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable segs : std_logic_vector(6 downto 0);
    begin
        case hex is
            when "0000" => segs := "1000000";
            when "0001" => segs := "1111001";
            when "0010" => segs := "0100100";
            when "0011" => segs := "0110000";
            when "0100" => segs := "0011001";
            when "0101" => segs := "0010010"; 
            when "0110" => segs := "0000010";
            when "0111" => segs := "1111000";
            when "1000" => segs := "0000000";
            when "1001" => segs := "0010000";
            when "1010" => segs := "0001000";
            when "1011" => segs := "0000011";
            when "1100" => segs := "1000110";
            when "1101" => segs := "0100001";
            when "1110" => segs := "0000110";
            when "1111" => segs := "0001110";
            when others => segs := "1111111";
        end case;
        return segs;
    end function;
    
    signal Result : std_logic_vector(7 downto 0);
    signal NZVC   : std_logic_vector(3 downto 0);

begin

    ALU_PROCESS : process (A, B, Alu_sel)
        variable Sum_uns    : unsigned(8 downto 0);
        variable Diff_uns   : unsigned(8 downto 0);
        variable Temp_uns   : unsigned(8 downto 0);
    begin
        case Alu_sel is
            when "00" => 
                Sum_uns := unsigned('0' & A) + unsigned('0' & B);
                Result <= std_logic_vector(Sum_uns(7 downto 0));
                
                NZVC(3) <= Sum_uns(7);
                
                if (Sum_uns(7 downto 0) = x"00") then
                    NZVC(2) <= '1';
                else
                    NZVC(2) <= '0';
                end if;
                
                if ((A(7)='0' and B(7)='0' and Sum_uns(7)='1') or
                    (A(7)='1' and B(7)='1' and Sum_uns(7)='0')) then
                    NZVC(1) <= '1';
                else
                    NZVC(1) <= '0';
                end if;
                
                NZVC(0) <= Sum_uns(8);
                
            when "01" =>
                Diff_uns := unsigned('0' & A) - unsigned('0' & B);
                Result <= std_logic_vector(Diff_uns(7 downto 0));
                
                NZVC(3) <= Diff_uns(7);
                
                if (Diff_uns(7 downto 0) = x"00") then
                    NZVC(2) <= '1';
                else
                    NZVC(2) <= '0';
                end if;
                
                if ((A(7)='0' and B(7)='1' and Diff_uns(7)='1') or
                    (A(7)='1' and B(7)='0' and Diff_uns(7)='0')) then
                    NZVC(1) <= '1';
                else
                    NZVC(1) <= '0';
                end if;
                
                NZVC(0) <= Diff_uns(8);
                
            when others => 
                Result <= (others => '0');
                NZVC <= (others => '0');
        end case;
    end process ALU_PROCESS;

    N_flag <= NZVC(3);
    Z_flag <= NZVC(2);
    O_flag <= NZVC(1);  
    C_flag <= NZVC(0);
    
    Z <= Result;

    dip0 <= hex_to_7seg(Result(3 downto 0));
    
    dip1 <= hex_to_7seg(Result(7 downto 4));
    
    dip2 <= hex_to_7seg(B(3 downto 0)); 

    dip3 <= hex_to_7seg(B(7 downto 4)); 

end arch;