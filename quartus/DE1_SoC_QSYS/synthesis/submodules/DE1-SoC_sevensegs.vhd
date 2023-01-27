


Library ieee;
Use     ieee.std_logic_1164.all;
Use     ieee.numeric_std.all;



Entity DE1_SoC_sevensegs Is Port (
        -- Host Side
        clk         : In    std_logic;
        reset_n     : In    std_logic;
        address     : In    std_logic_vector(3 downto 0);
        writedata   : In    std_logic_vector(31 downto 0);
        chipselect_n: In    std_logic;
        write_n     : In    std_logic;

        -- Seven Segs Output Datas
        s0          : Out   std_logic_vector(6 downto 0);
        s1          : Out   std_logic_vector(6 downto 0);
        s2          : Out   std_logic_vector(6 downto 0);
        s3          : Out   std_logic_vector(6 downto 0);
        s4          : Out   std_logic_vector(6 downto 0);
        s5          : Out   std_logic_vector(6 downto 0)
    );
End Entity ;


Architecture RTL of DE1_SoC_sevensegs Is

Begin

Process( Reset_n, Clk)
Variable DataOut : std_logic_vector(7 downto 0);
begin
    If( Reset_n = '0') Then
        s0          <=  (others => '0');
        s1          <=  (others => '0');
        s2          <=  (others => '0');
        s3          <=  (others => '0');
        s4          <=  (others => '0');
        s5          <=  (others => '0');
        DataOut     :=  (others => '0');

    ElsIf Rising_Edge(CLK) Then

      If (ChipSelect_n = '0') and (Write_n = '0') Then

        If Address(Address'Left) = '1' Then
          Case (WriteData(3 downto 0)) Is
            When x"0" =>
              DataOut := x"3F";
            When x"1" =>
              DataOut := x"06";
            When x"2" =>
              DataOut := x"5B";
            When x"3" =>
              DataOut := x"4F";
            When x"4" =>
              DataOut := x"66";
            When x"5" =>
              DataOut := x"ED";
            When x"6" =>
              DataOut := x"FD";
            When x"7" =>
              DataOut := x"07";
            When x"8" =>
              DataOut := x"FF";
            When x"9" =>
              DataOut := x"EF";
            When x"A" =>
              DataOut := x"F7";
            When x"B" =>
              DataOut := x"FC";
            When x"C" =>
              DataOut := x"58";
            When x"D" =>
              DataOut := x"DE";
            When x"E" =>
              DataOut := x"F9";
            When x"F" =>
              DataOut := x"F1";
            When Others =>
              DataOut := x"40";
          End Case;
        Else
          DataOut := '0' & WriteData(6 downto 0);
        End If;

        Case (to_integer(unsigned(Address(2 downto 0)))) Is
          When 0 =>
            s0 <= DataOut(6 downto 0);
          When 1 =>
            s1 <= DataOut(6 downto 0);
          When 2 =>
            s2 <= DataOut(6 downto 0);
          When 3 =>
            s3 <= DataOut(6 downto 0);
          When 4 =>
            s4 <= DataOut(6 downto 0);
          When 5 =>
            s5 <= DataOut(6 downto 0);
          When others =>
            null;
        End Case;
       End If;
    End If;
End Process;


End Architecture;
