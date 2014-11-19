-- SLCD.VHD (a peripheral module for SCOMP)
-- 2014.11.18
--
-- Very simple LCD controller which interprets a SCOMP 16 word as part data
-- and part instruction. All meaningful control of the LCD is done in software.
--
-- See datasheets for the HD44780 or equivalent LCD controller.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SLCD IS
  PORT(
    CLOCK_10KHZ : IN  STD_LOGIC;
    RESETN      : IN  STD_LOGIC;
    CS          : IN  STD_LOGIC;
    IO_DATA     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    LCD_RS      : OUT STD_LOGIC;
    LCD_RW      : OUT STD_LOGIC;
    LCD_E       : OUT STD_LOGIC;
    LCD_D       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END SLCD;

ARCHITECTURE a OF SLCD IS
  -- Register to hold the last value sent to this LCD controller
  SIGNAL data_in   : STD_LOGIC_VECTOR(15 DOWNTO 0);

  BEGIN
    LCD_RW <= '0';                 -- Always write to the LCD, never read
    LCD_D  <= data_in(7 DOWNTO 0); -- The low byte is interpreted as data

    -- The highest bit is used to select the instruction or data register
    WITH data_in(15) SELECT
      LCD_RS <= '0' WHEN '1',
                '1' WHEN OTHERS;

    -- The second highest bit is interpreted as a finish transaction flag
    WITH data_in(14) SELECT
      LCD_E <= '0' WHEN '1',
               '1' WHEN OTHERS;

    -- Put IO_DATA into data_in when a new value has been sent.
    -- Also, clear data_in when the DE2Bot is reset.
    PROCESS (RESETN, CS) BEGIN
      IF (RESETN = '0') THEN
        data_in <= x"0000";
      ELSIF (RISING_EDGE(CS)) THEN
        data_in <= IO_DATA;
      END IF;
    END PROCESS;
  END a;
