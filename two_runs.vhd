
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
 
entity custom_tb is
end custom_tb;
 
architecture custom_tb_arch of custom_tb is

    constant CLOCK_PERIOD : time := 20 ns;

    -- Signals to be connected to the component
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
 
    -- Signals for the memory
    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    -- Memory
    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");
    
    --signal count : std_logic_vector(15 downto 0);
    --signal state : std_logic_vector(5 downto 0);
 
    
    type scenario_config_type is array (0 to 16) of integer;
    
    -- Scenario 1
    constant SCENARIO_LENGTH : integer := 24;
    constant SCENARIO_LENGTH_STL : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(SCENARIO_LENGTH, 16));
    type scenario_type is array (0 to SCENARIO_LENGTH-1) of integer;

    signal scenario_config : scenario_config_type := (to_integer(unsigned(SCENARIO_LENGTH_STL(15 downto 8))),   -- K1
                                                      to_integer(unsigned(SCENARIO_LENGTH_STL(7 downto 0))),    -- K2
                                                      0,                                                        -- S
                                                      0, -1, 8, 0, -8, 1, 0, 1, -9, 45, 0, -45, 9, -1           -- C1-C14
                                                      );
    signal scenario_input : scenario_type := (32, -24, -35,   0, 46, -54, -39, -22, -53, -47,  12, 11,  11, 45, -30, -14, -35, -25, -19, -35, -41, -61, -24, -62);
    signal scenario_output : scenario_type :=(11,  43, -13, -54, 33,  53, -28,   8,  18, -38, -31,  7, -24, 23,  33,  -1,   7, -11,   5,  10,  15, -12,   3, -10);
    
    constant SCENARIO_ADDRESS : integer := 1234;    -- This value may arbitrarily change
    
    -- Scenario 2
    constant SCENARIO_LENGTH_2 : integer := 400;
    constant SCENARIO_LENGTH_STL_2 : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(SCENARIO_LENGTH_2, 16));
    type scenario_type_2 is array (0 to SCENARIO_LENGTH_2-1) of integer;
    
    signal scenario_config_2 : scenario_config_type := (to_integer(unsigned(SCENARIO_LENGTH_STL_2(15 downto 8))),   -- K1
                                                      to_integer(unsigned(SCENARIO_LENGTH_STL_2(7 downto 0))),    -- K2
                                                      65,                                     -- S
                                                      0, -1, 8, 0, -8, 1, 0, 1, -9, 45, 0, -45, 9, -1                                 -- C1-C14
                                                      );
    signal scenario_input_2 : scenario_type_2 := (20, 18, 24, -10, 48, -124, 35, -108, -71, -43, 109, -85, 75, 75, -101, 99, 51, 17, -111, 42, -61, 121, -37, -10, -3, -57, -8, 84, -97, 81, 12, 105, 6, 43, 81, -122, -117, -120, -103, -127, 22, -99, 79, -12, 92, 21, 31, -122, -29, 86, 113, 63, -32, 43, 34, -48, -33, -54, -123, -17, 48, 76, -10, -24, -103, 81, 11, -8, 27, -18, 123, 41, 113, 109, 109, -60, 76, 112, 102, 48, -4, 22, 31, -33, 91, -25, 78, 62, -24, 36, 59, -7, -48, 65, -49, -78, -56, -128, -51, 53, -86, -26, -1, -38, -17, -18, 126, 81, -105, 69, -82, -56, -90, 12, 113, -46, -46, 79, 41, 115, -81, -86, -124, 119, 100, -53, -42, 112, 53, -16, 54, -1, -31, -41, -85, -118, -1, 26, -101, 56, 8, -57, -120, 20, -124, 26, 103, -60, -126, -113, -24, -96, 16, 27, -64, 58, 71, -111, 115, 21, -3, -5, 30, 59, 122, 72, 55, 108, -114, -9, -30, -97, -57, 118, -72, 57, 101, -23, 62, 1, -108, -125, 86, 3, -121, -7, -49, -128, -8, -40, -98, -123, 104, -92, -8, 77, -86, -64, -69, -3, -17, 81, 106, -92, -65, 15, -13, 65, 111, 80, 114, -117, -15, 87, 73, 93, 79, -35, 97, -113, 82, -100, 31, 69, -106, 101, 48, -73, -81, 32, -122, -66, 12, 88, 104, -26, -45, 116, 33, 21, 38, 127, -48, -4, -65, -1, -11, 127, -50, -64, 93, -87, 125, -24, 126, 78, -82, -125, -80, 36, -22, -41, -97, -127, 94, 114, -22, -62, 0, 19, -13, 86, -114, -88, 85, -48, 13, -51, 32, 19, 3, 91, 118, -23, 102, -95, -122, -82, -62, 64, -59, 10, -78, -123, -52, -108, 54, -53, 58, -66, -98, 107, -114, -51, -48, 12, -17, 36, 31, -71, 80, 63, 127, 57, -108, -114, -16, -117, 105, -98, -19, -39, -69, 54, 99, -96, 42, 56, 5, 69, 61, 99, 43, 7, 79, 118, -124, -88, -19, 22, 74, -94, 18, -5, -24, -78, -100, 111, 108, -31, 82, 90, 40, -69, -68, 1, 122, 115, 18, 72, 4, -40, -58, 113, -106, -90, -79, -83, -83, 111, -23, -114, 100, -18, 105, 100, 103, -71, 38, 84, -125, 89, 12, 33, -22, 21, -85, -52, 32, -123, -3, 65, 53, 113, -61, 39, -38, 88, 58, 28);
    signal scenario_output_2 : scenario_type_2 := (-9, -4, 26, -39, 88, -3, -28, 89, -37, -128, 49, 42, -128, 127, -22, -119, 59, 111, -35, -20, -46, -26, 107, -52, 39, 18, -120, 86, 2, -77, -1, -3, 59, -87, 108, 125, -25, -9, 25, -92, 4, -27, -56, 7, -30, 30, 87, 54, -128, -76, 13, 99, 5, -62, 69, 36, -17, 71, -17, -108, -52, 41, 49, 70, -73, -82, 85, -29, 24, -65, -32, 24, -52, -10, 119, 24, -127, -1, 34, 65, 10, -37, 56, -53, 0, 24, -82, 85, 15, -70, 27, 83, -68, -7, 107, -23, 37, 15, -128, 40, 64, -77, 20, 9, 2, -87, -88, 127, -21, -34, 96, -5, -19, -128, 46, 126, -105, -37, -30, 66, 124, 30, -123, -128, 127, 102, -127, -63, 108, -17, -20, 61, 10, 23, 60, -51, -111, 98, -21, -91, 80, 90, -76, 13, 28, -128, 65, 127, 22, -79, 6, -9, -99, 80, -13, -122, 127, -39, -108, 104, 3, -18, -29, -57, -7, 59, -60, 115, 76, -91, 73, 38, -128, 31, 66, -128, 80, 21, -45, 111, 96, -128, -96, 127, -11, -71, 107, -35, -70, 64, 77, -128, -10, 112, -128, 64, 94, -24, -35, -20, -36, -105, 121, 116, -96, -14, -13, -85, 9, -28, 127, 97, -128, -32, 7, -24, 102, -43, 61, 2, -21, 68, -128, 127, -21, -128, 127, 86, -100, 31, 83, -94, -79, -63, 73, 114, -114, -49, 80, -1, -89, 61, 81, -5, 3, -20, -91, 17, 127, -128, 45, -20, -43, 26, -106, 127, 119, -4, -108, -29, 54, 28, 79, -119, -128, 94, 114, -28, -58, 32, -65, 57, 127, -128, -8, 56, -7, -2, -55, 40, -40, -92, 100, -12, 20, 127, -35, -18, -100, 10, 38, -13, 103, -38, 9, -70, -25, 3, -15, 127, -128, 15, 123, -64, -30, -11, -5, -49, 93, -34, -86, -12, -22, 127, 108, -93, 36, -89, -14, 104, -72, 59, -51, -128, 126, 41, -127, 52, -9, -35, -14, 2, 70, -20, -104, 127, 127, -92, -48, -72, 90, 37, -78, 36, 32, 72, -120, -128, 127, 13, -96, 27, 95, 65, -40, -113, -74, 86, 14, -9, 72, 54, -127, 29, 127, -48, -1, 30, -128, -52, 127, -113, -52, 25, -88, -5, 115, 49, -128, 127, -8, -108, 57, 13, -2, 34, 64, -108, 63, 40, -128, -4, -46, 81, 40, -20, -17, -73, 51, 28);
 
    constant SCENARIO_ADDRESS_2 : integer := 3792;    
    signal memory_control : std_logic := '0';      -- A signal to decide when the memory is accessed
                                                   -- by the testbench or by the project
 
    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
 
                o_done : out std_logic;
 
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;
 
begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
 
                o_done => tb_done,
 
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );
 
    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;
 
    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
 
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
 
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;
 
        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
 
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;
 
        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_rst <= '1';
 
        -- Wait some time for the component to reset...
        wait for 50 ns;
 
        -- Inizio della prima esecuzione
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
 
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock
 
        -- inizializzazione della memoria con la configurazione del primo scenario
        for i in 0 to 16 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_config(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
 
        -- inizializzazione della memoria con la sequenza di dati del primo scenario
        for i in 0 to SCENARIO_LENGTH-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+17+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
 
        wait until falling_edge(tb_clk);
 
        memory_control <= '1';  -- Memory controlled by the component
 
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
 
        tb_start <= '1';
 
        -- aspetta in segnale di "done" del componente
        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;
 
        wait for 5 ns;
 
        tb_start <= '0';
 
        wait until tb_done = '0';
        
        wait for 50 ns;
        
        -- Inizio della seconda esecuzione
        
        memory_control <= '0'; -- memory controlled by the tb
        
        wait until falling_edge(tb_clk);
        
        -- inizializzazione della memoria con la configurazione dello scenario 2
        for i in 0 to 16 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS_2+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_config_2(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
 
        -- inizializzazione della memoria con la sequenza di dati dello scenario 2
        for i in 0 to SCENARIO_LENGTH_2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS_2+17+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input_2(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);
        end loop;
        
        wait until falling_edge(tb_clk);
        
        memory_control <= '1'; -- memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS_2, 16));
        
        tb_start <= '1';
        
        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;
 
        wait for 5 ns;
 
        tb_start <= '0';
        
        wait;
 
    end process;
 
    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin
 
        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';
 
        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
 
        wait until rising_edge(tb_start);
 
        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;
 
        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;
 
        for i in 0 to SCENARIO_LENGTH-1 loop
            assert RAM(SCENARIO_ADDRESS+17+SCENARIO_LENGTH+i) = std_logic_vector(to_unsigned(scenario_output(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(17+SCENARIO_LENGTH+i) & " expected= " & integer'image(scenario_output(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(SCENARIO_ADDRESS+17+SCENARIO_LENGTH+i)))) severity failure;
        end loop;
 
        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done == 0 before start goes to zero" severity failure;
        wait until falling_edge(tb_done);
        
        -- Test del secondo scenario
        
        wait until rising_edge(tb_start);
 
        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;
 
        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;
 
        for i in 0 to SCENARIO_LENGTH_2-1 loop
            assert RAM(SCENARIO_ADDRESS_2+17+SCENARIO_LENGTH_2+i) = std_logic_vector(to_unsigned(scenario_output_2(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(17+SCENARIO_LENGTH_2+i) & " expected= " & integer'image(scenario_output_2(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(SCENARIO_ADDRESS_2+17+SCENARIO_LENGTH_2+i)))) severity failure;
        end loop;
 
        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done == 0 before start goes to zero" severity failure;
        wait until falling_edge(tb_done);
 
        assert false report "TestBench passato! Simulation ended" severity failure;
    end process;
 
end architecture;

