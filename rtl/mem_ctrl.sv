module mem_ctrl import config_pkg::*; #(
) (
    input  logic clk_i,
    input  logic rst_ni,
    output logic led_o
);

assign led_o = 0;

// interal states are retained during disable
// must be high before 1st running cycle
logic sram_enable_n = 0;
// 0 == write and 1 == read
logic sram_write_en_n = 0;
// write bit mask, when bit 6 is 0 then the 6 bit in btye gets updated 
logic sram_write_bit_mask_n = 0;
// addr written to or read from
logic sram_addr = 0;
// data to be written 
logic data_to_write = 0;
// data read
logic data_read = 0;
// power signals
logic vdd, ground = 0;

gf180mcu_fd_ip_sram__sram512x8m8wm1 sram1 (
	.CLK(clk_i),
	.CEN(sram_enable_n), 
	.GWEN(sram_write_en_n),
	.WEN(sram_write_bit_mask_n),
	.A(sram_addr),
	.D(data_to_write),
	.Q(data_read),
	.VDD(vdd),
	.VSS(ground)
);


endmodule

