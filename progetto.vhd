library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_add : in std_logic_vector (15 downto 0);
        o_done : out std_logic;
        o_mem_addr : out std_logic_vector (15 downto 0);
        i_mem_data : in std_logic_vector (7 downto 0);
        o_mem_data : out std_logic_vector (7 downto 0);
        o_mem_we : out std_logic;
        o_mem_en : out std_logic
    );
 end project_reti_logiche;
 
architecture project_reti_logiche_arc of project_reti_logiche is
 component datapath is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_ordine_filtro : in std_logic;
        i_seq_filter : in std_logic_vector(7 downto 0);
        i_scorr_filter : in std_logic;
        i_load_mult_res : in std_logic;
        i_load_sum1 : in std_logic;
        i_load_sum2 : in std_logic;
        i_load_sum3 : in std_logic;
        i_seq_data : in std_logic_vector(7 downto 0);
        i_scorr_data : in std_logic;
        i_load_shift_res0 : in std_logic;
        i_load_shift_res1 : in std_logic;
        i_load_shift_res2 : in std_logic;
        i_load_res : in std_logic;
        o_val_data : out std_logic_vector(7 downto 0)
    );
end component;
component counter is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_restart : in std_logic;
        i_inc : in std_logic;
        o_cont : out std_logic_vector(15 downto 0)
    );
end component;
    signal i_ordine_filtro : std_logic;
    signal i_seq_filter : std_logic_vector(7 downto 0);
    signal i_scorr_filter : std_logic;
    signal i_load_mult_res : std_logic;
    signal i_load_sum1, i_load_sum2, i_load_sum3 : std_logic;
    signal i_seq_data : std_logic_vector(7 downto 0);
    signal i_scorr_data : std_logic;
    signal i_load_shift_res0, i_load_shift_res1, i_load_shift_res2 : std_logic;
    signal i_load_res : std_logic;
    signal o_val_data : std_logic_vector(7 downto 0);
    signal i_restart_count, i_restart_count_aux : std_logic;
    signal i_inc_count, i_inc_count_aux : std_logic;
    signal o_count, o_count_aux : std_logic_vector(15 downto 0);
    type S is (s0,s0a,s1,s2a,s2a1,s2a2,s2b,s2b1,s2b2,s3,s3a,s3b,s40,s40a,s40b,s40c,s41,s41a,s41b,s41c,s50,s50a,s50b,s50c,s51,s51a,s51b,s51c,s60,s61,s70,s70a,s70b,s71,s71a,s71b,s80a,s80b,s80c,s80d,s81a,s81b,s81c,s81d,s90,s90a,s90b,s90c,s90d,s90e,s91,s91a,s91b,s91c,s91d,s91e,s10,s110,s111,serr);
    signal curr_state, next_state : S;
    signal k : std_logic_vector(15 downto 0);
    signal add : std_logic_vector(15 downto 0);
    signal o_state : std_logic_vector(5 downto 0);
    
