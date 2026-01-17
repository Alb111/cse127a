
module blinky_sim (
    input  logic clk_i,
    input  logic rst_ni,
    output logic led_o
);

blinky #(
    .CyclesPerToggle(100)
) blinky (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .led_o(led_o)
);

endmodule
