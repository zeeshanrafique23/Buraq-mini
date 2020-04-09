# Buraq-mini-sv

Buraq-mini is a small and efficient, 32-bit, in-order RISC-V core with a 5-stage pipeline that implements the RV32IMC instruction set architecture.  
This processor has a capability to do the basic mathematics calculation like addition, subtraction, multiplication, division and this processor also support all the logical operation as well as logic and arithematic shifts. 

## How to run any assembly code

First clone the repository in your local by running 
```
$ git clone https://github.com/merledu/Buraq-mini-sv.git
```
After cloning change your directory and switch into src by running
```
$ cd Buraq-mini-sv/src/
```
Now you are in the folder where the hex_memory_file.mem is located. You can type ``ls`` command to see the all files.  
Now edit this file by using any text editor, put the hex code of RISC-V assembly in this file and save it.
### Software needed to simulate this code
You can use any HDL simulator to simlate this code like [Modelsim](https://www.mentor.com/company/higher_ed/modelsim-student-edition),  [Questa](https://www.mentor.com/products/fv/questa/), [Vivado](https://www.xilinx.com/products/design-tools/vivado.html), [ISE](https://www.xilinx.com/products/design-tools/ise-design-suite.html) but if you are using [verilator](https://www.veripool.org/wiki/verilator) then visit [Verilator-for-Buraq-Core-Simulation](https://github.com/merledu/Verilator-for-Buraq-Core-Simulation) to get the make file and instructions to run.

## Testing and Debugging

We are testing this core according to the benchmarks provided by the RISC-V [[1](https://github.com/riscv/riscv-tests)].  
To see the status of tests open the [Test Status](https://github.com/merledu/Buraq-mini-sv/tree/master/tests%20status) folder or you can check our [Burq-simulator](https://github.com/merledu/BURQ-SIMULATOR) repository.
## References
1.https://github.com/riscv/riscv-tests
