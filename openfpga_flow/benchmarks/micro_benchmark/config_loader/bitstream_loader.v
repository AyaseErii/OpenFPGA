`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2021 09:43:10 AM
// Design Name: 
// Module Name: bitstream_loader
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bitstream_loader(
    input prog_clk,
    input start,
    output config_chain_head,
    output reg done
    );
    
    parameter BITSTREAM_FILE="";
    parameter BITSTREAM_SIZE=6140;
    
    reg [BITSTREAM_SIZE<=2 ? 2 : $clog2(BITSTREAM_SIZE):0] bitstream_index;
    
    reg [13:0] bram_addr;
    reg [3:0] bram_line_index;
    
    wire bram_output;
    assign config_chain_head = bram_output;

    RAMB18E1 #(
        // Address Collision Mode: "PERFORMANCE" or "DELAYED_WRITE" 
      .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
      // Collision check: Values ("ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE")
      .SIM_COLLISION_CHECK("ALL"),
      // RAM Mode: "SDP" or "TDP" 
      .RAM_MODE("TDP"),
      // READ_WIDTH_A/B, WRITE_WIDTH_A/B: Read/write width per port
      .READ_WIDTH_A(1),                                                                 // 0-72
      .READ_WIDTH_B(0),                                                                 // 0-18
      .WRITE_WIDTH_A(0),                                                                // 0-18
      .WRITE_WIDTH_B(0),                                                                // 0-72
      
      .INIT_00(256'h00000000000000000000000000000000000000000000007f00000000000000ff),
        .INIT_01(256'h0000fff8ffffffff000000000000000000000000000000000000000000000000),
        .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_04(256'h00000003f8000000000000000000000000000000000000000000000000000000),
        .INIT_05(256'h0000000000000000078000000000000000000000000000000000000000000000),
        .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_17(256'h0021000000000000000000000000000000000000000000000000000000000000),
        .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
        .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
      
     
      
      // RSTREG_PRIORITY_A, RSTREG_PRIORITY_B: Reset or enable priority ("RSTREG" or "REGCE")
      .RSTREG_PRIORITY_A("RSTREG"),
      .RSTREG_PRIORITY_B("RSTREG"),
      // SRVAL_A, SRVAL_B: Set/reset value for output
      .SRVAL_A(18'hFFFFF),
      .SRVAL_B(18'h00000),
      // Simulation Device: Must be set to "7SERIES" for simulation behavior
      .SIM_DEVICE("7SERIES"),
      // WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE")
      .WRITE_MODE_A("WRITE_FIRST"),
      .WRITE_MODE_B("WRITE_FIRST")
   )
   RAMB18E1_inst (
      // Port A Data: 16-bit (each) output: Port A data
      .DOADO(bram_output),                 // 16-bit output: A port data/LSB data
      .DOPADOP(),             // 2-bit output: A port parity/LSB parity
      // Port B Data: 16-bit (each) output: Port B data
      .DOBDO(),                 // 16-bit output: B port data/MSB data
      .DOPBDOP(),             // 2-bit output: B port parity/MSB parity
      // Port A Address/Control Signals: 14-bit (each) input: Port A address and control signals (read port
      // when RAM_MODE="SDP")
      .ADDRARDADDR(bram_addr),     // 14-bit input: A port address/Read address
      .CLKARDCLK(~prog_clk),         // 1-bit input: A port clock/Read clock
      .ENARDEN(1'b1),             // 1-bit input: A port enable/Read enable
      .REGCEAREGCE(1'b1),     // 1-bit input: A port register enable/Register enable
      .RSTRAMARSTRAM(0), // 1-bit input: A port set/reset
      .RSTREGARSTREG(0), // 1-bit input: A port register set/reset
      .WEA(2'b00),                     // 2-bit input: A port write enable
      // Port A Data: 16-bit (each) input: Port A data
      .DIADI(0),                 // 16-bit input: A port data/LSB data
      .DIPADIP(0),             // 2-bit input: A port parity/LSB parity
      // Port B Address/Control Signals: 14-bit (each) input: Port B address and control signals (write port
      // when RAM_MODE="SDP")
      .ADDRBWRADDR(0),     // 14-bit input: B port address/Write address
      .CLKBWRCLK(0),         // 1-bit input: B port clock/Write clock
      .ENBWREN(0),             // 1-bit input: B port enable/Write enable
      .REGCEB(0),               // 1-bit input: B port register enable
      .RSTRAMB(0),             // 1-bit input: B port set/reset
      .RSTREGB(0),             // 1-bit input: B port register set/reset
      .WEBWE(0),                 // 4-bit input: B port write enable/Write enable
      // Port B Data: 16-bit (each) input: Port B data
      .DIBDI(0),                 // 16-bit input: B port data/MSB data
      .DIPBDIP(0)              // 2-bit input: B port parity/MSB parity
   );
   
   
    initial begin
        bram_addr <= 0;
        bram_line_index <= 0;
        bitstream_index <= 0;
        done <= 1'b0;
    end
    
    always @(posedge prog_clk) begin
        if (start && !done) begin
            
            bram_addr <= bram_addr + 1;
            bitstream_index <= bitstream_index + 1;
        end
        if (bitstream_index == BITSTREAM_SIZE) begin
            done <= 1'b1;
        end
    end
    
    
endmodule








    