begin
    DATAPATH0 : datapath port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_ordine_filtro => i_ordine_filtro,
        i_seq_filter => i_seq_filter,
        i_scorr_filter => i_scorr_filter,
        i_load_mult_res => i_load_mult_res,
        i_load_sum1 => i_load_sum1,
        i_load_sum2 => i_load_sum2,
        i_load_sum3 => i_load_sum3,
        i_seq_data => i_seq_data,
        i_scorr_data => i_scorr_data,
        i_load_shift_res0 => i_load_shift_res0,
        i_load_shift_res1 => i_load_shift_res1,
        i_load_shift_res2 => i_load_shift_res2,
        i_load_res => i_load_res,
        o_val_data => o_val_data
    );
    COUNTER0 : counter port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_restart => i_restart_count,
        i_inc => i_inc_count,
        o_cont => o_count
    );
    
    COUNTER1 : counter port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_restart => i_restart_count_aux,
        i_inc => i_inc_count_aux,
        o_cont => o_count_aux
    );
    
    -- o_count_check <= o_count;
        
        
        process(i_clk, i_rst)
        begin
            if(i_rst='1') then curr_state <= s0;
            elsif i_clk'event and i_clk='1' then curr_state <= next_state;
            end if;
        end process;
        
        process(curr_state, i_start, o_count, o_count_aux)
        begin
            case curr_state is
                when s0 =>
                    o_state <= "000000";
                    if(i_start = '1') then
                        next_state <= s0a;
                    elsif(i_start = '0') then
                        next_state <= s0;
                    end if;
                when s0a =>
                    o_state <= "111011";
                    next_state <= s1;
                when s1 =>
                    o_state <= "000001";
                    next_state <= s2a;
                when s2a =>
                    o_state <= "000010";
                    next_state <= s2a1;
                when s2a1 =>
                    o_state <= "010110";
                    next_state <= s2a2;
                when s2a2 =>
                    o_state <= "110101";
                    next_state <= s2b;
                when s2b =>
                    o_state <= "000011";
                    next_state <= s2b1;
                when s2b1 =>
                    o_state <= "010111";
                    next_state <= s2b2;
                when s2b2 =>
                    o_state <= "110110";
                    next_state <= s3;
                when s3 =>
                    o_state <= "000100";
                    next_state <= s3a;
                when s3a =>
                    o_state <= "011000";
                    next_state <= s3b;
                when s3b =>
                    o_state <= "011001";
                    if(i_ordine_filtro = '0') then
                        next_state <= s40;
                    elsif(i_ordine_filtro = '1') then
                        next_state <= s41;
                    else next_state <= serr;
                    end if;
                when s40 =>
                    o_state <= "000101";
                    next_state <= s40a;
                when s40a => 
                    o_state <= "011100";
                    next_state <= s40b;
                when s40b =>
                    o_state <= "011010";
                    if(unsigned(o_count) = 7) then
                        next_state <= s40c;
                    else
                        next_state <= s40;
                    end if;
                when s40c =>
                    o_state <= "000110";
                    next_state <= s50;
                when s41 =>
                    o_state <= "000111";
                    next_state <= s41a;
                when s41a =>
                    o_state <= "011101";
                    next_state <= s41b;
                when s41b =>
                    o_state <= "011110";
                    if(unsigned(o_count) = 7) then
                        next_state <= s41c;
                    else
                        next_state <= s41;
                    end if;
                when s41c =>
                    o_state <= "001000";
                    next_state <= s51;
                when s50 =>
                    o_state <= "001001";
                    next_state <= s50a;
                when s50a =>
                    o_state <= "100000";
                    next_state <= s50b;
                when s50b =>
                    o_state <= "100001";
                    if(unsigned(o_count) = 4) then
                        next_state <= s50c;
                    else
                        next_state <= s50;
                    end if;
                when s50c =>
                    o_state <= "001010";
                    next_state <= s60;
                    
                 when s51 =>
                    o_state <= "001011";
                    next_state <= s51a;
                when s51a =>
                    o_state <= "100010";
                    next_state <= s51b;
                when s51b =>
                    o_state <= "100001";
                    if(unsigned(o_count) = 4) then
                        next_state <= s51c;
                    else
                        next_state <= s51;
                    end if;
                when s51c =>
                    o_state <= "001100";
                    next_state <= s61;
                when s60 =>
                    o_state <= "001101";
                    next_state <= s70;
                when s61 =>
                    o_state <= "001110";
                    next_state <= s71;
                when s70 =>
                    o_state <= "001111";
                    next_state <= s70a;
                when s70a =>
                    o_state <= "100011";
                    next_state <= s70b;
                when s70b =>
                    o_state <= "100100";
                    next_state <= s80a;
                when s71 =>
                    o_state <= "010000";
                    next_state <= s71a;
                when s71a =>
                    o_state <= "100101";
                    next_state <= s71b;
                when s71b =>
                    o_state <= "100110";
                    next_state <= s81a;
                when s80a =>
                    o_state <= "100111";
                    next_state <= s80b;
                when s80b =>
                    o_state <= "101000";
                    next_state <= s80c;
                when s80c =>
                    o_state <= "101001";
                    next_state <= s80d;
                when s80d =>
                    o_state <= "010001";
                    next_state <= s90;
                when s81a =>
                    o_state <= "101010";
                    next_state <= s81b;
                when s81b =>
                    o_state <= "101011";
                    next_state <= s81c;
                when s81c =>
                    o_state <= "101100";
                    next_state <= s81d;
                when s81d =>
                    o_state <= "010010";
                    next_state <= s91;
                when s90 =>
                    o_state <= "010011";
                    next_state <= s90a;
                when s90a =>
                    o_state <= "110011";
                    next_state <= s90b;
                when s90b =>
                    o_state <= "111010";
                    next_state <= s90c;
                when s90c =>
                    o_state <= "101101";
                    if(unsigned(o_count) >= unsigned(k) - 3 or signed(k)-3 < 0) then
                        next_state <= s110;
                    else
                        next_state <= s90d;
                    end if;
                when s90d =>
                    o_state <= "101110";
                    next_state <= s90e;
                when s90e =>
                    o_state <= "101111";
                    next_state <= s60;
                when s91 =>
                    o_state <= "010100";
                    next_state <= s91a;
                when s91a =>
                    o_state <= "110100";
                    next_state <= s91b;
                when s91b =>
                    o_state <= "111010";
                    next_state <= s91c;
                when s91c =>
                    o_state <= "110000";
                    if(unsigned(o_count) >= unsigned(k) - 3 or signed(k)-3 < 0) then
                        next_state <= s111;
                    else
                        next_state <= s91d;
                    end if;
                when s91d =>
                    o_state <= "110001";
                    next_state <= s91e;
                when s91e =>
                    o_state <= "110010";
                    next_state <= s61;
                when s10 =>
                    o_state <= "010101";
                    if(i_start = '1') then
                        next_state <= s10;
                    elsif (i_start = '0') then
                        next_state <= s0;
                    end if;
                when s110 =>
                    o_state <= "110111";
                    if(unsigned(o_count_aux) = 3 or (signed(k) = 2 and unsigned(o_count_aux) = 1) or (signed(k) = 3 and unsigned(o_count_aux) = 2)) then
                        next_state <= s10;
                    else
                        next_state <= s60;
                    end if;
                when s111 =>
                    o_state <= "111000";
                    if(unsigned(o_count_aux) = 3 or (signed(k) = 2 and unsigned(o_count_aux) = 1) or (signed(k) = 3 and unsigned(o_count_aux) = 2)) then
                        next_state <= s10;
                    else
                        next_state <= s61;
                    end if;
                when serr =>
                    o_state <= "111111";
                    next_state <= serr;
                when others =>
                    next_state <= serr;
            end case;
        end process;
        
        process(curr_state, o_count)
        begin
            case curr_state is
                when s0 =>
                -- stato di reset: inizializza tutti i segnali
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_load_shift_res0 <= '0';
                    i_load_shift_res1 <= '0';
                    i_load_shift_res2 <= '0';
                    i_restart_count <= '1';
                    i_restart_count_aux <= '1';
                    i_inc_count <= '0';
                    i_inc_count_aux <= '0';
                    o_done <= '0';
                    o_mem_addr <= "0000000000000000";
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                    k <= "0000000000000000";
                    add <= "0000000000000000";
                when s0a =>
                -- da tempo ai contatori di resettarsi
                    i_restart_count <= '1';
                    i_restart_count_aux <= '1';
                when s1 =>
                -- stato di inizio: legge il valore add
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_restart_count_aux <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= "0000000000000000";
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                    k <= "0000000000000000";
                    add <= i_add;
                when s2a =>
                -- s2a, s2a1, s2a2 leggono i bit più significativi di k
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_restart_count_aux <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= add;
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';                    
                when s2a1 =>
                
                when s2a2 =>
                    k(15 downto 8) <= i_mem_data;
                when s2b =>
                -- -- s2b, s2b1, s2b2 leggono i bit meno significativi di k
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 1);
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                when s2b1 =>
                
                when s2b2 =>
                    o_mem_addr <= std_logic_vector(unsigned(add) + 2);
                    k(7 downto 0) <= i_mem_data;
                when s3 =>
                -- legge il valore che determina l'ordine del filtro: 0->3 / 1->5
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                when s3a =>
                    i_ordine_filtro <= i_mem_data(0);
                when s3b =>
                -- attende il caricamento dell'ordine del filtro, poi in base ad esso sceglie in che stato andare (nel processo sopra)
                when s40 =>
                -- con ordine=0, gli stati s40 a, b caricano nel registro a scorrimento "filter" la sequenza del filtro
                -- s40 imposta la memoria e indica al counter di incrementare al prossimo ciclo
                    i_ordine_filtro <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 3 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_inc_count <= '1';
                    i_scorr_filter <= '0';
                when s40a =>
                -- s40a pone inc_count = 0 e aspetta che arrivi il valore dalla memoria
                    i_inc_count <= '0';
                when s40b =>
                -- s40b carica il dato dalla memoria al registro a scorrimento
                    i_seq_filter <= i_mem_data;
                    i_scorr_filter <= '1';
                when s40c =>
                -- s40c (completato il ciclo di caricamento del filtro) resetta il contatore a 0
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                    i_restart_count <= '1';
                when s41 =>
                -- con ordine=1, gli stati s41 a, b caricano nel registro a scorrimento "filter" la sequenza del filtro
                -- s41 imposta la memoria e indica al counter di incrementare al prossimo ciclo
                    i_ordine_filtro <= '1';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 10 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_inc_count <= '1';
                    i_scorr_filter <= '0';
                when s41a =>
                -- s41a pone inc_count = 0 e aspetta che arrivi il valore dalla memoria
                    i_inc_count <= '0';
                when s41b =>
                -- s41b carica il dato dalla memoria al registro a scorrimento
                    i_seq_filter <= i_mem_data;
                    i_scorr_filter <= '1';
                when s41c =>
                -- s41c (completato il ciclo di caricamento del filtro) resetta il contatore a 0
                    i_ordine_filtro <= '1';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                    i_restart_count <= '1';
                when s50 =>
                -- con ordine 3, carica i primi 4 valori della sequenza d'ingresso dentro al registro a scorrimento "seq" per poi eseguire le operazioni
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '1';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_scorr_data <= '0';
                when s50a =>
                    i_inc_count <= '0';
                when s50b =>
                    i_seq_data <= i_mem_data;
                    i_scorr_data <= '1';
                when s50c =>
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '1';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= "0000000000000000";
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                when s51 =>
                -- con ordine 5, carica i primi 4 valori della sequenza d'ingresso dentro al registro "seq" per poi eseguire le operazioni
                    i_ordine_filtro <= '1';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '1';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_scorr_data <= '0';
                when s51a =>
                    i_inc_count <= '0';
                when s51b =>
                    i_seq_data <= i_mem_data;
                    i_scorr_data <= '1';
                when s51c =>
                    i_ordine_filtro <= '1';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '1';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= "0000000000000000";
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                when s60 =>
                -- con ordine 3, esegue le moltiplicazioni
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '1';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    i_inc_count_aux <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                when s61 =>
                -- con ordine 5, esegue le moltiplicazioni
                    i_ordine_filtro <= '1';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '1';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    i_inc_count_aux <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                when s70 =>
                -- con ordine 3, esegue le somme (abilita il primo banco di sommatori)
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '1';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                when s70a =>
                -- (abilita il secondo banco di sommatori)
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '1';
                    i_load_sum3 <= '0';
                when s70b =>
                -- (abilita il sommatore per ottenere il risultato finale)
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '1';
                when s71 =>
                -- esegue le somme
                    i_ordine_filtro <= '1';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '1';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                when s71a =>
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '1';
                    i_load_sum3 <= '0';
                when s71b =>
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '1';
                when s80a =>
                -- con ordine 3, esegue gli shift, alla fine di ciò, il risultato è pronto in o_val_data
                -- (abilita il primo banco di shift)
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_shift_res0 <= '1';
                    i_load_shift_res1 <= '0';
                    i_load_shift_res2 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_seq_data <= i_mem_data;
                    i_scorr_data <= '0';
                when s80b =>
                -- (abilita il secondo banco di shift)
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_shift_res0 <= '0';
                    i_load_shift_res1 <= '1';
                    i_load_shift_res2 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_seq_data <= i_mem_data;
                    i_scorr_data <= '0';
                when s80c =>
                -- (abilita il terzo banco di shift)
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_shift_res1 <= '0';
                    i_load_shift_res2 <= '1';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_seq_data <= i_mem_data;
                    i_scorr_data <= '0';
                when s80d =>
                -- (consente al risultato di essere accessibile in o_val_data)
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_shift_res1 <= '0';
                    i_load_shift_res2 <= '0';
                    i_load_res <= '1';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_seq_data <= i_mem_data;
                    i_scorr_data <= '0';
                when s81a =>
                -- con ordine 5, esegue gli shift, alla fine di ciò il risultato è pronto in o_val_data
                    i_ordine_filtro <= '1';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_shift_res0 <= '1';
                    i_load_shift_res1 <= '0';
                    i_load_shift_res2 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_seq_data <= i_mem_data;
                    i_scorr_data <= '0';
                when s81b =>
                -- esegue gli shift e carica il prossimo dato dalla sequenza, alla fine di ciò, il risultato è pronto in o_val_data
                    i_ordine_filtro <= '1';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_shift_res0 <= '0';
                    i_load_shift_res1 <= '1';
                    i_load_shift_res2 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_seq_data <= i_mem_data;
                    i_scorr_data <= '0';
                when s81c =>
                -- esegue gli shift e carica il prossimo dato dalla sequenza, alla fine di ciò, il risultato è pronto in o_val_data
                    i_ordine_filtro <= '1';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_shift_res1 <= '0';
                    i_load_shift_res2 <= '1';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_seq_data <= i_mem_data;
                    i_scorr_data <= '0';
                when s81d =>
                -- esegue gli shift e carica il prossimo dato dalla sequenza, alla fine di ciò, il risultato è pronto in o_val_data
                    i_ordine_filtro <= '1';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_shift_res1 <= '0';
                    i_load_shift_res2 <= '0';
                    i_load_res <= '1';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count));
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_seq_data <= i_mem_data;
                    i_scorr_data <= '0';
                when s90 =>
                -- prepara la memoria per la scrittura
                    i_ordine_filtro <= '0';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '1';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(k) + unsigned(o_count));
                    o_mem_we <= '1';
                    o_mem_en <= '1';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                when s90a =>
                -- s90a e s90b scrivono il risultato in memoria
                    o_mem_en <= '1';
                    o_mem_we <= '1';
                    i_inc_count <= '0';
                    o_mem_data <= o_val_data;
                    i_load_res <= '0';
                when s90b =>
                    o_mem_en <= '1';
                    o_mem_we <= '1';
                    i_load_res <= '0';
                when s90c =>
                -- controlla il valore di count e prepara la memoria per il prossimo valore dalla sequenza in ingresso
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count) + 3);
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_inc_count <= '0';
                    i_load_res <= '0';
                when s90d =>
                -- aspetta il valore
                when s90e =>
                -- carica il valore
                    o_mem_en <= '0';
                    i_scorr_data <= '1';
                    i_seq_data <= i_mem_data;
                    i_load_res <= '0';
                    
                when s110 =>
                -- se sta trattando gli ultimi numeri (verificato nel processo sopra), carica "00000000" nella sequenza in ingresso
                    i_inc_count <= '0';
                    o_mem_en <= '0';
                    i_scorr_data <= '1';
                    i_seq_data <= "00000000";
                    i_inc_count_aux <= '1';
                    i_load_res <= '0';
                    
                when s91 =>
                -- scrive il risultato in memoria
                    i_ordine_filtro <= '1';
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '1';
                    o_done <= '0';
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(k) + unsigned(o_count));
                    o_mem_we <= '1';
                    o_mem_en <= '1';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                when s91a =>
                -- s91 a e s91b scrivono il risultato in memoria
                    o_mem_en <= '1';
                    o_mem_we <= '1';
                    i_inc_count <= '0';
                    o_mem_data <= o_val_data;
                    i_load_res <= '0';
                when s91b =>
                    o_mem_en <= '1';
                    o_mem_we <= '1';
                    i_load_res <= '0';
                when s91c =>
                    -- controlla il valore di count e prepara la memoria per il prossimo numero dalla sequenza in ingresso
                    o_mem_addr <= std_logic_vector(unsigned(add) + 17 + unsigned(o_count) + 3);
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    i_inc_count <= '0';
                    i_load_res <= '0';
                when s91d =>
                    -- aspetta il valore
                when s91e =>
                    -- carica il valore
                    o_mem_en <= '0';
                    i_scorr_data <= '1';
                    i_seq_data <= i_mem_data;
                    i_load_res <= '0';
                when s111 =>
                -- se sta trattando gli ultimi numeri (verificato nel processo sopra), carica "00000000" nella sequenza in ingresso
                    i_inc_count <= '0';
                    o_mem_en <= '0';
                    i_scorr_data <= '1';
                    i_seq_data <= "00000000";
                    i_inc_count_aux <= '1';
                    i_load_res <= '0';
                when s10 =>
                -- stato finale: done = 1 e rimane in attesa di start = 0
                    i_seq_filter <= "00000000";
                    i_scorr_filter <= '0';
                    i_load_mult_res <= '0';
                    i_load_sum1 <= '0';
                    i_load_sum2 <= '0';
                    i_load_sum3 <= '0';
                    i_seq_data <= "00000000";
                    i_scorr_data <= '0';
                    i_load_res <= '0';
                    i_restart_count <= '0';
                    i_inc_count <= '0';
                    o_done <= '1';
                    o_mem_addr <= "0000000000000000";
                    o_mem_data <= "00000000";
                    o_mem_we <= '0';
                    o_mem_en <= '0';
                when others =>
            end case;
        end process;
        
                    
                    
                    
