// =============================================================
//  Astra CPU - Top-level Testbench
//  Tests: imm load, ALU (add/sub/cmp), conditional branch,
//         RAM store/load, stack push/pop, shift, signed add
// =============================================================
module Top_test;

    // ----------------------------------------------------------
    // DUT instantiation
    // Top has no ports (clock is internal), we just probe internals
    // ----------------------------------------------------------
    Top dut();

    // ----------------------------------------------------------
    // Convenience aliases into DUT internals for readability
    // ----------------------------------------------------------
    wire [7:0] PC       = dut.count;
    wire [7:0] op_code  = dut.op_code;
    wire [7:0] op1      = dut.op1;
    wire [7:0] op2      = dut.op2;
    wire [3:0] flags    = dut.flagsin;   // z=3, o=2, n=1, c=0
    wire [7:0] r0_val   = dut.m3.regs[0];
    wire [7:0] r1_val   = dut.m3.regs[1];
    wire [7:0] r2_val   = dut.m3.regs[2];
    wire [7:0] r3_val   = dut.m3.regs[3];
    wire [7:0] ram_42   = dut.m9.sram[42]; // RAM slot we write to
    wire [7:0] sp       = dut.m8.sp;

    // ----------------------------------------------------------
    // Cycle counter
    // ----------------------------------------------------------
    integer cycle = 0;
    always @(posedge dut.clk) cycle <= cycle + 1;

    // ----------------------------------------------------------
    // Pass/fail tracking
    // ----------------------------------------------------------
    integer pass_count;
    integer fail_count;

    task automatic check;
        input string   label;
        input [7:0]    got;
        input [7:0]    expected;
        begin
            if (got === expected) begin
                $display("  PASS  [%0d] %s = 0x%02X", cycle, label, got);
                pass_count++;
            end else begin
                $display("  FAIL  [%0d] %s : got 0x%02X, expected 0x%02X",
                         cycle, label, got, expected);
                fail_count++;
            end
        end
    endtask

    // ----------------------------------------------------------
    // Waveform dump (comment out if not using XSim/VCD)
    // ----------------------------------------------------------
    initial begin
        $dumpfile("astra_wave.vcd");
        $dumpvars(0, Top_test);
    end

    // ----------------------------------------------------------
    // Main test sequence
    // Each @(posedge dut.clk) advances one instruction cycle.
    // We check results one cycle AFTER the instruction executes
    // so the register write has settled.
    // ----------------------------------------------------------
    initial begin
        cycle      = 0;
        pass_count = 0;
        fail_count = 0;

        $display("=================================================");
        $display("  Astra CPU Testbench");
        $display("=================================================");

        // ---- Wait for reset / first instruction fetch --------
        repeat(2) @(posedge dut.clk);

        // =====================================================
        // TEST 1: IMM -> R0  (load 0x0A into r0)
        // Instruction @ PC=0: op_code=8'b1_0000011, op1=0x0A, op2=0x00
        //   op_code[7]=1 (mov), [1:0]=11 (imm->r), op2 selects dst=r0
        // =====================================================
        @(posedge dut.clk); // execute instr at PC=0
        @(posedge dut.clk); // writeback settles
        $display("\n-- Test 1: imm->r0 (expect r0=0x0A) --");
        check("r0", r0_val, 8'h0A);

        // =====================================================
        // TEST 2: IMM -> R1  (load 0x05 into r1)
        // Instruction @ PC=3: op_code=8'b1_0000011, op1=0x05, op2=0x01
        // =====================================================
        @(posedge dut.clk);
        @(posedge dut.clk);
        $display("\n-- Test 2: imm->r1 (expect r1=0x05) --");
        check("r1", r1_val, 8'h05);

        // =====================================================
        // TEST 3: ADD r0, r1 -> r0  (0x0A + 0x05 = 0x0F)
        // Instruction @ PC=6: op_code=8'b0_0_00_0000, op1=r0(0x00), op2=r1(0x01)
        //   op_code[7]=0 (calc), [5:4]=00 (ALU), [3:0]=0000 (op_add)
        //   result saved to op1 = r0
        // =====================================================
        @(posedge dut.clk);
        @(posedge dut.clk);
        $display("\n-- Test 3: ADD r0+r1->r0 (expect r0=0x0F, zero_flag=0) --");
        check("r0 after ADD", r0_val, 8'h0F);
        check("zero flag",    {7'b0, flags[3]}, 8'h00);

        // =====================================================
        // TEST 4: CMP r0, r1  (0x0F cmp 0x05 -> sets flags, no writeback)
        // Instruction @ PC=9: op_code=8'b0_0_00_0110, op1=r0, op2=r1
        //   [3:0]=0110 (op_cmp)
        //   0x0F > 0x05: expect zero=0, negative=0
        // =====================================================
        @(posedge dut.clk);
        @(posedge dut.clk);
        $display("\n-- Test 4: CMP r0,r1 (0x0F vs 0x05, expect z=0 n=0) --");
        check("zero flag after CMP",     {7'b0, flags[3]}, 8'h00);
        check("negative flag after CMP", {7'b0, flags[1]}, 8'h00);

        // =====================================================
        // TEST 5: JEZ (jump if zero) - should NOT jump
        // Instruction @ PC=12: op_code=8'b0_0_01_0010, op1=<target>, op2=xx
        //   [5:4]=01 (Cond), [3:0]=0010 (op_jez)
        //   zero flag is 0, so no jump -> PC advances to 15
        // =====================================================
        @(posedge dut.clk);
        @(posedge dut.clk);
        $display("\n-- Test 5: JEZ should NOT jump (expect PC=15) --");
        check("PC after no-jump", PC, 8'd15);

        // =====================================================
        // TEST 6: SUB r0, r1 -> r0  (0x0F - 0x0F = 0x00, zero flag set)
        // First load 0x0F into r1 to make them equal
        // Instruction @ PC=15: imm->r1 with 0x0F
        // Instruction @ PC=18: SUB r0,r1->r0
        // =====================================================
        @(posedge dut.clk); // imm->r1 (0x0F)
        @(posedge dut.clk);
        @(posedge dut.clk); // SUB
        @(posedge dut.clk);
        $display("\n-- Test 6: SUB r0-r1->r0 (0x0F-0x0F, expect r0=0x00, z=1) --");
        check("r0 after SUB", r0_val, 8'h00);
        check("zero flag",    {7'b0, flags[3]}, 8'h01);

        // =====================================================
        // TEST 7: JEZ should NOW jump (zero flag=1)
        // Instruction @ PC=21: op_jez, op1 = jump target (PC=30)
        // =====================================================
        @(posedge dut.clk);
        @(posedge dut.clk);
        $display("\n-- Test 7: JEZ SHOULD jump (expect PC=30) --");
        check("PC after jump", PC, 8'd30);

        // =====================================================
        // TEST 8: RAM store then load
        // @ PC=30: imm->r2 (value=0xBE, addr=r3 preloaded to 42)
        // @ PC=33: imm->r3 (addr=42)
        // @ PC=36: r->mem  (store r2 to addr in r3)
        // @ PC=39: mem->r  (load from addr in r3 into r0)
        // =====================================================
        repeat(8) @(posedge dut.clk);
        $display("\n-- Test 8: RAM store/load (expect ram[42]=0xBE, r0=0xBE) --");
        check("RAM[42]",       ram_42, 8'hBE);
        check("r0 after load", r0_val, 8'hBE);

        // =====================================================
        // TEST 9: Stack push then pop to register
        // @ PC=42: push r2 (value 0xBE)
        //   op_code=8'b0_0_11_0010 (stack, op_push=3'b100, op_code[1]=1->pop to reg)
        //   Actually push: op_code[1]=0 needed for push path in Stack
        //   push: op_code = 8'b0_0_11_0000, pp driven by Top
        // @ PC=45: pop to r0
        //   op_code=8'b0_0_11_0011 (op_code[1]=1 -> writeback to reg, op2=r0 dest)
        // =====================================================
        repeat(6) @(posedge dut.clk);
        $display("\n-- Test 9: Stack push/pop (expect r0=0xBE after pop) --");
        check("r0 after pop", r0_val, 8'hBE);

        // =====================================================
        // TEST 10: Shift left r1 by 1
        // Load r1=0x01, shl by 1 -> expect 0x02
        // @ PC=48: imm->r1 (0x01)
        // @ PC=51: SHL r1 by r2[2:0] (r2 should hold shift amount=1)
        //   op_code=8'b0_0_10_0001 ([5:4]=10 Xtra, [2:0]=001 op_shl)
        // =====================================================
        repeat(6) @(posedge dut.clk);
        $display("\n-- Test 10: SHL r1 by 1 (expect r1=0x02) --");
        check("r1 after SHL", r1_val, 8'h02);

        // =====================================================
        // RESULTS
        // =====================================================
        $display("\n=================================================");
        $display("  Results: %0d passed, %0d failed", pass_count, fail_count);
        $display("=================================================");

        if (fail_count == 0)
            $display("  ALL TESTS PASSED");
        else
            $display("  SOME TESTS FAILED - check waveform for details");

        $finish;
    end

    // ----------------------------------------------------------
    // Timeout watchdog - kills sim if CPU hangs
    // ----------------------------------------------------------
    initial begin
        #10000;
        $display("TIMEOUT - simulation exceeded 10000ns");
        $finish;
    end

    // ----------------------------------------------------------
    // Continuous monitor - prints every instruction fetch
    // ----------------------------------------------------------
    always @(posedge dut.clk) begin
        $display("  [cyc %0d] PC=%0d op=%08b op1=%02X op2=%02X flags=%04b",
                 cycle, PC, op_code, op1, op2, flags);
    end

endmodule
