module run_on_board(input CLOCK_50, input [0:0] KEY);
	
    AES_Qsys_generate u0 (
        .clk_clk       (CLOCK_50),       //   clk.clk
        .reset_reset_n (KEY[0])  // reset.reset_n
    );

endmodule 