end project_reti_logiche_arc;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_restart : in std_logic;
        i_inc : in std_logic;
        o_cont : out std_logic_vector(15 downto 0)
    );
end counter;
architecture counter_arc of counter is
    signal tmp_cont : std_logic_vector(15 downto 0);
begin
    process(i_inc, i_rst, i_clk, i_restart)
    begin
        if(i_rst = '1' or i_restart = '1') then
            tmp_cont <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(i_inc = '1') then
                tmp_cont <= std_logic_vector(unsigned(tmp_cont)+1);
            end if;
        end if;
    end process;
    o_cont <= tmp_cont;
end counter_arc;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_ordine_filtro : in std_logic;
        i_seq_filter : in std_logic_vector(7 downto 0);
        i_scorr_filter : in std_logic;
        i_load_mult_res : in std_logic;
        i_load_sum1 : in std_logic;
        i_load_sum2 : in std_logic;
        i_load_sum3 : in std_logic;
        i_seq_data : in std_logic_vector(7 downto 0);
        i_scorr_data : in std_logic;
        i_load_shift_res0 : in std_logic;
        i_load_shift_res1 : in std_logic;
        i_load_shift_res2 : in std_logic;
        i_load_res : in std_logic;
        o_val_data : out std_logic_vector(7 downto 0)
        );
        
