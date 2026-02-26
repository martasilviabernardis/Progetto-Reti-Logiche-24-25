library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
 
entity rst_during_run_then_rerun_new_scene is
end rst_during_run_then_rerun_new_scene;
 
architecture project_tb_arch of rst_during_run_then_rerun_new_scene is

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
 
    -- Scenario 1
    type scenario_config_type is array (0 to 16) of integer;
    constant SCENARIO_LENGTH : integer := 200;
    constant SCENARIO_LENGTH_STL : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(SCENARIO_LENGTH, 16));
    type scenario_type is array (0 to SCENARIO_LENGTH-1) of integer;
    
    signal scenario_config : scenario_config_type := (to_integer(unsigned(SCENARIO_LENGTH_STL(15 downto 8))),   -- K1
                                                      to_integer(unsigned(SCENARIO_LENGTH_STL(7 downto 0))),    -- K2
                                                      206,                                     -- S
                                                      0, -1, 8, 0, -8, 1, 0, 1, -9, 45, 0, -45, 9, -1                                 -- C1-C14
                                                      );
    signal scenario_input : scenario_type := (42, -122, 108, -6, 15, -111, 6, 57, -15, 25, -65, 3, 21, -47, -39, -88, -116, 121, -41, 21, 42, -82, -88, 58, -64, -18, -42, 70, 87, 37, -80, -46, -28, -80, -95, -30, 75, -31, -24, 94, -42, -81, 77, -95, -41, 93, 4, 44, -23, 47, 87, 79, -19, -119, 62, -88, -3, -41, -117, -57, 50, -127, 126, -76, 60, 36, 116, -72, 80, 109, 24, 38, -73, 89, -72, -70, -124, 50, -104, 16, 70, 68, 116, 2, -58, -4, -1, -77, -113, 31, 78, 77, -111, 68, -126, -49, 86, -10, -34, -44, 120, 80, 121, -106, -17, -71, -24, 31, 95, -88, 56, 106, 40, 93, -68, -86, 108, 93, -22, 61, -122, -125, 79, 11, 57, -61, -104, 77, -39, -77, 24, 110, -68, -66, 26, -71, -52, 72, 64, 10, 113, -6, -45, 122, -47, -109, 71, -70, 52, -32, 120, 84, 40, -12, 76, -111, 66, -90, -61, 123, 40, 86, 90, 78, 7, -73, -7, 90, -28, -68, 62, -4, -44, 66, 117, -45, 18, 59, -42, -44, -97, 14, 61, -45, 42, 5, 122, 96, 12, 11, 106, 99, -119, 110, 85, 11, -99, -67, -111, 35);
    signal scenario_output : scenario_type := (88, -43, -76, 60, 59, 10, -112, 24, 13, 27, 16, -60, 33, 31, 13, 64, -128, -38, 76, -70, 63, 88, -100, -8, 52, -12, -44, -79, 17, 100, 44, -43, 21, 44, -23, -107, 5, 74, -91, 6, 122, -93, 8, 91, -128, -16, 32, 12, 3, -68, -18, 54, 127, -65, -17, 48, -44, 75, 13, -116, 65, -50, -31, 55, -73, -34, 71, 28, -127, 44, 32, 60, -39, -8, 100, 29, -79, -5, 37, -112, -15, -29, 32, 108, -5, -43, 43, 75, -64, -112, -28, 127, -10, 0, 92, -128, -16, 78, 24, -93, -68, -5, 111, 76, -33, 15, -55, -78, 85, 31, -128, 24, -1, 54, 122, -114, -113, 97, 1, 47, 127, -128, -73, 18, 31, 111, -97, -43, 112, -37, -124, 59, 116, -75, 3, 60, -91, -68, 53, -37, 1, 113, -96, -6, 127, -92, -16, 17, -18, -31, -75, 53, 58, -38, 66, 0, -24, 102, -128, -50, 34, -34, 1, 39, 91, 8, -109, 12, 109, -65, -42, 79, -39, -109, 76, 64, -79, 38, 57, 31, -28, -103, 49, 10, -27, -39, -60, 71, 53, -59, -68, 127, -7, -128, 65, 106, 33, 8, -57, -66);

    constant SCENARIO_ADDRESS : integer := 1000;

    -- Scenario 2
    constant SCENARIO_LENGTH_2 : integer := 200;
    constant SCENARIO_LENGTH_STL_2 : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(SCENARIO_LENGTH_2, 16));
    type scenario_type_2 is array (0 to SCENARIO_LENGTH_2-1) of integer;
    
    signal scenario_config_2 : scenario_config_type := (to_integer(unsigned(SCENARIO_LENGTH_STL_2(15 downto 8))),   -- K1
                                                      to_integer(unsigned(SCENARIO_LENGTH_STL_2(7 downto 0))),    -- K2
                                                      207,                                     -- S
                                                      0, -1, 8, 0, -8, 1, 0, 1, -9, 45, 0, -45, 9, -1                                 -- C1-C14
                                                      );
    signal scenario_input_2 : scenario_type_2 := (-27, 112, -54, 25, -103, -99, -71, -21, -7, -6, 20, -4, 32, 40, -55, 1, -92, 48, 118, 108, -25, 6, 68, -7, 22, -125, -23, 106, 47, -98, -70, -1, -46, 104, -71, 79, 101, -59, -104, -78, 75, -81, 67, 55, 95, 41, -4, -126, 5, 40, -107, -113, 117, 120, 46, -86, 53, -124, -50, 33, -38, -114, -85, -102, -80, 87, -121, -57, 54, 35, -63, 87, -116, 52, 25, 66, 109, 6, -111, 62, 7, 5, -54, 66, -80, -87, -16, 109, -39, 126, -108, 101, 55, -97, -92, 47, -33, 12, -54, 35, -87, 28, -120, 35, -5, 70, -2, -88, 45, -56, 32, -11, -111, -4, 115, 28, -69, -91, -13, 100, -54, 52, 115, 117, 87, -81, -4, 81, -67, -23, -11, -27, -122, 17, -5, -82, 98, -35, -116, -53, 20, 29, -109, -63, 94, 37, -20, 73, 73, -15, 102, -112, 112, 83, 21, 59, -73, 68, -41, 5, -44, -102, -24, -82, 43, -106, 65, 48, -115, 42, -43, 48, 106, 116, -124, -76, 58, -22, -27, -77, -27, -78, -28, -73, 69, -51, 34, -38, -113, -62, 103, -45, 63, -126, -3, 2, 114, 52, 4, 120);
    signal scenario_output_2 : scenario_type_2 := (-91, 25, 55, 5, 91, -30, -42, -35, 0, -19, 3, -1, -43, 66, 9, 26, -9, -128, -34, 97, 69, -85, 20, 13, 72, 49, -128, -45, 127, 71, -86, 13, -80, 27, 41, -128, 100, 126, 12, -128, 25, 22, -99, -1, 0, 47, 111, -3, -128, 82, 126, -128, -128, 54, 127, -38, 14, 95, -128, -4, 104, 14, -15, 27, -128, 34, 124, -128, -59, 108, -65, 42, 38, -110, 24, -69, 23, 127, -55, -85, 49, 44, -55, 5, 117, -41, -128, 48, -28, 48, 36, -128, 127, 99, -119, -25, 28, 13, -24, 27, -4, 23, 6, -80, -6, -22, 126, -54, -17, 22, -57, 112, 5, -128, -15, 122, 68, -27, -128, 48, 51, -124, -24, 0, 127, 64, -128, 56, 75, -55, -3, 87, -30, -96, 106, -83, -49, 127, 0, -88, -59, 91, 77, -128, -61, 102, -30, -76, 86, -51, 77, 7, -128, 95, -11, 70, -13, -30, 53, -23, 83, -28, 0, -52, 28, 4, -128, 127, -13, -54, 26, -99, -60, 127, 127, -128, -22, 61, 27, -6, 1, 0, 9, -69, -7, 31, -36, 107, 27, -128, 14, 18, 43, 55, -89, -59, -40, 98, -66, -2);

    constant SCENARIO_ADDRESS_2 : integer := 4000;
    
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
 
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
 
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock
 
 
        for i in 0 to 16 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_config(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
 
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

        for i in 0 to 200 loop
            wait until rising_edge(tb_clk);
        end loop;

        tb_rst <= '1';
        tb_start <= '0';       

        wait for 50 ns;
 
        tb_rst <= '0';

        memory_control <= '0';  -- Memory controlled by the testbench
 
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock
 
        for i in 0 to 16 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS_2+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_config_2(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
 
        for i in 0 to SCENARIO_LENGTH_2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS_2+17+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input_2(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
 
        wait until falling_edge(tb_clk);
 
        memory_control <= '1';  -- Memory controlled by the component
 
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
 
        for i in 0 to SCENARIO_LENGTH_2-1 loop
            assert RAM(SCENARIO_ADDRESS_2+17+SCENARIO_LENGTH_2+i) = std_logic_vector(to_unsigned(scenario_output_2(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(17+SCENARIO_LENGTH_2+i) & " expected= " & integer'image(scenario_output_2(i)) & " actual=" & integer'image(to_integer(signed(RAM(SCENARIO_ADDRESS_2+17+SCENARIO_LENGTH_2+i)))) severity failure;
            end loop;
 
        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done == 0 before start goes to zero" severity failure;
        wait until falling_edge(tb_done);
 
        assert false report "Simulation Ended! TEST PASSATO" severity failure;
    end process;
 
end architecture;
