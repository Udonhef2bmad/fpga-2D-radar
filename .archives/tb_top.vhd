LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

USE IEEE.math_real.ALL;

ENTITY tb_top IS
END ENTITY;

ARCHITECTURE RTL OF tb_top IS

    -- model constants
    CONSTANT address_bitwidth : INTEGER := 6; --node pointer bitwidth
    CONSTANT feature_bitwidth : INTEGER := 8; --feature precision
    CONSTANT subfeature_count : INTEGER := 2; --number of features inside a node
    CONSTANT feature_count : INTEGER := 4; --number of features in the dataset

    -- memory constants
    CONSTANT mem_depth : INTEGER := 16; -- node memory depth
    CONSTANT data_width : INTEGER := (address_bitwidth * 2) + (feature_bitwidth * subfeature_count * 2) + feature_count;
    CONSTANT addr_width : INTEGER := INTEGER(ceil(log2(real(mem_depth))));
    CONSTANT init_file : STRING := "../mif_export/nodes_0.mif"; --file path (relative to generic_ram_dual_port.vhd)

    -- manhattan constants
    CONSTANT distance_bitwidth : INTEGER := INTEGER(ceil(log2(real((2 ** feature_bitwidth - 1) * subfeature_count)))); --manhattan output bitwidth

    -- Clock period definitions
    CONSTANT clock_period : TIME := 20 ns;

    --wait duration
    CONSTANT PERIOD : TIME := 0.02 us;

    SIGNAL CLK : STD_LOGIC;
    SIGNAL RST : STD_LOGIC;
    SIGNAL ENDSIM : STD_LOGIC; --simulation end signal

    -- import_module -> generic_ram_dual_port
    SIGNAL data : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL wraddress : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0);
    SIGNAL wren : STD_LOGIC;

    -- tree_manager -> generic_ram_dual_port
    SIGNAL rdaddress : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0);

    -- generic_ram_dual_port -> node_splitter
    SIGNAL q : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0); -- = (0 TO (address_bitwidth * 2) + (feature_bitwidth * subfeature_count * 2) + feature_count - 1 );

    -- node_splitter -> pointer_sel 
    SIGNAL left_addr : STD_LOGIC_VECTOR (address_bitwidth - 1 DOWNTO 0);
    SIGNAL right_addr : STD_LOGIC_VECTOR (address_bitwidth - 1 DOWNTO 0);

    -- node_splitter -> subfeature_sel 
    SIGNAL subfeature_selector : STD_LOGIC_VECTOR (feature_count - 1 DOWNTO 0);

    -- scheduler -> subfeature_sel
    SIGNAL example_features : STD_LOGIC_VECTOR ((feature_bitwidth * feature_count) - 1 DOWNTO 0);

    -- subfeature_sel -> left_manhattan & right_manhattan
    SIGNAL subfeatures : STD_LOGIC_VECTOR ((feature_bitwidth * subfeature_count) - 1 DOWNTO 0);

    -- node_splitter -> left_manhattan
    SIGNAL left_done : STD_LOGIC;
    SIGNAL left_centroid : STD_LOGIC_VECTOR ((feature_bitwidth * subfeature_count) - 1 DOWNTO 0);

    -- node_splitter -> right_manhattan
    SIGNAL right_done : STD_LOGIC;
    SIGNAL right_centroid : STD_LOGIC_VECTOR ((feature_bitwidth * subfeature_count) - 1 DOWNTO 0);

    -- left_manhattan -> comparator
    SIGNAL left_distance : STD_LOGIC_VECTOR (distance_bitwidth - 1 DOWNTO 0);

    -- right_manhattan -> comparator
    SIGNAL right_distance : STD_LOGIC_VECTOR (distance_bitwidth - 1 DOWNTO 0);

    -- comparator -> pointer_sel
    SIGNAL distance_comparison : STD_LOGIC;

    -- pointer_sel
    SIGNAL next_addr : STD_LOGIC_VECTOR (address_bitwidth - 1 DOWNTO 0);

