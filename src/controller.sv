// =============================================================
// Controller
// A state machine that decides what happens next.
// It never touches a number: it only looks at "enough" and
// tells the datapath what to do.
//
// Fill in the body below.
// Do NOT change the module name or the port list.
// =============================================================
module controller (
    input  logic clk,
    input  logic rst,
    input  logic enough,    // from datapath
    output logic load,      // to datapath
    output logic clear,     // to datapath
    output logic dispense   // high for exactly one cycle per sale
);

    // your code here

endmodule
