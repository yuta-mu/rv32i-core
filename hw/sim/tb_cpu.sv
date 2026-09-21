module tb_cpu;

    logic        clk;
    logic        rst_n;

    logic [31:0] pc;
    logic [31:0] inst;
    logic        mem_read;
    logic        mem_write;
    logic [31:0] mem_addr;
    logic [31:0] mem_wdata;
    logic [31:0] mem_rdata;

    cpu u_cpu (
        .clk       (clk),
        .rst_n     (rst_n),
        .pc        (pc),
        .inst      (inst),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .mem_addr  (mem_addr),
        .mem_wdata (mem_wdata),
        .mem_rdata (mem_rdata)
    );

    logic [31:0] imem [0:1023];
    logic [31:0] dmem [0:1023];

    // Instruction memory read (Combinational / Asynchronous)
    assign inst = imem[pc[11:2]];

    // Data memory read (Combinational)
    assign mem_rdata = mem_read ? dmem[mem_addr[11:2]] : 32'h0;

    // Data memory write (Synchronous)
    always_ff @(posedge clk) begin
        if (mem_write) begin
            dmem[mem_addr[11:2]] <= mem_wdata;
            $display("[MEM WRITE] Addr: 0x%08h | Data: 0x%08h (%0d)", mem_addr, mem_wdata, $signed(mem_wdata));
        end
    end

    // Clock & Reset Generation
    always #5 clk = ~clk;

    // Simulation Monitor & Termination
    integer cycle_count = 0;

    initial begin
        $dumpfile("hw/sim/tb_cpu.vcd");
        $dumpvars(0, tb_cpu);

        // Load test hex file
        if ($test$plusargs("hex")) begin
            string hex_path;
            $value$plusargs("hex=%s", hex_path);
            $readmemh(hex_path, imem);
        end else begin
            // Default program loading
            $readmemh("hw/sim/prog_basic.hex", imem);
        end

        // Reset sequence
        clk   = 0;
        rst_n = 0;
        #25;
        rst_n = 1;
    end

    always @(posedge clk) begin
        if (rst_n) begin
            cycle_count <= cycle_count + 1;

            $display("Cycle %0d | PC: 0x%08h | Inst: 0x%08h", cycle_count, pc, inst);

            // Self-loop detection: program termination
            if (inst == 32'h0000_006f) begin
                $display("--- Program finished cleanly via self-loop ---");
                #20;
                $finish;
            end

            // Timeout safety limit
            if (cycle_count > 1000) begin
                $display("--- Timeout: Reached maximum cycle limit ---");
                $finish;
            end
        end
    end

endmodule