BEGIN

    -- clock process
    clock_process : PROCESS
    BEGIN
        IF (ENDSIM = '1') THEN
            WAIT;
        ELSE
            CLK <= '0';
            WAIT FOR clock_period/2;
            CLK <= '1';
            WAIT FOR clock_period/2;
        END IF;
    END PROCESS;
    -- test process
    Test : PROCESS
    BEGIN
        --simulation init start
        RST <= '1';
        ENDSIM <= '0';
        WAIT FOR PERIOD;
        RST <= '0';
        --simulation init end

        --test here

        --test init
        example_features <= "00000001" & "00000011" & "00000111" & "00001111";
        rdaddress <= (OTHERS => '0');
        wraddress <= (OTHERS => '0');
        data <= (OTHERS => '0');
        wren <= '0'; --disable writing
        WAIT FOR PERIOD;
        WAIT FOR PERIOD;

        rdaddress <= next_addr(rdaddress'length - 1 DOWNTO 0);

        WAIT FOR PERIOD;
        WAIT FOR PERIOD;

        rdaddress <= next_addr(rdaddress'length - 1 DOWNTO 0);

        WAIT FOR PERIOD;
        WAIT FOR PERIOD;

        rdaddress <= next_addr(rdaddress'length - 1 DOWNTO 0);

        WAIT FOR PERIOD;
        WAIT FOR PERIOD;


        --simulation end
        ENDSIM <= '1';
        WAIT;
    END PROCESS;

    generic_ram_dual_port : ENTITY work.generic_ram_dual_port
        GENERIC MAP(
            data_width => data_width,
            addr_width => addr_width,
            init_file => init_file
        )
        PORT MAP(
            clock => CLK,
            data => data,
            rdaddress => rdaddress,
            wraddress => wraddress,
            wren => wren,
            q => q
        );

    node_splitter : ENTITY work.node_splitter
        GENERIC MAP(
            address_bitwidth => address_bitwidth,
            feature_bitwidth => feature_bitwidth,
            subfeature_count => subfeature_count,
            feature_count => feature_count
        )
        PORT MAP(
            i_node_info => q,
            o_left_addr => left_addr,
            o_right_addr => right_addr,
            o_left_centroid => left_centroid,
            o_right_centroid => right_centroid,
            o_subfeature_sel => subfeature_selector
        );

    subfeature_sel : ENTITY work.subfeature_sel
        GENERIC MAP(
            feature_bitwidth => feature_bitwidth,
            subfeature_count => subfeature_count,
            feature_count => feature_count
        )
        PORT MAP(
            i_RST => RST,
            i_example_features => example_features,
            i_selector => subfeature_selector,
            o_subfeatures => subfeatures
        );

    left_manhattan : ENTITY work.manhattan
        GENERIC MAP(
            feature_bitwidth => feature_bitwidth,
            subfeature_count => subfeature_count
        )
        PORT MAP(
            i_RST => RST,
            i_A => left_centroid,
            i_B => subfeatures,
            o_distance => left_distance,
            o_done => left_done
        );

    right_manhattan : ENTITY work.manhattan
        GENERIC MAP(
            feature_bitwidth => feature_bitwidth,
            subfeature_count => subfeature_count
        )
        PORT MAP(
            i_RST => RST,
            i_A => right_centroid,
            i_B => subfeatures,
            o_distance => right_distance,
            o_done => right_done
        );

    comparator : ENTITY work.comparator
        GENERIC MAP(
            input_bitwidth => distance_bitwidth
        )
        PORT MAP(
            i_A => left_distance,
            i_B => right_distance,
            o_result => distance_comparison
        );

    pointer_sel : ENTITY work.pointer_sel
        GENERIC MAP(
            address_bitwidth => address_bitwidth
        )
        PORT MAP(
            i_selector => distance_comparison,
            i_left_addr => left_addr,
            i_right_addr => right_addr,
            o_next_addr => next_addr
        );

END ARCHITECTURE;