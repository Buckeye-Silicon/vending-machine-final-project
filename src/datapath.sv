// =============================================================
// Datapath
// Holds the running credit and does all the arithmetic.
// It never decides anything on its own: it only acts when the
// controller tells it to.
//
// Fill in the body below.
// Do NOT change the module name or the port list.
// =============================================================
module datapath (
    input  logic       clk,
    input  logic       rst,
    input  logic [6:0] value,   // coin value from the decoder
    input  logic       load,    // from controller: add value to credit
    input  logic       clear,   // from controller: reset credit to 0
    output logic       enough,  // to controller: credit + value >= 50
    output logic [6:0] change   // credit minus 50
);

    // your code here

endmodule