end datapath;

architecture datapath_arc of datapath is
    signal seq1, seq2, seq3, seq4, seq5, seq6, seq7 : std_logic_vector(7 downto 0);
    signal fil1, fil2, fil3, fil4, fil5, fil6, fil7 : std_logic_vector(7 downto 0);
    signal i_mulA1, i_mulA2, i_mulA3, i_mulA4, i_mulA5, i_mulA6, i_mulA7 : std_logic_vector(7 downto 0);
    signal i_mulB1, i_mulB2, i_mulB3, i_mulB4, i_mulB5, i_mulB6, i_mulB7 : std_logic_vector(7 downto 0);
    signal i_mul_res1, i_mul_res2, i_mul_res3, i_mul_res4, i_mul_res5, i_mul_res6, i_mul_res7 : std_logic_vector(15 downto 0);
    signal sum_res, sum_res1, sum_res2, sum_res3, sum_res4, sum_res5 : std_logic_vector (17 downto 0);
    signal temp_res1, temp_res2, temp_res3, temp_res : std_logic_vector(17 downto 0);
    signal temp_res1a, temp_res1b, temp_res2a, temp_res2b : signed(17 downto 0);
    begin
        -- Multiplexer per il primo byte della sequenza in ingresso al moltiplicatore
        with i_ordine_filtro select
            i_mulA1 <=   "00000000" when '0',
                        seq1 when '1',
                        "XXXXXXXX" when others;
        i_mulA2 <= seq2;
        i_mulA3 <= seq3;
        i_mulA4 <= seq4;
        i_mulA5 <= seq5;
        i_mulA6 <= seq6;
        -- Multiplexer per l'ultimo byte della sequenza in ingresso al moltiplicatore
        with i_ordine_filtro select
            i_mulA7 <=   "00000000" when '0',
                        seq7 when '1',
                        "XXXXXXXX" when others;
                        
        shiftRegSeq : process(i_clk, i_rst, i_scorr_data)
        begin
            if(i_rst = '1') then
                seq1 <= "00000000"; seq2 <= "00000000"; seq3 <= "00000000"; seq4 <= "00000000"; seq5 <= "00000000"; seq6 <= "00000000"; seq7 <= "00000000";
            elsif i_clk'event and i_clk = '1' then
                if (i_scorr_data = '1') then
                    seq1 <= i_seq_data; seq2 <= seq1; seq3 <= seq2; seq4 <= seq3; seq5 <= seq4; seq6 <= seq5; seq7 <= seq6;
                end if;
            end if; 
        end process;
        
        shiftRegFil : process(i_clk, i_rst, i_scorr_filter)
        begin
            if(i_rst = '1') then
                fil1 <= "00000000"; fil2 <= "00000000"; fil3 <= "00000000"; fil4 <= "00000000"; fil5 <= "00000000"; fil6 <= "00000000"; fil7 <= "00000000";
            elsif i_clk'event and i_clk = '1' then
                if (i_scorr_filter = '1') then
                    fil1  <= i_seq_filter; fil2 <= fil1; fil3 <= fil2; fil4 <= fil3; fil5 <= fil4; fil6 <= fil5; fil7 <= fil6;
                end if;
            end if; 
        end process;
        
        i_mulB1 <= fil1;
        i_mulB2 <= fil2;
        i_mulB3 <= fil3;
        i_mulB4 <= fil4;
        i_mulB5 <= fil5;
        i_mulB6 <= fil6;
        i_mulB7 <= fil7;
        
        -- Moltiplicatori:
        mulReg : process(i_clk, i_rst, i_load_mult_res)
        begin
            if(i_rst = '1') then
                i_mul_res1 <= "0000000000000000";
                i_mul_res2 <= "0000000000000000";
                i_mul_res3 <= "0000000000000000";
                i_mul_res4 <= "0000000000000000";
                i_mul_res5 <= "0000000000000000";
                i_mul_res6 <= "0000000000000000";
                i_mul_res7 <= "0000000000000000";
            elsif i_clk'event and i_clk='1' then
                if(i_load_mult_res = '1') then
                    i_mul_res1 <= std_logic_vector(signed(i_mulA1) * signed(i_mulB1));
                    i_mul_res2 <= std_logic_vector(signed(i_mulA2) * signed(i_mulB2));
                    i_mul_res3 <= std_logic_vector(signed(i_mulA3) * signed(i_mulB3));
                    i_mul_res4 <= std_logic_vector(signed(i_mulA4) * signed(i_mulB4));
                    i_mul_res5 <= std_logic_vector(signed(i_mulA5) * signed(i_mulB5));
                    i_mul_res6 <= std_logic_vector(signed(i_mulA6) * signed(i_mulB6));
                    i_mul_res7 <= std_logic_vector(signed(i_mulA7) * signed(i_mulB7));
                 end if;
             end if;
         end process;
         
         -- Sommatori
         sumReg : process (i_clk, i_rst, i_load_sum1, i_load_sum2, i_load_sum3)
         begin
            if(i_rst = '1') then
                sum_res <="000000000000000000";
            elsif i_clk'event and i_clk = '1' then
                if i_load_sum1 = '1' then
                    sum_res1 <= std_logic_vector(signed(i_mul_res1(15) & i_mul_res1(15) & i_mul_res1)+signed(i_mul_res2(15) & i_mul_res2(15) & i_mul_res2)); 
                    sum_res2 <= std_logic_vector(signed(i_mul_res3(15) & i_mul_res3(15) & i_mul_res3)+signed(i_mul_res4(15) & i_mul_res4(15) & i_mul_res4)); 
                    sum_res3 <= std_logic_vector(signed(i_mul_res5(15) & i_mul_res5(15) & i_mul_res5)+signed(i_mul_res6(15) & i_mul_res6(15) & i_mul_res6));
                elsif i_load_sum2 = '1' then
                    sum_res4 <= std_logic_vector(signed(sum_res1)+signed(sum_res2)); 
                    sum_res5 <= std_logic_vector(signed(sum_res3)+signed(i_mul_res7(15) & i_mul_res7));
                elsif i_load_sum3 = '1' then
                    sum_res <= std_logic_vector(signed(sum_res4)+signed(sum_res5));
                end if;
            end if;
        end process;
        
        shiftReg : process (i_clk, i_rst,i_load_shift_res0,  i_load_shift_res1, i_load_shift_res2, i_load_res, i_ordine_filtro)
        begin
            if(i_rst = '1') then
                o_val_data <= "00000000";
            elsif i_clk = '1' and i_clk'event then
                if  (i_ordine_filtro = '0') then
                    if(i_load_shift_res0 = '1') then
                        if(signed(shift_right(signed(sum_res), 4)) <0 ) then
                            temp_res1a <= signed(shift_right(signed(sum_res), 4)) +1;
                         else
                            temp_res1a <= signed(shift_right(signed(sum_res), 4));
                         end if;
                        if(signed(shift_right(signed(sum_res), 6)) <0 ) then
                            temp_res1b <= signed(shift_right(signed(sum_res), 6)) +1;
                         else
                            temp_res1b <= signed(shift_right(signed(sum_res), 6));
                         end if;
                       
                         if(signed(shift_right(signed(sum_res), 8)) <0 ) then
                            temp_res2a <= signed(shift_right(signed(sum_res), 8)) +1;
                         else
                            temp_res2a <= signed(shift_right(signed(sum_res), 8));
                         end if;
                         
                         if(signed(shift_right(signed(sum_res), 10)) <0 ) then
                            temp_res2b <= signed(shift_right(signed(sum_res), 10)) +1;
                         else
                            temp_res2b <= signed(shift_right(signed(sum_res), 10));
                         end if;
                    elsif(i_load_shift_res1 = '1') then     
                        temp_res1 <= std_logic_vector (temp_res1a + temp_res1b);
                        temp_res2 <= std_logic_vector (temp_res2a + temp_res2b);                    
                    elsif(i_load_shift_res2 = '1') then
                        temp_res3 <= std_logic_vector(signed(temp_res1) + signed(temp_res2));
                    end if;
                elsif i_ordine_filtro = '1' then
                    if(i_load_shift_res0 = '1') then
                        if(signed(shift_right(signed(sum_res), 6)) <0 ) then
                            temp_res1a <= signed(shift_right(signed(sum_res), 6)) +1;
                         else
                            temp_res1a <= signed(shift_right(signed(sum_res), 6));
                         end if;
                        if(signed(shift_right(signed(sum_res), 10)) <0 ) then
                            temp_res1b <= signed(shift_right(signed(sum_res), 10)) +1;
                         else
                            temp_res1b <= signed(shift_right(signed(sum_res), 10));
                         end if;
                    elsif(i_load_shift_res2 = '1') then
                        temp_res3 <= std_logic_vector (temp_res1a + temp_res1b);
                    end if;
                end if;
                if(i_load_res = '1') then
                    if(signed(temp_res3) > 127) then
                        o_val_data <= "01111111";
                    elsif(signed(temp_res3) < -128) then
                        o_val_data <= "10000000";
                    else
                        o_val_data <= temp_res3 (7 downto 0);
                    end if;
                end if;
            end if;
        end process;
    end;