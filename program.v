`timescale 1ns / 1ps
`define DLY #1

(* DowngradeIPIdentifiedWarnings="yes" *)
//***********************************Entity Declaration************************
(* CORE_GENERATION_INFO = "gtwizard_0,gtwizard_v3_6_10,{protocol_file=Start_from_scratch}" *)
module gtwizard_0_exdes #
(
    parameter EXAMPLE_CONFIG_INDEPENDENT_LANES     =	1,//configuration for frame gen and check
    parameter EXAMPLE_LANE_WITH_START_CHAR         =   	0,         // specifies lane with unique start frame char
    parameter EXAMPLE_WORDS_IN_BRAM                =   	512,       // specifies amount of data in BRAM
    parameter EXAMPLE_SIM_GTRESET_SPEEDUP          =   	"TRUE",    // simulation setting for GT SecureIP model
    parameter EXAMPLE_USE_CHIPSCOPE                =   	1,         // Set to 1 to use Chipscope to drive resets
    parameter STABLE_CLOCK_PERIOD                  =	10

)
(
    input	 wire										Q1_CLK0_GTREFCLK_PAD_N_IN,
    input	 wire  										Q1_CLK0_GTREFCLK_PAD_P_IN,
    input	 wire  										Q2_CLK0_GTREFCLK_PAD_N_IN,
    input	 wire  										Q2_CLK0_GTREFCLK_PAD_P_IN,
    input	 wire 								[15:0]  RXN_IN,
    input	 wire 								[15:0]  RXP_IN,
    output	 wire 								[15:0]  TXN_OUT,
    output	 wire 								[15:0]  TXP_OUT,
    //ADATE320
    output   wire                                       spi_clk,
    output   wire                                       spi_sdi,
    output   wire                               [3:0]   spi_csn,
    input    wire                                       spi_sdo,
    //pcie interface
    input    wire                                       ADSN,
    input    wire                                       LHOLD,
    input    wire                                       LCLK_50M,//底板50M
    input    wire                                       LWRN,
    input    wire                                       BLASTN,
    input    wire                               [31:2] 	LA,
    inout    wire                               [31:0]	PXI_LD,
    output   wire                                       READYN,
    output   wire                                       LHOLDA,
    
    //NB6L295配置
    output   wire                                       Delay_SCLK,
    output   wire                                       Delay_LOAD,
    output   wire                                       Delay_DIN,
    output   wire                                       Delay_EN_n,
   
    //ADG1406多选一
    output   wire                              [3:0]	ADG1406,
    
    //ADC数据传输
    input    wire                                       LTC2380_SDO,
    output   wire                                       LTC2380_CLK,
    input    wire                                       LTC2380_BUSY,
    output   wire                                       LTC2380_CNV,
       
    //ADF4350_clkin        
    output   wire                                       ADF4350_CS,
    output   wire                                       ADF4350_DIN,
    output   wire                                       ADF4350_SCLK,  
    
    //relay control
    output   wire                                       DUT0_RELAY_OUT,
//    output wire                                       DUT0_RELAY_CALIP,
    output   wire                                       DUT1_RELAY_OUT,
//    output wire                                       DUT1_RELAY_CALIP,
    output   wire                                       DUT2_RELAY_OUT,
//    output wire                                       DUT2_RELAY_CALIP,
    output   wire                                       DUT3_RELAY_OUT,
//    output wire                                       DUT3_RELAY_CALIP,
    output   wire                                       DUT4_RELAY_OUT,
//    output wire                                       DUT4_RELAY_CALIP,
    output   wire                                       DUT5_RELAY_OUT,
//    output wire                                       DUT5_RELAY_CALIP,
    output   wire                                       DUT6_RELAY_OUT,
//    output wire                                       DUT6_RELAY_CALIP,
    output   wire                                       DUT7_RELAY_OUT,
//    output wire                                       DUT7_RELAY_CALIP,
//    output wire                                       CLK_RELAY_EX_IN,
    output   wire                                       CLK_RELAY_10M_IN,
//    output wire                                       TRIG_RELAY_EX_IN,
//    output wire                                       TRIG_RELAY_STAR_IN,
    output   wire                                       CALIP_RELAY_10M_IN
);

    wire soft_reset_i;
    (*mark_debug = "TRUE" *) wire soft_reset_vio_i;

//************************** Register Declarations ****************************

    wire            gt_txfsmresetdone_i;
    wire            gt_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt_txfsmresetdone_r2;
    wire            gt0_txfsmresetdone_i;
    wire            gt0_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt0_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_vio_r3;

    wire            gt1_txfsmresetdone_i;
    wire            gt1_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt1_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt1_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_vio_r3;

    wire            gt2_txfsmresetdone_i;
    wire            gt2_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt2_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt2_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_vio_r3;

    wire            gt3_txfsmresetdone_i;
    wire            gt3_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt3_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt3_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_vio_r3;

    wire            gt4_txfsmresetdone_i;
    wire            gt4_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt4_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt4_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt4_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt4_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt4_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt4_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt4_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt4_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt4_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt4_rxresetdone_vio_r3;

    wire            gt5_txfsmresetdone_i;
    wire            gt5_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt5_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt5_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt5_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt5_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt5_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt5_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt5_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt5_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt5_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt5_rxresetdone_vio_r3;

    wire            gt6_txfsmresetdone_i;
    wire            gt6_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt6_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt6_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt6_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt6_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt6_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt6_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt6_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt6_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt6_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt6_rxresetdone_vio_r3;

    wire            gt7_txfsmresetdone_i;
    wire            gt7_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt7_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt7_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt7_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt7_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt7_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt7_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt7_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt7_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt7_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt7_rxresetdone_vio_r3;

    wire            gt8_txfsmresetdone_i;
    wire            gt8_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt8_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt8_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt8_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt8_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt8_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt8_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt8_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt8_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt8_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt8_rxresetdone_vio_r3;

    wire            gt9_txfsmresetdone_i;
    wire            gt9_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt9_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt9_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt9_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt9_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt9_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt9_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt9_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt9_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt9_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt9_rxresetdone_vio_r3;

    wire            gt10_txfsmresetdone_i;
    wire            gt10_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt10_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt10_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt10_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt10_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt10_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt10_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt10_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt10_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt10_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt10_rxresetdone_vio_r3;

    wire            gt11_txfsmresetdone_i;
    wire            gt11_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt11_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt11_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt11_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt11_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt11_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt11_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt11_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt11_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt11_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt11_rxresetdone_vio_r3;

    wire            gt12_txfsmresetdone_i;
    wire            gt12_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt12_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt12_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt12_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt12_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt12_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt12_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt12_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt12_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt12_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt12_rxresetdone_vio_r3;

    wire            gt13_txfsmresetdone_i;
    wire            gt13_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt13_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt13_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt13_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt13_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt13_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt13_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt13_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt13_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt13_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt13_rxresetdone_vio_r3;

    wire            gt14_txfsmresetdone_i;
    wire            gt14_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt14_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt14_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt14_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt14_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt14_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt14_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt14_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt14_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt14_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt14_rxresetdone_vio_r3;

    wire            gt15_txfsmresetdone_i;
    wire            gt15_rxfsmresetdone_i;
    (* ASYNC_REG = "TRUE" *)reg             gt15_txfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt15_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt15_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt15_rxfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt15_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt15_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt15_rxresetdone_r3;
    (* ASYNC_REG = "TRUE" *)reg             gt15_rxresetdone_vio_r;
    (* ASYNC_REG = "TRUE" *)reg             gt15_rxresetdone_vio_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt15_rxresetdone_vio_r3;

    reg [5:0] reset_counter = 0;
    reg     [3:0]   reset_pulse;

