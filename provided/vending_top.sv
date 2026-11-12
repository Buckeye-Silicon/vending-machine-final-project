// =============================================================
// PROVIDED FILE. Do not edit. Do not submit.
//
// This top-level module wires your three modules together.
// Read it to see exactly which signals flow between them.
// =============================================================
module vending_top (
    input  logic       clk,
    input  logic       rst,
    input  logic [1:0] coin,
    output logic       dispense,
    output logic [6:0] change
);
    logic [6:0] value;
    logic       enough, load, clear;

    coin_decoder u_dec (
        .coin  (coin),
        .value (value)
    );

    datapath u_dp (
        .clk    (clk),
        .rst    (rst),
        .value  (value),
        .load   (load),
        .clear  (clear),
        .enough (enough),
        .change (change)
    );

    controller u_ctrl (
        .clk      (clk),
        .rst      (rst),
        .enough   (enough),
        .load     (load),
        .clear    (clear),
        .dispense (dispense)
    );
endmodule