//**************************** Wire Declarations ******************************//
    //------------------------ GT Wrapper Wires ------------------------------
    //________________________________________________________________________
    //________________________________________________________________________
    //GT0  (X1Y0)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt0_drpaddr_i;
    wire    [15:0]  gt0_drpdi_i;
    wire    [15:0]  gt0_drpdo_i;
    wire            gt0_drpen_i;
    wire            gt0_drprdy_i;
    wire            gt0_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt0_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt0_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt0_eyescanreset_i;
    wire            gt0_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt0_eyescandataerror_i;
    wire            gt0_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt0_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt0_rxprbserr_i;
    wire    [2:0]   gt0_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt0_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt0_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt0_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt0_rxdfelpmreset_i;
    wire    [6:0]   gt0_rxmonitorout_i;
    wire    [1:0]   gt0_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt0_rxoutclk_i;
    wire            gt0_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt0_gtrxreset_i;
    wire            gt0_rxpcsreset_i;
    wire            gt0_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt0_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt0_gttxreset_i;
    wire            gt0_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt0_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt0_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt0_gtxtxn_i;
    wire            gt0_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt0_txoutclk_i;
    wire            gt0_txoutclkfabric_i;
    wire            gt0_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt0_txpcsreset_i;
    wire            gt0_txpmareset_i;
    wire            gt0_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt0_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT1  (X1Y1)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt1_drpaddr_i;
    wire    [15:0]  gt1_drpdi_i;
    wire    [15:0]  gt1_drpdo_i;
    wire            gt1_drpen_i;
    wire            gt1_drprdy_i;
    wire            gt1_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt1_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt1_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt1_eyescanreset_i;
    wire            gt1_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt1_eyescandataerror_i;
    wire            gt1_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt1_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt1_rxprbserr_i;
    wire    [2:0]   gt1_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt1_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt1_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt1_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt1_rxdfelpmreset_i;
    wire    [6:0]   gt1_rxmonitorout_i;
    wire    [1:0]   gt1_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt1_rxoutclk_i;
    wire            gt1_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt1_gtrxreset_i;
    wire            gt1_rxpcsreset_i;
    wire            gt1_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt1_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt1_gttxreset_i;
    wire            gt1_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt1_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt1_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt1_gtxtxn_i;
    wire            gt1_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt1_txoutclk_i;
    wire            gt1_txoutclkfabric_i;
    wire            gt1_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt1_txpcsreset_i;
    wire            gt1_txpmareset_i;
    wire            gt1_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt1_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT2  (X1Y2)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt2_drpaddr_i;
    wire    [15:0]  gt2_drpdi_i;
    wire    [15:0]  gt2_drpdo_i;
    wire            gt2_drpen_i;
    wire            gt2_drprdy_i;
    wire            gt2_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt2_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt2_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt2_eyescanreset_i;
    wire            gt2_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt2_eyescandataerror_i;
    wire            gt2_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt2_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt2_rxprbserr_i;
    wire    [2:0]   gt2_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt2_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt2_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt2_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt2_rxdfelpmreset_i;
    wire    [6:0]   gt2_rxmonitorout_i;
    wire    [1:0]   gt2_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt2_rxoutclk_i;
    wire            gt2_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt2_gtrxreset_i;
    wire            gt2_rxpcsreset_i;
    wire            gt2_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt2_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt2_gttxreset_i;
    wire            gt2_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt2_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt2_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt2_gtxtxn_i;
    wire            gt2_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt2_txoutclk_i;
    wire            gt2_txoutclkfabric_i;
    wire            gt2_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt2_txpcsreset_i;
    wire            gt2_txpmareset_i;
    wire            gt2_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt2_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT3  (X1Y3)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt3_drpaddr_i;
    wire    [15:0]  gt3_drpdi_i;
    wire    [15:0]  gt3_drpdo_i;
    wire            gt3_drpen_i;
    wire            gt3_drprdy_i;
    wire            gt3_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt3_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt3_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt3_eyescanreset_i;
    wire            gt3_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt3_eyescandataerror_i;
    wire            gt3_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt3_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt3_rxprbserr_i;
    wire    [2:0]   gt3_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt3_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt3_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt3_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt3_rxdfelpmreset_i;
    wire    [6:0]   gt3_rxmonitorout_i;
    wire    [1:0]   gt3_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt3_rxoutclk_i;
    wire            gt3_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt3_gtrxreset_i;
    wire            gt3_rxpcsreset_i;
    wire            gt3_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt3_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt3_gttxreset_i;
    wire            gt3_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt3_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt3_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt3_gtxtxn_i;
    wire            gt3_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt3_txoutclk_i;
    wire            gt3_txoutclkfabric_i;
    wire            gt3_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt3_txpcsreset_i;
    wire            gt3_txpmareset_i;
    wire            gt3_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt3_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT4  (X1Y4)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt4_drpaddr_i;
    wire    [15:0]  gt4_drpdi_i;
    wire    [15:0]  gt4_drpdo_i;
    wire            gt4_drpen_i;
    wire            gt4_drprdy_i;
    wire            gt4_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt4_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt4_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt4_eyescanreset_i;
    wire            gt4_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt4_eyescandataerror_i;
    wire            gt4_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt4_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt4_rxprbserr_i;
    wire    [2:0]   gt4_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt4_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt4_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt4_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt4_rxdfelpmreset_i;
    wire    [6:0]   gt4_rxmonitorout_i;
    wire    [1:0]   gt4_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt4_rxoutclk_i;
    wire            gt4_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt4_gtrxreset_i;
    wire            gt4_rxpcsreset_i;
    wire            gt4_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt4_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt4_gttxreset_i;
    wire            gt4_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt4_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt4_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt4_gtxtxn_i;
    wire            gt4_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt4_txoutclk_i;
    wire            gt4_txoutclkfabric_i;
    wire            gt4_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt4_txpcsreset_i;
    wire            gt4_txpmareset_i;
    wire            gt4_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt4_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT5  (X1Y5)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt5_drpaddr_i;
    wire    [15:0]  gt5_drpdi_i;
    wire    [15:0]  gt5_drpdo_i;
    wire            gt5_drpen_i;
    wire            gt5_drprdy_i;
    wire            gt5_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt5_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt5_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt5_eyescanreset_i;
    wire            gt5_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt5_eyescandataerror_i;
    wire            gt5_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt5_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt5_rxprbserr_i;
    wire    [2:0]   gt5_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt5_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt5_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt5_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt5_rxdfelpmreset_i;
    wire    [6:0]   gt5_rxmonitorout_i;
    wire    [1:0]   gt5_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt5_rxoutclk_i;
    wire            gt5_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt5_gtrxreset_i;
    wire            gt5_rxpcsreset_i;
    wire            gt5_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt5_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt5_gttxreset_i;
    wire            gt5_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt5_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt5_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt5_gtxtxn_i;
    wire            gt5_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt5_txoutclk_i;
    wire            gt5_txoutclkfabric_i;
    wire            gt5_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt5_txpcsreset_i;
    wire            gt5_txpmareset_i;
    wire            gt5_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt5_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT6  (X1Y6)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt6_drpaddr_i;
    wire    [15:0]  gt6_drpdi_i;
    wire    [15:0]  gt6_drpdo_i;
    wire            gt6_drpen_i;
    wire            gt6_drprdy_i;
    wire            gt6_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt6_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt6_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt6_eyescanreset_i;
    wire            gt6_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt6_eyescandataerror_i;
    wire            gt6_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt6_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt6_rxprbserr_i;
    wire    [2:0]   gt6_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt6_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt6_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt6_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt6_rxdfelpmreset_i;
    wire    [6:0]   gt6_rxmonitorout_i;
    wire    [1:0]   gt6_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt6_rxoutclk_i;
    wire            gt6_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt6_gtrxreset_i;
    wire            gt6_rxpcsreset_i;
    wire            gt6_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt6_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt6_gttxreset_i;
    wire            gt6_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt6_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt6_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt6_gtxtxn_i;
    wire            gt6_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt6_txoutclk_i;
    wire            gt6_txoutclkfabric_i;
    wire            gt6_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt6_txpcsreset_i;
    wire            gt6_txpmareset_i;
    wire            gt6_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt6_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT7  (X1Y7)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt7_drpaddr_i;
    wire    [15:0]  gt7_drpdi_i;
    wire    [15:0]  gt7_drpdo_i;
    wire            gt7_drpen_i;
    wire            gt7_drprdy_i;
    wire            gt7_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt7_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt7_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt7_eyescanreset_i;
    wire            gt7_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt7_eyescandataerror_i;
    wire            gt7_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt7_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt7_rxprbserr_i;
    wire    [2:0]   gt7_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt7_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt7_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt7_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt7_rxdfelpmreset_i;
    wire    [6:0]   gt7_rxmonitorout_i;
    wire    [1:0]   gt7_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt7_rxoutclk_i;
    wire            gt7_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt7_gtrxreset_i;
    wire            gt7_rxpcsreset_i;
    wire            gt7_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt7_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt7_gttxreset_i;
    wire            gt7_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt7_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt7_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt7_gtxtxn_i;
    wire            gt7_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt7_txoutclk_i;
    wire            gt7_txoutclkfabric_i;
    wire            gt7_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt7_txpcsreset_i;
    wire            gt7_txpmareset_i;
    wire            gt7_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt7_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT8  (X1Y8)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt8_drpaddr_i;
    wire    [15:0]  gt8_drpdi_i;
    wire    [15:0]  gt8_drpdo_i;
    wire            gt8_drpen_i;
    wire            gt8_drprdy_i;
    wire            gt8_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt8_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt8_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt8_eyescanreset_i;
    wire            gt8_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt8_eyescandataerror_i;
    wire            gt8_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt8_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt8_rxprbserr_i;
    wire    [2:0]   gt8_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt8_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt8_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt8_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt8_rxdfelpmreset_i;
    wire    [6:0]   gt8_rxmonitorout_i;
    wire    [1:0]   gt8_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt8_rxoutclk_i;
    wire            gt8_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt8_gtrxreset_i;
    wire            gt8_rxpcsreset_i;
    wire            gt8_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt8_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt8_gttxreset_i;
    wire            gt8_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt8_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt8_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt8_gtxtxn_i;
    wire            gt8_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt8_txoutclk_i;
    wire            gt8_txoutclkfabric_i;
    wire            gt8_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt8_txpcsreset_i;
    wire            gt8_txpmareset_i;
    wire            gt8_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt8_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT9  (X1Y9)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt9_drpaddr_i;
    wire    [15:0]  gt9_drpdi_i;
    wire    [15:0]  gt9_drpdo_i;
    wire            gt9_drpen_i;
    wire            gt9_drprdy_i;
    wire            gt9_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt9_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt9_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt9_eyescanreset_i;
    wire            gt9_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt9_eyescandataerror_i;
    wire            gt9_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt9_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt9_rxprbserr_i;
    wire    [2:0]   gt9_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt9_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt9_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt9_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt9_rxdfelpmreset_i;
    wire    [6:0]   gt9_rxmonitorout_i;
    wire    [1:0]   gt9_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt9_rxoutclk_i;
    wire            gt9_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt9_gtrxreset_i;
    wire            gt9_rxpcsreset_i;
    wire            gt9_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt9_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt9_gttxreset_i;
    wire            gt9_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt9_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt9_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt9_gtxtxn_i;
    wire            gt9_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt9_txoutclk_i;
    wire            gt9_txoutclkfabric_i;
    wire            gt9_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt9_txpcsreset_i;
    wire            gt9_txpmareset_i;
    wire            gt9_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt9_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT10  (X1Y10)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt10_drpaddr_i;
    wire    [15:0]  gt10_drpdi_i;
    wire    [15:0]  gt10_drpdo_i;
    wire            gt10_drpen_i;
    wire            gt10_drprdy_i;
    wire            gt10_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt10_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt10_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt10_eyescanreset_i;
    wire            gt10_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt10_eyescandataerror_i;
    wire            gt10_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt10_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt10_rxprbserr_i;
    wire    [2:0]   gt10_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt10_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt10_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt10_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt10_rxdfelpmreset_i;
    wire    [6:0]   gt10_rxmonitorout_i;
    wire    [1:0]   gt10_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt10_rxoutclk_i;
    wire            gt10_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt10_gtrxreset_i;
    wire            gt10_rxpcsreset_i;
    wire            gt10_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt10_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt10_gttxreset_i;
    wire            gt10_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt10_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt10_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt10_gtxtxn_i;
    wire            gt10_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt10_txoutclk_i;
    wire            gt10_txoutclkfabric_i;
    wire            gt10_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt10_txpcsreset_i;
    wire            gt10_txpmareset_i;
    wire            gt10_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt10_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT11  (X1Y11)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt11_drpaddr_i;
    wire    [15:0]  gt11_drpdi_i;
    wire    [15:0]  gt11_drpdo_i;
    wire            gt11_drpen_i;
    wire            gt11_drprdy_i;
    wire            gt11_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt11_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt11_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt11_eyescanreset_i;
    wire            gt11_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt11_eyescandataerror_i;
    wire            gt11_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt11_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt11_rxprbserr_i;
    wire    [2:0]   gt11_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt11_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt11_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt11_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt11_rxdfelpmreset_i;
    wire    [6:0]   gt11_rxmonitorout_i;
    wire    [1:0]   gt11_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt11_rxoutclk_i;
    wire            gt11_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt11_gtrxreset_i;
    wire            gt11_rxpcsreset_i;
    wire            gt11_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt11_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt11_gttxreset_i;
    wire            gt11_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt11_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt11_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt11_gtxtxn_i;
    wire            gt11_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt11_txoutclk_i;
    wire            gt11_txoutclkfabric_i;
    wire            gt11_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt11_txpcsreset_i;
    wire            gt11_txpmareset_i;
    wire            gt11_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt11_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT12  (X1Y12)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt12_drpaddr_i;
    wire    [15:0]  gt12_drpdi_i;
    wire    [15:0]  gt12_drpdo_i;
    wire            gt12_drpen_i;
    wire            gt12_drprdy_i;
    wire            gt12_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt12_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt12_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt12_eyescanreset_i;
    wire            gt12_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt12_eyescandataerror_i;
    wire            gt12_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt12_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt12_rxprbserr_i;
    wire    [2:0]   gt12_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt12_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt12_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt12_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt12_rxdfelpmreset_i;
    wire    [6:0]   gt12_rxmonitorout_i;
    wire    [1:0]   gt12_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt12_rxoutclk_i;
    wire            gt12_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt12_gtrxreset_i;
    wire            gt12_rxpcsreset_i;
    wire            gt12_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt12_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt12_gttxreset_i;
    wire            gt12_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt12_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt12_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt12_gtxtxn_i;
    wire            gt12_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt12_txoutclk_i;
    wire            gt12_txoutclkfabric_i;
    wire            gt12_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt12_txpcsreset_i;
    wire            gt12_txpmareset_i;
    wire            gt12_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt12_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT13  (X1Y13)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt13_drpaddr_i;
    wire    [15:0]  gt13_drpdi_i;
    wire    [15:0]  gt13_drpdo_i;
    wire            gt13_drpen_i;
    wire            gt13_drprdy_i;
    wire            gt13_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt13_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt13_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt13_eyescanreset_i;
    wire            gt13_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt13_eyescandataerror_i;
    wire            gt13_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt13_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt13_rxprbserr_i;
    wire    [2:0]   gt13_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt13_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt13_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt13_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt13_rxdfelpmreset_i;
    wire    [6:0]   gt13_rxmonitorout_i;
    wire    [1:0]   gt13_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt13_rxoutclk_i;
    wire            gt13_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt13_gtrxreset_i;
    wire            gt13_rxpcsreset_i;
    wire            gt13_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt13_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt13_gttxreset_i;
    wire            gt13_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt13_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt13_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt13_gtxtxn_i;
    wire            gt13_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt13_txoutclk_i;
    wire            gt13_txoutclkfabric_i;
    wire            gt13_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt13_txpcsreset_i;
    wire            gt13_txpmareset_i;
    wire            gt13_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt13_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT14  (X1Y14)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt14_drpaddr_i;
    wire    [15:0]  gt14_drpdi_i;
    wire    [15:0]  gt14_drpdo_i;
    wire            gt14_drpen_i;
    wire            gt14_drprdy_i;
    wire            gt14_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt14_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt14_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt14_eyescanreset_i;
    wire            gt14_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt14_eyescandataerror_i;
    wire            gt14_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt14_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt14_rxprbserr_i;
    wire    [2:0]   gt14_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt14_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt14_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt14_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt14_rxdfelpmreset_i;
    wire    [6:0]   gt14_rxmonitorout_i;
    wire    [1:0]   gt14_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt14_rxoutclk_i;
    wire            gt14_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt14_gtrxreset_i;
    wire            gt14_rxpcsreset_i;
    wire            gt14_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt14_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt14_gttxreset_i;
    wire            gt14_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt14_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt14_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt14_gtxtxn_i;
    wire            gt14_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt14_txoutclk_i;
    wire            gt14_txoutclkfabric_i;
    wire            gt14_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt14_txpcsreset_i;
    wire            gt14_txpmareset_i;
    wire            gt14_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt14_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT15  (X1Y15)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt15_drpaddr_i;
    wire    [15:0]  gt15_drpdi_i;
    wire    [15:0]  gt15_drpdo_i;
    wire            gt15_drpen_i;
    wire            gt15_drprdy_i;
    wire            gt15_drpwe_i;
    //------------------------- Digital Monitor Ports --------------------------
    wire    [7:0]   gt15_dmonitorout_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt15_loopback_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt15_eyescanreset_i;
    wire            gt15_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt15_eyescandataerror_i;
    wire            gt15_eyescantrigger_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [31:0]  gt15_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt15_rxprbserr_i;
    wire    [2:0]   gt15_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt15_rxprbscntreset_i;
    //------------------------- Receive Ports - RX AFE -------------------------
    wire            gt15_gtxrxp_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt15_gtxrxn_i;
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    wire            gt15_rxdfelpmreset_i;
    wire    [6:0]   gt15_rxmonitorout_i;
    wire    [1:0]   gt15_rxmonitorsel_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt15_rxoutclk_i;
    wire            gt15_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt15_gtrxreset_i;
    wire            gt15_rxpcsreset_i;
    wire            gt15_rxpmareset_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt15_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt15_gttxreset_i;
    wire            gt15_txuserrdy_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt15_txprbsforceerr_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire    [31:0]  gt15_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt15_gtxtxn_i;
    wire            gt15_gtxtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt15_txoutclk_i;
    wire            gt15_txoutclkfabric_i;
    wire            gt15_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt15_txpcsreset_i;
    wire            gt15_txpmareset_i;
    wire            gt15_txresetdone_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt15_txprbssel_i;

    //____________________________COMMON PORTS________________________________
    //-------------------- Common Block  - Ref Clock Ports ---------------------
    wire            gt0_gtrefclk1_common_i;
    //----------------------- Common Block - QPLL Ports ------------------------
    wire            gt0_qplllock_i;
    wire            gt0_qpllrefclklost_i;
    wire            gt0_qpllreset_i;

    //____________________________COMMON PORTS________________________________
    //-------------------- Common Block  - Ref Clock Ports ---------------------
    wire            gt1_gtrefclk1_common_i;
    //----------------------- Common Block - QPLL Ports ------------------------
    wire            gt1_qplllock_i;
    wire            gt1_qpllrefclklost_i;
    wire            gt1_qpllreset_i;

    //____________________________COMMON PORTS________________________________
    //-------------------- Common Block  - Ref Clock Ports ---------------------
    wire            gt2_gtrefclk1_common_i;
    //----------------------- Common Block - QPLL Ports ------------------------
    wire            gt2_qplllock_i;
    wire            gt2_qpllrefclklost_i;
    wire            gt2_qpllreset_i;

    //____________________________COMMON PORTS________________________________
    //-------------------- Common Block  - Ref Clock Ports ---------------------
    wire            gt3_gtrefclk1_common_i;
    //----------------------- Common Block - QPLL Ports ------------------------
    wire            gt3_qplllock_i;
    wire            gt3_qpllrefclklost_i;
    wire            gt3_qpllreset_i;


    //----------------------------- Global Signals -----------------------------

    wire            drpclk_in_i;
    wire            DRPCLK_IN;
    wire            gt0_tx_system_reset_c;
    wire            gt0_rx_system_reset_c;
    wire            gt1_tx_system_reset_c;
    wire            gt1_rx_system_reset_c;
    wire            gt2_tx_system_reset_c;
    wire            gt2_rx_system_reset_c;
    wire            gt3_tx_system_reset_c;
    wire            gt3_rx_system_reset_c;
    wire            gt4_tx_system_reset_c;
    wire            gt4_rx_system_reset_c;
    wire            gt5_tx_system_reset_c;
    wire            gt5_rx_system_reset_c;
    wire            gt6_tx_system_reset_c;
    wire            gt6_rx_system_reset_c;
    wire            gt7_tx_system_reset_c;
    wire            gt7_rx_system_reset_c;
    wire            gt8_tx_system_reset_c;
    wire            gt8_rx_system_reset_c;
    wire            gt9_tx_system_reset_c;
    wire            gt9_rx_system_reset_c;
    wire            gt10_tx_system_reset_c;
    wire            gt10_rx_system_reset_c;
    wire            gt11_tx_system_reset_c;
    wire            gt11_rx_system_reset_c;
    wire            gt12_tx_system_reset_c;
    wire            gt12_rx_system_reset_c;
    wire            gt13_tx_system_reset_c;
    wire            gt13_rx_system_reset_c;
    wire            gt14_tx_system_reset_c;
    wire            gt14_rx_system_reset_c;
    wire            gt15_tx_system_reset_c;
    wire            gt15_rx_system_reset_c;
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [7:0]   tied_to_vcc_vec_i;
    wire            GTTXRESET_IN;
    wire            GTRXRESET_IN;
    wire            QPLLRESET_IN;

     //--------------------------- User Clocks ---------------------------------
     wire            gt0_txusrclk_i; 
     wire            gt0_txusrclk2_i; 
     wire            gt0_rxusrclk_i; 
     wire            gt0_rxusrclk2_i; 
     wire            gt1_txusrclk_i; 
     wire            gt1_txusrclk2_i; 
     wire            gt1_rxusrclk_i; 
     wire            gt1_rxusrclk2_i; 
     wire            gt2_txusrclk_i; 
     wire            gt2_txusrclk2_i; 
     wire            gt2_rxusrclk_i; 
     wire            gt2_rxusrclk2_i; 
     wire            gt3_txusrclk_i; 
     wire            gt3_txusrclk2_i; 
     wire            gt3_rxusrclk_i; 
     wire            gt3_rxusrclk2_i; 
     wire            gt4_txusrclk_i; 
     wire            gt4_txusrclk2_i; 
     wire            gt4_rxusrclk_i; 
     wire            gt4_rxusrclk2_i; 
     wire            gt5_txusrclk_i; 
     wire            gt5_txusrclk2_i; 
     wire            gt5_rxusrclk_i; 
     wire            gt5_rxusrclk2_i; 
     wire            gt6_txusrclk_i; 
     wire            gt6_txusrclk2_i; 
     wire            gt6_rxusrclk_i; 
     wire            gt6_rxusrclk2_i; 
     wire            gt7_txusrclk_i; 
     wire            gt7_txusrclk2_i; 
     wire            gt7_rxusrclk_i; 
     wire            gt7_rxusrclk2_i; 
     wire            gt8_txusrclk_i; 
     wire            gt8_txusrclk2_i; 
     wire            gt8_rxusrclk_i; 
     wire            gt8_rxusrclk2_i; 
     wire            gt9_txusrclk_i; 
     wire            gt9_txusrclk2_i; 
     wire            gt9_rxusrclk_i; 
     wire            gt9_rxusrclk2_i; 
     wire            gt10_txusrclk_i; 
     wire            gt10_txusrclk2_i; 
     wire            gt10_rxusrclk_i; 
     wire            gt10_rxusrclk2_i; 
     wire            gt11_txusrclk_i; 
     wire            gt11_txusrclk2_i; 
     wire            gt11_rxusrclk_i; 
     wire            gt11_rxusrclk2_i; 
     wire            gt12_txusrclk_i; 
     wire            gt12_txusrclk2_i; 
     wire            gt12_rxusrclk_i; 
     wire            gt12_rxusrclk2_i; 
     wire            gt13_txusrclk_i; 
     wire            gt13_txusrclk2_i; 
     wire            gt13_rxusrclk_i; 
     wire            gt13_rxusrclk2_i; 
     wire            gt14_txusrclk_i; 
     wire            gt14_txusrclk2_i; 
     wire            gt14_rxusrclk_i; 
     wire            gt14_rxusrclk2_i; 
     wire            gt15_txusrclk_i; 
     wire            gt15_txusrclk2_i; 
     wire            gt15_rxusrclk_i; 
     wire            gt15_rxusrclk2_i; 
 
    //--------------------------- Reference Clocks ----------------------------
    
    wire            q1_clk0_refclk_i;
    
    wire            q2_clk0_refclk_i;


    //--------------------- Frame check/gen Module Signals --------------------
    wire            gt0_matchn_i;
    
    wire    [3:0]   gt0_txcharisk_float_i;
   
    wire    [15:0]  gt0_txdata_float16_i;
    wire    [31:0]  gt0_txdata_float_i;
    
    
    wire            gt0_block_sync_i;
    wire            gt0_track_data_i;
    wire    [7:0]   gt0_error_count_i;
    wire            gt0_frame_check_reset_i;
    wire            gt0_inc_in_i;
    wire            gt0_inc_out_i;
    wire    [31:0]  gt0_unscrambled_data_i;

    wire            gt1_matchn_i;
    
    wire    [3:0]   gt1_txcharisk_float_i;
   
    wire    [15:0]  gt1_txdata_float16_i;
    wire    [31:0]  gt1_txdata_float_i;
    
    
    wire            gt1_block_sync_i;
    wire            gt1_track_data_i;
    wire    [7:0]   gt1_error_count_i;
    wire            gt1_frame_check_reset_i;
    wire            gt1_inc_in_i;
    wire            gt1_inc_out_i;
    wire    [31:0]  gt1_unscrambled_data_i;

    wire            gt2_matchn_i;
    
    wire    [3:0]   gt2_txcharisk_float_i;
   
    wire    [15:0]  gt2_txdata_float16_i;
    wire    [31:0]  gt2_txdata_float_i;
    
    
    wire            gt2_block_sync_i;
    wire            gt2_track_data_i;
    wire    [7:0]   gt2_error_count_i;
    wire            gt2_frame_check_reset_i;
    wire            gt2_inc_in_i;
    wire            gt2_inc_out_i;
    wire    [31:0]  gt2_unscrambled_data_i;

    wire            gt3_matchn_i;
    
    wire    [3:0]   gt3_txcharisk_float_i;
   
    wire    [15:0]  gt3_txdata_float16_i;
    wire    [31:0]  gt3_txdata_float_i;
    
    
    wire            gt3_block_sync_i;
    wire            gt3_track_data_i;
    wire    [7:0]   gt3_error_count_i;
    wire            gt3_frame_check_reset_i;
    wire            gt3_inc_in_i;
    wire            gt3_inc_out_i;
    wire    [31:0]  gt3_unscrambled_data_i;

    wire            gt4_matchn_i;
    
    wire    [3:0]   gt4_txcharisk_float_i;
   
    wire    [15:0]  gt4_txdata_float16_i;
    wire    [31:0]  gt4_txdata_float_i;
    
    
    wire            gt4_block_sync_i;
    wire            gt4_track_data_i;
    wire    [7:0]   gt4_error_count_i;
    wire            gt4_frame_check_reset_i;
    wire            gt4_inc_in_i;
    wire            gt4_inc_out_i;
    wire    [31:0]  gt4_unscrambled_data_i;

    wire            gt5_matchn_i;
    
    wire    [3:0]   gt5_txcharisk_float_i;
   
    wire    [15:0]  gt5_txdata_float16_i;
    wire    [31:0]  gt5_txdata_float_i;
    
    
    wire            gt5_block_sync_i;
    wire            gt5_track_data_i;
    wire    [7:0]   gt5_error_count_i;
    wire            gt5_frame_check_reset_i;
    wire            gt5_inc_in_i;
    wire            gt5_inc_out_i;
    wire    [31:0]  gt5_unscrambled_data_i;

    wire            gt6_matchn_i;
    
    wire    [3:0]   gt6_txcharisk_float_i;
   
    wire    [15:0]  gt6_txdata_float16_i;
    wire    [31:0]  gt6_txdata_float_i;
    
    
    wire            gt6_block_sync_i;
    wire            gt6_track_data_i;
    wire    [7:0]   gt6_error_count_i;
    wire            gt6_frame_check_reset_i;
    wire            gt6_inc_in_i;
    wire            gt6_inc_out_i;
    wire    [31:0]  gt6_unscrambled_data_i;

    wire            gt7_matchn_i;
    
    wire    [3:0]   gt7_txcharisk_float_i;
   
    wire    [15:0]  gt7_txdata_float16_i;
    wire    [31:0]  gt7_txdata_float_i;
    
    
    wire            gt7_block_sync_i;
    wire            gt7_track_data_i;
    wire    [7:0]   gt7_error_count_i;
    wire            gt7_frame_check_reset_i;
    wire            gt7_inc_in_i;
    wire            gt7_inc_out_i;
    wire    [31:0]  gt7_unscrambled_data_i;

    wire            gt8_matchn_i;
    
    wire    [3:0]   gt8_txcharisk_float_i;
   
    wire    [15:0]  gt8_txdata_float16_i;
    wire    [31:0]  gt8_txdata_float_i;
    
    
    wire            gt8_block_sync_i;
    wire            gt8_track_data_i;
    wire    [7:0]   gt8_error_count_i;
    wire            gt8_frame_check_reset_i;
    wire            gt8_inc_in_i;
    wire            gt8_inc_out_i;
    wire    [31:0]  gt8_unscrambled_data_i;

    wire            gt9_matchn_i;
    
    wire    [3:0]   gt9_txcharisk_float_i;
   
    wire    [15:0]  gt9_txdata_float16_i;
    wire    [31:0]  gt9_txdata_float_i;
    
    
    wire            gt9_block_sync_i;
    wire            gt9_track_data_i;
    wire    [7:0]   gt9_error_count_i;
    wire            gt9_frame_check_reset_i;
    wire            gt9_inc_in_i;
    wire            gt9_inc_out_i;
    wire    [31:0]  gt9_unscrambled_data_i;

    wire            gt10_matchn_i;
    
    wire    [3:0]   gt10_txcharisk_float_i;
   
    wire    [15:0]  gt10_txdata_float16_i;
    wire    [31:0]  gt10_txdata_float_i;
    
    
    wire            gt10_block_sync_i;
    wire            gt10_track_data_i;
    wire    [7:0]   gt10_error_count_i;
    wire            gt10_frame_check_reset_i;
    wire            gt10_inc_in_i;
    wire            gt10_inc_out_i;
    wire    [31:0]  gt10_unscrambled_data_i;

    wire            gt11_matchn_i;
    
    wire    [3:0]   gt11_txcharisk_float_i;
   
    wire    [15:0]  gt11_txdata_float16_i;
    wire    [31:0]  gt11_txdata_float_i;
    
    
    wire            gt11_block_sync_i;
    wire            gt11_track_data_i;
    wire    [7:0]   gt11_error_count_i;
    wire            gt11_frame_check_reset_i;
    wire            gt11_inc_in_i;
    wire            gt11_inc_out_i;
    wire    [31:0]  gt11_unscrambled_data_i;

    wire            gt12_matchn_i;
    
    wire    [3:0]   gt12_txcharisk_float_i;
   
    wire    [15:0]  gt12_txdata_float16_i;
    wire    [31:0]  gt12_txdata_float_i;
    
    
    wire            gt12_block_sync_i;
    wire            gt12_track_data_i;
    wire    [7:0]   gt12_error_count_i;
    wire            gt12_frame_check_reset_i;
    wire            gt12_inc_in_i;
    wire            gt12_inc_out_i;
    wire    [31:0]  gt12_unscrambled_data_i;

    wire            gt13_matchn_i;
    
    wire    [3:0]   gt13_txcharisk_float_i;
   
    wire    [15:0]  gt13_txdata_float16_i;
    wire    [31:0]  gt13_txdata_float_i;
    
    
    wire            gt13_block_sync_i;
    wire            gt13_track_data_i;
    wire    [7:0]   gt13_error_count_i;
    wire            gt13_frame_check_reset_i;
    wire            gt13_inc_in_i;
    wire            gt13_inc_out_i;
    wire    [31:0]  gt13_unscrambled_data_i;

    wire            gt14_matchn_i;
    
    wire    [3:0]   gt14_txcharisk_float_i;
   
    wire    [15:0]  gt14_txdata_float16_i;
    wire    [31:0]  gt14_txdata_float_i;
    
    
    wire            gt14_block_sync_i;
    wire            gt14_track_data_i;
    wire    [7:0]   gt14_error_count_i;
    wire            gt14_frame_check_reset_i;
    wire            gt14_inc_in_i;
    wire            gt14_inc_out_i;
    wire    [31:0]  gt14_unscrambled_data_i;

    wire            gt15_matchn_i;
    
    wire    [3:0]   gt15_txcharisk_float_i;
   
    wire    [15:0]  gt15_txdata_float16_i;
    wire    [31:0]  gt15_txdata_float_i;
    
    
    wire            gt15_block_sync_i;
    wire            gt15_track_data_i;
    wire    [7:0]   gt15_error_count_i;
    wire            gt15_frame_check_reset_i;
    wire            gt15_inc_in_i;
    wire            gt15_inc_out_i;
    wire    [31:0]  gt15_unscrambled_data_i;

    wire            reset_on_data_error_i;
    wire            track_data_out_i;
  

    //--------------------- Chipscope Signals ---------------------------------
    (*mark_debug = "TRUE" *)wire   rxresetdone_vio_i;
    wire    [35:0]  tx_data_vio_control_i;
    wire    [35:0]  rx_data_vio_control_i;
    wire    [35:0]  shared_vio_control_i;
    wire    [35:0]  ila_control_i;
    wire    [35:0]  channel_drp_vio_control_i;
    wire    [35:0]  common_drp_vio_control_i;
    wire    [31:0]  tx_data_vio_async_in_i;
    wire    [31:0]  tx_data_vio_sync_in_i;
    wire    [31:0]  tx_data_vio_async_out_i;
    wire    [31:0]  tx_data_vio_sync_out_i;
    wire    [31:0]  rx_data_vio_async_in_i;
    wire    [31:0]  rx_data_vio_sync_in_i;
    wire    [31:0]  rx_data_vio_async_out_i;
    wire    [31:0]  rx_data_vio_sync_out_i;
    wire    [31:0]  shared_vio_in_i;
    wire    [31:0]  shared_vio_out_i;
    wire    [163:0] ila_in_i;
    wire    [31:0]  channel_drp_vio_async_in_i;
    wire    [31:0]  channel_drp_vio_sync_in_i;
    wire    [31:0]  channel_drp_vio_async_out_i;
    wire    [31:0]  channel_drp_vio_sync_out_i;
    wire    [31:0]  common_drp_vio_async_in_i;
    wire    [31:0]  common_drp_vio_sync_in_i;
    wire    [31:0]  common_drp_vio_async_out_i;
    wire    [31:0]  common_drp_vio_sync_out_i;

    wire    [31:0]  gt0_tx_data_vio_async_in_i;
    wire    [31:0]  gt0_tx_data_vio_sync_in_i;
    wire    [31:0]  gt0_tx_data_vio_async_out_i;
    wire    [31:0]  gt0_tx_data_vio_sync_out_i;
    wire    [31:0]  gt0_rx_data_vio_async_in_i;
    wire    [31:0]  gt0_rx_data_vio_sync_in_i;
    wire    [31:0]  gt0_rx_data_vio_async_out_i;
    wire    [31:0]  gt0_rx_data_vio_sync_out_i;
    wire    [163:0] gt0_ila_in_i;
    wire    [31:0]  gt0_channel_drp_vio_async_in_i;
    wire    [31:0]  gt0_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt0_channel_drp_vio_async_out_i;
    wire    [31:0]  gt0_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt0_common_drp_vio_async_in_i;
    wire    [31:0]  gt0_common_drp_vio_sync_in_i;
    wire    [31:0]  gt0_common_drp_vio_async_out_i;
    wire    [31:0]  gt0_common_drp_vio_sync_out_i;

    wire    [31:0]  gt1_tx_data_vio_async_in_i;
    wire    [31:0]  gt1_tx_data_vio_sync_in_i;
    wire    [31:0]  gt1_tx_data_vio_async_out_i;
    wire    [31:0]  gt1_tx_data_vio_sync_out_i;
    wire    [31:0]  gt1_rx_data_vio_async_in_i;
    wire    [31:0]  gt1_rx_data_vio_sync_in_i;
    wire    [31:0]  gt1_rx_data_vio_async_out_i;
    wire    [31:0]  gt1_rx_data_vio_sync_out_i;
    wire    [163:0] gt1_ila_in_i;
    wire    [31:0]  gt1_channel_drp_vio_async_in_i;
    wire    [31:0]  gt1_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt1_channel_drp_vio_async_out_i;
    wire    [31:0]  gt1_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt1_common_drp_vio_async_in_i;
    wire    [31:0]  gt1_common_drp_vio_sync_in_i;
    wire    [31:0]  gt1_common_drp_vio_async_out_i;
    wire    [31:0]  gt1_common_drp_vio_sync_out_i;

    wire    [31:0]  gt2_tx_data_vio_async_in_i;
    wire    [31:0]  gt2_tx_data_vio_sync_in_i;
    wire    [31:0]  gt2_tx_data_vio_async_out_i;
    wire    [31:0]  gt2_tx_data_vio_sync_out_i;
    wire    [31:0]  gt2_rx_data_vio_async_in_i;
    wire    [31:0]  gt2_rx_data_vio_sync_in_i;
    wire    [31:0]  gt2_rx_data_vio_async_out_i;
    wire    [31:0]  gt2_rx_data_vio_sync_out_i;
    wire    [163:0] gt2_ila_in_i;
    wire    [31:0]  gt2_channel_drp_vio_async_in_i;
    wire    [31:0]  gt2_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt2_channel_drp_vio_async_out_i;
    wire    [31:0]  gt2_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt2_common_drp_vio_async_in_i;
    wire    [31:0]  gt2_common_drp_vio_sync_in_i;
    wire    [31:0]  gt2_common_drp_vio_async_out_i;
    wire    [31:0]  gt2_common_drp_vio_sync_out_i;

    wire    [31:0]  gt3_tx_data_vio_async_in_i;
    wire    [31:0]  gt3_tx_data_vio_sync_in_i;
    wire    [31:0]  gt3_tx_data_vio_async_out_i;
    wire    [31:0]  gt3_tx_data_vio_sync_out_i;
    wire    [31:0]  gt3_rx_data_vio_async_in_i;
    wire    [31:0]  gt3_rx_data_vio_sync_in_i;
    wire    [31:0]  gt3_rx_data_vio_async_out_i;
    wire    [31:0]  gt3_rx_data_vio_sync_out_i;
    wire    [163:0] gt3_ila_in_i;
    wire    [31:0]  gt3_channel_drp_vio_async_in_i;
    wire    [31:0]  gt3_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt3_channel_drp_vio_async_out_i;
    wire    [31:0]  gt3_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt3_common_drp_vio_async_in_i;
    wire    [31:0]  gt3_common_drp_vio_sync_in_i;
    wire    [31:0]  gt3_common_drp_vio_async_out_i;
    wire    [31:0]  gt3_common_drp_vio_sync_out_i;

    wire    [31:0]  gt4_tx_data_vio_async_in_i;
    wire    [31:0]  gt4_tx_data_vio_sync_in_i;
    wire    [31:0]  gt4_tx_data_vio_async_out_i;
    wire    [31:0]  gt4_tx_data_vio_sync_out_i;
    wire    [31:0]  gt4_rx_data_vio_async_in_i;
    wire    [31:0]  gt4_rx_data_vio_sync_in_i;
    wire    [31:0]  gt4_rx_data_vio_async_out_i;
    wire    [31:0]  gt4_rx_data_vio_sync_out_i;
    wire    [163:0] gt4_ila_in_i;
    wire    [31:0]  gt4_channel_drp_vio_async_in_i;
    wire    [31:0]  gt4_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt4_channel_drp_vio_async_out_i;
    wire    [31:0]  gt4_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt4_common_drp_vio_async_in_i;
    wire    [31:0]  gt4_common_drp_vio_sync_in_i;
    wire    [31:0]  gt4_common_drp_vio_async_out_i;
    wire    [31:0]  gt4_common_drp_vio_sync_out_i;

    wire    [31:0]  gt5_tx_data_vio_async_in_i;
    wire    [31:0]  gt5_tx_data_vio_sync_in_i;
    wire    [31:0]  gt5_tx_data_vio_async_out_i;
    wire    [31:0]  gt5_tx_data_vio_sync_out_i;
    wire    [31:0]  gt5_rx_data_vio_async_in_i;
    wire    [31:0]  gt5_rx_data_vio_sync_in_i;
    wire    [31:0]  gt5_rx_data_vio_async_out_i;
    wire    [31:0]  gt5_rx_data_vio_sync_out_i;
    wire    [163:0] gt5_ila_in_i;
    wire    [31:0]  gt5_channel_drp_vio_async_in_i;
    wire    [31:0]  gt5_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt5_channel_drp_vio_async_out_i;
    wire    [31:0]  gt5_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt5_common_drp_vio_async_in_i;
    wire    [31:0]  gt5_common_drp_vio_sync_in_i;
    wire    [31:0]  gt5_common_drp_vio_async_out_i;
    wire    [31:0]  gt5_common_drp_vio_sync_out_i;

    wire    [31:0]  gt6_tx_data_vio_async_in_i;
    wire    [31:0]  gt6_tx_data_vio_sync_in_i;
    wire    [31:0]  gt6_tx_data_vio_async_out_i;
    wire    [31:0]  gt6_tx_data_vio_sync_out_i;
    wire    [31:0]  gt6_rx_data_vio_async_in_i;
    wire    [31:0]  gt6_rx_data_vio_sync_in_i;
    wire    [31:0]  gt6_rx_data_vio_async_out_i;
    wire    [31:0]  gt6_rx_data_vio_sync_out_i;
    wire    [163:0] gt6_ila_in_i;
    wire    [31:0]  gt6_channel_drp_vio_async_in_i;
    wire    [31:0]  gt6_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt6_channel_drp_vio_async_out_i;
    wire    [31:0]  gt6_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt6_common_drp_vio_async_in_i;
    wire    [31:0]  gt6_common_drp_vio_sync_in_i;
    wire    [31:0]  gt6_common_drp_vio_async_out_i;
    wire    [31:0]  gt6_common_drp_vio_sync_out_i;

    wire    [31:0]  gt7_tx_data_vio_async_in_i;
    wire    [31:0]  gt7_tx_data_vio_sync_in_i;
    wire    [31:0]  gt7_tx_data_vio_async_out_i;
    wire    [31:0]  gt7_tx_data_vio_sync_out_i;
    wire    [31:0]  gt7_rx_data_vio_async_in_i;
    wire    [31:0]  gt7_rx_data_vio_sync_in_i;
    wire    [31:0]  gt7_rx_data_vio_async_out_i;
    wire    [31:0]  gt7_rx_data_vio_sync_out_i;
    wire    [163:0] gt7_ila_in_i;
    wire    [31:0]  gt7_channel_drp_vio_async_in_i;
    wire    [31:0]  gt7_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt7_channel_drp_vio_async_out_i;
    wire    [31:0]  gt7_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt7_common_drp_vio_async_in_i;
    wire    [31:0]  gt7_common_drp_vio_sync_in_i;
    wire    [31:0]  gt7_common_drp_vio_async_out_i;
    wire    [31:0]  gt7_common_drp_vio_sync_out_i;

    wire    [31:0]  gt8_tx_data_vio_async_in_i;
    wire    [31:0]  gt8_tx_data_vio_sync_in_i;
    wire    [31:0]  gt8_tx_data_vio_async_out_i;
    wire    [31:0]  gt8_tx_data_vio_sync_out_i;
    wire    [31:0]  gt8_rx_data_vio_async_in_i;
    wire    [31:0]  gt8_rx_data_vio_sync_in_i;
    wire    [31:0]  gt8_rx_data_vio_async_out_i;
    wire    [31:0]  gt8_rx_data_vio_sync_out_i;
    wire    [163:0] gt8_ila_in_i;
    wire    [31:0]  gt8_channel_drp_vio_async_in_i;
    wire    [31:0]  gt8_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt8_channel_drp_vio_async_out_i;
    wire    [31:0]  gt8_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt8_common_drp_vio_async_in_i;
    wire    [31:0]  gt8_common_drp_vio_sync_in_i;
    wire    [31:0]  gt8_common_drp_vio_async_out_i;
    wire    [31:0]  gt8_common_drp_vio_sync_out_i;

    wire    [31:0]  gt9_tx_data_vio_async_in_i;
    wire    [31:0]  gt9_tx_data_vio_sync_in_i;
    wire    [31:0]  gt9_tx_data_vio_async_out_i;
    wire    [31:0]  gt9_tx_data_vio_sync_out_i;
    wire    [31:0]  gt9_rx_data_vio_async_in_i;
    wire    [31:0]  gt9_rx_data_vio_sync_in_i;
    wire    [31:0]  gt9_rx_data_vio_async_out_i;
    wire    [31:0]  gt9_rx_data_vio_sync_out_i;
    wire    [163:0] gt9_ila_in_i;
    wire    [31:0]  gt9_channel_drp_vio_async_in_i;
    wire    [31:0]  gt9_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt9_channel_drp_vio_async_out_i;
    wire    [31:0]  gt9_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt9_common_drp_vio_async_in_i;
    wire    [31:0]  gt9_common_drp_vio_sync_in_i;
    wire    [31:0]  gt9_common_drp_vio_async_out_i;
    wire    [31:0]  gt9_common_drp_vio_sync_out_i;

    wire    [31:0]  gt10_tx_data_vio_async_in_i;
    wire    [31:0]  gt10_tx_data_vio_sync_in_i;
    wire    [31:0]  gt10_tx_data_vio_async_out_i;
    wire    [31:0]  gt10_tx_data_vio_sync_out_i;
    wire    [31:0]  gt10_rx_data_vio_async_in_i;
    wire    [31:0]  gt10_rx_data_vio_sync_in_i;
    wire    [31:0]  gt10_rx_data_vio_async_out_i;
    wire    [31:0]  gt10_rx_data_vio_sync_out_i;
    wire    [163:0] gt10_ila_in_i;
    wire    [31:0]  gt10_channel_drp_vio_async_in_i;
    wire    [31:0]  gt10_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt10_channel_drp_vio_async_out_i;
    wire    [31:0]  gt10_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt10_common_drp_vio_async_in_i;
    wire    [31:0]  gt10_common_drp_vio_sync_in_i;
    wire    [31:0]  gt10_common_drp_vio_async_out_i;
    wire    [31:0]  gt10_common_drp_vio_sync_out_i;

    wire    [31:0]  gt11_tx_data_vio_async_in_i;
    wire    [31:0]  gt11_tx_data_vio_sync_in_i;
    wire    [31:0]  gt11_tx_data_vio_async_out_i;
    wire    [31:0]  gt11_tx_data_vio_sync_out_i;
    wire    [31:0]  gt11_rx_data_vio_async_in_i;
    wire    [31:0]  gt11_rx_data_vio_sync_in_i;
    wire    [31:0]  gt11_rx_data_vio_async_out_i;
    wire    [31:0]  gt11_rx_data_vio_sync_out_i;
    wire    [163:0] gt11_ila_in_i;
    wire    [31:0]  gt11_channel_drp_vio_async_in_i;
    wire    [31:0]  gt11_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt11_channel_drp_vio_async_out_i;
    wire    [31:0]  gt11_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt11_common_drp_vio_async_in_i;
    wire    [31:0]  gt11_common_drp_vio_sync_in_i;
    wire    [31:0]  gt11_common_drp_vio_async_out_i;
    wire    [31:0]  gt11_common_drp_vio_sync_out_i;

    wire    [31:0]  gt12_tx_data_vio_async_in_i;
    wire    [31:0]  gt12_tx_data_vio_sync_in_i;
    wire    [31:0]  gt12_tx_data_vio_async_out_i;
    wire    [31:0]  gt12_tx_data_vio_sync_out_i;
    wire    [31:0]  gt12_rx_data_vio_async_in_i;
    wire    [31:0]  gt12_rx_data_vio_sync_in_i;
    wire    [31:0]  gt12_rx_data_vio_async_out_i;
    wire    [31:0]  gt12_rx_data_vio_sync_out_i;
    wire    [163:0] gt12_ila_in_i;
    wire    [31:0]  gt12_channel_drp_vio_async_in_i;
    wire    [31:0]  gt12_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt12_channel_drp_vio_async_out_i;
    wire    [31:0]  gt12_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt12_common_drp_vio_async_in_i;
    wire    [31:0]  gt12_common_drp_vio_sync_in_i;
    wire    [31:0]  gt12_common_drp_vio_async_out_i;
    wire    [31:0]  gt12_common_drp_vio_sync_out_i;

    wire    [31:0]  gt13_tx_data_vio_async_in_i;
    wire    [31:0]  gt13_tx_data_vio_sync_in_i;
    wire    [31:0]  gt13_tx_data_vio_async_out_i;
    wire    [31:0]  gt13_tx_data_vio_sync_out_i;
    wire    [31:0]  gt13_rx_data_vio_async_in_i;
    wire    [31:0]  gt13_rx_data_vio_sync_in_i;
    wire    [31:0]  gt13_rx_data_vio_async_out_i;
    wire    [31:0]  gt13_rx_data_vio_sync_out_i;
    wire    [163:0] gt13_ila_in_i;
    wire    [31:0]  gt13_channel_drp_vio_async_in_i;
    wire    [31:0]  gt13_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt13_channel_drp_vio_async_out_i;
    wire    [31:0]  gt13_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt13_common_drp_vio_async_in_i;
    wire    [31:0]  gt13_common_drp_vio_sync_in_i;
    wire    [31:0]  gt13_common_drp_vio_async_out_i;
    wire    [31:0]  gt13_common_drp_vio_sync_out_i;

    wire    [31:0]  gt14_tx_data_vio_async_in_i;
    wire    [31:0]  gt14_tx_data_vio_sync_in_i;
    wire    [31:0]  gt14_tx_data_vio_async_out_i;
    wire    [31:0]  gt14_tx_data_vio_sync_out_i;
    wire    [31:0]  gt14_rx_data_vio_async_in_i;
    wire    [31:0]  gt14_rx_data_vio_sync_in_i;
    wire    [31:0]  gt14_rx_data_vio_async_out_i;
    wire    [31:0]  gt14_rx_data_vio_sync_out_i;
    wire    [163:0] gt14_ila_in_i;
    wire    [31:0]  gt14_channel_drp_vio_async_in_i;
    wire    [31:0]  gt14_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt14_channel_drp_vio_async_out_i;
    wire    [31:0]  gt14_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt14_common_drp_vio_async_in_i;
    wire    [31:0]  gt14_common_drp_vio_sync_in_i;
    wire    [31:0]  gt14_common_drp_vio_async_out_i;
    wire    [31:0]  gt14_common_drp_vio_sync_out_i;

    wire    [31:0]  gt15_tx_data_vio_async_in_i;
    wire    [31:0]  gt15_tx_data_vio_sync_in_i;
    wire    [31:0]  gt15_tx_data_vio_async_out_i;
    wire    [31:0]  gt15_tx_data_vio_sync_out_i;
    wire    [31:0]  gt15_rx_data_vio_async_in_i;
    wire    [31:0]  gt15_rx_data_vio_sync_in_i;
    wire    [31:0]  gt15_rx_data_vio_async_out_i;
    wire    [31:0]  gt15_rx_data_vio_sync_out_i;
    wire    [163:0] gt15_ila_in_i;
    wire    [31:0]  gt15_channel_drp_vio_async_in_i;
    wire    [31:0]  gt15_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt15_channel_drp_vio_async_out_i;
    wire    [31:0]  gt15_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt15_common_drp_vio_async_in_i;
    wire    [31:0]  gt15_common_drp_vio_sync_in_i;
    wire    [31:0]  gt15_common_drp_vio_async_out_i;
    wire    [31:0]  gt15_common_drp_vio_sync_out_i;


    wire            gttxreset_i;
    wire            gtrxreset_i;
    wire    [3:0]   mux_sel_i;

    wire            user_tx_reset_i;
    wire            user_rx_reset_i;
    wire            tx_vio_clk_i;
    wire            tx_vio_clk_mux_out_i;    
    wire            rx_vio_ila_clk_i;
    wire            rx_vio_ila_clk_mux_out_i;

    wire            qpllreset_i;
    


  wire [(80 -32) -1:0] zero_vector_rx_80 ;
  wire [(8 -4) -1:0] zero_vector_rx_8 ;
  wire [79:0] gt0_rxdata_ila ;
  wire [1:0]  gt0_rxdatavalid_ila; 
  wire [7:0]  gt0_rxcharisk_ila ;
  wire gt0_txmmcm_lock_ila ;
  wire gt0_rxmmcm_lock_ila ;
  wire gt0_rxresetdone_ila ;
  wire gt0_txresetdone_ila ;
  wire [79:0] gt1_rxdata_ila ;
  wire [1:0]  gt1_rxdatavalid_ila; 
  wire [7:0]  gt1_rxcharisk_ila ;
  wire gt1_txmmcm_lock_ila ;
  wire gt1_rxmmcm_lock_ila ;
  wire gt1_rxresetdone_ila ;
  wire gt1_txresetdone_ila ;
  wire [79:0] gt2_rxdata_ila ;
  wire [1:0]  gt2_rxdatavalid_ila; 
  wire [7:0]  gt2_rxcharisk_ila ;
  wire gt2_txmmcm_lock_ila ;
  wire gt2_rxmmcm_lock_ila ;
  wire gt2_rxresetdone_ila ;
  wire gt2_txresetdone_ila ;
  wire [79:0] gt3_rxdata_ila ;
  wire [1:0]  gt3_rxdatavalid_ila; 
  wire [7:0]  gt3_rxcharisk_ila ;
  wire gt3_txmmcm_lock_ila ;
  wire gt3_rxmmcm_lock_ila ;
  wire gt3_rxresetdone_ila ;
  wire gt3_txresetdone_ila ;
  wire [79:0] gt4_rxdata_ila ;
  wire [1:0]  gt4_rxdatavalid_ila; 
  wire [7:0]  gt4_rxcharisk_ila ;
  wire gt4_txmmcm_lock_ila ;
  wire gt4_rxmmcm_lock_ila ;
  wire gt4_rxresetdone_ila ;
  wire gt4_txresetdone_ila ;
  wire [79:0] gt5_rxdata_ila ;
  wire [1:0]  gt5_rxdatavalid_ila; 
  wire [7:0]  gt5_rxcharisk_ila ;
  wire gt5_txmmcm_lock_ila ;
  wire gt5_rxmmcm_lock_ila ;
  wire gt5_rxresetdone_ila ;
  wire gt5_txresetdone_ila ;
  wire [79:0] gt6_rxdata_ila ;
  wire [1:0]  gt6_rxdatavalid_ila; 
  wire [7:0]  gt6_rxcharisk_ila ;
  wire gt6_txmmcm_lock_ila ;
  wire gt6_rxmmcm_lock_ila ;
  wire gt6_rxresetdone_ila ;
  wire gt6_txresetdone_ila ;
  wire [79:0] gt7_rxdata_ila ;
  wire [1:0]  gt7_rxdatavalid_ila; 
  wire [7:0]  gt7_rxcharisk_ila ;
  wire gt7_txmmcm_lock_ila ;
  wire gt7_rxmmcm_lock_ila ;
  wire gt7_rxresetdone_ila ;
  wire gt7_txresetdone_ila ;
  wire [79:0] gt8_rxdata_ila ;
  wire [1:0]  gt8_rxdatavalid_ila; 
  wire [7:0]  gt8_rxcharisk_ila ;
  wire gt8_txmmcm_lock_ila ;
  wire gt8_rxmmcm_lock_ila ;
  wire gt8_rxresetdone_ila ;
  wire gt8_txresetdone_ila ;
  wire [79:0] gt9_rxdata_ila ;
  wire [1:0]  gt9_rxdatavalid_ila; 
  wire [7:0]  gt9_rxcharisk_ila ;
  wire gt9_txmmcm_lock_ila ;
  wire gt9_rxmmcm_lock_ila ;
  wire gt9_rxresetdone_ila ;
  wire gt9_txresetdone_ila ;
  wire [79:0] gt10_rxdata_ila ;
  wire [1:0]  gt10_rxdatavalid_ila; 
  wire [7:0]  gt10_rxcharisk_ila ;
  wire gt10_txmmcm_lock_ila ;
  wire gt10_rxmmcm_lock_ila ;
  wire gt10_rxresetdone_ila ;
  wire gt10_txresetdone_ila ;
  wire [79:0] gt11_rxdata_ila ;
  wire [1:0]  gt11_rxdatavalid_ila; 
  wire [7:0]  gt11_rxcharisk_ila ;
  wire gt11_txmmcm_lock_ila ;
  wire gt11_rxmmcm_lock_ila ;
  wire gt11_rxresetdone_ila ;
  wire gt11_txresetdone_ila ;
  wire [79:0] gt12_rxdata_ila ;
  wire [1:0]  gt12_rxdatavalid_ila; 
  wire [7:0]  gt12_rxcharisk_ila ;
  wire gt12_txmmcm_lock_ila ;
  wire gt12_rxmmcm_lock_ila ;
  wire gt12_rxresetdone_ila ;
  wire gt12_txresetdone_ila ;
  wire [79:0] gt13_rxdata_ila ;
  wire [1:0]  gt13_rxdatavalid_ila; 
  wire [7:0]  gt13_rxcharisk_ila ;
  wire gt13_txmmcm_lock_ila ;
  wire gt13_rxmmcm_lock_ila ;
  wire gt13_rxresetdone_ila ;
  wire gt13_txresetdone_ila ;
  wire [79:0] gt14_rxdata_ila ;
  wire [1:0]  gt14_rxdatavalid_ila; 
  wire [7:0]  gt14_rxcharisk_ila ;
  wire gt14_txmmcm_lock_ila ;
  wire gt14_rxmmcm_lock_ila ;
  wire gt14_rxresetdone_ila ;
  wire gt14_txresetdone_ila ;
  wire [79:0] gt15_rxdata_ila ;
  wire [1:0]  gt15_rxdatavalid_ila; 
  wire [7:0]  gt15_rxcharisk_ila ;
  wire gt15_txmmcm_lock_ila ;
  wire gt15_rxmmcm_lock_ila ;
  wire gt15_rxresetdone_ila ;
  wire gt15_txresetdone_ila ;

//**************************** Main Body of Code *******************************

//  Static signal Assigments    
assign tied_to_ground_i             = 1'b0;
assign tied_to_ground_vec_i         = 64'h0000000000000000;
assign tied_to_vcc_i                = 1'b1;
assign tied_to_vcc_vec_i            = 8'hff;

assign zero_vector_rx_80 = 0;
assign zero_vector_rx_8 = 0;

    
assign  q1_clk0_refclk_i                     =  1'b0;
    
assign  q2_clk0_refclk_i                     =  1'b0;


    //***********************************************************************//
    //                                                                       //
    //---------------------------  Main Verilog  ----------------------------//
    //                                                                       //
    //***********************************************************************//
    wire									LCLK;
    wire									clk_5M;
	wire									clk_50M;
	wire									clk_100M;
	wire									clk_200M;
	
	BUFG BUFG_inst1	(
					.O(LCLK),     // 1-bit output: Clock output
					.I(LCLK_50M)  // 1-bit input: Clock input
					);  
	Clock_PLL Clock_PLL_ins
					(
						 // Clock out ports
						 .clk_out1			(clk_5M				),     // output clk_out1
						 .clk_out2			(clk_50M			),     // output clk_out2
						 .clk_out3			(clk_100M			),     // output clk_out3
						 .clk_out4			(clk_200M			),     // output clk_out4

						 // Clock in ports
						 .clk_in1			(LCLK				));    // input clk_in1  

	//--------------------------------------------------------------------------------------------------------
	//读写控制
	//--------------------------------------------------------------------------------------------------------
	wire							[0:0]	pcie_wren;
	wire							[0:0]	pcie_rden;
	wire							[31:0]	pcie_addr;
	wire							[31:0]	data_latch;
	reg								[31:0]	pcidata_latch;
	reg								[0:0]	user_reset_c;
	reg								[0:0]	GTX_reset;
	reg								[0:0]	ADC_Control;
	reg								[0:0]	all_start_soft;
	reg								[0:0]	mode_choose_pc;
	reg								[3:0]	ADG1406_PC;
	reg								[7:0]	Pattern_number_pc;
	reg								[7:0]	TSB_addr_pc;
	reg								[0:0]	DUT0_RELAY_OUT_TEMP;
	reg								[0:0]	DUT1_RELAY_OUT_TEMP;
	reg								[0:0]	DUT2_RELAY_OUT_TEMP;
	reg								[0:0]	DUT3_RELAY_OUT_TEMP;
	reg								[0:0]	DUT4_RELAY_OUT_TEMP;
	reg								[0:0]	DUT5_RELAY_OUT_TEMP;
	reg								[0:0]	DUT6_RELAY_OUT_TEMP;
	reg								[0:0]	DUT7_RELAY_OUT_TEMP;
	reg								[0:0]	CLK_RELAY_10M_IN_TEMP;
	reg								[0:0]	CALIP_RELAY_10M_IN_TEMP;

    //写控制
    always @ (posedge LCLK_50M)
    begin
		if(pcie_wren)
		case(pcie_addr[16:0])
			   17'h1FFFF: pcidata_latch			<= data_latch;//测试用
			   17'h12210: user_reset_c			<= 1'b1;//h112214
			   17'h12214: GTX_reset				<= data_latch[0];//h112215 高速收发口复位信号需要手动撤销
			   17'h1C200: ADC_Control			<= 1'b1;//
			   17'h12200: all_start_soft		<= 1'b1;		    
			   17'h12220: mode_choose_pc 		<= data_latch[0];//循环模式：0   单次模式：1     
			   17'h1C208: ADG1406_PC 			<= data_latch[3:0];//PPMU 通道8选1
			   17'h12224: Pattern_number_pc 	<= data_latch[7:0];
			   17'h12228: TSB_addr_pc         	<= data_latch[7:0];
			// 17'h1222C: rate_choose         	<= data_latch[2:0];
			   
			//               17'h12280: RELAY_control_temp <= data_latch[20:0];
			   17'h1A108: DUT0_RELAY_OUT_TEMP 	<= data_latch[0];//dut0输出继电器控制
			//			   17'h12280: DUT0_RELAY_CALIP_TEMP <= data_latch[1];//dut0校准输入继电器控制
			   17'h1A508: DUT1_RELAY_OUT_TEMP 	<= data_latch[0];//dut1输出继电器控制
			//			   17'h12280: DUT1_RELAY_CALIP_TEMP <= data_latch[3];//dut1校准输入继电器控制
			   17'h1A908: DUT2_RELAY_OUT_TEMP 	<= data_latch[0];//dut2输出继电器控制
			//			   17'h12280: DUT2_RELAY_CALIP_TEMP <= data_latch[5];//dut2校准输入继电器控制
			   17'h1AD08: DUT3_RELAY_OUT_TEMP 	<= data_latch[0];//dut3输出继电器控制
			//			   17'h12280: DUT3_RELAY_CALIP_TEMP <= data_latch[7];//dut3校准输入继电器控制
			   17'h1B108: DUT4_RELAY_OUT_TEMP 	<= data_latch[0];//dut4输出继电器控制
			//			   17'h12280: DUT4_RELAY_CALIP_TEMP <= data_latch[9];//dut4校准输入继电器控制
			   17'h1B508: DUT5_RELAY_OUT_TEMP 	<= data_latch[0];//dut5输出继电器控制
			//			   17'h12280: DUT5_RELAY_CALIP_TEMP <= data_latch[11];//dut5校准输入继电器控制
			   17'h1B908: DUT6_RELAY_OUT_TEMP 	<= data_latch[0];//dut6输出继电器控制
			//			   17'h12280: DUT6_RELAY_CALIP_TEMP <= data_latch[13];//dut6校准输入继电器控制
			   17'h1BD08: DUT7_RELAY_OUT_TEMP 	<= data_latch[0];//dut7输出继电器控制
			//			   17'h12280: DUT7_RELAY_CALIP_TEMP <= data_latch[15];//dut7校准输入继电器控制
			//			   17'h12280: CLK_RELAY_EX_IN_TEMP <= data_latch[16];//外部输入时钟作为参考时钟继电器控制
			   17'h12284: CLK_RELAY_10M_IN_TEMP <= data_latch[0];//背板10M时钟作为参考时钟继电器控制
			//			   17'h12280: TRIG_RELAY_EX_IN_TEMP <= data_latch[18];//外部输入触发作为触发信号继电器控制
			//			   17'h12280: TRIG_RELAY_STAR_IN_TEMP <= data_latch[19];//背板星型触发作为触发信号继电器控制
			   17'h12290: CALIP_RELAY_10M_IN_TEMP <= data_latch[0];//背板10M时钟作为校准信号继电器控制				
		endcase
		else
		begin
               pcidata_latch		<= pcidata_latch;
               GTX_reset 			<= GTX_reset;
               mode_choose_pc 		<= mode_choose_pc;  
               Pattern_number_pc 	<= Pattern_number_pc; 
               user_reset_c 		<= 1'b0;
               ADC_Control 			<= 1'b0;          
               all_start_soft 		<= 1'b0;	
         end
    end


	reg								[5:0]	Hram_read_addr_pc_0;
	reg								[5:0]	Hram_read_addr_pc_1;
	reg								[5:0]	Hram_read_addr_pc_2;
	reg								[5:0]	Hram_read_addr_pc_3;
	reg								[5:0]	Hram_read_addr_pc_4;
	reg								[5:0]	Hram_read_addr_pc_5;
	reg								[5:0]	Hram_read_addr_pc_6;
	reg								[5:0]	Hram_read_addr_pc_7;
	wire							[31:0]	error_ram_data_out_0;
	wire							[31:0]	error_ram_data_out_1;
	wire							[31:0]	error_ram_data_out_2;
	wire							[31:0]	error_ram_data_out_3;
	wire							[31:0]	error_ram_data_out_4;
	wire							[31:0]	error_ram_data_out_5;
	wire							[31:0]	error_ram_data_out_6;
	wire							[31:0]	error_ram_data_out_7;
	wire							[7:0]	error_read_number_0;
	wire							[7:0]	error_read_number_1;
	wire							[7:0]	error_read_number_2;
	wire							[7:0]	error_read_number_3;
	wire							[7:0]	error_read_number_4;
	wire							[7:0]	error_read_number_5;
	wire							[7:0]	error_read_number_6;
	wire							[7:0]	error_read_number_7;
	wire							[31:0]	CAPTURE_DATA;
	wire							[0:0]	transmit_finish;
    //读控制
	always @ (posedge LCLK_50M)
	begin
		if(pcie_rden)
		case(pcie_addr[15:8])		
		     8'h42: begin  Hram_read_addr_pc_0 <= pcie_addr[7:2]; end	
			 8'h43: begin  Hram_read_addr_pc_1 <= pcie_addr[7:2]; end	
			 8'h44: begin  Hram_read_addr_pc_2 <= pcie_addr[7:2]; end	
			 8'h45: begin  Hram_read_addr_pc_3 <= pcie_addr[7:2]; end	
			 8'h46: begin  Hram_read_addr_pc_4 <= pcie_addr[7:2]; end	
			 8'h47: begin  Hram_read_addr_pc_5 <= pcie_addr[7:2]; end	
			 8'h48: begin  Hram_read_addr_pc_6 <= pcie_addr[7:2]; end	
			 8'h49: begin  Hram_read_addr_pc_7 <= pcie_addr[7:2]; end	
		endcase
		else begin		

		end
	end
	assign PXI_LD = (READYN) ? 'bz :
                (pcie_addr[16:0]  == 17'h1C204)? CAPTURE_DATA: //ADC采集信息
                (pcie_addr[16:8]  == 9'h142)? error_ram_data_out_0: //CH0错误数据
				(pcie_addr[16:8]  == 9'h143)? error_ram_data_out_1: //CH1错误数据
				(pcie_addr[16:8]  == 9'h144)? error_ram_data_out_2: //CH2错误数据
				(pcie_addr[16:8]  == 9'h145)? error_ram_data_out_3: //CH3错误数据
				(pcie_addr[16:8]  == 9'h146)? error_ram_data_out_4: //CH4错误数据
				(pcie_addr[16:8]  == 9'h147)? error_ram_data_out_5: //CH5错误数据
				(pcie_addr[16:8]  == 9'h148)? error_ram_data_out_6: //CH6错误数据
				(pcie_addr[16:8]  == 9'h149)? error_ram_data_out_7: //CH7错误数据
                (pcie_addr[16:0]  == 17'h13304)? transmit_finish: //传输完成
                (pcie_addr[16:0]  == 17'h14020)? error_read_number_0:
                (pcie_addr[16:0]  == 17'h14024)? error_read_number_1:
                (pcie_addr[16:0]  == 17'h14028)? error_read_number_2:
                (pcie_addr[16:0]  == 17'h1402C)? error_read_number_3:
                (pcie_addr[16:0]  == 17'h14030)? error_read_number_4:
                (pcie_addr[16:0]  == 17'h14034)? error_read_number_5:
				(pcie_addr[16:0]  == 17'h14038)? error_read_number_6:
				(pcie_addr[16:0]  == 17'h1403C)? error_read_number_7:
                (pcie_addr == 17'h1FFFF)? pcidata_latch : 32'h12345678;
				
				
    //---------------------------------------------------------------------------------------------
    //ADF4350配置
    //---------------------------------------------------------------------------------------------
    ADF_Control ADF4350_Control_Inst(
            .clk_2M                                     (clk_5M                     ),
            .reset                                      (user_reset_c               ),
            .sample_clk                                 (LCLK_50M                   ),
            .data                                       (data_latch                 ),
            .pcie_wren                                  (pcie_wren                  ),
            .pcie_addr                                  (pcie_addr                  ),
            .adf_cs                                     (ADF4350_CS                 ),
            .adf_din                                    (ADF4350_DIN                ),
            .adf_sclk                                   (ADF4350_SCLK               )
        );

    //--------------------------------------------------------------------------------------------------------
    //ADC   LTC2380控制
    //--------------------------------------------------------------------------------------------------------   
    LTC2380_Control LTC2380_Control_ins(
            .CLK_50M                                    (LCLK_50M                   ),
            .RESET                                      (user_reset_c               ),
            .ADC_CAP_START                              (ADC_Control                ),
            .CAPTURE_DATA_OUT                           (CAPTURE_DATA               ),
            .LTC2380_SDO                                (LTC2380_SDO                ),
            .LTC2380_CLK                                (LTC2380_CLK                ),
            .LTC2380_BUSY                               (LTC2380_BUSY               ),
            .LTC2380_CNV                                (LTC2380_CNV                ));
    //--------------------------------------------------------------------------------------------------------
    //NB6L295配置
    //--------------------------------------------------------------------------------------------------------    
    NB6L295_Config 
    NB6L295_Config_Inst (
			.clk_2M                                 	(clk_5M                     ),//10M
			.reset                                  	(user_reset_c               ),
			.sample_clk                             	(LCLK_50M                   ),
			.pcie_wren                              	(pcie_wren                  ),
			.pcie_addr                              	(pcie_addr                  ),
			.NB6L295_ctrlData                       	(data_latch                 ),
			.Delay_SCLK                             	(Delay_SCLK                 ),
			.Delay_DIN                              	(Delay_DIN                  ),
			.Delay_EN_n                             	(Delay_EN_n                 ),
			.Delay_LOAD                             	(Delay_LOAD                 ));
                    
    //--------------------------------------------------------------------------------------------------------
    //ADATE320配置（SPI）
    //--------------------------------------------------------------------------------------------------------
    ADATE_CONFIG ADATE_CONFIG_inst(
            .clk_50M                        			(LCLK_50M                   ),
            .clk_2M                         			(clk_5M                     ),
            .reset                          			(user_reset_c               ),
            .pcie_wren                      			(pcie_wren                  ),
            .pcie_addr                      			(pcie_addr                  ),
            .data                           			(data_latch                 ),
            .spi_csn                        			(spi_csn                    ),
            .spi_din                        			(spi_sdi                    ),
            .spi_clk                        			(spi_clk                    ));//从机输出给主机的数据;;读输入管脚不进行编程

	////--------------------------------------------------------------------------------------------------------
	////8311配置
	////--------------------------------------------------------------------------------------------------------
    wire							[0:0]	addr_en;
	pcie8311 pcie8311 (
			.clk                						(LCLK_50M               	), 
			.ads_n              						(ADSN                   	), 
			.blast_n            						(BLASTN                 	), 
			.la                 						(LA                     	), 
			.lhold              						(LHOLD                  	), 
			.lholda             						(LHOLDA                 	), 
			.lwr_n              						(LWRN                   	),
			.ready_n            						(READYN                 	), 
			.PXI_LD             						(PXI_LD                 	),
			.data_latch         						(data_latch             	),
			.addr_en            						(addr_en                	), 
			.wren               						(pcie_wren              	), 
			.rden               						(pcie_rden              	),
			.addr               						(pcie_addr              	));
            
	////--------------------------------------------------------------------------------------------------------
	////周期选择
	////--------------------------------------------------------------------------------------------------------                  
    wire							[31:0]	period_data;
	wire							[2:0]	rate_choose_CH0;
	wire							[2:0]	rate_choose_CH1;
	wire							[2:0]	rate_choose_CH2;
	wire							[2:0]	rate_choose_CH3;
	wire							[2:0]	rate_choose_CH4;
	wire							[2:0]	rate_choose_CH5;
	wire							[2:0]	rate_choose_CH6;
	wire							[2:0]	rate_choose_CH7;
	
	period_choose_module period_choose_inst(
			.reset                  					(user_reset_c           	),
			.clk_50M                					(LCLK_50M               	),
			.pcie_wren              					(pcie_wren              	),
			.pcie_addr              					(pcie_addr              	),
			.data                   					(data_latch             	),
			.period_data_out        					(period_data            	));   
    assign rate_choose_CH0 = period_data[2:0];
	assign rate_choose_CH1 = period_data[2:0];
	assign rate_choose_CH2 = period_data[2:0];
	assign rate_choose_CH3 = period_data[2:0];
	assign rate_choose_CH4 = period_data[2:0];
	assign rate_choose_CH5 = period_data[2:0];
	assign rate_choose_CH6 = period_data[2:0];
	assign rate_choose_CH7 = period_data[2:0];
		 
	//--------------------------------------------------------------------------------------------------------
	//输出赋值
	//--------------------------------------------------------------------------------------------------------		
	//    assign RELAY_control[20:0] = RELAY_control_temp[20:0];
		assign DUT0_RELAY_OUT = DUT0_RELAY_OUT_TEMP;
	//	assign DUT0_RELAY_CALIP = DUT0_RELAY_CALIP_TEMP;
		assign DUT1_RELAY_OUT = DUT1_RELAY_OUT_TEMP;
	//	assign DUT1_RELAY_CALIP = DUT1_RELAY_CALIP_TEMP;
		assign DUT2_RELAY_OUT = DUT2_RELAY_OUT_TEMP;
	//	assign DUT2_RELAY_CALIP = DUT2_RELAY_CALIP_TEMP;
		assign DUT3_RELAY_OUT = DUT3_RELAY_OUT_TEMP;
	//	assign DUT3_RELAY_CALIP = DUT3_RELAY_CALIP_TEMP;
		assign DUT4_RELAY_OUT = DUT4_RELAY_OUT_TEMP;
	//	assign DUT4_RELAY_CALIP = DUT4_RELAY_CALIP_TEMP;
		assign DUT5_RELAY_OUT = DUT5_RELAY_OUT_TEMP;
	//	assign DUT5_RELAY_CALIP = DUT5_RELAY_CALIP_TEMP;
		assign DUT6_RELAY_OUT = DUT6_RELAY_OUT_TEMP;
	//	assign DUT6_RELAY_CALIP = DUT6_RELAY_CALIP_TEMP;
		assign DUT7_RELAY_OUT = DUT7_RELAY_OUT_TEMP;
	//	assign DUT7_RELAY_CALIP = DUT7_RELAY_CALIP_TEMP;
	//	assign CLK_RELAY_EX_IN = CLK_RELAY_EX_IN_TEMP;
		assign CLK_RELAY_10M_IN = CLK_RELAY_10M_IN_TEMP;
	//	assign TRIG_RELAY_EX_IN = TRIG_RELAY_EX_IN_TEMP;
	//	assign TRIG_RELAY_STAR_IN = TRIG_RELAY_STAR_IN_TEMP;
		assign CALIP_RELAY_10M_IN = CALIP_RELAY_10M_IN_TEMP;
		
		assign ADG1406 = ADG1406_PC[3:0];


    //***********************************************************************//
    //                                                                       //
    //------------------------  Frame Generators  ---------------------------//
    //                                                                       //
    //***********************************************************************//
	(* ASYNC_REG = "TRUE"*)	reg				all_start_soft_temp;
	(* ASYNC_REG = "TRUE"*)	reg				all_start_soft_temp1;
	(* ASYNC_REG = "TRUE"*)	reg				all_start_soft_temp2;
	(* ASYNC_REG = "TRUE"*)	reg				all_start_soft_temp3;
	(* ASYNC_REG = "TRUE"*)	reg				all_start_soft_temp4;
	reg										start_flag;
	
	always @(posedge gt0_txusrclk2_i)//PROCESS_CLK
	begin
	   all_start_soft_temp <= all_start_soft;
	   all_start_soft_temp4 <= all_start_soft_temp;
	   all_start_soft_temp3 <= all_start_soft_temp4;
	   all_start_soft_temp2 <= all_start_soft_temp3;
	   all_start_soft_temp1 <= all_start_soft_temp2;
	end
	
	always @(posedge gt0_txusrclk2_i)
	begin
	   if(user_reset_c)
	       start_flag <= 1'b0;
	   else if(all_start_soft_temp1 == 0 && all_start_soft_temp2 == 1)
	       start_flag <= !start_flag;
	   else
	       start_flag <= start_flag;
	end

	//____________________________数据准备___________________________________
    wire                                    EDGE_DATA_VALID_0;
    wire                                    EDGE_DATA_VALID_1;
    wire                                    EDGE_DATA_VALID_2;
    wire                                    EDGE_DATA_VALID_3;
    wire                                    EDGE_DATA_VALID_4;
    wire                                    EDGE_DATA_VALID_5;
    wire                                    EDGE_DATA_VALID_6;
    wire                                    EDGE_DATA_VALID_7;
    wire		[0:0]						edge_pre_finish;		//
    wire		[63:0]						ESET_8CH_OFFSET;	    //
    wire		[31:0]						TX_DATA_OUT;			//
    wire		[31:0]						TX_CHECK_OUT;			//
    wire		[0:0]						ESET_8CH_OFFSET_VALID;	//
    wire		[0:0]						output_flow_start;		//
    wire        [0:0]                       flow_start_ack;
        
	ic_test_data_control ic_test_data_control_inst(
	
		// output接口
        .ESET_8CH_OFFSET			(ESET_8CH_OFFSET			),			//64位ESET八通道偏移数据
        .TX_DATA_OUT				(TX_DATA_OUT				),          //32位八通道向量数据
        .ESET_8CH_OFFSET_VALID		(ESET_8CH_OFFSET_VALID		),         	//ESET八通道偏移数据有效标志位
        .TX_DATA_OUT_VALID			(output_flow_start			),          //八通道向量数据有效标志位,同时为测试启动位
        .flow_start_ack             (flow_start_ack             ),          //接收到准备工作已完成,返回的握手信号
		
        //input接口       
        .ram_data_pc				(data_latch					),          //32位PC发下来的数据
        .system_start_stop_pc		(start_flag              	),       	//PC端发下来的开始信号,用于边沿准备工作
        .pcie_wren					(pcie_wren					),          //PCIe写使能
        .pcie_addr					(pcie_addr					),          //32位PCIe读写地址
        .mode_choose_cycle0_single1	(mode_choose_pc				),    		//控制模式选择,0：循环模式；1：正常模式
        .Pattern_number_pc			(Pattern_number_pc			),          //8位正常模式向量发送个数
        .edge_pre_finish			(edge_pre_finish			),          //边沿准备工作完成标志位,同时也是向量开始发使能位
        .rate_choose				(rate_choose_CH0			),          //3位速度选择
        .TSB_addr_pc                (TSB_addr_pc                ),          //PC发下来的TSB地址

        .USER_CLK					(LCLK_50M					),
        .PROCESS_CLK				(gt0_txusrclk2_i			),
        .SYSTEM_RESET				(user_reset_c				)
	);

	assign edge_pre_finish = EDGE_DATA_VALID_0
							& EDGE_DATA_VALID_1
							& EDGE_DATA_VALID_2
							& EDGE_DATA_VALID_3
							& EDGE_DATA_VALID_4
							& EDGE_DATA_VALID_5
							& EDGE_DATA_VALID_6
							& EDGE_DATA_VALID_7;
	
	
	
	//______________________Eset PC Write Channel Address Decode___________________________	
	wire   		[2:0]   					eset_write_ch_choose;
	wire   		[191:0] 					eset_write_data;
	wire           							eset_write_data_valid;
	wire   		[4:0]   					Eset_write_addr_pc;
	reg			   							Eset_write_en_CH0;
	reg			   							Eset_write_en_CH1;
	reg			   							Eset_write_en_CH2;
	reg			   							Eset_write_en_CH3;
	reg			   							Eset_write_en_CH4;
	reg			   							Eset_write_en_CH5;
	reg			   							Eset_write_en_CH6;
	reg			   							Eset_write_en_CH7;

    always @(posedge LCLK_50M)
    begin
		if(user_reset_c)
		begin
			Eset_write_en_CH0 <= 1'b0;
			Eset_write_en_CH1 <= 1'b0;
			Eset_write_en_CH2 <= 1'b0;
			Eset_write_en_CH3 <= 1'b0;
			Eset_write_en_CH4 <= 1'b0;
			Eset_write_en_CH5 <= 1'b0;
			Eset_write_en_CH6 <= 1'b0;
			Eset_write_en_CH7 <= 1'b0;
		end
        else if(eset_write_data_valid)
        begin
            case(eset_write_ch_choose)
                3'b000  : begin Eset_write_en_CH0 <= 1'b1; end
				3'b001  : begin Eset_write_en_CH1 <= 1'b1; end
				3'b010  : begin Eset_write_en_CH2 <= 1'b1; end
				3'b011  : begin Eset_write_en_CH3 <= 1'b1; end
				3'b100  : begin Eset_write_en_CH4 <= 1'b1; end
				3'b101  : begin Eset_write_en_CH5 <= 1'b1; end
				3'b110  : begin Eset_write_en_CH6 <= 1'b1; end
				3'b111  : begin Eset_write_en_CH7 <= 1'b1; end
            endcase
        end
		else begin
			Eset_write_en_CH0 <= 1'b0;
			Eset_write_en_CH1 <= 1'b0;
			Eset_write_en_CH2 <= 1'b0;
			Eset_write_en_CH3 <= 1'b0;
			Eset_write_en_CH4 <= 1'b0;
			Eset_write_en_CH5 <= 1'b0;
			Eset_write_en_CH6 <= 1'b0;
			Eset_write_en_CH7 <= 1'b0;			
		end
    end
    //控制说明：六个边沿信息,同类的边沿信息数值不能小于32,200MHz除外
	ESET_CH_ADDR_DECODE ESET_CH_ADDR_DECODE_inst(
        .eset_write_ch_choose       (eset_write_ch_choose       ),//3out
        .eset_write_data            (eset_write_data            ),//192out
        .eset_write_addr_pc         (Eset_write_addr_pc         ),//5out
        .eset_write_data_valid      (eset_write_data_valid      ),//out
        .eset_data_pc               (data_latch                 ),//32in
        .pcie_wren                  (pcie_wren                  ),
        .pcie_addr                  (pcie_addr                  ),         
        .USER_CLK                   (LCLK_50M                   ),
        .SYSTEM_RESET               (user_reset_c               )
    );
    
    //----------------------------------------------------------------
	//----------------------------CH0---------------------------------
	//----------------------------------------------------------------
    wire                                    TRANS_FINISH_ALL_CH0;
    wire                                    trans_enable_CH0;
    wire                                    check_enable_CH0;
    wire		[31:0]						switch_addr0_data_CH0;			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr0_data_CH0;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr0_data_CH0;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr1_data_CH0; 			//32位开关信号第一个边沿
    wire		[31:0]						vector_addr1_data_CH0;			//32位向量信号第一个边沿
    wire		[31:0]						check_addr1_data_CH0;			//32位检测信号第一个边沿
    wire		[31:0]						switch_addr2_data_CH0;			//32位开关信号32位0的个数
    wire		[31:0]						vector_addr2_data_CH0;			//32位向量信号32位1的个数
    wire		[31:0]						check_addr2_data_CH0;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr3_data_CH0; 			//32位开关信号第二个边沿
    wire		[31:0]						vector_addr3_data_CH0;			//32位向量信号第二个边沿
    wire		[31:0]						check_addr3_data_CH0;			//32位检测信号第二个边沿
    wire		[31:0]						switch_addr4_data_CH0; 			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr4_data_CH0;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr4_data_CH0;			//32位检测信号32位0的个数		
    
    ESET_EDGE_CHOOSE ESET_EDGE_CHOOSE_CH0(
			
			//input接口
			.ESET_OFFSET					(ESET_8CH_OFFSET[7:0]			),          //8位ESET偏移数据
			.ESET_OFFSET_VALID				(ESET_8CH_OFFSET_VALID			),          //ESET偏移数据有效
			.TRANS_FINISH_ALL				(TRANS_FINISH_ALL_CH0			),          //传输完成,准备清除准备数据,信号来源于开关信号的完成,由开关信号总控
			.ram_data_pc					(eset_write_data				),		    //192位PC端发下来的写入RAM的边沿数据
			.ram_data_write_en				(Eset_write_en_CH0				),          //边沿RAM写使能
			.ram_addr_pc					(Eset_write_addr_pc				),          //5位边沿RAM写地址
			.rate_choose                    (rate_choose_CH0                ),          //3位速度选择
			.mode_choose_cycle_single       (mode_choose_pc				    ),    		//控制模式选择,0：循环模式；1：正常模式
			.flow_start_ack                 (flow_start_ack                 ),          //ic模块接收到准备工作已完成,返回的握手信号

			.PROCESS_CLK					(gt0_txusrclk2_i				),
			.USER_CLK						(LCLK_50M						),
			.SYSTEM_RESET					(user_reset_c					),
			
			//output接口
			.EDGE_DATA_VALID				(EDGE_DATA_VALID_0				),          //准备数据已经完成且有效

			.switch_addr0_data				(switch_addr0_data_CH0			),			//32位开关信号32位1的个数
			.vector_addr0_data				(vector_addr0_data_CH0			),			//32位向量信号32位0的个数
			.check_addr0_data				(check_addr0_data_CH0			),			//32位检测信号32位0的个数
			.switch_addr1_data				(switch_addr1_data_CH0			), 			//32位开关信号第一个边沿
			.vector_addr1_data				(vector_addr1_data_CH0			),			//32位向量信号第一个边沿
			.check_addr1_data				(check_addr1_data_CH0			),			//32位检测信号第一个边沿
			.switch_addr2_data				(switch_addr2_data_CH0			),			//32位开关信号32位0的个数
			.vector_addr2_data				(vector_addr2_data_CH0			),			//32位向量信号32位1的个数
			.check_addr2_data				(check_addr2_data_CH0			),			//32位检测信号32位0的个数
			.switch_addr3_data				(switch_addr3_data_CH0			), 			//32位开关信号第二个边沿
			.vector_addr3_data				(vector_addr3_data_CH0			),			//32位向量信号第二个边沿
			.check_addr3_data				(check_addr3_data_CH0			),			//32位检测信号第二个边沿
			.switch_addr4_data				(switch_addr4_data_CH0			), 			//32位开关信号32位1的个数
			.vector_addr4_data				(vector_addr4_data_CH0			),			//32位向量信号32位0的个数
			.check_addr4_data				(check_addr4_data_CH0			),			//32位检测信号32位0的个数										
			.trans_enable					(trans_enable_CH0				),			//传输使能标志位,同check_enable共同决定该通道是发还是收
			.check_enable					(check_enable_CH0				)			//传输使能标志位,同trans_enable共同决定该通道是发还是收
		
        );
    
    edge_expansion edge_expansion_switch0(
  
		//input接口
		.PROCESS_CLK			(gt0_txusrclk2_i			),
		.reset					(gt0_tx_system_reset_c		),
		.rate_choose			(rate_choose_CH0			),         	//3位速度选择
		.output_flow_start		(output_flow_start			),			//高速收发器开始信号,采用IC_test模块数据有效信号

		.switch_addr0_data		(switch_addr0_data_CH0		),			//32位开关信号32位1的个数
		.switch_addr1_data		(switch_addr1_data_CH0		), 			//32位开关信号第一个边沿
		.switch_addr2_data		(switch_addr2_data_CH0		),			//32位开关信号32位0的个数
		.switch_addr3_data		(switch_addr3_data_CH0		), 			//32位开关信号第二个边沿
		.switch_addr4_data		(switch_addr4_data_CH0		), 			//32位开关信号32位1的个数								
		.trans_enable			(trans_enable_CH0			),			//传输使能标志位,	

		//output接口
		.TRANS_FINISH_ALL		(TRANS_FINISH_ALL_CH0		),			//一次测试结束信号
		.expansion_swit_out		(gt1_txdata_i				)  			//32位高速收发器并行数据		 
        ); 

    data_expansion edge_expansion_data0(

		//input接口
        .PROCESS_CLK			(gt0_txusrclk2_i			),
        .reset					(gt0_tx_system_reset_c		),
		.rate_choose			(rate_choose_CH0			),              //3位速率控制
        .output_flow_start		(output_flow_start			),				//高速收发器开始信号,采用IC_test模块数据有效信号
		.gtx_data_out			(TX_DATA_OUT[3:0]			),				//4位高速收发器准备输出的未扩展的向量

		.vector_addr0_data		(vector_addr0_data_CH0		),				//32位向量信号32位0的个数
		.vector_addr1_data		(vector_addr1_data_CH0		), 				//32位向量信号第一个边沿
		.vector_addr2_data		(vector_addr2_data_CH0		),				//32位向量信号32位1的个数
		.vector_addr3_data		(vector_addr3_data_CH0		), 				//32位向量信号第二个边沿
		.vector_addr4_data		(vector_addr4_data_CH0		), 				//32位向量信号32位0的个数								
		.trans_enable			(trans_enable_CH0			),				//传输使能标志位,	
		
		//output接口
		.expansion_data_out		(gt0_txdata_i				)   			//32位高速收发器并行数据
		
         );
          
    //----------------------------------------------------------------
	//----------------------------CH1---------------------------------
	//----------------------------------------------------------------
    wire                                    TRANS_FINISH_ALL_CH1;
    wire                                    trans_enable_CH1;
    wire                                    check_enable_CH1;
    wire		[31:0]						switch_addr0_data_CH1;			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr0_data_CH1;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr0_data_CH1;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr1_data_CH1; 			//32位开关信号第一个边沿
    wire		[31:0]						vector_addr1_data_CH1;			//32位向量信号第一个边沿
    wire		[31:0]						check_addr1_data_CH1;			//32位检测信号第一个边沿
    wire		[31:0]						switch_addr2_data_CH1;			//32位开关信号32位0的个数
    wire		[31:0]						vector_addr2_data_CH1;			//32位向量信号32位1的个数
    wire		[31:0]						check_addr2_data_CH1;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr3_data_CH1; 			//32位开关信号第二个边沿
    wire		[31:0]						vector_addr3_data_CH1;			//32位向量信号第二个边沿
    wire		[31:0]						check_addr3_data_CH1;			//32位检测信号第二个边沿
    wire		[31:0]						switch_addr4_data_CH1; 			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr4_data_CH1;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr4_data_CH1;			//32位检测信号32位0的个数	
    	
    ESET_EDGE_CHOOSE ESET_EDGE_CHOOSE_CH1(
			
			//input接口
			.ESET_OFFSET					(ESET_8CH_OFFSET[15:8]			),          //8位ESET偏移数据
			.ESET_OFFSET_VALID				(ESET_8CH_OFFSET_VALID			),          //ESET偏移数据有效
			.TRANS_FINISH_ALL				(TRANS_FINISH_ALL_CH1			),          //传输完成,准备清除准备数据,信号来源于开关信号的完成,由开关信号总控
			.ram_data_pc					(eset_write_data				),		    //192位PC端发下来的写入RAM的边沿数据
			.ram_data_write_en				(Eset_write_en_CH1				),          //边沿RAM写使能
			.ram_addr_pc					(Eset_write_addr_pc				),          //5位边沿RAM写地址
			.rate_choose                    (rate_choose_CH0                ),          //3位速度选择
			.mode_choose_cycle_single       (mode_choose_pc				    ),    		//控制模式选择,0：循环模式；1：正常模式
			.flow_start_ack                 (flow_start_ack                 ),          //ic模块接收到准备工作已完成,返回的握手信号

			.PROCESS_CLK					(gt0_txusrclk2_i				),
			.USER_CLK						(LCLK_50M						),
			.SYSTEM_RESET					(user_reset_c					),
			
			//output接口
			.EDGE_DATA_VALID				(EDGE_DATA_VALID_1				),          //准备数据已经完成且有效

			.switch_addr0_data				(switch_addr0_data_CH1			),			//32位开关信号32位1的个数
			.vector_addr0_data				(vector_addr0_data_CH1			),			//32位向量信号32位0的个数
			.check_addr0_data				(check_addr0_data_CH1			),			//32位检测信号32位0的个数
			.switch_addr1_data				(switch_addr1_data_CH1			), 			//32位开关信号第一个边沿
			.vector_addr1_data				(vector_addr1_data_CH1			),			//32位向量信号第一个边沿
			.check_addr1_data				(check_addr1_data_CH1			),			//32位检测信号第一个边沿
			.switch_addr2_data				(switch_addr2_data_CH1			),			//32位开关信号32位0的个数
			.vector_addr2_data				(vector_addr2_data_CH1			),			//32位向量信号32位1的个数
			.check_addr2_data				(check_addr2_data_CH1			),			//32位检测信号32位0的个数
			.switch_addr3_data				(switch_addr3_data_CH1			), 			//32位开关信号第二个边沿
			.vector_addr3_data				(vector_addr3_data_CH1			),			//32位向量信号第二个边沿
			.check_addr3_data				(check_addr3_data_CH1			),			//32位检测信号第二个边沿
			.switch_addr4_data				(switch_addr4_data_CH1			), 			//32位开关信号32位1的个数
			.vector_addr4_data				(vector_addr4_data_CH1			),			//32位向量信号32位0的个数
			.check_addr4_data				(check_addr4_data_CH1			),			//32位检测信号32位0的个数										
			.trans_enable					(trans_enable_CH1				),			//传输使能标志位,同check_enable共同决定该通道是发还是收
			.check_enable					(check_enable_CH1				)			//传输使能标志位,同trans_enable共同决定该通道是发还是收
		
        );
    
    edge_expansion edge_expansion_switch1(
  
			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),         	//3位速度选择
			.output_flow_start		(output_flow_start			),			//高速收发器开始信号,采用IC_test模块数据有效信号

			.switch_addr0_data		(switch_addr0_data_CH1		),			//32位开关信号32位1的个数
			.switch_addr1_data		(switch_addr1_data_CH1		), 			//32位开关信号第一个边沿
			.switch_addr2_data		(switch_addr2_data_CH1		),			//32位开关信号32位0的个数
			.switch_addr3_data		(switch_addr3_data_CH1		), 			//32位开关信号第二个边沿
			.switch_addr4_data		(switch_addr4_data_CH1		), 			//32位开关信号32位1的个数								
			.trans_enable			(trans_enable_CH1			),			//传输使能标志位,	

			//output接口
			.TRANS_FINISH_ALL		(TRANS_FINISH_ALL_CH1		),			//一次测试结束信号
			.expansion_swit_out		(gt3_txdata_i    			)  			//32位高速收发器并行数据		 
        ); 

    data_expansion edge_expansion_data1(

			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),              //3位速率控制
			.output_flow_start		(output_flow_start			),				//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_data_out			(TX_DATA_OUT[7:4]			),				//4位高速收发器准备输出的未扩展的向量

			.vector_addr0_data		(vector_addr0_data_CH1		),				//32位向量信号32位0的个数
			.vector_addr1_data		(vector_addr1_data_CH1		), 				//32位向量信号第一个边沿
			.vector_addr2_data		(vector_addr2_data_CH1		),				//32位向量信号32位1的个数
			.vector_addr3_data		(vector_addr3_data_CH1		), 				//32位向量信号第二个边沿
			.vector_addr4_data		(vector_addr4_data_CH1		), 				//32位向量信号32位0的个数								
			.trans_enable			(trans_enable_CH1			),				//传输使能标志位,	
			
			//output接口
			.expansion_data_out		(gt2_txdata_i				)   			//32位高速收发器并行数据
		
         );

    //----------------------------------------------------------------
	//----------------------------CH2---------------------------------
	//----------------------------------------------------------------
    wire                                    TRANS_FINISH_ALL_CH2;
    wire                                    trans_enable_CH2;
    wire                                    check_enable_CH2;
    wire		[31:0]						switch_addr0_data_CH2;			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr0_data_CH2;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr0_data_CH2;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr1_data_CH2; 			//32位开关信号第一个边沿
    wire		[31:0]						vector_addr1_data_CH2;			//32位向量信号第一个边沿
    wire		[31:0]						check_addr1_data_CH2;			//32位检测信号第一个边沿
    wire		[31:0]						switch_addr2_data_CH2;			//32位开关信号32位0的个数
    wire		[31:0]						vector_addr2_data_CH2;			//32位向量信号32位1的个数
    wire		[31:0]						check_addr2_data_CH2;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr3_data_CH2; 			//32位开关信号第二个边沿
    wire		[31:0]						vector_addr3_data_CH2;			//32位向量信号第二个边沿
    wire		[31:0]						check_addr3_data_CH2;			//32位检测信号第二个边沿
    wire		[31:0]						switch_addr4_data_CH2; 			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr4_data_CH2;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr4_data_CH2;			//32位检测信号32位0的个数	
    	
    ESET_EDGE_CHOOSE ESET_EDGE_CHOOSE_CH2(
			
			//input接口
			.ESET_OFFSET					(ESET_8CH_OFFSET[23:16]			),          //8位ESET偏移数据
			.ESET_OFFSET_VALID				(ESET_8CH_OFFSET_VALID			),          //ESET偏移数据有效
			.TRANS_FINISH_ALL				(TRANS_FINISH_ALL_CH2			),          //传输完成,准备清除准备数据,信号来源于开关信号的完成,由开关信号总控
			.ram_data_pc					(eset_write_data				),		    //192位PC端发下来的写入RAM的边沿数据
			.ram_data_write_en				(Eset_write_en_CH2				),          //边沿RAM写使能
			.ram_addr_pc					(Eset_write_addr_pc				),          //5位边沿RAM写地址
			.rate_choose                    (rate_choose_CH0                ),          //3位速度选择
			.mode_choose_cycle_single       (mode_choose_pc				    ),    		//控制模式选择,0：循环模式；1：正常模式
			.flow_start_ack                 (flow_start_ack                 ),          //ic模块接收到准备工作已完成,返回的握手信号

			.PROCESS_CLK					(gt0_txusrclk2_i				),
			.USER_CLK						(LCLK_50M						),
			.SYSTEM_RESET					(user_reset_c					),
			
			//output接口
			.EDGE_DATA_VALID				(EDGE_DATA_VALID_2				),          //准备数据已经完成且有效

			.switch_addr0_data				(switch_addr0_data_CH2			),			//32位开关信号32位1的个数
			.vector_addr0_data				(vector_addr0_data_CH2			),			//32位向量信号32位0的个数
			.check_addr0_data				(check_addr0_data_CH2			),			//32位检测信号32位0的个数
			.switch_addr1_data				(switch_addr1_data_CH2			), 			//32位开关信号第一个边沿
			.vector_addr1_data				(vector_addr1_data_CH2			),			//32位向量信号第一个边沿
			.check_addr1_data				(check_addr1_data_CH2			),			//32位检测信号第一个边沿
			.switch_addr2_data				(switch_addr2_data_CH2			),			//32位开关信号32位0的个数
			.vector_addr2_data				(vector_addr2_data_CH2			),			//32位向量信号32位1的个数
			.check_addr2_data				(check_addr2_data_CH2			),			//32位检测信号32位0的个数
			.switch_addr3_data				(switch_addr3_data_CH2			), 			//32位开关信号第二个边沿
			.vector_addr3_data				(vector_addr3_data_CH2			),			//32位向量信号第二个边沿
			.check_addr3_data				(check_addr3_data_CH2			),			//32位检测信号第二个边沿
			.switch_addr4_data				(switch_addr4_data_CH2			), 			//32位开关信号32位1的个数
			.vector_addr4_data				(vector_addr4_data_CH2			),			//32位向量信号32位0的个数
			.check_addr4_data				(check_addr4_data_CH2			),			//32位检测信号32位0的个数										
			.trans_enable					(trans_enable_CH2				),			//传输使能标志位,同check_enable共同决定该通道是发还是收
			.check_enable					(check_enable_CH2				)			//传输使能标志位,同trans_enable共同决定该通道是发还是收
		
        );
    
    edge_expansion edge_expansion_switch2(
  
			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),         	//3位速度选择
			.output_flow_start		(output_flow_start			),			//高速收发器开始信号,采用IC_test模块数据有效信号

			.switch_addr0_data		(switch_addr0_data_CH2		),			//32位开关信号32位1的个数
			.switch_addr1_data		(switch_addr1_data_CH2		), 			//32位开关信号第一个边沿
			.switch_addr2_data		(switch_addr2_data_CH2		),			//32位开关信号32位0的个数
			.switch_addr3_data		(switch_addr3_data_CH2		), 			//32位开关信号第二个边沿
			.switch_addr4_data		(switch_addr4_data_CH2		), 			//32位开关信号32位1的个数								
			.trans_enable			(trans_enable_CH2			),			//传输使能标志位,	

			//output接口
			.TRANS_FINISH_ALL		(TRANS_FINISH_ALL_CH2		),			//一次测试结束信号
			.expansion_swit_out		(gt5_txdata_i    			)  			//32位高速收发器并行数据		 
        ); 

    data_expansion edge_expansion_data2(

			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),              //3位速率控制
			.output_flow_start		(output_flow_start			),				//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_data_out			(TX_DATA_OUT[11:8]			),				//4位高速收发器准备输出的未扩展的向量

			.vector_addr0_data		(vector_addr0_data_CH2		),				//32位向量信号32位0的个数
			.vector_addr1_data		(vector_addr1_data_CH2		), 				//32位向量信号第一个边沿
			.vector_addr2_data		(vector_addr2_data_CH2		),				//32位向量信号32位1的个数
			.vector_addr3_data		(vector_addr3_data_CH2		), 				//32位向量信号第二个边沿
			.vector_addr4_data		(vector_addr4_data_CH2		), 				//32位向量信号32位0的个数								
			.trans_enable			(trans_enable_CH2			),				//传输使能标志位,	
			
			//output接口
			.expansion_data_out		(gt4_txdata_i				)   			//32位高速收发器并行数据
		
         );	
         
    //----------------------------------------------------------------
	//----------------------------CH3---------------------------------
	//----------------------------------------------------------------
    wire                                    TRANS_FINISH_ALL_CH3;
    wire                                    trans_enable_CH3;
    wire                                    check_enable_CH3;
    wire		[31:0]						switch_addr0_data_CH3;			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr0_data_CH3;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr0_data_CH3;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr1_data_CH3; 			//32位开关信号第一个边沿
    wire		[31:0]						vector_addr1_data_CH3;			//32位向量信号第一个边沿
    wire		[31:0]						check_addr1_data_CH3;			//32位检测信号第一个边沿
    wire		[31:0]						switch_addr2_data_CH3;			//32位开关信号32位0的个数
    wire		[31:0]						vector_addr2_data_CH3;			//32位向量信号32位1的个数
    wire		[31:0]						check_addr2_data_CH3;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr3_data_CH3; 			//32位开关信号第二个边沿
    wire		[31:0]						vector_addr3_data_CH3;			//32位向量信号第二个边沿
    wire		[31:0]						check_addr3_data_CH3;			//32位检测信号第二个边沿
    wire		[31:0]						switch_addr4_data_CH3; 			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr4_data_CH3;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr4_data_CH3;			//32位检测信号32位0的个数	
    	
    ESET_EDGE_CHOOSE ESET_EDGE_CHOOSE_CH3(
			
			//input接口
			.ESET_OFFSET					(ESET_8CH_OFFSET[31:24]			),          //8位ESET偏移数据
			.ESET_OFFSET_VALID				(ESET_8CH_OFFSET_VALID			),          //ESET偏移数据有效
			.TRANS_FINISH_ALL				(TRANS_FINISH_ALL_CH3			),          //传输完成,准备清除准备数据,信号来源于开关信号的完成,由开关信号总控
			.ram_data_pc					(eset_write_data				),		    //192位PC端发下来的写入RAM的边沿数据
			.ram_data_write_en				(Eset_write_en_CH3				),          //边沿RAM写使能
			.ram_addr_pc					(Eset_write_addr_pc				),          //5位边沿RAM写地址
			.rate_choose                    (rate_choose_CH0                ),          //3位速度选择
			.mode_choose_cycle_single       (mode_choose_pc				    ),    		//控制模式选择,0：循环模式；1：正常模式
			.flow_start_ack                 (flow_start_ack                 ),          //ic模块接收到准备工作已完成,返回的握手信号

			.PROCESS_CLK					(gt0_txusrclk2_i				),
			.USER_CLK						(LCLK_50M						),
			.SYSTEM_RESET					(user_reset_c					),
			
			//output接口
			.EDGE_DATA_VALID				(EDGE_DATA_VALID_3				),          //准备数据已经完成且有效

			.switch_addr0_data				(switch_addr0_data_CH3			),			//32位开关信号32位1的个数
			.vector_addr0_data				(vector_addr0_data_CH3			),			//32位向量信号32位0的个数
			.check_addr0_data				(check_addr0_data_CH3			),			//32位检测信号32位0的个数
			.switch_addr1_data				(switch_addr1_data_CH3			), 			//32位开关信号第一个边沿
			.vector_addr1_data				(vector_addr1_data_CH3			),			//32位向量信号第一个边沿
			.check_addr1_data				(check_addr1_data_CH3			),			//32位检测信号第一个边沿
			.switch_addr2_data				(switch_addr2_data_CH3			),			//32位开关信号32位0的个数
			.vector_addr2_data				(vector_addr2_data_CH3			),			//32位向量信号32位1的个数
			.check_addr2_data				(check_addr2_data_CH3			),			//32位检测信号32位0的个数
			.switch_addr3_data				(switch_addr3_data_CH3			), 			//32位开关信号第二个边沿
			.vector_addr3_data				(vector_addr3_data_CH3			),			//32位向量信号第二个边沿
			.check_addr3_data				(check_addr3_data_CH3			),			//32位检测信号第二个边沿
			.switch_addr4_data				(switch_addr4_data_CH3			), 			//32位开关信号32位1的个数
			.vector_addr4_data				(vector_addr4_data_CH3			),			//32位向量信号32位0的个数
			.check_addr4_data				(check_addr4_data_CH3			),			//32位检测信号32位0的个数										
			.trans_enable					(trans_enable_CH3				),			//传输使能标志位,同check_enable共同决定该通道是发还是收
			.check_enable					(check_enable_CH3				)			//传输使能标志位,同trans_enable共同决定该通道是发还是收
		
        );
    
    edge_expansion edge_expansion_switch3(
  
			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),         	//3位速度选择
			.output_flow_start		(output_flow_start			),			//高速收发器开始信号,采用IC_test模块数据有效信号

			.switch_addr0_data		(switch_addr0_data_CH3		),			//32位开关信号32位1的个数
			.switch_addr1_data		(switch_addr1_data_CH3		), 			//32位开关信号第一个边沿
			.switch_addr2_data		(switch_addr2_data_CH3		),			//32位开关信号32位0的个数
			.switch_addr3_data		(switch_addr3_data_CH3		), 			//32位开关信号第二个边沿
			.switch_addr4_data		(switch_addr4_data_CH3		), 			//32位开关信号32位1的个数								
			.trans_enable			(trans_enable_CH3			),			//传输使能标志位,	

			//output接口
			.TRANS_FINISH_ALL		(TRANS_FINISH_ALL_CH3		),			//一次测试结束信号
			.expansion_swit_out		(gt7_txdata_i    			)  			//32位高速收发器并行数据		 
        ); 

    data_expansion edge_expansion_data3(

			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),              //3位速率控制
			.output_flow_start		(output_flow_start			),				//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_data_out			(TX_DATA_OUT[15:12]			),				//4位高速收发器准备输出的未扩展的向量

			.vector_addr0_data		(vector_addr0_data_CH3		),				//32位向量信号32位0的个数
			.vector_addr1_data		(vector_addr1_data_CH3		), 				//32位向量信号第一个边沿
			.vector_addr2_data		(vector_addr2_data_CH3		),				//32位向量信号32位1的个数
			.vector_addr3_data		(vector_addr3_data_CH3		), 				//32位向量信号第二个边沿
			.vector_addr4_data		(vector_addr4_data_CH3		), 				//32位向量信号32位0的个数								
			.trans_enable			(trans_enable_CH3			),				//传输使能标志位,	
			
			//output接口
			.expansion_data_out		(gt6_txdata_i				)   			//32位高速收发器并行数据
		
         );

    //----------------------------------------------------------------
	//----------------------------CH4---------------------------------
	//----------------------------------------------------------------
    wire                                    TRANS_FINISH_ALL_CH4;
    wire                                    trans_enable_CH4;
    wire                                    check_enable_CH4;
    wire		[31:0]						switch_addr0_data_CH4;			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr0_data_CH4;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr0_data_CH4;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr1_data_CH4; 			//32位开关信号第一个边沿
    wire		[31:0]						vector_addr1_data_CH4;			//32位向量信号第一个边沿
    wire		[31:0]						check_addr1_data_CH4;			//32位检测信号第一个边沿
    wire		[31:0]						switch_addr2_data_CH4;			//32位开关信号32位0的个数
    wire		[31:0]						vector_addr2_data_CH4;			//32位向量信号32位1的个数
    wire		[31:0]						check_addr2_data_CH4;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr3_data_CH4; 			//32位开关信号第二个边沿
    wire		[31:0]						vector_addr3_data_CH4;			//32位向量信号第二个边沿
    wire		[31:0]						check_addr3_data_CH4;			//32位检测信号第二个边沿
    wire		[31:0]						switch_addr4_data_CH4; 			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr4_data_CH4;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr4_data_CH4;			//32位检测信号32位0的个数	
    	
    ESET_EDGE_CHOOSE ESET_EDGE_CHOOSE_CH4(
			
			//input接口
			.ESET_OFFSET					(ESET_8CH_OFFSET[39:32]			),          //8位ESET偏移数据
			.ESET_OFFSET_VALID				(ESET_8CH_OFFSET_VALID			),          //ESET偏移数据有效
			.TRANS_FINISH_ALL				(TRANS_FINISH_ALL_CH4			),          //传输完成,准备清除准备数据,信号来源于开关信号的完成,由开关信号总控
			.ram_data_pc					(eset_write_data				),		    //192位PC端发下来的写入RAM的边沿数据
			.ram_data_write_en				(Eset_write_en_CH4				),          //边沿RAM写使能
			.ram_addr_pc					(Eset_write_addr_pc				),          //5位边沿RAM写地址
			.rate_choose                    (rate_choose_CH0                ),          //3位速度选择
			.mode_choose_cycle_single       (mode_choose_pc				    ),    		//控制模式选择,0：循环模式；1：正常模式
			.flow_start_ack                 (flow_start_ack                 ),          //ic模块接收到准备工作已完成,返回的握手信号

			.PROCESS_CLK					(gt0_txusrclk2_i				),
			.USER_CLK						(LCLK_50M						),
			.SYSTEM_RESET					(user_reset_c					),
			
			//output接口
			.EDGE_DATA_VALID				(EDGE_DATA_VALID_4				),          //准备数据已经完成且有效

			.switch_addr0_data				(switch_addr0_data_CH4			),			//32位开关信号32位1的个数
			.vector_addr0_data				(vector_addr0_data_CH4			),			//32位向量信号32位0的个数
			.check_addr0_data				(check_addr0_data_CH4			),			//32位检测信号32位0的个数
			.switch_addr1_data				(switch_addr1_data_CH4			), 			//32位开关信号第一个边沿
			.vector_addr1_data				(vector_addr1_data_CH4			),			//32位向量信号第一个边沿
			.check_addr1_data				(check_addr1_data_CH4			),			//32位检测信号第一个边沿
			.switch_addr2_data				(switch_addr2_data_CH4			),			//32位开关信号32位0的个数
			.vector_addr2_data				(vector_addr2_data_CH4			),			//32位向量信号32位1的个数
			.check_addr2_data				(check_addr2_data_CH4			),			//32位检测信号32位0的个数
			.switch_addr3_data				(switch_addr3_data_CH4			), 			//32位开关信号第二个边沿
			.vector_addr3_data				(vector_addr3_data_CH4			),			//32位向量信号第二个边沿
			.check_addr3_data				(check_addr3_data_CH4			),			//32位检测信号第二个边沿
			.switch_addr4_data				(switch_addr4_data_CH4			), 			//32位开关信号32位1的个数
			.vector_addr4_data				(vector_addr4_data_CH4			),			//32位向量信号32位0的个数
			.check_addr4_data				(check_addr4_data_CH4			),			//32位检测信号32位0的个数										
			.trans_enable					(trans_enable_CH4				),			//传输使能标志位,同check_enable共同决定该通道是发还是收
			.check_enable					(check_enable_CH4				)			//传输使能标志位,同trans_enable共同决定该通道是发还是收
		
        );
    
    edge_expansion edge_expansion_switch4(
  
			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),         	//3位速度选择
			.output_flow_start		(output_flow_start			),			//高速收发器开始信号,采用IC_test模块数据有效信号

			.switch_addr0_data		(switch_addr0_data_CH4		),			//32位开关信号32位1的个数
			.switch_addr1_data		(switch_addr1_data_CH4		), 			//32位开关信号第一个边沿
			.switch_addr2_data		(switch_addr2_data_CH4		),			//32位开关信号32位0的个数
			.switch_addr3_data		(switch_addr3_data_CH4		), 			//32位开关信号第二个边沿
			.switch_addr4_data		(switch_addr4_data_CH4		), 			//32位开关信号32位1的个数								
			.trans_enable			(trans_enable_CH4			),			//传输使能标志位,	

			//output接口
			.TRANS_FINISH_ALL		(TRANS_FINISH_ALL_CH4		),			//一次测试结束信号
			.expansion_swit_out		(gt9_txdata_i    			)  			//32位高速收发器并行数据		 
        ); 

    data_expansion edge_expansion_data4(

			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),              //3位速率控制
			.output_flow_start		(output_flow_start			),				//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_data_out			(TX_DATA_OUT[19:16]			),				//4位高速收发器准备输出的未扩展的向量

			.vector_addr0_data		(vector_addr0_data_CH4		),				//32位向量信号32位0的个数
			.vector_addr1_data		(vector_addr1_data_CH4		), 				//32位向量信号第一个边沿
			.vector_addr2_data		(vector_addr2_data_CH4		),				//32位向量信号32位1的个数
			.vector_addr3_data		(vector_addr3_data_CH4		), 				//32位向量信号第二个边沿
			.vector_addr4_data		(vector_addr4_data_CH4		), 				//32位向量信号32位0的个数								
			.trans_enable			(trans_enable_CH4			),				//传输使能标志位,	
			
			//output接口
			.expansion_data_out		(gt8_txdata_i				)   			//32位高速收发器并行数据
		
         );
         
    //----------------------------------------------------------------
	//----------------------------CH5---------------------------------
	//----------------------------------------------------------------
    wire                                    TRANS_FINISH_ALL_CH5;
    wire                                    trans_enable_CH5;
    wire                                    check_enable_CH5;
    wire		[31:0]						switch_addr0_data_CH5;			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr0_data_CH5;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr0_data_CH5;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr1_data_CH5; 			//32位开关信号第一个边沿
    wire		[31:0]						vector_addr1_data_CH5;			//32位向量信号第一个边沿
    wire		[31:0]						check_addr1_data_CH5;			//32位检测信号第一个边沿
    wire		[31:0]						switch_addr2_data_CH5;			//32位开关信号32位0的个数
    wire		[31:0]						vector_addr2_data_CH5;			//32位向量信号32位1的个数
    wire		[31:0]						check_addr2_data_CH5;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr3_data_CH5; 			//32位开关信号第二个边沿
    wire		[31:0]						vector_addr3_data_CH5;			//32位向量信号第二个边沿
    wire		[31:0]						check_addr3_data_CH5;			//32位检测信号第二个边沿
    wire		[31:0]						switch_addr4_data_CH5; 			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr4_data_CH5;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr4_data_CH5;			//32位检测信号32位0的个数	
    	
    ESET_EDGE_CHOOSE ESET_EDGE_CHOOSE_CH5(
			
			//input接口
			.ESET_OFFSET					(ESET_8CH_OFFSET[47:40]			),          //8位ESET偏移数据
			.ESET_OFFSET_VALID				(ESET_8CH_OFFSET_VALID			),          //ESET偏移数据有效
			.TRANS_FINISH_ALL				(TRANS_FINISH_ALL_CH5			),          //传输完成,准备清除准备数据,信号来源于开关信号的完成,由开关信号总控
			.ram_data_pc					(eset_write_data				),		    //192位PC端发下来的写入RAM的边沿数据
			.ram_data_write_en				(Eset_write_en_CH5				),          //边沿RAM写使能
			.ram_addr_pc					(Eset_write_addr_pc				),          //5位边沿RAM写地址
			.rate_choose                    (rate_choose_CH0                ),          //3位速度选择
			.mode_choose_cycle_single       (mode_choose_pc				    ),    		//控制模式选择,0：循环模式；1：正常模式
			.flow_start_ack                 (flow_start_ack                 ),          //ic模块接收到准备工作已完成,返回的握手信号

			.PROCESS_CLK					(gt0_txusrclk2_i				),
			.USER_CLK						(LCLK_50M						),
			.SYSTEM_RESET					(user_reset_c					),
			
			//output接口
			.EDGE_DATA_VALID				(EDGE_DATA_VALID_5				),          //准备数据已经完成且有效

			.switch_addr0_data				(switch_addr0_data_CH5			),			//32位开关信号32位1的个数
			.vector_addr0_data				(vector_addr0_data_CH5			),			//32位向量信号32位0的个数
			.check_addr0_data				(check_addr0_data_CH5			),			//32位检测信号32位0的个数
			.switch_addr1_data				(switch_addr1_data_CH5			), 			//32位开关信号第一个边沿
			.vector_addr1_data				(vector_addr1_data_CH5			),			//32位向量信号第一个边沿
			.check_addr1_data				(check_addr1_data_CH5			),			//32位检测信号第一个边沿
			.switch_addr2_data				(switch_addr2_data_CH5			),			//32位开关信号32位0的个数
			.vector_addr2_data				(vector_addr2_data_CH5			),			//32位向量信号32位1的个数
			.check_addr2_data				(check_addr2_data_CH5			),			//32位检测信号32位0的个数
			.switch_addr3_data				(switch_addr3_data_CH5			), 			//32位开关信号第二个边沿
			.vector_addr3_data				(vector_addr3_data_CH5			),			//32位向量信号第二个边沿
			.check_addr3_data				(check_addr3_data_CH5			),			//32位检测信号第二个边沿
			.switch_addr4_data				(switch_addr4_data_CH5			), 			//32位开关信号32位1的个数
			.vector_addr4_data				(vector_addr4_data_CH5			),			//32位向量信号32位0的个数
			.check_addr4_data				(check_addr4_data_CH5			),			//32位检测信号32位0的个数										
			.trans_enable					(trans_enable_CH5				),			//传输使能标志位,同check_enable共同决定该通道是发还是收
			.check_enable					(check_enable_CH5				)			//传输使能标志位,同trans_enable共同决定该通道是发还是收
		
        );
    
    edge_expansion edge_expansion_switch5(
  
			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),         	//3位速度选择
			.output_flow_start		(output_flow_start			),			//高速收发器开始信号,采用IC_test模块数据有效信号

			.switch_addr0_data		(switch_addr0_data_CH5		),			//32位开关信号32位1的个数
			.switch_addr1_data		(switch_addr1_data_CH5		), 			//32位开关信号第一个边沿
			.switch_addr2_data		(switch_addr2_data_CH5		),			//32位开关信号32位0的个数
			.switch_addr3_data		(switch_addr3_data_CH5		), 			//32位开关信号第二个边沿
			.switch_addr4_data		(switch_addr4_data_CH5		), 			//32位开关信号32位1的个数								
			.trans_enable			(trans_enable_CH5			),			//传输使能标志位,	

			//output接口
			.TRANS_FINISH_ALL		(TRANS_FINISH_ALL_CH5		),			//一次测试结束信号
			.expansion_swit_out		(gt11_txdata_i    			)  			//32位高速收发器并行数据		 
        ); 

    data_expansion edge_expansion_data5(

			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),              //3位速率控制
			.output_flow_start		(output_flow_start			),				//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_data_out			(TX_DATA_OUT[23:20]			),				//4位高速收发器准备输出的未扩展的向量

			.vector_addr0_data		(vector_addr0_data_CH5		),				//32位向量信号32位0的个数
			.vector_addr1_data		(vector_addr1_data_CH5		), 				//32位向量信号第一个边沿
			.vector_addr2_data		(vector_addr2_data_CH5		),				//32位向量信号32位1的个数
			.vector_addr3_data		(vector_addr3_data_CH5		), 				//32位向量信号第二个边沿
			.vector_addr4_data		(vector_addr4_data_CH5		), 				//32位向量信号32位0的个数								
			.trans_enable			(trans_enable_CH5			),				//传输使能标志位,	
			
			//output接口
			.expansion_data_out		(gt10_txdata_i				)   			//32位高速收发器并行数据
		
         );

    //----------------------------------------------------------------
	//----------------------------CH6---------------------------------
	//----------------------------------------------------------------
    wire                                    TRANS_FINISH_ALL_CH6;
    wire                                    trans_enable_CH6;
    wire                                    check_enable_CH6;
    wire		[31:0]						switch_addr0_data_CH6;			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr0_data_CH6;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr0_data_CH6;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr1_data_CH6; 			//32位开关信号第一个边沿
    wire		[31:0]						vector_addr1_data_CH6;			//32位向量信号第一个边沿
    wire		[31:0]						check_addr1_data_CH6;			//32位检测信号第一个边沿
    wire		[31:0]						switch_addr2_data_CH6;			//32位开关信号32位0的个数
    wire		[31:0]						vector_addr2_data_CH6;			//32位向量信号32位1的个数
    wire		[31:0]						check_addr2_data_CH6;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr3_data_CH6; 			//32位开关信号第二个边沿
    wire		[31:0]						vector_addr3_data_CH6;			//32位向量信号第二个边沿
    wire		[31:0]						check_addr3_data_CH6;			//32位检测信号第二个边沿
    wire		[31:0]						switch_addr4_data_CH6; 			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr4_data_CH6;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr4_data_CH6;			//32位检测信号32位0的个数	
    	
    ESET_EDGE_CHOOSE ESET_EDGE_CHOOSE_CH6(
			
			//input接口
			.ESET_OFFSET					(ESET_8CH_OFFSET[55:48]			),          //8位ESET偏移数据
			.ESET_OFFSET_VALID				(ESET_8CH_OFFSET_VALID			),          //ESET偏移数据有效
			.TRANS_FINISH_ALL				(TRANS_FINISH_ALL_CH6			),          //传输完成,准备清除准备数据,信号来源于开关信号的完成,由开关信号总控
			.ram_data_pc					(eset_write_data				),		    //192位PC端发下来的写入RAM的边沿数据
			.ram_data_write_en				(Eset_write_en_CH6				),          //边沿RAM写使能
			.ram_addr_pc					(Eset_write_addr_pc				),          //5位边沿RAM写地址
			.rate_choose                    (rate_choose_CH0                ),          //3位速度选择
			.mode_choose_cycle_single       (mode_choose_pc				    ),    		//控制模式选择,0：循环模式；1：正常模式
			.flow_start_ack                 (flow_start_ack                 ),          //ic模块接收到准备工作已完成,返回的握手信号

			.PROCESS_CLK					(gt0_txusrclk2_i				),
			.USER_CLK						(LCLK_50M						),
			.SYSTEM_RESET					(user_reset_c					),
			
			//output接口
			.EDGE_DATA_VALID				(EDGE_DATA_VALID_6				),          //准备数据已经完成且有效

			.switch_addr0_data				(switch_addr0_data_CH6			),			//32位开关信号32位1的个数
			.vector_addr0_data				(vector_addr0_data_CH6			),			//32位向量信号32位0的个数
			.check_addr0_data				(check_addr0_data_CH6			),			//32位检测信号32位0的个数
			.switch_addr1_data				(switch_addr1_data_CH6			), 			//32位开关信号第一个边沿
			.vector_addr1_data				(vector_addr1_data_CH6			),			//32位向量信号第一个边沿
			.check_addr1_data				(check_addr1_data_CH6			),			//32位检测信号第一个边沿
			.switch_addr2_data				(switch_addr2_data_CH6			),			//32位开关信号32位0的个数
			.vector_addr2_data				(vector_addr2_data_CH6			),			//32位向量信号32位1的个数
			.check_addr2_data				(check_addr2_data_CH6			),			//32位检测信号32位0的个数
			.switch_addr3_data				(switch_addr3_data_CH6			), 			//32位开关信号第二个边沿
			.vector_addr3_data				(vector_addr3_data_CH6			),			//32位向量信号第二个边沿
			.check_addr3_data				(check_addr3_data_CH6			),			//32位检测信号第二个边沿
			.switch_addr4_data				(switch_addr4_data_CH6			), 			//32位开关信号32位1的个数
			.vector_addr4_data				(vector_addr4_data_CH6			),			//32位向量信号32位0的个数
			.check_addr4_data				(check_addr4_data_CH6			),			//32位检测信号32位0的个数										
			.trans_enable					(trans_enable_CH6				),			//传输使能标志位,同check_enable共同决定该通道是发还是收
			.check_enable					(check_enable_CH6				)			//传输使能标志位,同trans_enable共同决定该通道是发还是收
		
        );
    
    edge_expansion edge_expansion_switch6(
  
			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),         	//3位速度选择
			.output_flow_start		(output_flow_start			),			//高速收发器开始信号,采用IC_test模块数据有效信号

			.switch_addr0_data		(switch_addr0_data_CH6		),			//32位开关信号32位1的个数
			.switch_addr1_data		(switch_addr1_data_CH6		), 			//32位开关信号第一个边沿
			.switch_addr2_data		(switch_addr2_data_CH6		),			//32位开关信号32位0的个数
			.switch_addr3_data		(switch_addr3_data_CH6		), 			//32位开关信号第二个边沿
			.switch_addr4_data		(switch_addr4_data_CH6		), 			//32位开关信号32位1的个数								
			.trans_enable			(trans_enable_CH6			),			//传输使能标志位,	

			//output接口
			.TRANS_FINISH_ALL		(TRANS_FINISH_ALL_CH6		),			//一次测试结束信号
			.expansion_swit_out		(gt13_txdata_i    			)  			//32位高速收发器并行数据		 
        ); 

    data_expansion edge_expansion_data6(

			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),              //3位速率控制
			.output_flow_start		(output_flow_start			),				//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_data_out			(TX_DATA_OUT[27:24]			),				//4位高速收发器准备输出的未扩展的向量

			.vector_addr0_data		(vector_addr0_data_CH6		),				//32位向量信号32位0的个数
			.vector_addr1_data		(vector_addr1_data_CH6		), 				//32位向量信号第一个边沿
			.vector_addr2_data		(vector_addr2_data_CH6		),				//32位向量信号32位1的个数
			.vector_addr3_data		(vector_addr3_data_CH6		), 				//32位向量信号第二个边沿
			.vector_addr4_data		(vector_addr4_data_CH6		), 				//32位向量信号32位0的个数								
			.trans_enable			(trans_enable_CH6			),				//传输使能标志位,	
			
			//output接口
			.expansion_data_out		(gt12_txdata_i				)   			//32位高速收发器并行数据
		
         );         

    //----------------------------------------------------------------
	//----------------------------CH7---------------------------------
	//----------------------------------------------------------------
    wire                                    TRANS_FINISH_ALL_CH7;
    wire                                    trans_enable_CH7;
    wire                                    check_enable_CH7;
    wire		[31:0]						switch_addr0_data_CH7;			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr0_data_CH7;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr0_data_CH7;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr1_data_CH7; 			//32位开关信号第一个边沿
    wire		[31:0]						vector_addr1_data_CH7;			//32位向量信号第一个边沿
    wire		[31:0]						check_addr1_data_CH7;			//32位检测信号第一个边沿
    wire		[31:0]						switch_addr2_data_CH7;			//32位开关信号32位0的个数
    wire		[31:0]						vector_addr2_data_CH7;			//32位向量信号32位1的个数
    wire		[31:0]						check_addr2_data_CH7;			//32位检测信号32位0的个数
    wire		[31:0]						switch_addr3_data_CH7; 			//32位开关信号第二个边沿
    wire		[31:0]						vector_addr3_data_CH7;			//32位向量信号第二个边沿
    wire		[31:0]						check_addr3_data_CH7;			//32位检测信号第二个边沿
    wire		[31:0]						switch_addr4_data_CH7; 			//32位开关信号32位1的个数
    wire		[31:0]						vector_addr4_data_CH7;			//32位向量信号32位0的个数
    wire		[31:0]						check_addr4_data_CH7;			//32位检测信号32位0的个数	
    	
    ESET_EDGE_CHOOSE ESET_EDGE_CHOOSE_CH7(
			
			//input接口
			.ESET_OFFSET					(ESET_8CH_OFFSET[63:56]			),          //8位ESET偏移数据
			.ESET_OFFSET_VALID				(ESET_8CH_OFFSET_VALID			),          //ESET偏移数据有效
			.TRANS_FINISH_ALL				(TRANS_FINISH_ALL_CH7			),          //传输完成,准备清除准备数据,信号来源于开关信号的完成,由开关信号总控
			.ram_data_pc					(eset_write_data				),		    //192位PC端发下来的写入RAM的边沿数据
			.ram_data_write_en				(Eset_write_en_CH7				),          //边沿RAM写使能
			.ram_addr_pc					(Eset_write_addr_pc				),          //5位边沿RAM写地址
			.rate_choose                    (rate_choose_CH0                ),          //3位速度选择
			.mode_choose_cycle_single       (mode_choose_pc				    ),    		//控制模式选择,0：循环模式；1：正常模式
			.flow_start_ack                 (flow_start_ack                 ),          //ic模块接收到准备工作已完成,返回的握手信号

			.PROCESS_CLK					(gt0_txusrclk2_i				),
			.USER_CLK						(LCLK_50M						),
			.SYSTEM_RESET					(user_reset_c					),
			
			//output接口
			.EDGE_DATA_VALID				(EDGE_DATA_VALID_7				),          //准备数据已经完成且有效

			.switch_addr0_data				(switch_addr0_data_CH7			),			//32位开关信号32位1的个数
			.vector_addr0_data				(vector_addr0_data_CH7			),			//32位向量信号32位0的个数
			.check_addr0_data				(check_addr0_data_CH7			),			//32位检测信号32位0的个数
			.switch_addr1_data				(switch_addr1_data_CH7			), 			//32位开关信号第一个边沿
			.vector_addr1_data				(vector_addr1_data_CH7			),			//32位向量信号第一个边沿
			.check_addr1_data				(check_addr1_data_CH7			),			//32位检测信号第一个边沿
			.switch_addr2_data				(switch_addr2_data_CH7			),			//32位开关信号32位0的个数
			.vector_addr2_data				(vector_addr2_data_CH7			),			//32位向量信号32位1的个数
			.check_addr2_data				(check_addr2_data_CH7			),			//32位检测信号32位0的个数
			.switch_addr3_data				(switch_addr3_data_CH7			), 			//32位开关信号第二个边沿
			.vector_addr3_data				(vector_addr3_data_CH7			),			//32位向量信号第二个边沿
			.check_addr3_data				(check_addr3_data_CH7			),			//32位检测信号第二个边沿
			.switch_addr4_data				(switch_addr4_data_CH7			), 			//32位开关信号32位1的个数
			.vector_addr4_data				(vector_addr4_data_CH7			),			//32位向量信号32位0的个数
			.check_addr4_data				(check_addr4_data_CH7			),			//32位检测信号32位0的个数										
			.trans_enable					(trans_enable_CH7				),			//传输使能标志位,同check_enable共同决定该通道是发还是收
			.check_enable					(check_enable_CH7				)			//传输使能标志位,同trans_enable共同决定该通道是发还是收
		
        );
    
    edge_expansion edge_expansion_switch7(
  
			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),         	//3位速度选择
			.output_flow_start		(output_flow_start			),			//高速收发器开始信号,采用IC_test模块数据有效信号

			.switch_addr0_data		(switch_addr0_data_CH7		),			//32位开关信号32位1的个数
			.switch_addr1_data		(switch_addr1_data_CH7		), 			//32位开关信号第一个边沿
			.switch_addr2_data		(switch_addr2_data_CH7		),			//32位开关信号32位0的个数
			.switch_addr3_data		(switch_addr3_data_CH7		), 			//32位开关信号第二个边沿
			.switch_addr4_data		(switch_addr4_data_CH7		), 			//32位开关信号32位1的个数								
			.trans_enable			(trans_enable_CH7			),			//传输使能标志位,	

			//output接口
			.TRANS_FINISH_ALL		(TRANS_FINISH_ALL_CH7		),			//一次测试结束信号
			.expansion_swit_out		(gt15_txdata_i    			)  			//32位高速收发器并行数据		 
        ); 

    data_expansion edge_expansion_data7(

			//input接口
			.PROCESS_CLK			(gt0_txusrclk2_i			),
			.reset					(user_reset_c				),
			.rate_choose			(rate_choose_CH0			),              //3位速率控制
			.output_flow_start		(output_flow_start			),				//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_data_out			(TX_DATA_OUT[31:28]			),				//4位高速收发器准备输出的未扩展的向量

			.vector_addr0_data		(vector_addr0_data_CH7		),				//32位向量信号32位0的个数
			.vector_addr1_data		(vector_addr1_data_CH7		), 				//32位向量信号第一个边沿
			.vector_addr2_data		(vector_addr2_data_CH7		),				//32位向量信号32位1的个数
			.vector_addr3_data		(vector_addr3_data_CH7		), 				//32位向量信号第二个边沿
			.vector_addr4_data		(vector_addr4_data_CH7		), 				//32位向量信号32位0的个数								
			.trans_enable			(trans_enable_CH7			),				//传输使能标志位,	
			
			//output接口
			.expansion_data_out		(gt14_txdata_i				)   			//32位高速收发器并行数据
		
         );	 
         
    //***********************************************************************//
    //                                                                       //
    //------------------------  Frame Checkers  -----------------------------//
    //                                                                       //
    //***********************************************************************//
    
    //____________________________CH0_________________________________       
    check_expansion gt0_frame_check_h(

			//output接口
			.error_cnt_out					(error_read_number_0				),			//8位采集到的错误数据数量	
			.error_ram_data_out				(error_ram_data_out_0				),			//32位PC读错误数据RAM输出	

			//input接口
			.data_check_in					(gt1_rxdata_i						),			//32位采集到的32位并行信号
			.error_read_addr_pc				(Hram_read_addr_pc_0				),			//6位PC读错误数据RAM地址

			.PROCESS_CLK					(gt0_rxusrclk2_i					),
			.user_clk						(LCLK_50M							),
			.reset							(user_reset_c						),
			.rate_choose					(rate_choose_CH0					),          //3位速度选择
			.output_flow_start				(output_flow_start					),			//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_check_out					(TX_DATA_OUT[3:0]					),			//4位高速收发器准备输出的未扩展的向量

			.check_addr0_data				(check_addr0_data_CH0				),			//32位向量信号32位0的个数
			.check_addr1_data				(check_addr1_data_CH0				), 			//32位向量信号第一个边沿
			.check_addr2_data				(check_addr2_data_CH0				),			//32位向量信号32位1的个数
			.check_addr3_data				(check_addr3_data_CH0				), 			//32位向量信号第二个边沿
			.check_addr4_data				(check_addr4_data_CH0				), 			//32位向量信号32位0的个数								
			.check_enable					(check_enable_CH0					)			//传输使能标志位,	
            ); 

    //____________________________CH1_________________________________       
    check_expansion gt1_frame_check_h(

			//output接口
			.error_cnt_out					(error_read_number_1				),			//8位采集到的错误数据数量	
			.error_ram_data_out				(error_ram_data_out_1				),			//32位PC读错误数据RAM输出	

			//input接口
			.data_check_in					(gt3_rxdata_i						),			//32位采集到的32位并行信号
			.error_read_addr_pc				(Hram_read_addr_pc_1				),			//6位PC读错误数据RAM地址

			.PROCESS_CLK					(gt3_rxusrclk2_i					),
			.user_clk						(LCLK_50M							),
			.reset							(user_reset_c						),
			.rate_choose					(rate_choose_CH0					),          //3位速度选择
			.output_flow_start				(output_flow_start					),			//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_check_out					(TX_DATA_OUT[7:4]					),			//4位高速收发器准备输出的未扩展的向量

			.check_addr0_data				(check_addr0_data_CH1				),			//32位向量信号32位0的个数
			.check_addr1_data				(check_addr1_data_CH1				), 			//32位向量信号第一个边沿
			.check_addr2_data				(check_addr2_data_CH1				),			//32位向量信号32位1的个数
			.check_addr3_data				(check_addr3_data_CH1				), 			//32位向量信号第二个边沿
			.check_addr4_data				(check_addr4_data_CH1				), 			//32位向量信号32位0的个数								
			.check_enable					(check_enable_CH1					)			//传输使能标志位,	
            ); 

    //____________________________CH2_________________________________       
    check_expansion gt2_frame_check_h(

			//output接口
			.error_cnt_out					(error_read_number_2				),			//8位采集到的错误数据数量	
			.error_ram_data_out				(error_ram_data_out_2				),			//32位PC读错误数据RAM输出	

			//input接口
			.data_check_in					(gt5_rxdata_i						),			//32位采集到的32位并行信号
			.error_read_addr_pc				(Hram_read_addr_pc_2				),			//6位PC读错误数据RAM地址

			.PROCESS_CLK					(gt5_rxusrclk2_i					),
			.user_clk						(LCLK_50M							),
			.reset							(user_reset_c						),
			.rate_choose					(rate_choose_CH0					),          //3位速度选择
			.output_flow_start				(output_flow_start					),			//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_check_out					(TX_DATA_OUT[11:8]					),			//4位高速收发器准备输出的未扩展的向量

			.check_addr0_data				(check_addr0_data_CH2				),			//32位向量信号32位0的个数
			.check_addr1_data				(check_addr1_data_CH2				), 			//32位向量信号第一个边沿
			.check_addr2_data				(check_addr2_data_CH2				),			//32位向量信号32位1的个数
			.check_addr3_data				(check_addr3_data_CH2				), 			//32位向量信号第二个边沿
			.check_addr4_data				(check_addr4_data_CH2				), 			//32位向量信号32位0的个数								
			.check_enable					(check_enable_CH2					)			//传输使能标志位,	
            );	
            
    //____________________________CH3_________________________________       
    check_expansion gt3_frame_check_h(

			//output接口
			.error_cnt_out					(error_read_number_3				),			//8位采集到的错误数据数量	
			.error_ram_data_out				(error_ram_data_out_3				),			//32位PC读错误数据RAM输出	

			//input接口
			.data_check_in					(gt7_rxdata_i						),			//32位采集到的32位并行信号
			.error_read_addr_pc				(Hram_read_addr_pc_3				),			//6位PC读错误数据RAM地址

			.PROCESS_CLK					(gt7_rxusrclk2_i					),
			.user_clk						(LCLK_50M							),
			.reset							(user_reset_c						),
			.rate_choose					(rate_choose_CH0					),          //3位速度选择
			.output_flow_start				(output_flow_start					),			//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_check_out					(TX_DATA_OUT[15:12]					),			//4位高速收发器准备输出的未扩展的向量

			.check_addr0_data				(check_addr0_data_CH3				),			//32位向量信号32位0的个数
			.check_addr1_data				(check_addr1_data_CH3				), 			//32位向量信号第一个边沿
			.check_addr2_data				(check_addr2_data_CH3				),			//32位向量信号32位1的个数
			.check_addr3_data				(check_addr3_data_CH3				), 			//32位向量信号第二个边沿
			.check_addr4_data				(check_addr4_data_CH3				), 			//32位向量信号32位0的个数								
			.check_enable					(check_enable_CH3					)			//传输使能标志位,	
            );

    //____________________________CH4_________________________________       
    check_expansion gt4_frame_check_h(

			//output接口
			.error_cnt_out					(error_read_number_4				),			//8位采集到的错误数据数量	
			.error_ram_data_out				(error_ram_data_out_4				),			//32位PC读错误数据RAM输出	

			//input接口
			.data_check_in					(gt9_rxdata_i						),			//32位采集到的32位并行信号
			.error_read_addr_pc				(Hram_read_addr_pc_4				),			//6位PC读错误数据RAM地址

			.PROCESS_CLK					(gt9_rxusrclk2_i					),
			.user_clk						(LCLK_50M							),
			.reset							(user_reset_c						),
			.rate_choose					(rate_choose_CH0					),          //3位速度选择
			.output_flow_start				(output_flow_start					),			//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_check_out					(TX_DATA_OUT[19:16]					),			//4位高速收发器准备输出的未扩展的向量

			.check_addr0_data				(check_addr0_data_CH4				),			//32位向量信号32位0的个数
			.check_addr1_data				(check_addr1_data_CH4				), 			//32位向量信号第一个边沿
			.check_addr2_data				(check_addr2_data_CH4				),			//32位向量信号32位1的个数
			.check_addr3_data				(check_addr3_data_CH4				), 			//32位向量信号第二个边沿
			.check_addr4_data				(check_addr4_data_CH4				), 			//32位向量信号32位0的个数								
			.check_enable					(check_enable_CH4					)			//传输使能标志位,	
            );

    //____________________________CH5_________________________________       
    check_expansion gt5_frame_check_h(

			//output接口
			.error_cnt_out					(error_read_number_5				),			//8位采集到的错误数据数量	
			.error_ram_data_out				(error_ram_data_out_5				),			//32位PC读错误数据RAM输出	

			//input接口
			.data_check_in					(gt11_rxdata_i						),			//32位采集到的32位并行信号
			.error_read_addr_pc				(Hram_read_addr_pc_5				),			//6位PC读错误数据RAM地址

			.PROCESS_CLK					(gt11_rxusrclk2_i					),
			.user_clk						(LCLK_50M							),
			.reset							(user_reset_c						),
			.rate_choose					(rate_choose_CH0					),          //3位速度选择
			.output_flow_start				(output_flow_start					),			//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_check_out					(TX_DATA_OUT[23:20]					),			//4位高速收发器准备输出的未扩展的向量

			.check_addr0_data				(check_addr0_data_CH5				),			//32位向量信号32位0的个数
			.check_addr1_data				(check_addr1_data_CH5				), 			//32位向量信号第一个边沿
			.check_addr2_data				(check_addr2_data_CH5				),			//32位向量信号32位1的个数
			.check_addr3_data				(check_addr3_data_CH5				), 			//32位向量信号第二个边沿
			.check_addr4_data				(check_addr4_data_CH5				), 			//32位向量信号32位0的个数								
			.check_enable					(check_enable_CH5					)			//传输使能标志位,	
            );

    //____________________________CH6_________________________________       
    check_expansion gt6_frame_check_h(

			//output接口
			.error_cnt_out					(error_read_number_6				),			//8位采集到的错误数据数量	
			.error_ram_data_out				(error_ram_data_out_6				),			//32位PC读错误数据RAM输出	

			//input接口
			.data_check_in					(gt13_rxdata_i						),			//32位采集到的32位并行信号
			.error_read_addr_pc				(Hram_read_addr_pc_6				),			//6位PC读错误数据RAM地址

			.PROCESS_CLK					(gt13_rxusrclk2_i					),
			.user_clk						(LCLK_50M							),
			.reset							(user_reset_c						),
			.rate_choose					(rate_choose_CH0					),          //3位速度选择
			.output_flow_start				(output_flow_start					),			//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_check_out					(TX_DATA_OUT[27:24]					),			//4位高速收发器准备输出的未扩展的向量

			.check_addr0_data				(check_addr0_data_CH6				),			//32位向量信号32位0的个数
			.check_addr1_data				(check_addr1_data_CH6				), 			//32位向量信号第一个边沿
			.check_addr2_data				(check_addr2_data_CH6				),			//32位向量信号32位1的个数
			.check_addr3_data				(check_addr3_data_CH6				), 			//32位向量信号第二个边沿
			.check_addr4_data				(check_addr4_data_CH6				), 			//32位向量信号32位0的个数								
			.check_enable					(check_enable_CH6					)			//传输使能标志位,	
            );

    //____________________________CH7_________________________________       
    check_expansion gt7_frame_check_h(

			//output接口
			.error_cnt_out					(error_read_number_7				),			//8位采集到的错误数据数量	
			.error_ram_data_out				(error_ram_data_out_7				),			//32位PC读错误数据RAM输出	

			//input接口
			.data_check_in					(gt15_rxdata_i						),			//32位采集到的32位并行信号
			.error_read_addr_pc				(Hram_read_addr_pc_7				),			//6位PC读错误数据RAM地址

			.PROCESS_CLK					(gt15_rxusrclk2_i					),
			.user_clk						(LCLK_50M							),
			.reset							(user_reset_c						),
			.rate_choose					(rate_choose_CH0					),          //3位速度选择
			.output_flow_start				(output_flow_start					),			//高速收发器开始信号,采用IC_test模块数据有效信号
			.gtx_check_out					(TX_DATA_OUT[31:28]					),			//4位高速收发器准备输出的未扩展的向量

			.check_addr0_data				(check_addr0_data_CH7				),			//32位向量信号32位0的个数
			.check_addr1_data				(check_addr1_data_CH7				), 			//32位向量信号第一个边沿
			.check_addr2_data				(check_addr2_data_CH7				),			//32位向量信号32位1的个数
			.check_addr3_data				(check_addr3_data_CH7				), 			//32位向量信号第二个边沿
			.check_addr4_data				(check_addr4_data_CH7				), 			//32位向量信号32位0的个数								
			.check_enable					(check_enable_CH7					)			//传输使能标志位,	
            );
			
    //***********************************************************************//
    //                                                                       //
    //--------------------------- The GT Wrapper ----------------------------//
    //                                                                       //
    //***********************************************************************//
   
    gtwizard_0_support #
    (
        .EXAMPLE_SIM_GTRESET_SPEEDUP    (EXAMPLE_SIM_GTRESET_SPEEDUP),
        .STABLE_CLOCK_PERIOD            (STABLE_CLOCK_PERIOD)
    )
    gtwizard_0_support_i
    (
        .soft_reset_tx_in               (soft_reset_i),
        .soft_reset_rx_in               (soft_reset_i),
        .dont_reset_on_data_error_in    (tied_to_ground_i),
		.q1_clk0_gtrefclk_pad_n_in		(Q1_CLK0_GTREFCLK_PAD_N_IN),
		.q1_clk0_gtrefclk_pad_p_in		(Q1_CLK0_GTREFCLK_PAD_P_IN),
		.q2_clk0_gtrefclk_pad_n_in		(Q2_CLK0_GTREFCLK_PAD_N_IN),
		.q2_clk0_gtrefclk_pad_p_in		(Q2_CLK0_GTREFCLK_PAD_P_IN),
        .gt0_tx_fsm_reset_done_out      (gt0_txfsmresetdone_i),
        .gt0_rx_fsm_reset_done_out      (gt0_rxfsmresetdone_i),
        .gt0_data_valid_in              (gt0_track_data_i),
        .gt1_tx_fsm_reset_done_out      (gt1_txfsmresetdone_i),
        .gt1_rx_fsm_reset_done_out      (gt1_rxfsmresetdone_i),
        .gt1_data_valid_in              (gt1_track_data_i),
        .gt2_tx_fsm_reset_done_out      (gt2_txfsmresetdone_i),
        .gt2_rx_fsm_reset_done_out      (gt2_rxfsmresetdone_i),
        .gt2_data_valid_in              (gt2_track_data_i),
        .gt3_tx_fsm_reset_done_out      (gt3_txfsmresetdone_i),
        .gt3_rx_fsm_reset_done_out      (gt3_rxfsmresetdone_i),
        .gt3_data_valid_in              (gt3_track_data_i),
        .gt4_tx_fsm_reset_done_out      (gt4_txfsmresetdone_i),
        .gt4_rx_fsm_reset_done_out      (gt4_rxfsmresetdone_i),
        .gt4_data_valid_in              (gt4_track_data_i),
        .gt5_tx_fsm_reset_done_out      (gt5_txfsmresetdone_i),
        .gt5_rx_fsm_reset_done_out      (gt5_rxfsmresetdone_i),
        .gt5_data_valid_in              (gt5_track_data_i),
        .gt6_tx_fsm_reset_done_out      (gt6_txfsmresetdone_i),
        .gt6_rx_fsm_reset_done_out      (gt6_rxfsmresetdone_i),
        .gt6_data_valid_in              (gt6_track_data_i),
        .gt7_tx_fsm_reset_done_out      (gt7_txfsmresetdone_i),
        .gt7_rx_fsm_reset_done_out      (gt7_rxfsmresetdone_i),
        .gt7_data_valid_in              (gt7_track_data_i),
        .gt8_tx_fsm_reset_done_out      (gt8_txfsmresetdone_i),
        .gt8_rx_fsm_reset_done_out      (gt8_rxfsmresetdone_i),
        .gt8_data_valid_in              (gt8_track_data_i),
        .gt9_tx_fsm_reset_done_out      (gt9_txfsmresetdone_i),
        .gt9_rx_fsm_reset_done_out      (gt9_rxfsmresetdone_i),
        .gt9_data_valid_in              (gt9_track_data_i),
        .gt10_tx_fsm_reset_done_out     (gt10_txfsmresetdone_i),
        .gt10_rx_fsm_reset_done_out     (gt10_rxfsmresetdone_i),
        .gt10_data_valid_in             (gt10_track_data_i),
        .gt11_tx_fsm_reset_done_out     (gt11_txfsmresetdone_i),
        .gt11_rx_fsm_reset_done_out     (gt11_rxfsmresetdone_i),
        .gt11_data_valid_in             (gt11_track_data_i),
        .gt12_tx_fsm_reset_done_out     (gt12_txfsmresetdone_i),
        .gt12_rx_fsm_reset_done_out     (gt12_rxfsmresetdone_i),
        .gt12_data_valid_in             (gt12_track_data_i),
        .gt13_tx_fsm_reset_done_out     (gt13_txfsmresetdone_i),
        .gt13_rx_fsm_reset_done_out     (gt13_rxfsmresetdone_i),
        .gt13_data_valid_in             (gt13_track_data_i),
        .gt14_tx_fsm_reset_done_out     (gt14_txfsmresetdone_i),
        .gt14_rx_fsm_reset_done_out     (gt14_rxfsmresetdone_i),
        .gt14_data_valid_in             (gt14_track_data_i),
        .gt15_tx_fsm_reset_done_out     (gt15_txfsmresetdone_i),
        .gt15_rx_fsm_reset_done_out     (gt15_rxfsmresetdone_i),
        .gt15_data_valid_in             (gt15_track_data_i),
 
		.gt0_txusrclk_out				(gt0_txusrclk_i),
		.gt0_txusrclk2_out				(gt0_txusrclk2_i),
		.gt0_rxusrclk_out				(gt0_rxusrclk_i),
		.gt0_rxusrclk2_out				(gt0_rxusrclk2_i),
 
		.gt1_txusrclk_out				(gt1_txusrclk_i),
		.gt1_txusrclk2_out				(gt1_txusrclk2_i),
		.gt1_rxusrclk_out				(gt1_rxusrclk_i),
		.gt1_rxusrclk2_out				(gt1_rxusrclk2_i),
	 
		.gt2_txusrclk_out				(gt2_txusrclk_i),
		.gt2_txusrclk2_out				(gt2_txusrclk2_i),
		.gt2_rxusrclk_out				(gt2_rxusrclk_i),
		.gt2_rxusrclk2_out				(gt2_rxusrclk2_i),
	 
		.gt3_txusrclk_out				(gt3_txusrclk_i),
		.gt3_txusrclk2_out				(gt3_txusrclk2_i),
		.gt3_rxusrclk_out				(gt3_rxusrclk_i),
		.gt3_rxusrclk2_out				(gt3_rxusrclk2_i),
	 
		.gt4_txusrclk_out				(gt4_txusrclk_i),
		.gt4_txusrclk2_out				(gt4_txusrclk2_i),
		.gt4_rxusrclk_out				(gt4_rxusrclk_i),
		.gt4_rxusrclk2_out				(gt4_rxusrclk2_i),
	 
		.gt5_txusrclk_out				(gt5_txusrclk_i),
		.gt5_txusrclk2_out				(gt5_txusrclk2_i),
		.gt5_rxusrclk_out				(gt5_rxusrclk_i),
		.gt5_rxusrclk2_out				(gt5_rxusrclk2_i),
	 
		.gt6_txusrclk_out				(gt6_txusrclk_i),
		.gt6_txusrclk2_out				(gt6_txusrclk2_i),
		.gt6_rxusrclk_out				(gt6_rxusrclk_i),
		.gt6_rxusrclk2_out				(gt6_rxusrclk2_i),
	 
		.gt7_txusrclk_out				(gt7_txusrclk_i),
		.gt7_txusrclk2_out				(gt7_txusrclk2_i),
		.gt7_rxusrclk_out				(gt7_rxusrclk_i),
		.gt7_rxusrclk2_out				(gt7_rxusrclk2_i),
	 
		.gt8_txusrclk_out				(gt8_txusrclk_i),
		.gt8_txusrclk2_out				(gt8_txusrclk2_i),
		.gt8_rxusrclk_out				(gt8_rxusrclk_i),
		.gt8_rxusrclk2_out				(gt8_rxusrclk2_i),
	 
		.gt9_txusrclk_out				(gt9_txusrclk_i),
		.gt9_txusrclk2_out				(gt9_txusrclk2_i),
		.gt9_rxusrclk_out				(gt9_rxusrclk_i),
		.gt9_rxusrclk2_out				(gt9_rxusrclk2_i),
	 
		.gt10_txusrclk_out				(gt10_txusrclk_i),
		.gt10_txusrclk2_out				(gt10_txusrclk2_i),
		.gt10_rxusrclk_out				(gt10_rxusrclk_i),
		.gt10_rxusrclk2_out				(gt10_rxusrclk2_i),
	 
		.gt11_txusrclk_out				(gt11_txusrclk_i),
		.gt11_txusrclk2_out				(gt11_txusrclk2_i),
		.gt11_rxusrclk_out				(gt11_rxusrclk_i),
		.gt11_rxusrclk2_out				(gt11_rxusrclk2_i),
	 
		.gt12_txusrclk_out				(gt12_txusrclk_i),
		.gt12_txusrclk2_out				(gt12_txusrclk2_i),
		.gt12_rxusrclk_out				(gt12_rxusrclk_i),
		.gt12_rxusrclk2_out				(gt12_rxusrclk2_i),
	 
		.gt13_txusrclk_out				(gt13_txusrclk_i),
		.gt13_txusrclk2_out				(gt13_txusrclk2_i),
		.gt13_rxusrclk_out				(gt13_rxusrclk_i),
		.gt13_rxusrclk2_out				(gt13_rxusrclk2_i),
	 
		.gt14_txusrclk_out				(gt14_txusrclk_i),
		.gt14_txusrclk2_out				(gt14_txusrclk2_i),
		.gt14_rxusrclk_out				(gt14_rxusrclk_i),
		.gt14_rxusrclk2_out				(gt14_rxusrclk2_i),
	 
		.gt15_txusrclk_out				(gt15_txusrclk_i),
		.gt15_txusrclk2_out				(gt15_txusrclk2_i),
		.gt15_rxusrclk_out				(gt15_rxusrclk_i),
		.gt15_rxusrclk2_out				(gt15_rxusrclk2_i),


        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT0  (X1Y0)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt0_drpaddr_in                 (gt0_drpaddr_i),
        .gt0_drpdi_in                   (gt0_drpdi_i),
        .gt0_drpdo_out                  (gt0_drpdo_i),
        .gt0_drpen_in                   (gt0_drpen_i),
        .gt0_drprdy_out                 (gt0_drprdy_i),
        .gt0_drpwe_in                   (gt0_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt0_dmonitorout_out            (gt0_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt0_loopback_in                (gt0_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt0_eyescanreset_in            (tied_to_ground_i),
        .gt0_rxuserrdy_in               (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt0_eyescandataerror_out       (gt0_eyescandataerror_i),
        .gt0_eyescantrigger_in          (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt0_rxdata_out                 (gt0_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt0_rxprbserr_out              (gt0_rxprbserr_i),
        .gt0_rxprbssel_in               (gt0_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt0_rxprbscntreset_in          (gt0_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt0_gtxrxp_in                  (RXP_IN[0]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt0_gtxrxn_in                  (RXN_IN[0]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt0_rxdfelpmreset_in           (tied_to_ground_i),
        .gt0_rxmonitorout_out           (gt0_rxmonitorout_i),
        .gt0_rxmonitorsel_in            (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt0_rxoutclkfabric_out         (gt0_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt0_gtrxreset_in               (tied_to_ground_i),
        .gt0_rxpcsreset_in              (tied_to_ground_i),
        .gt0_rxpmareset_in              (gt0_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt0_rxresetdone_out            (gt0_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt0_gttxreset_in               (tied_to_ground_i),
        .gt0_txuserrdy_in               (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt0_txprbsforceerr_in          (gt0_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt0_txdata_in                  (gt0_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt0_gtxtxn_out                 (TXN_OUT[0]),
        .gt0_gtxtxp_out                 (TXP_OUT[0]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt0_txoutclkfabric_out         (gt0_txoutclkfabric_i),
        .gt0_txoutclkpcs_out            (gt0_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt0_txpcsreset_in              (tied_to_ground_i),
        .gt0_txpmareset_in              (tied_to_ground_i),
        .gt0_txresetdone_out            (gt0_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt0_txprbssel_in               (gt0_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT1  (X1Y1)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt1_drpaddr_in                 (gt1_drpaddr_i),
        .gt1_drpdi_in                   (gt1_drpdi_i),
        .gt1_drpdo_out                  (gt1_drpdo_i),
        .gt1_drpen_in                   (gt1_drpen_i),
        .gt1_drprdy_out                 (gt1_drprdy_i),
        .gt1_drpwe_in                   (gt1_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt1_dmonitorout_out            (gt1_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt1_loopback_in                (gt1_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt1_eyescanreset_in            (tied_to_ground_i),
        .gt1_rxuserrdy_in               (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt1_eyescandataerror_out       (gt1_eyescandataerror_i),
        .gt1_eyescantrigger_in          (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt1_rxdata_out                 (gt1_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt1_rxprbserr_out              (gt1_rxprbserr_i),
        .gt1_rxprbssel_in               (gt1_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt1_rxprbscntreset_in          (gt1_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt1_gtxrxp_in                  (RXP_IN[1]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt1_gtxrxn_in                  (RXN_IN[1]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt1_rxdfelpmreset_in           (tied_to_ground_i),
        .gt1_rxmonitorout_out           (gt1_rxmonitorout_i),
        .gt1_rxmonitorsel_in            (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt1_rxoutclkfabric_out         (gt1_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt1_gtrxreset_in               (tied_to_ground_i),
        .gt1_rxpcsreset_in              (tied_to_ground_i),
        .gt1_rxpmareset_in              (gt1_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt1_rxresetdone_out            (gt1_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt1_gttxreset_in               (tied_to_ground_i),
        .gt1_txuserrdy_in               (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt1_txprbsforceerr_in          (gt1_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt1_txdata_in                  (gt1_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt1_gtxtxn_out                 (TXN_OUT[1]),
        .gt1_gtxtxp_out                 (TXP_OUT[1]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt1_txoutclkfabric_out         (gt1_txoutclkfabric_i),
        .gt1_txoutclkpcs_out            (gt1_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt1_txpcsreset_in              (tied_to_ground_i),
        .gt1_txpmareset_in              (tied_to_ground_i),
        .gt1_txresetdone_out            (gt1_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt1_txprbssel_in               (gt1_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT2  (X1Y2)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt2_drpaddr_in                 (gt2_drpaddr_i),
        .gt2_drpdi_in                   (gt2_drpdi_i),
        .gt2_drpdo_out                  (gt2_drpdo_i),
        .gt2_drpen_in                   (gt2_drpen_i),
        .gt2_drprdy_out                 (gt2_drprdy_i),
        .gt2_drpwe_in                   (gt2_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt2_dmonitorout_out            (gt2_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt2_loopback_in                (gt2_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt2_eyescanreset_in            (tied_to_ground_i),
        .gt2_rxuserrdy_in               (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt2_eyescandataerror_out       (gt2_eyescandataerror_i),
        .gt2_eyescantrigger_in          (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt2_rxdata_out                 (gt2_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt2_rxprbserr_out              (gt2_rxprbserr_i),
        .gt2_rxprbssel_in               (gt2_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt2_rxprbscntreset_in          (gt2_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt2_gtxrxp_in                  (RXP_IN[2]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt2_gtxrxn_in                  (RXN_IN[2]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt2_rxdfelpmreset_in           (tied_to_ground_i),
        .gt2_rxmonitorout_out           (gt2_rxmonitorout_i),
        .gt2_rxmonitorsel_in            (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt2_rxoutclkfabric_out         (gt2_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt2_gtrxreset_in               (tied_to_ground_i),
        .gt2_rxpcsreset_in              (tied_to_ground_i),
        .gt2_rxpmareset_in              (gt2_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt2_rxresetdone_out            (gt2_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt2_gttxreset_in               (tied_to_ground_i),
        .gt2_txuserrdy_in               (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt2_txprbsforceerr_in          (gt2_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt2_txdata_in                  (gt2_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt2_gtxtxn_out                 (TXN_OUT[2]),
        .gt2_gtxtxp_out                 (TXP_OUT[2]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt2_txoutclkfabric_out         (gt2_txoutclkfabric_i),
        .gt2_txoutclkpcs_out            (gt2_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt2_txpcsreset_in              (tied_to_ground_i),
        .gt2_txpmareset_in              (tied_to_ground_i),
        .gt2_txresetdone_out            (gt2_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt2_txprbssel_in               (gt2_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT3  (X1Y3)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt3_drpaddr_in                 (gt3_drpaddr_i),
        .gt3_drpdi_in                   (gt3_drpdi_i),
        .gt3_drpdo_out                  (gt3_drpdo_i),
        .gt3_drpen_in                   (gt3_drpen_i),
        .gt3_drprdy_out                 (gt3_drprdy_i),
        .gt3_drpwe_in                   (gt3_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt3_dmonitorout_out            (gt3_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt3_loopback_in                (gt3_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt3_eyescanreset_in            (tied_to_ground_i),
        .gt3_rxuserrdy_in               (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt3_eyescandataerror_out       (gt3_eyescandataerror_i),
        .gt3_eyescantrigger_in          (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt3_rxdata_out                 (gt3_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt3_rxprbserr_out              (gt3_rxprbserr_i),
        .gt3_rxprbssel_in               (gt3_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt3_rxprbscntreset_in          (gt3_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt3_gtxrxp_in                  (RXP_IN[3]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt3_gtxrxn_in                  (RXN_IN[3]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt3_rxdfelpmreset_in           (tied_to_ground_i),
        .gt3_rxmonitorout_out           (gt3_rxmonitorout_i),
        .gt3_rxmonitorsel_in            (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt3_rxoutclkfabric_out         (gt3_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt3_gtrxreset_in               (tied_to_ground_i),
        .gt3_rxpcsreset_in              (tied_to_ground_i),
        .gt3_rxpmareset_in              (gt3_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt3_rxresetdone_out            (gt3_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt3_gttxreset_in               (tied_to_ground_i),
        .gt3_txuserrdy_in               (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt3_txprbsforceerr_in          (gt3_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt3_txdata_in                  (gt3_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt3_gtxtxn_out                 (TXN_OUT[3]),
        .gt3_gtxtxp_out                 (TXP_OUT[3]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt3_txoutclkfabric_out         (gt3_txoutclkfabric_i),
        .gt3_txoutclkpcs_out            (gt3_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt3_txpcsreset_in              (tied_to_ground_i),
        .gt3_txpmareset_in              (tied_to_ground_i),
        .gt3_txresetdone_out            (gt3_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt3_txprbssel_in               (gt3_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT4  (X1Y4)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt4_drpaddr_in                 (gt4_drpaddr_i),
        .gt4_drpdi_in                   (gt4_drpdi_i),
        .gt4_drpdo_out                  (gt4_drpdo_i),
        .gt4_drpen_in                   (gt4_drpen_i),
        .gt4_drprdy_out                 (gt4_drprdy_i),
        .gt4_drpwe_in                   (gt4_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt4_dmonitorout_out            (gt4_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt4_loopback_in                (gt4_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt4_eyescanreset_in            (tied_to_ground_i),
        .gt4_rxuserrdy_in               (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt4_eyescandataerror_out       (gt4_eyescandataerror_i),
        .gt4_eyescantrigger_in          (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt4_rxdata_out                 (gt4_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt4_rxprbserr_out              (gt4_rxprbserr_i),
        .gt4_rxprbssel_in               (gt4_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt4_rxprbscntreset_in          (gt4_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt4_gtxrxp_in                  (RXP_IN[4]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt4_gtxrxn_in                  (RXN_IN[4]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt4_rxdfelpmreset_in           (tied_to_ground_i),
        .gt4_rxmonitorout_out           (gt4_rxmonitorout_i),
        .gt4_rxmonitorsel_in            (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt4_rxoutclkfabric_out         (gt4_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt4_gtrxreset_in               (tied_to_ground_i),
        .gt4_rxpcsreset_in              (tied_to_ground_i),
        .gt4_rxpmareset_in              (gt4_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt4_rxresetdone_out            (gt4_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt4_gttxreset_in               (tied_to_ground_i),
        .gt4_txuserrdy_in               (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt4_txprbsforceerr_in          (gt4_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt4_txdata_in                  (gt4_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt4_gtxtxn_out                 (TXN_OUT[4]),
        .gt4_gtxtxp_out                 (TXP_OUT[4]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt4_txoutclkfabric_out         (gt4_txoutclkfabric_i),
        .gt4_txoutclkpcs_out            (gt4_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt4_txpcsreset_in              (tied_to_ground_i),
        .gt4_txpmareset_in              (tied_to_ground_i),
        .gt4_txresetdone_out            (gt4_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt4_txprbssel_in               (gt4_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT5  (X1Y5)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt5_drpaddr_in                 (gt5_drpaddr_i),
        .gt5_drpdi_in                   (gt5_drpdi_i),
        .gt5_drpdo_out                  (gt5_drpdo_i),
        .gt5_drpen_in                   (gt5_drpen_i),
        .gt5_drprdy_out                 (gt5_drprdy_i),
        .gt5_drpwe_in                   (gt5_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt5_dmonitorout_out            (gt5_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt5_loopback_in                (gt5_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt5_eyescanreset_in            (tied_to_ground_i),
        .gt5_rxuserrdy_in               (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt5_eyescandataerror_out       (gt5_eyescandataerror_i),
        .gt5_eyescantrigger_in          (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt5_rxdata_out                 (gt5_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt5_rxprbserr_out              (gt5_rxprbserr_i),
        .gt5_rxprbssel_in               (gt5_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt5_rxprbscntreset_in          (gt5_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt5_gtxrxp_in                  (RXP_IN[5]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt5_gtxrxn_in                  (RXN_IN[5]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt5_rxdfelpmreset_in           (tied_to_ground_i),
        .gt5_rxmonitorout_out           (gt5_rxmonitorout_i),
        .gt5_rxmonitorsel_in            (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt5_rxoutclkfabric_out         (gt5_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt5_gtrxreset_in               (tied_to_ground_i),
        .gt5_rxpcsreset_in              (tied_to_ground_i),
        .gt5_rxpmareset_in              (gt5_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt5_rxresetdone_out            (gt5_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt5_gttxreset_in               (tied_to_ground_i),
        .gt5_txuserrdy_in               (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt5_txprbsforceerr_in          (gt5_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt5_txdata_in                  (gt5_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt5_gtxtxn_out                 (TXN_OUT[5]),
        .gt5_gtxtxp_out                 (TXP_OUT[5]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt5_txoutclkfabric_out         (gt5_txoutclkfabric_i),
        .gt5_txoutclkpcs_out            (gt5_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt5_txpcsreset_in              (tied_to_ground_i),
        .gt5_txpmareset_in              (tied_to_ground_i),
        .gt5_txresetdone_out            (gt5_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt5_txprbssel_in               (gt5_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT6  (X1Y6)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt6_drpaddr_in                 (gt6_drpaddr_i),
        .gt6_drpdi_in                   (gt6_drpdi_i),
        .gt6_drpdo_out                  (gt6_drpdo_i),
        .gt6_drpen_in                   (gt6_drpen_i),
        .gt6_drprdy_out                 (gt6_drprdy_i),
        .gt6_drpwe_in                   (gt6_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt6_dmonitorout_out            (gt6_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt6_loopback_in                (gt6_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt6_eyescanreset_in            (tied_to_ground_i),
        .gt6_rxuserrdy_in               (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt6_eyescandataerror_out       (gt6_eyescandataerror_i),
        .gt6_eyescantrigger_in          (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt6_rxdata_out                 (gt6_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt6_rxprbserr_out              (gt6_rxprbserr_i),
        .gt6_rxprbssel_in               (gt6_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt6_rxprbscntreset_in          (gt6_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt6_gtxrxp_in                  (RXP_IN[6]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt6_gtxrxn_in                  (RXN_IN[6]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt6_rxdfelpmreset_in           (tied_to_ground_i),
        .gt6_rxmonitorout_out           (gt6_rxmonitorout_i),
        .gt6_rxmonitorsel_in            (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt6_rxoutclkfabric_out         (gt6_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt6_gtrxreset_in               (tied_to_ground_i),
        .gt6_rxpcsreset_in              (tied_to_ground_i),
        .gt6_rxpmareset_in              (gt6_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt6_rxresetdone_out            (gt6_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt6_gttxreset_in               (tied_to_ground_i),
        .gt6_txuserrdy_in               (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt6_txprbsforceerr_in          (gt6_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt6_txdata_in                  (gt6_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt6_gtxtxn_out                 (TXN_OUT[6]),
        .gt6_gtxtxp_out                 (TXP_OUT[6]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt6_txoutclkfabric_out         (gt6_txoutclkfabric_i),
        .gt6_txoutclkpcs_out            (gt6_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt6_txpcsreset_in              (tied_to_ground_i),
        .gt6_txpmareset_in              (tied_to_ground_i),
        .gt6_txresetdone_out            (gt6_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt6_txprbssel_in               (gt6_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT7  (X1Y7)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt7_drpaddr_in                 (gt7_drpaddr_i),
        .gt7_drpdi_in                   (gt7_drpdi_i),
        .gt7_drpdo_out                  (gt7_drpdo_i),
        .gt7_drpen_in                   (gt7_drpen_i),
        .gt7_drprdy_out                 (gt7_drprdy_i),
        .gt7_drpwe_in                   (gt7_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt7_dmonitorout_out            (gt7_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt7_loopback_in                (gt7_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt7_eyescanreset_in            (tied_to_ground_i),
        .gt7_rxuserrdy_in               (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt7_eyescandataerror_out       (gt7_eyescandataerror_i),
        .gt7_eyescantrigger_in          (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt7_rxdata_out                 (gt7_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt7_rxprbserr_out              (gt7_rxprbserr_i),
        .gt7_rxprbssel_in               (gt7_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt7_rxprbscntreset_in          (gt7_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt7_gtxrxp_in                  (RXP_IN[7]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt7_gtxrxn_in                  (RXN_IN[7]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt7_rxdfelpmreset_in           (tied_to_ground_i),
        .gt7_rxmonitorout_out           (gt7_rxmonitorout_i),
        .gt7_rxmonitorsel_in            (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt7_rxoutclkfabric_out         (gt7_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt7_gtrxreset_in               (tied_to_ground_i),
        .gt7_rxpcsreset_in              (tied_to_ground_i),
        .gt7_rxpmareset_in              (gt7_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt7_rxresetdone_out            (gt7_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt7_gttxreset_in               (tied_to_ground_i),
        .gt7_txuserrdy_in               (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt7_txprbsforceerr_in          (gt7_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt7_txdata_in                  (gt7_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt7_gtxtxn_out                 (TXN_OUT[7]),
        .gt7_gtxtxp_out                 (TXP_OUT[7]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt7_txoutclkfabric_out         (gt7_txoutclkfabric_i),
        .gt7_txoutclkpcs_out            (gt7_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt7_txpcsreset_in              (tied_to_ground_i),
        .gt7_txpmareset_in              (tied_to_ground_i),
        .gt7_txresetdone_out            (gt7_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt7_txprbssel_in               (gt7_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT8  (X1Y8)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt8_drpaddr_in                 (gt8_drpaddr_i),
        .gt8_drpdi_in                   (gt8_drpdi_i),
        .gt8_drpdo_out                  (gt8_drpdo_i),
        .gt8_drpen_in                   (gt8_drpen_i),
        .gt8_drprdy_out                 (gt8_drprdy_i),
        .gt8_drpwe_in                   (gt8_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt8_dmonitorout_out            (gt8_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt8_loopback_in                (gt8_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt8_eyescanreset_in            (tied_to_ground_i),
        .gt8_rxuserrdy_in               (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt8_eyescandataerror_out       (gt8_eyescandataerror_i),
        .gt8_eyescantrigger_in          (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt8_rxdata_out                 (gt8_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt8_rxprbserr_out              (gt8_rxprbserr_i),
        .gt8_rxprbssel_in               (gt8_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt8_rxprbscntreset_in          (gt8_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt8_gtxrxp_in                  (RXP_IN[8]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt8_gtxrxn_in                  (RXN_IN[8]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt8_rxdfelpmreset_in           (tied_to_ground_i),
        .gt8_rxmonitorout_out           (gt8_rxmonitorout_i),
        .gt8_rxmonitorsel_in            (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt8_rxoutclkfabric_out         (gt8_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt8_gtrxreset_in               (tied_to_ground_i),
        .gt8_rxpcsreset_in              (tied_to_ground_i),
        .gt8_rxpmareset_in              (gt8_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt8_rxresetdone_out            (gt8_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt8_gttxreset_in               (tied_to_ground_i),
        .gt8_txuserrdy_in               (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt8_txprbsforceerr_in          (gt8_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt8_txdata_in                  (gt8_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt8_gtxtxn_out                 (TXN_OUT[8]),
        .gt8_gtxtxp_out                 (TXP_OUT[8]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt8_txoutclkfabric_out         (gt8_txoutclkfabric_i),
        .gt8_txoutclkpcs_out            (gt8_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt8_txpcsreset_in              (tied_to_ground_i),
        .gt8_txpmareset_in              (tied_to_ground_i),
        .gt8_txresetdone_out            (gt8_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt8_txprbssel_in               (gt8_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT9  (X1Y9)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt9_drpaddr_in                 (gt9_drpaddr_i),
        .gt9_drpdi_in                   (gt9_drpdi_i),
        .gt9_drpdo_out                  (gt9_drpdo_i),
        .gt9_drpen_in                   (gt9_drpen_i),
        .gt9_drprdy_out                 (gt9_drprdy_i),
        .gt9_drpwe_in                   (gt9_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt9_dmonitorout_out            (gt9_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt9_loopback_in                (gt9_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt9_eyescanreset_in            (tied_to_ground_i),
        .gt9_rxuserrdy_in               (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt9_eyescandataerror_out       (gt9_eyescandataerror_i),
        .gt9_eyescantrigger_in          (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt9_rxdata_out                 (gt9_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt9_rxprbserr_out              (gt9_rxprbserr_i),
        .gt9_rxprbssel_in               (gt9_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt9_rxprbscntreset_in          (gt9_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt9_gtxrxp_in                  (RXP_IN[9]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt9_gtxrxn_in                  (RXN_IN[9]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt9_rxdfelpmreset_in           (tied_to_ground_i),
        .gt9_rxmonitorout_out           (gt9_rxmonitorout_i),
        .gt9_rxmonitorsel_in            (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt9_rxoutclkfabric_out         (gt9_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt9_gtrxreset_in               (tied_to_ground_i),
        .gt9_rxpcsreset_in              (tied_to_ground_i),
        .gt9_rxpmareset_in              (gt9_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt9_rxresetdone_out            (gt9_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt9_gttxreset_in               (tied_to_ground_i),
        .gt9_txuserrdy_in               (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt9_txprbsforceerr_in          (gt9_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt9_txdata_in                  (gt9_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt9_gtxtxn_out                 (TXN_OUT[9]),
        .gt9_gtxtxp_out                 (TXP_OUT[9]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt9_txoutclkfabric_out         (gt9_txoutclkfabric_i),
        .gt9_txoutclkpcs_out            (gt9_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt9_txpcsreset_in              (tied_to_ground_i),
        .gt9_txpmareset_in              (tied_to_ground_i),
        .gt9_txresetdone_out            (gt9_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt9_txprbssel_in               (gt9_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT10  (X1Y10)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt10_drpaddr_in                (gt10_drpaddr_i),
        .gt10_drpdi_in                  (gt10_drpdi_i),
        .gt10_drpdo_out                 (gt10_drpdo_i),
        .gt10_drpen_in                  (gt10_drpen_i),
        .gt10_drprdy_out                (gt10_drprdy_i),
        .gt10_drpwe_in                  (gt10_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt10_dmonitorout_out           (gt10_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt10_loopback_in               (gt10_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt10_eyescanreset_in           (tied_to_ground_i),
        .gt10_rxuserrdy_in              (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt10_eyescandataerror_out      (gt10_eyescandataerror_i),
        .gt10_eyescantrigger_in         (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt10_rxdata_out                (gt10_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt10_rxprbserr_out             (gt10_rxprbserr_i),
        .gt10_rxprbssel_in              (gt10_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt10_rxprbscntreset_in         (gt10_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt10_gtxrxp_in                 (RXP_IN[10]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt10_gtxrxn_in                 (RXN_IN[10]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt10_rxdfelpmreset_in          (tied_to_ground_i),
        .gt10_rxmonitorout_out          (gt10_rxmonitorout_i),
        .gt10_rxmonitorsel_in           (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt10_rxoutclkfabric_out        (gt10_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt10_gtrxreset_in              (tied_to_ground_i),
        .gt10_rxpcsreset_in             (tied_to_ground_i),
        .gt10_rxpmareset_in             (gt10_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt10_rxresetdone_out           (gt10_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt10_gttxreset_in              (tied_to_ground_i),
        .gt10_txuserrdy_in              (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt10_txprbsforceerr_in         (gt10_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt10_txdata_in                 (gt10_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt10_gtxtxn_out                (TXN_OUT[10]),
        .gt10_gtxtxp_out                (TXP_OUT[10]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt10_txoutclkfabric_out        (gt10_txoutclkfabric_i),
        .gt10_txoutclkpcs_out           (gt10_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt10_txpcsreset_in             (tied_to_ground_i),
        .gt10_txpmareset_in             (tied_to_ground_i),
        .gt10_txresetdone_out           (gt10_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt10_txprbssel_in              (gt10_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT11  (X1Y11)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt11_drpaddr_in                (gt11_drpaddr_i),
        .gt11_drpdi_in                  (gt11_drpdi_i),
        .gt11_drpdo_out                 (gt11_drpdo_i),
        .gt11_drpen_in                  (gt11_drpen_i),
        .gt11_drprdy_out                (gt11_drprdy_i),
        .gt11_drpwe_in                  (gt11_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt11_dmonitorout_out           (gt11_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt11_loopback_in               (gt11_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt11_eyescanreset_in           (tied_to_ground_i),
        .gt11_rxuserrdy_in              (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt11_eyescandataerror_out      (gt11_eyescandataerror_i),
        .gt11_eyescantrigger_in         (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt11_rxdata_out                (gt11_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt11_rxprbserr_out             (gt11_rxprbserr_i),
        .gt11_rxprbssel_in              (gt11_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt11_rxprbscntreset_in         (gt11_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt11_gtxrxp_in                 (RXP_IN[11]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt11_gtxrxn_in                 (RXN_IN[11]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt11_rxdfelpmreset_in          (tied_to_ground_i),
        .gt11_rxmonitorout_out          (gt11_rxmonitorout_i),
        .gt11_rxmonitorsel_in           (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt11_rxoutclkfabric_out        (gt11_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt11_gtrxreset_in              (tied_to_ground_i),
        .gt11_rxpcsreset_in             (tied_to_ground_i),
        .gt11_rxpmareset_in             (gt11_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt11_rxresetdone_out           (gt11_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt11_gttxreset_in              (tied_to_ground_i),
        .gt11_txuserrdy_in              (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt11_txprbsforceerr_in         (gt11_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt11_txdata_in                 (gt11_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt11_gtxtxn_out                (TXN_OUT[11]),
        .gt11_gtxtxp_out                (TXP_OUT[11]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt11_txoutclkfabric_out        (gt11_txoutclkfabric_i),
        .gt11_txoutclkpcs_out           (gt11_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt11_txpcsreset_in             (tied_to_ground_i),
        .gt11_txpmareset_in             (tied_to_ground_i),
        .gt11_txresetdone_out           (gt11_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt11_txprbssel_in              (gt11_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT12  (X1Y12)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt12_drpaddr_in                (gt12_drpaddr_i),
        .gt12_drpdi_in                  (gt12_drpdi_i),
        .gt12_drpdo_out                 (gt12_drpdo_i),
        .gt12_drpen_in                  (gt12_drpen_i),
        .gt12_drprdy_out                (gt12_drprdy_i),
        .gt12_drpwe_in                  (gt12_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt12_dmonitorout_out           (gt12_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt12_loopback_in               (gt12_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt12_eyescanreset_in           (tied_to_ground_i),
        .gt12_rxuserrdy_in              (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt12_eyescandataerror_out      (gt12_eyescandataerror_i),
        .gt12_eyescantrigger_in         (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt12_rxdata_out                (gt12_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt12_rxprbserr_out             (gt12_rxprbserr_i),
        .gt12_rxprbssel_in              (gt12_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt12_rxprbscntreset_in         (gt12_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt12_gtxrxp_in                 (RXP_IN[12]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt12_gtxrxn_in                 (RXN_IN[12]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt12_rxdfelpmreset_in          (tied_to_ground_i),
        .gt12_rxmonitorout_out          (gt12_rxmonitorout_i),
        .gt12_rxmonitorsel_in           (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt12_rxoutclkfabric_out        (gt12_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt12_gtrxreset_in              (tied_to_ground_i),
        .gt12_rxpcsreset_in             (tied_to_ground_i),
        .gt12_rxpmareset_in             (gt12_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt12_rxresetdone_out           (gt12_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt12_gttxreset_in              (tied_to_ground_i),
        .gt12_txuserrdy_in              (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt12_txprbsforceerr_in         (gt12_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt12_txdata_in                 (gt12_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt12_gtxtxn_out                (TXN_OUT[12]),
        .gt12_gtxtxp_out                (TXP_OUT[12]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt12_txoutclkfabric_out        (gt12_txoutclkfabric_i),
        .gt12_txoutclkpcs_out           (gt12_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt12_txpcsreset_in             (tied_to_ground_i),
        .gt12_txpmareset_in             (tied_to_ground_i),
        .gt12_txresetdone_out           (gt12_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt12_txprbssel_in              (gt12_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT13  (X1Y13)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt13_drpaddr_in                (gt13_drpaddr_i),
        .gt13_drpdi_in                  (gt13_drpdi_i),
        .gt13_drpdo_out                 (gt13_drpdo_i),
        .gt13_drpen_in                  (gt13_drpen_i),
        .gt13_drprdy_out                (gt13_drprdy_i),
        .gt13_drpwe_in                  (gt13_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt13_dmonitorout_out           (gt13_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt13_loopback_in               (gt13_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt13_eyescanreset_in           (tied_to_ground_i),
        .gt13_rxuserrdy_in              (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt13_eyescandataerror_out      (gt13_eyescandataerror_i),
        .gt13_eyescantrigger_in         (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt13_rxdata_out                (gt13_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt13_rxprbserr_out             (gt13_rxprbserr_i),
        .gt13_rxprbssel_in              (gt13_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt13_rxprbscntreset_in         (gt13_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt13_gtxrxp_in                 (RXP_IN[13]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt13_gtxrxn_in                 (RXN_IN[13]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt13_rxdfelpmreset_in          (tied_to_ground_i),
        .gt13_rxmonitorout_out          (gt13_rxmonitorout_i),
        .gt13_rxmonitorsel_in           (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt13_rxoutclkfabric_out        (gt13_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt13_gtrxreset_in              (tied_to_ground_i),
        .gt13_rxpcsreset_in             (tied_to_ground_i),
        .gt13_rxpmareset_in             (gt13_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt13_rxresetdone_out           (gt13_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt13_gttxreset_in              (tied_to_ground_i),
        .gt13_txuserrdy_in              (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt13_txprbsforceerr_in         (gt13_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt13_txdata_in                 (gt13_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt13_gtxtxn_out                (TXN_OUT[13]),
        .gt13_gtxtxp_out                (TXP_OUT[13]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt13_txoutclkfabric_out        (gt13_txoutclkfabric_i),
        .gt13_txoutclkpcs_out           (gt13_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt13_txpcsreset_in             (tied_to_ground_i),
        .gt13_txpmareset_in             (tied_to_ground_i),
        .gt13_txresetdone_out           (gt13_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt13_txprbssel_in              (gt13_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT14  (X1Y14)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt14_drpaddr_in                (gt14_drpaddr_i),
        .gt14_drpdi_in                  (gt14_drpdi_i),
        .gt14_drpdo_out                 (gt14_drpdo_i),
        .gt14_drpen_in                  (gt14_drpen_i),
        .gt14_drprdy_out                (gt14_drprdy_i),
        .gt14_drpwe_in                  (gt14_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt14_dmonitorout_out           (gt14_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt14_loopback_in               (gt14_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt14_eyescanreset_in           (tied_to_ground_i),
        .gt14_rxuserrdy_in              (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt14_eyescandataerror_out      (gt14_eyescandataerror_i),
        .gt14_eyescantrigger_in         (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt14_rxdata_out                (gt14_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt14_rxprbserr_out             (gt14_rxprbserr_i),
        .gt14_rxprbssel_in              (gt14_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt14_rxprbscntreset_in         (gt14_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt14_gtxrxp_in                 (RXP_IN[14]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt14_gtxrxn_in                 (RXN_IN[14]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt14_rxdfelpmreset_in          (tied_to_ground_i),
        .gt14_rxmonitorout_out          (gt14_rxmonitorout_i),
        .gt14_rxmonitorsel_in           (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt14_rxoutclkfabric_out        (gt14_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt14_gtrxreset_in              (tied_to_ground_i),
        .gt14_rxpcsreset_in             (tied_to_ground_i),
        .gt14_rxpmareset_in             (gt14_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt14_rxresetdone_out           (gt14_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt14_gttxreset_in              (tied_to_ground_i),
        .gt14_txuserrdy_in              (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt14_txprbsforceerr_in         (gt14_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt14_txdata_in                 (gt14_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt14_gtxtxn_out                (TXN_OUT[14]),
        .gt14_gtxtxp_out                (TXP_OUT[14]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt14_txoutclkfabric_out        (gt14_txoutclkfabric_i),
        .gt14_txoutclkpcs_out           (gt14_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt14_txpcsreset_in             (tied_to_ground_i),
        .gt14_txpmareset_in             (tied_to_ground_i),
        .gt14_txresetdone_out           (gt14_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt14_txprbssel_in              (gt14_txprbssel_i),



        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT15  (X1Y15)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt15_drpaddr_in                (gt15_drpaddr_i),
        .gt15_drpdi_in                  (gt15_drpdi_i),
        .gt15_drpdo_out                 (gt15_drpdo_i),
        .gt15_drpen_in                  (gt15_drpen_i),
        .gt15_drprdy_out                (gt15_drprdy_i),
        .gt15_drpwe_in                  (gt15_drpwe_i),
        //------------------------- Digital Monitor Ports --------------------------
        .gt15_dmonitorout_out           (gt15_dmonitorout_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt15_loopback_in               (gt15_loopback_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt15_eyescanreset_in           (tied_to_ground_i),
        .gt15_rxuserrdy_in              (tied_to_vcc_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt15_eyescandataerror_out      (gt15_eyescandataerror_i),
        .gt15_eyescantrigger_in         (tied_to_ground_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt15_rxdata_out                (gt15_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt15_rxprbserr_out             (gt15_rxprbserr_i),
        .gt15_rxprbssel_in              (gt15_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt15_rxprbscntreset_in         (gt15_rxprbscntreset_i),
        //------------------------- Receive Ports - RX AFE -------------------------
        .gt15_gtxrxp_in                 (RXP_IN[15]),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt15_gtxrxn_in                 (RXN_IN[15]),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt15_rxdfelpmreset_in          (tied_to_ground_i),
        .gt15_rxmonitorout_out          (gt15_rxmonitorout_i),
        .gt15_rxmonitorsel_in           (2'b00),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt15_rxoutclkfabric_out        (gt15_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt15_gtrxreset_in              (tied_to_ground_i),
        .gt15_rxpcsreset_in             (tied_to_ground_i),
        .gt15_rxpmareset_in             (gt15_rxpmareset_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt15_rxresetdone_out           (gt15_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt15_gttxreset_in              (tied_to_ground_i),
        .gt15_txuserrdy_in              (tied_to_vcc_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt15_txprbsforceerr_in         (gt15_txprbsforceerr_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt15_txdata_in                 (gt15_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt15_gtxtxn_out                (TXN_OUT[15]),
        .gt15_gtxtxp_out                (TXP_OUT[15]),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt15_txoutclkfabric_out        (gt15_txoutclkfabric_i),
        .gt15_txoutclkpcs_out           (gt15_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt15_txpcsreset_in             (tied_to_ground_i),
        .gt15_txpmareset_in             (tied_to_ground_i),
        .gt15_txresetdone_out           (gt15_txresetdone_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt15_txprbssel_in              (gt15_txprbssel_i),


		//____________________________COMMON PORTS________________________________
		.gt0_qplllock_out(),
		.gt0_qpllrefclklost_out(),
		.gt0_qplloutclk_out(),
		.gt0_qplloutrefclk_out(),
		.gt1_qplllock_out(),
		.gt1_qpllrefclklost_out(),
		.gt1_qplloutclk_out(),
		.gt1_qplloutrefclk_out(),
		.gt2_qplllock_out(),
		.gt2_qpllrefclklost_out(),
		.gt2_qplloutclk_out(),
		.gt2_qplloutrefclk_out(),
		.gt3_qplllock_out(),
		.gt3_qpllrefclklost_out(),
		.gt3_qplloutclk_out(),
		.gt3_qplloutrefclk_out(),
		.sysclk_in(drpclk_in_i)
    );

    BUFG DRP_CLK_BUFG
    (
        .I                              (clk_100M),
        .O                              (drpclk_in_i) 
    );

 
    //***********************************************************************//
    //                                                                       //
    //--------------------------- User Module Resets-------------------------//
    //                                                                       //
    //***********************************************************************//
    // All the User Modules i.e. FRAME_GEN, FRAME_CHECK and the sync modules
    // are held in reset till the RESETDONE goes high. 
    // The RESETDONE is registered a couple of times on *USRCLK2 and connected 
    // to the reset of the modules
    
always @(posedge gt0_rxusrclk2_i or negedge gt0_rxresetdone_i)

    begin
        if (!gt0_rxresetdone_i)
        begin
            gt0_rxresetdone_r    <=   `DLY 1'b0;
            gt0_rxresetdone_r2   <=   `DLY 1'b0;
            gt0_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_rxresetdone_r    <=   `DLY gt0_rxresetdone_i;
            gt0_rxresetdone_r2   <=   `DLY gt0_rxresetdone_r;
            gt0_rxresetdone_r3   <=   `DLY gt0_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt0_txusrclk2_i or negedge gt0_txfsmresetdone_i)

    begin
        if (!gt0_txfsmresetdone_i)
        begin
            gt0_txfsmresetdone_r    <=   `DLY 1'b0;
            gt0_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_txfsmresetdone_r    <=   `DLY gt0_txfsmresetdone_i;
            gt0_txfsmresetdone_r2   <=   `DLY gt0_txfsmresetdone_r;
        end
    end

always @(posedge gt1_rxusrclk2_i or negedge gt1_rxresetdone_i)

    begin
        if (!gt1_rxresetdone_i)
        begin
            gt1_rxresetdone_r    <=   `DLY 1'b0;
            gt1_rxresetdone_r2   <=   `DLY 1'b0;
            gt1_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt1_rxresetdone_r    <=   `DLY gt1_rxresetdone_i;
            gt1_rxresetdone_r2   <=   `DLY gt1_rxresetdone_r;
            gt1_rxresetdone_r3   <=   `DLY gt1_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt1_txusrclk2_i or negedge gt1_txfsmresetdone_i)

    begin
        if (!gt1_txfsmresetdone_i)
        begin
            gt1_txfsmresetdone_r    <=   `DLY 1'b0;
            gt1_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt1_txfsmresetdone_r    <=   `DLY gt1_txfsmresetdone_i;
            gt1_txfsmresetdone_r2   <=   `DLY gt1_txfsmresetdone_r;
        end
    end

always @(posedge gt2_rxusrclk2_i or negedge gt2_rxresetdone_i)

    begin
        if (!gt2_rxresetdone_i)
        begin
            gt2_rxresetdone_r    <=   `DLY 1'b0;
            gt2_rxresetdone_r2   <=   `DLY 1'b0;
            gt2_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt2_rxresetdone_r    <=   `DLY gt2_rxresetdone_i;
            gt2_rxresetdone_r2   <=   `DLY gt2_rxresetdone_r;
            gt2_rxresetdone_r3   <=   `DLY gt2_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt2_txusrclk2_i or negedge gt2_txfsmresetdone_i)

    begin
        if (!gt2_txfsmresetdone_i)
        begin
            gt2_txfsmresetdone_r    <=   `DLY 1'b0;
            gt2_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt2_txfsmresetdone_r    <=   `DLY gt2_txfsmresetdone_i;
            gt2_txfsmresetdone_r2   <=   `DLY gt2_txfsmresetdone_r;
        end
    end

always @(posedge gt3_rxusrclk2_i or negedge gt3_rxresetdone_i)

    begin
        if (!gt3_rxresetdone_i)
        begin
            gt3_rxresetdone_r    <=   `DLY 1'b0;
            gt3_rxresetdone_r2   <=   `DLY 1'b0;
            gt3_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt3_rxresetdone_r    <=   `DLY gt3_rxresetdone_i;
            gt3_rxresetdone_r2   <=   `DLY gt3_rxresetdone_r;
            gt3_rxresetdone_r3   <=   `DLY gt3_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt3_txusrclk2_i or negedge gt3_txfsmresetdone_i)

    begin
        if (!gt3_txfsmresetdone_i)
        begin
            gt3_txfsmresetdone_r    <=   `DLY 1'b0;
            gt3_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt3_txfsmresetdone_r    <=   `DLY gt3_txfsmresetdone_i;
            gt3_txfsmresetdone_r2   <=   `DLY gt3_txfsmresetdone_r;
        end
    end

always @(posedge gt4_rxusrclk2_i or negedge gt4_rxresetdone_i)

    begin
        if (!gt4_rxresetdone_i)
        begin
            gt4_rxresetdone_r    <=   `DLY 1'b0;
            gt4_rxresetdone_r2   <=   `DLY 1'b0;
            gt4_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt4_rxresetdone_r    <=   `DLY gt4_rxresetdone_i;
            gt4_rxresetdone_r2   <=   `DLY gt4_rxresetdone_r;
            gt4_rxresetdone_r3   <=   `DLY gt4_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt4_txusrclk2_i or negedge gt4_txfsmresetdone_i)

    begin
        if (!gt4_txfsmresetdone_i)
        begin
            gt4_txfsmresetdone_r    <=   `DLY 1'b0;
            gt4_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt4_txfsmresetdone_r    <=   `DLY gt4_txfsmresetdone_i;
            gt4_txfsmresetdone_r2   <=   `DLY gt4_txfsmresetdone_r;
        end
    end

always @(posedge gt5_rxusrclk2_i or negedge gt5_rxresetdone_i)

    begin
        if (!gt5_rxresetdone_i)
        begin
            gt5_rxresetdone_r    <=   `DLY 1'b0;
            gt5_rxresetdone_r2   <=   `DLY 1'b0;
            gt5_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt5_rxresetdone_r    <=   `DLY gt5_rxresetdone_i;
            gt5_rxresetdone_r2   <=   `DLY gt5_rxresetdone_r;
            gt5_rxresetdone_r3   <=   `DLY gt5_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt5_txusrclk2_i or negedge gt5_txfsmresetdone_i)

    begin
        if (!gt5_txfsmresetdone_i)
        begin
            gt5_txfsmresetdone_r    <=   `DLY 1'b0;
            gt5_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt5_txfsmresetdone_r    <=   `DLY gt5_txfsmresetdone_i;
            gt5_txfsmresetdone_r2   <=   `DLY gt5_txfsmresetdone_r;
        end
    end

always @(posedge gt6_rxusrclk2_i or negedge gt6_rxresetdone_i)

    begin
        if (!gt6_rxresetdone_i)
        begin
            gt6_rxresetdone_r    <=   `DLY 1'b0;
            gt6_rxresetdone_r2   <=   `DLY 1'b0;
            gt6_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt6_rxresetdone_r    <=   `DLY gt6_rxresetdone_i;
            gt6_rxresetdone_r2   <=   `DLY gt6_rxresetdone_r;
            gt6_rxresetdone_r3   <=   `DLY gt6_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt6_txusrclk2_i or negedge gt6_txfsmresetdone_i)

    begin
        if (!gt6_txfsmresetdone_i)
        begin
            gt6_txfsmresetdone_r    <=   `DLY 1'b0;
            gt6_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt6_txfsmresetdone_r    <=   `DLY gt6_txfsmresetdone_i;
            gt6_txfsmresetdone_r2   <=   `DLY gt6_txfsmresetdone_r;
        end
    end

always @(posedge gt7_rxusrclk2_i or negedge gt7_rxresetdone_i)

    begin
        if (!gt7_rxresetdone_i)
        begin
            gt7_rxresetdone_r    <=   `DLY 1'b0;
            gt7_rxresetdone_r2   <=   `DLY 1'b0;
            gt7_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt7_rxresetdone_r    <=   `DLY gt7_rxresetdone_i;
            gt7_rxresetdone_r2   <=   `DLY gt7_rxresetdone_r;
            gt7_rxresetdone_r3   <=   `DLY gt7_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt7_txusrclk2_i or negedge gt7_txfsmresetdone_i)

    begin
        if (!gt7_txfsmresetdone_i)
        begin
            gt7_txfsmresetdone_r    <=   `DLY 1'b0;
            gt7_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt7_txfsmresetdone_r    <=   `DLY gt7_txfsmresetdone_i;
            gt7_txfsmresetdone_r2   <=   `DLY gt7_txfsmresetdone_r;
        end
    end

always @(posedge gt8_rxusrclk2_i or negedge gt8_rxresetdone_i)

    begin
        if (!gt8_rxresetdone_i)
        begin
            gt8_rxresetdone_r    <=   `DLY 1'b0;
            gt8_rxresetdone_r2   <=   `DLY 1'b0;
            gt8_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt8_rxresetdone_r    <=   `DLY gt8_rxresetdone_i;
            gt8_rxresetdone_r2   <=   `DLY gt8_rxresetdone_r;
            gt8_rxresetdone_r3   <=   `DLY gt8_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt8_txusrclk2_i or negedge gt8_txfsmresetdone_i)

    begin
        if (!gt8_txfsmresetdone_i)
        begin
            gt8_txfsmresetdone_r    <=   `DLY 1'b0;
            gt8_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt8_txfsmresetdone_r    <=   `DLY gt8_txfsmresetdone_i;
            gt8_txfsmresetdone_r2   <=   `DLY gt8_txfsmresetdone_r;
        end
    end

always @(posedge gt9_rxusrclk2_i or negedge gt9_rxresetdone_i)

    begin
        if (!gt9_rxresetdone_i)
        begin
            gt9_rxresetdone_r    <=   `DLY 1'b0;
            gt9_rxresetdone_r2   <=   `DLY 1'b0;
            gt9_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt9_rxresetdone_r    <=   `DLY gt9_rxresetdone_i;
            gt9_rxresetdone_r2   <=   `DLY gt9_rxresetdone_r;
            gt9_rxresetdone_r3   <=   `DLY gt9_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt9_txusrclk2_i or negedge gt9_txfsmresetdone_i)

    begin
        if (!gt9_txfsmresetdone_i)
        begin
            gt9_txfsmresetdone_r    <=   `DLY 1'b0;
            gt9_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt9_txfsmresetdone_r    <=   `DLY gt9_txfsmresetdone_i;
            gt9_txfsmresetdone_r2   <=   `DLY gt9_txfsmresetdone_r;
        end
    end

always @(posedge gt10_rxusrclk2_i or negedge gt10_rxresetdone_i)

    begin
        if (!gt10_rxresetdone_i)
        begin
            gt10_rxresetdone_r    <=   `DLY 1'b0;
            gt10_rxresetdone_r2   <=   `DLY 1'b0;
            gt10_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt10_rxresetdone_r    <=   `DLY gt10_rxresetdone_i;
            gt10_rxresetdone_r2   <=   `DLY gt10_rxresetdone_r;
            gt10_rxresetdone_r3   <=   `DLY gt10_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt10_txusrclk2_i or negedge gt10_txfsmresetdone_i)

    begin
        if (!gt10_txfsmresetdone_i)
        begin
            gt10_txfsmresetdone_r    <=   `DLY 1'b0;
            gt10_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt10_txfsmresetdone_r    <=   `DLY gt10_txfsmresetdone_i;
            gt10_txfsmresetdone_r2   <=   `DLY gt10_txfsmresetdone_r;
        end
    end

always @(posedge gt11_rxusrclk2_i or negedge gt11_rxresetdone_i)

    begin
        if (!gt11_rxresetdone_i)
        begin
            gt11_rxresetdone_r    <=   `DLY 1'b0;
            gt11_rxresetdone_r2   <=   `DLY 1'b0;
            gt11_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt11_rxresetdone_r    <=   `DLY gt11_rxresetdone_i;
            gt11_rxresetdone_r2   <=   `DLY gt11_rxresetdone_r;
            gt11_rxresetdone_r3   <=   `DLY gt11_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt11_txusrclk2_i or negedge gt11_txfsmresetdone_i)

    begin
        if (!gt11_txfsmresetdone_i)
        begin
            gt11_txfsmresetdone_r    <=   `DLY 1'b0;
            gt11_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt11_txfsmresetdone_r    <=   `DLY gt11_txfsmresetdone_i;
            gt11_txfsmresetdone_r2   <=   `DLY gt11_txfsmresetdone_r;
        end
    end

always @(posedge gt12_rxusrclk2_i or negedge gt12_rxresetdone_i)

    begin
        if (!gt12_rxresetdone_i)
        begin
            gt12_rxresetdone_r    <=   `DLY 1'b0;
            gt12_rxresetdone_r2   <=   `DLY 1'b0;
            gt12_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt12_rxresetdone_r    <=   `DLY gt12_rxresetdone_i;
            gt12_rxresetdone_r2   <=   `DLY gt12_rxresetdone_r;
            gt12_rxresetdone_r3   <=   `DLY gt12_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt12_txusrclk2_i or negedge gt12_txfsmresetdone_i)

    begin
        if (!gt12_txfsmresetdone_i)
        begin
            gt12_txfsmresetdone_r    <=   `DLY 1'b0;
            gt12_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt12_txfsmresetdone_r    <=   `DLY gt12_txfsmresetdone_i;
            gt12_txfsmresetdone_r2   <=   `DLY gt12_txfsmresetdone_r;
        end
    end

always @(posedge gt13_rxusrclk2_i or negedge gt13_rxresetdone_i)

    begin
        if (!gt13_rxresetdone_i)
        begin
            gt13_rxresetdone_r    <=   `DLY 1'b0;
            gt13_rxresetdone_r2   <=   `DLY 1'b0;
            gt13_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt13_rxresetdone_r    <=   `DLY gt13_rxresetdone_i;
            gt13_rxresetdone_r2   <=   `DLY gt13_rxresetdone_r;
            gt13_rxresetdone_r3   <=   `DLY gt13_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt13_txusrclk2_i or negedge gt13_txfsmresetdone_i)

    begin
        if (!gt13_txfsmresetdone_i)
        begin
            gt13_txfsmresetdone_r    <=   `DLY 1'b0;
            gt13_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt13_txfsmresetdone_r    <=   `DLY gt13_txfsmresetdone_i;
            gt13_txfsmresetdone_r2   <=   `DLY gt13_txfsmresetdone_r;
        end
    end

always @(posedge gt14_rxusrclk2_i or negedge gt14_rxresetdone_i)

    begin
        if (!gt14_rxresetdone_i)
        begin
            gt14_rxresetdone_r    <=   `DLY 1'b0;
            gt14_rxresetdone_r2   <=   `DLY 1'b0;
            gt14_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt14_rxresetdone_r    <=   `DLY gt14_rxresetdone_i;
            gt14_rxresetdone_r2   <=   `DLY gt14_rxresetdone_r;
            gt14_rxresetdone_r3   <=   `DLY gt14_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt14_txusrclk2_i or negedge gt14_txfsmresetdone_i)

    begin
        if (!gt14_txfsmresetdone_i)
        begin
            gt14_txfsmresetdone_r    <=   `DLY 1'b0;
            gt14_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt14_txfsmresetdone_r    <=   `DLY gt14_txfsmresetdone_i;
            gt14_txfsmresetdone_r2   <=   `DLY gt14_txfsmresetdone_r;
        end
    end

always @(posedge gt15_rxusrclk2_i or negedge gt15_rxresetdone_i)

    begin
        if (!gt15_rxresetdone_i)
        begin
            gt15_rxresetdone_r    <=   `DLY 1'b0;
            gt15_rxresetdone_r2   <=   `DLY 1'b0;
            gt15_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt15_rxresetdone_r    <=   `DLY gt15_rxresetdone_i;
            gt15_rxresetdone_r2   <=   `DLY gt15_rxresetdone_r;
            gt15_rxresetdone_r3   <=   `DLY gt15_rxresetdone_r2;
        end
    end

    
    
always @(posedge  gt15_txusrclk2_i or negedge gt15_txfsmresetdone_i)

    begin
        if (!gt15_txfsmresetdone_i)
        begin
            gt15_txfsmresetdone_r    <=   `DLY 1'b0;
            gt15_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt15_txfsmresetdone_r    <=   `DLY gt15_txfsmresetdone_i;
            gt15_txfsmresetdone_r2   <=   `DLY gt15_txfsmresetdone_r;
        end
    end


//-------------------------------------------------------------------------------------


//-------------------------Debug Signals assignment--------------------

//------------ optional Ports assignments --------------
assign  gt0_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt0_rxprbssel_i                      =  0;
assign  gt0_loopback_i                       =  0;
 //------GTH/GTP
assign  gt0_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt0_rxpmareset_i                     =  tied_to_ground_i;
assign  gt0_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt0_txprbssel_i                      =  0;
assign  gt1_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt1_rxprbssel_i                      =  0;
assign  gt1_loopback_i                       =  0;
 //------GTH/GTP
assign  gt1_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt1_rxpmareset_i                     =  tied_to_ground_i;
assign  gt1_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt1_txprbssel_i                      =  0;
assign  gt2_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt2_rxprbssel_i                      =  0;
assign  gt2_loopback_i                       =  0;
 //------GTH/GTP
assign  gt2_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt2_rxpmareset_i                     =  tied_to_ground_i;
assign  gt2_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt2_txprbssel_i                      =  0;
assign  gt3_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt3_rxprbssel_i                      =  0;
assign  gt3_loopback_i                       =  0;
 //------GTH/GTP
assign  gt3_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt3_rxpmareset_i                     =  tied_to_ground_i;
assign  gt3_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt3_txprbssel_i                      =  0;
assign  gt4_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt4_rxprbssel_i                      =  0;
assign  gt4_loopback_i                       =  0;
 //------GTH/GTP
assign  gt4_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt4_rxpmareset_i                     =  tied_to_ground_i;
assign  gt4_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt4_txprbssel_i                      =  0;
assign  gt5_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt5_rxprbssel_i                      =  0;
assign  gt5_loopback_i                       =  0;
 //------GTH/GTP
assign  gt5_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt5_rxpmareset_i                     =  tied_to_ground_i;
assign  gt5_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt5_txprbssel_i                      =  0;
assign  gt6_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt6_rxprbssel_i                      =  0;
assign  gt6_loopback_i                       =  0;
 //------GTH/GTP
assign  gt6_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt6_rxpmareset_i                     =  tied_to_ground_i;
assign  gt6_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt6_txprbssel_i                      =  0;
assign  gt7_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt7_rxprbssel_i                      =  0;
assign  gt7_loopback_i                       =  0;
 //------GTH/GTP
assign  gt7_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt7_rxpmareset_i                     =  tied_to_ground_i;
assign  gt7_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt7_txprbssel_i                      =  0;
assign  gt8_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt8_rxprbssel_i                      =  0;
assign  gt8_loopback_i                       =  0;
 //------GTH/GTP
assign  gt8_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt8_rxpmareset_i                     =  tied_to_ground_i;
assign  gt8_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt8_txprbssel_i                      =  0;
assign  gt9_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt9_rxprbssel_i                      =  0;
assign  gt9_loopback_i                       =  0;
 //------GTH/GTP
assign  gt9_rxdfelpmreset_i                  =  tied_to_ground_i;
assign  gt9_rxpmareset_i                     =  tied_to_ground_i;
assign  gt9_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt9_txprbssel_i                      =  0;
assign  gt10_rxprbscntreset_i                =  tied_to_ground_i;
assign  gt10_rxprbssel_i                     =  0;
assign  gt10_loopback_i                      =  0;
 //------GTH/GTP
assign  gt10_rxdfelpmreset_i                 =  tied_to_ground_i;
assign  gt10_rxpmareset_i                    =  tied_to_ground_i;
assign  gt10_txprbsforceerr_i                =  tied_to_ground_i;
assign  gt10_txprbssel_i                     =  0;
assign  gt11_rxprbscntreset_i                =  tied_to_ground_i;
assign  gt11_rxprbssel_i                     =  0;
assign  gt11_loopback_i                      =  0;
 //------GTH/GTP
assign  gt11_rxdfelpmreset_i                 =  tied_to_ground_i;
assign  gt11_rxpmareset_i                    =  tied_to_ground_i;
assign  gt11_txprbsforceerr_i                =  tied_to_ground_i;
assign  gt11_txprbssel_i                     =  0;
assign  gt12_rxprbscntreset_i                =  tied_to_ground_i;
assign  gt12_rxprbssel_i                     =  0;
assign  gt12_loopback_i                      =  0;
 //------GTH/GTP
assign  gt12_rxdfelpmreset_i                 =  tied_to_ground_i;
assign  gt12_rxpmareset_i                    =  tied_to_ground_i;
assign  gt12_txprbsforceerr_i                =  tied_to_ground_i;
assign  gt12_txprbssel_i                     =  0;
assign  gt13_rxprbscntreset_i                =  tied_to_ground_i;
assign  gt13_rxprbssel_i                     =  0;
assign  gt13_loopback_i                      =  0;
 //------GTH/GTP
assign  gt13_rxdfelpmreset_i                 =  tied_to_ground_i;
assign  gt13_rxpmareset_i                    =  tied_to_ground_i;
assign  gt13_txprbsforceerr_i                =  tied_to_ground_i;
assign  gt13_txprbssel_i                     =  0;
assign  gt14_rxprbscntreset_i                =  tied_to_ground_i;
assign  gt14_rxprbssel_i                     =  0;
assign  gt14_loopback_i                      =  0;
 //------GTH/GTP
assign  gt14_rxdfelpmreset_i                 =  tied_to_ground_i;
assign  gt14_rxpmareset_i                    =  tied_to_ground_i;
assign  gt14_txprbsforceerr_i                =  tied_to_ground_i;
assign  gt14_txprbssel_i                     =  0;
assign  gt15_rxprbscntreset_i                =  tied_to_ground_i;
assign  gt15_rxprbssel_i                     =  0;
assign  gt15_loopback_i                      =  0;
 //------GTH/GTP
assign  gt15_rxdfelpmreset_i                 =  tied_to_ground_i;
assign  gt15_rxpmareset_i                    =  tied_to_ground_i;
assign  gt15_txprbsforceerr_i                =  tied_to_ground_i;
assign  gt15_txprbssel_i                     =  0;
//------------------------------------------------------
// assign resets for frame_gen modules
assign  gt0_tx_system_reset_c = !gt0_txfsmresetdone_r2;
assign  gt1_tx_system_reset_c = !gt1_txfsmresetdone_r2;
assign  gt2_tx_system_reset_c = !gt2_txfsmresetdone_r2;
assign  gt3_tx_system_reset_c = !gt3_txfsmresetdone_r2;
assign  gt4_tx_system_reset_c = !gt4_txfsmresetdone_r2;
assign  gt5_tx_system_reset_c = !gt5_txfsmresetdone_r2;
assign  gt6_tx_system_reset_c = !gt6_txfsmresetdone_r2;
assign  gt7_tx_system_reset_c = !gt7_txfsmresetdone_r2;
assign  gt8_tx_system_reset_c = !gt8_txfsmresetdone_r2;
assign  gt9_tx_system_reset_c = !gt9_txfsmresetdone_r2;
assign  gt10_tx_system_reset_c = !gt10_txfsmresetdone_r2;
assign  gt11_tx_system_reset_c = !gt11_txfsmresetdone_r2;
assign  gt12_tx_system_reset_c = !gt12_txfsmresetdone_r2;
assign  gt13_tx_system_reset_c = !gt13_txfsmresetdone_r2;
assign  gt14_tx_system_reset_c = !gt14_txfsmresetdone_r2;
assign  gt15_tx_system_reset_c = !gt15_txfsmresetdone_r2;

// assign resets for frame_check modules
assign  gt0_rx_system_reset_c = !gt0_rxresetdone_r3;
assign  gt1_rx_system_reset_c = !gt1_rxresetdone_r3;
assign  gt2_rx_system_reset_c = !gt2_rxresetdone_r3;
assign  gt3_rx_system_reset_c = !gt3_rxresetdone_r3;
assign  gt4_rx_system_reset_c = !gt4_rxresetdone_r3;
assign  gt5_rx_system_reset_c = !gt5_rxresetdone_r3;
assign  gt6_rx_system_reset_c = !gt6_rxresetdone_r3;
assign  gt7_rx_system_reset_c = !gt7_rxresetdone_r3;
assign  gt8_rx_system_reset_c = !gt8_rxresetdone_r3;
assign  gt9_rx_system_reset_c = !gt9_rxresetdone_r3;
assign  gt10_rx_system_reset_c = !gt10_rxresetdone_r3;
assign  gt11_rx_system_reset_c = !gt11_rxresetdone_r3;
assign  gt12_rx_system_reset_c = !gt12_rxresetdone_r3;
assign  gt13_rx_system_reset_c = !gt13_rxresetdone_r3;
assign  gt14_rx_system_reset_c = !gt14_rxresetdone_r3;
assign  gt15_rx_system_reset_c = !gt15_rxresetdone_r3;

assign gt0_drpaddr_i = 9'd0;
assign gt0_drpdi_i = 16'd0;
assign gt0_drpen_i = 1'b0;
assign gt0_drpwe_i = 1'b0;
assign gt1_drpaddr_i = 9'd0;
assign gt1_drpdi_i = 16'd0;
assign gt1_drpen_i = 1'b0;
assign gt1_drpwe_i = 1'b0;
assign gt2_drpaddr_i = 9'd0;
assign gt2_drpdi_i = 16'd0;
assign gt2_drpen_i = 1'b0;
assign gt2_drpwe_i = 1'b0;
assign gt3_drpaddr_i = 9'd0;
assign gt3_drpdi_i = 16'd0;
assign gt3_drpen_i = 1'b0;
assign gt3_drpwe_i = 1'b0;
assign gt4_drpaddr_i = 9'd0;
assign gt4_drpdi_i = 16'd0;
assign gt4_drpen_i = 1'b0;
assign gt4_drpwe_i = 1'b0;
assign gt5_drpaddr_i = 9'd0;
assign gt5_drpdi_i = 16'd0;
assign gt5_drpen_i = 1'b0;
assign gt5_drpwe_i = 1'b0;
assign gt6_drpaddr_i = 9'd0;
assign gt6_drpdi_i = 16'd0;
assign gt6_drpen_i = 1'b0;
assign gt6_drpwe_i = 1'b0;
assign gt7_drpaddr_i = 9'd0;
assign gt7_drpdi_i = 16'd0;
assign gt7_drpen_i = 1'b0;
assign gt7_drpwe_i = 1'b0;
assign gt8_drpaddr_i = 9'd0;
assign gt8_drpdi_i = 16'd0;
assign gt8_drpen_i = 1'b0;
assign gt8_drpwe_i = 1'b0;
assign gt9_drpaddr_i = 9'd0;
assign gt9_drpdi_i = 16'd0;
assign gt9_drpen_i = 1'b0;
assign gt9_drpwe_i = 1'b0;
assign gt10_drpaddr_i = 9'd0;
assign gt10_drpdi_i = 16'd0;
assign gt10_drpen_i = 1'b0;
assign gt10_drpwe_i = 1'b0;
assign gt11_drpaddr_i = 9'd0;
assign gt11_drpdi_i = 16'd0;
assign gt11_drpen_i = 1'b0;
assign gt11_drpwe_i = 1'b0;
assign gt12_drpaddr_i = 9'd0;
assign gt12_drpdi_i = 16'd0;
assign gt12_drpen_i = 1'b0;
assign gt12_drpwe_i = 1'b0;
assign gt13_drpaddr_i = 9'd0;
assign gt13_drpdi_i = 16'd0;
assign gt13_drpen_i = 1'b0;
assign gt13_drpwe_i = 1'b0;
assign gt14_drpaddr_i = 9'd0;
assign gt14_drpdi_i = 16'd0;
assign gt14_drpen_i = 1'b0;
assign gt14_drpwe_i = 1'b0;
assign gt15_drpaddr_i = 9'd0;
assign gt15_drpdi_i = 16'd0;
assign gt15_drpen_i = 1'b0;
assign gt15_drpwe_i = 1'b0;

generate
if (EXAMPLE_USE_CHIPSCOPE==1) 
begin : chipscope
assign soft_reset_i = soft_reset_vio_i;
end //end EXAMPLE_USE_CHIPSCOPE=1 generate section
else 
begin: no_chipscope 
assign soft_reset_i = tied_to_ground_i;
end
endgenerate //End generate for EXAMPLE_USE_CHIPSCOPE
always @(posedge drpclk_in_i or negedge gt0_rxresetdone_i)

    begin
        if (!gt0_rxresetdone_i)
        begin
            gt0_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt0_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt0_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_rxresetdone_vio_r    <=   `DLY gt0_rxresetdone_i;
            gt0_rxresetdone_vio_r2   <=   `DLY gt0_rxresetdone_vio_r;
            gt0_rxresetdone_vio_r3   <=   `DLY gt0_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt1_rxresetdone_i)

    begin
        if (!gt1_rxresetdone_i)
        begin
            gt1_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt1_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt1_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt1_rxresetdone_vio_r    <=   `DLY gt1_rxresetdone_i;
            gt1_rxresetdone_vio_r2   <=   `DLY gt1_rxresetdone_vio_r;
            gt1_rxresetdone_vio_r3   <=   `DLY gt1_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt2_rxresetdone_i)

    begin
        if (!gt2_rxresetdone_i)
        begin
            gt2_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt2_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt2_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt2_rxresetdone_vio_r    <=   `DLY gt2_rxresetdone_i;
            gt2_rxresetdone_vio_r2   <=   `DLY gt2_rxresetdone_vio_r;
            gt2_rxresetdone_vio_r3   <=   `DLY gt2_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt3_rxresetdone_i)

    begin
        if (!gt3_rxresetdone_i)
        begin
            gt3_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt3_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt3_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt3_rxresetdone_vio_r    <=   `DLY gt3_rxresetdone_i;
            gt3_rxresetdone_vio_r2   <=   `DLY gt3_rxresetdone_vio_r;
            gt3_rxresetdone_vio_r3   <=   `DLY gt3_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt4_rxresetdone_i)

    begin
        if (!gt4_rxresetdone_i)
        begin
            gt4_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt4_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt4_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt4_rxresetdone_vio_r    <=   `DLY gt4_rxresetdone_i;
            gt4_rxresetdone_vio_r2   <=   `DLY gt4_rxresetdone_vio_r;
            gt4_rxresetdone_vio_r3   <=   `DLY gt4_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt5_rxresetdone_i)

    begin
        if (!gt5_rxresetdone_i)
        begin
            gt5_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt5_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt5_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt5_rxresetdone_vio_r    <=   `DLY gt5_rxresetdone_i;
            gt5_rxresetdone_vio_r2   <=   `DLY gt5_rxresetdone_vio_r;
            gt5_rxresetdone_vio_r3   <=   `DLY gt5_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt6_rxresetdone_i)

    begin
        if (!gt6_rxresetdone_i)
        begin
            gt6_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt6_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt6_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt6_rxresetdone_vio_r    <=   `DLY gt6_rxresetdone_i;
            gt6_rxresetdone_vio_r2   <=   `DLY gt6_rxresetdone_vio_r;
            gt6_rxresetdone_vio_r3   <=   `DLY gt6_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt7_rxresetdone_i)

    begin
        if (!gt7_rxresetdone_i)
        begin
            gt7_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt7_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt7_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt7_rxresetdone_vio_r    <=   `DLY gt7_rxresetdone_i;
            gt7_rxresetdone_vio_r2   <=   `DLY gt7_rxresetdone_vio_r;
            gt7_rxresetdone_vio_r3   <=   `DLY gt7_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt8_rxresetdone_i)

    begin
        if (!gt8_rxresetdone_i)
        begin
            gt8_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt8_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt8_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt8_rxresetdone_vio_r    <=   `DLY gt8_rxresetdone_i;
            gt8_rxresetdone_vio_r2   <=   `DLY gt8_rxresetdone_vio_r;
            gt8_rxresetdone_vio_r3   <=   `DLY gt8_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt9_rxresetdone_i)

    begin
        if (!gt9_rxresetdone_i)
        begin
            gt9_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt9_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt9_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt9_rxresetdone_vio_r    <=   `DLY gt9_rxresetdone_i;
            gt9_rxresetdone_vio_r2   <=   `DLY gt9_rxresetdone_vio_r;
            gt9_rxresetdone_vio_r3   <=   `DLY gt9_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt10_rxresetdone_i)

    begin
        if (!gt10_rxresetdone_i)
        begin
            gt10_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt10_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt10_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt10_rxresetdone_vio_r    <=   `DLY gt10_rxresetdone_i;
            gt10_rxresetdone_vio_r2   <=   `DLY gt10_rxresetdone_vio_r;
            gt10_rxresetdone_vio_r3   <=   `DLY gt10_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt11_rxresetdone_i)

    begin
        if (!gt11_rxresetdone_i)
        begin
            gt11_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt11_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt11_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt11_rxresetdone_vio_r    <=   `DLY gt11_rxresetdone_i;
            gt11_rxresetdone_vio_r2   <=   `DLY gt11_rxresetdone_vio_r;
            gt11_rxresetdone_vio_r3   <=   `DLY gt11_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt12_rxresetdone_i)

    begin
        if (!gt12_rxresetdone_i)
        begin
            gt12_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt12_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt12_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt12_rxresetdone_vio_r    <=   `DLY gt12_rxresetdone_i;
            gt12_rxresetdone_vio_r2   <=   `DLY gt12_rxresetdone_vio_r;
            gt12_rxresetdone_vio_r3   <=   `DLY gt12_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt13_rxresetdone_i)

    begin
        if (!gt13_rxresetdone_i)
        begin
            gt13_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt13_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt13_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt13_rxresetdone_vio_r    <=   `DLY gt13_rxresetdone_i;
            gt13_rxresetdone_vio_r2   <=   `DLY gt13_rxresetdone_vio_r;
            gt13_rxresetdone_vio_r3   <=   `DLY gt13_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt14_rxresetdone_i)

    begin
        if (!gt14_rxresetdone_i)
        begin
            gt14_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt14_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt14_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt14_rxresetdone_vio_r    <=   `DLY gt14_rxresetdone_i;
            gt14_rxresetdone_vio_r2   <=   `DLY gt14_rxresetdone_vio_r;
            gt14_rxresetdone_vio_r3   <=   `DLY gt14_rxresetdone_vio_r2;
        end
    end

always @(posedge drpclk_in_i or negedge gt15_rxresetdone_i)

    begin
        if (!gt15_rxresetdone_i)
        begin
            gt15_rxresetdone_vio_r    <=   `DLY 1'b0;
            gt15_rxresetdone_vio_r2   <=   `DLY 1'b0;
            gt15_rxresetdone_vio_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt15_rxresetdone_vio_r    <=   `DLY gt15_rxresetdone_i;
            gt15_rxresetdone_vio_r2   <=   `DLY gt15_rxresetdone_vio_r;
            gt15_rxresetdone_vio_r3   <=   `DLY gt15_rxresetdone_vio_r2;
        end
    end

    assign rxresetdone_vio_i = gt0_rxresetdone_vio_r3 
                         & gt1_rxresetdone_vio_r3
                         & gt2_rxresetdone_vio_r3
                         & gt3_rxresetdone_vio_r3
                         & gt4_rxresetdone_vio_r3
                         & gt5_rxresetdone_vio_r3
                         & gt6_rxresetdone_vio_r3
                         & gt7_rxresetdone_vio_r3
                         & gt8_rxresetdone_vio_r3
                         & gt9_rxresetdone_vio_r3
                         & gt10_rxresetdone_vio_r3
                         & gt11_rxresetdone_vio_r3
                         & gt12_rxresetdone_vio_r3
                         & gt13_rxresetdone_vio_r3
                         & gt14_rxresetdone_vio_r3
                         & gt15_rxresetdone_vio_r3
                         ;


// vio core insertion for driving soft_reset_i
vio_0 vio_gt_inst (
  .clk(drpclk_in_i),                // input clk
  .probe_in0(rxresetdone_vio_i),  // output [0 : 0] probe_out0
  .probe_out0(soft_reset_vio_i)  // output [0 : 0] probe_out0
);

assign  gt0_rxdata_ila      = {zero_vector_rx_80,gt0_rxdata_i};

assign gt0_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt0_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt0_rxcharisk_ila = 0; 


assign gt0_txmmcm_lock_ila = tied_to_ground_i;

assign gt0_rxmmcm_lock_ila = tied_to_ground_i;
assign gt0_rxresetdone_ila = gt0_rxresetdone_i;
assign gt0_txresetdone_ila = gt0_txresetdone_i;
assign  gt1_rxdata_ila      = {zero_vector_rx_80,gt1_rxdata_i};

assign gt1_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt1_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt1_rxcharisk_ila = 0; 


assign gt1_txmmcm_lock_ila = tied_to_ground_i;

assign gt1_rxmmcm_lock_ila = tied_to_ground_i;
assign gt1_rxresetdone_ila = gt1_rxresetdone_i;
assign gt1_txresetdone_ila = gt1_txresetdone_i;
assign  gt2_rxdata_ila      = {zero_vector_rx_80,gt2_rxdata_i};

assign gt2_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt2_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt2_rxcharisk_ila = 0; 


assign gt2_txmmcm_lock_ila = tied_to_ground_i;

assign gt2_rxmmcm_lock_ila = tied_to_ground_i;
assign gt2_rxresetdone_ila = gt2_rxresetdone_i;
assign gt2_txresetdone_ila = gt2_txresetdone_i;
assign  gt3_rxdata_ila      = {zero_vector_rx_80,gt3_rxdata_i};

assign gt3_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt3_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt3_rxcharisk_ila = 0; 


assign gt3_txmmcm_lock_ila = tied_to_ground_i;

assign gt3_rxmmcm_lock_ila = tied_to_ground_i;
assign gt3_rxresetdone_ila = gt3_rxresetdone_i;
assign gt3_txresetdone_ila = gt3_txresetdone_i;
assign  gt4_rxdata_ila      = {zero_vector_rx_80,gt4_rxdata_i};

assign gt4_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt4_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt4_rxcharisk_ila = 0; 


assign gt4_txmmcm_lock_ila = tied_to_ground_i;

assign gt4_rxmmcm_lock_ila = tied_to_ground_i;
assign gt4_rxresetdone_ila = gt4_rxresetdone_i;
assign gt4_txresetdone_ila = gt4_txresetdone_i;
assign  gt5_rxdata_ila      = {zero_vector_rx_80,gt5_rxdata_i};

assign gt5_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt5_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt5_rxcharisk_ila = 0; 


assign gt5_txmmcm_lock_ila = tied_to_ground_i;

assign gt5_rxmmcm_lock_ila = tied_to_ground_i;
assign gt5_rxresetdone_ila = gt5_rxresetdone_i;
assign gt5_txresetdone_ila = gt5_txresetdone_i;
assign  gt6_rxdata_ila      = {zero_vector_rx_80,gt6_rxdata_i};

assign gt6_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt6_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt6_rxcharisk_ila = 0; 


assign gt6_txmmcm_lock_ila = tied_to_ground_i;

assign gt6_rxmmcm_lock_ila = tied_to_ground_i;
assign gt6_rxresetdone_ila = gt6_rxresetdone_i;
assign gt6_txresetdone_ila = gt6_txresetdone_i;
assign  gt7_rxdata_ila      = {zero_vector_rx_80,gt7_rxdata_i};

assign gt7_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt7_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt7_rxcharisk_ila = 0; 


assign gt7_txmmcm_lock_ila = tied_to_ground_i;

assign gt7_rxmmcm_lock_ila = tied_to_ground_i;
assign gt7_rxresetdone_ila = gt7_rxresetdone_i;
assign gt7_txresetdone_ila = gt7_txresetdone_i;
assign  gt8_rxdata_ila      = {zero_vector_rx_80,gt8_rxdata_i};

assign gt8_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt8_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt8_rxcharisk_ila = 0; 


assign gt8_txmmcm_lock_ila = tied_to_ground_i;

assign gt8_rxmmcm_lock_ila = tied_to_ground_i;
assign gt8_rxresetdone_ila = gt8_rxresetdone_i;
assign gt8_txresetdone_ila = gt8_txresetdone_i;
assign  gt9_rxdata_ila      = {zero_vector_rx_80,gt9_rxdata_i};

assign gt9_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt9_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt9_rxcharisk_ila = 0; 


assign gt9_txmmcm_lock_ila = tied_to_ground_i;

assign gt9_rxmmcm_lock_ila = tied_to_ground_i;
assign gt9_rxresetdone_ila = gt9_rxresetdone_i;
assign gt9_txresetdone_ila = gt9_txresetdone_i;
assign  gt10_rxdata_ila      = {zero_vector_rx_80,gt10_rxdata_i};

assign gt10_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt10_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt10_rxcharisk_ila = 0; 


assign gt10_txmmcm_lock_ila = tied_to_ground_i;

assign gt10_rxmmcm_lock_ila = tied_to_ground_i;
assign gt10_rxresetdone_ila = gt10_rxresetdone_i;
assign gt10_txresetdone_ila = gt10_txresetdone_i;
assign  gt11_rxdata_ila      = {zero_vector_rx_80,gt11_rxdata_i};

assign gt11_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt11_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt11_rxcharisk_ila = 0; 


assign gt11_txmmcm_lock_ila = tied_to_ground_i;

assign gt11_rxmmcm_lock_ila = tied_to_ground_i;
assign gt11_rxresetdone_ila = gt11_rxresetdone_i;
assign gt11_txresetdone_ila = gt11_txresetdone_i;
assign  gt12_rxdata_ila      = {zero_vector_rx_80,gt12_rxdata_i};

assign gt12_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt12_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt12_rxcharisk_ila = 0; 


assign gt12_txmmcm_lock_ila = tied_to_ground_i;

assign gt12_rxmmcm_lock_ila = tied_to_ground_i;
assign gt12_rxresetdone_ila = gt12_rxresetdone_i;
assign gt12_txresetdone_ila = gt12_txresetdone_i;
assign  gt13_rxdata_ila      = {zero_vector_rx_80,gt13_rxdata_i};

assign gt13_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt13_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt13_rxcharisk_ila = 0; 


assign gt13_txmmcm_lock_ila = tied_to_ground_i;

assign gt13_rxmmcm_lock_ila = tied_to_ground_i;
assign gt13_rxresetdone_ila = gt13_rxresetdone_i;
assign gt13_txresetdone_ila = gt13_txresetdone_i;
assign  gt14_rxdata_ila      = {zero_vector_rx_80,gt14_rxdata_i};

assign gt14_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt14_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt14_rxcharisk_ila = 0; 


assign gt14_txmmcm_lock_ila = tied_to_ground_i;

assign gt14_rxmmcm_lock_ila = tied_to_ground_i;
assign gt14_rxresetdone_ila = gt14_rxresetdone_i;
assign gt14_txresetdone_ila = gt14_txresetdone_i;
assign  gt15_rxdata_ila      = {zero_vector_rx_80,gt15_rxdata_i};

assign gt15_rxdatavalid_ila[0] = tied_to_ground_i; 
assign gt15_rxdatavalid_ila[1] = tied_to_ground_i; 

assign gt15_rxcharisk_ila = 0; 


assign gt15_txmmcm_lock_ila = tied_to_ground_i;

assign gt15_rxmmcm_lock_ila = tied_to_ground_i;
assign gt15_rxresetdone_ila = gt15_rxresetdone_i;
assign gt15_txresetdone_ila = gt15_txresetdone_i;


endmodule
    

