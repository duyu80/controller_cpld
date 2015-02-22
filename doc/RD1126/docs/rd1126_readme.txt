                    UFM - Wishbone Reference Design
===============================================================================

1.  /RD1126/docs/rd1126_readme.txt				--> Read me file (this file)

2. /RD1126/project/project.lpf                --> Diamond constraint file  

3. /RD1126/source/UFM_WB_top.v                --> verilog source file
   /RD1126/source/efb_define_def.v            --> verilog definitions file
   /RD1126/source/ipExpress/EFB_UFM.v      	  --> EFB module verilog source file
   /RD1126/source/ipExpress/USR_MEM.v         --> True DPRAM verilog source file
   

4. /RD1126/testbench/UFM_WB_TB.v             	--> Testbench for verilog simulation

5. /RD1126/Simulation/verilog/rtl_verilog.do			--> RTL simulation script file for verilog
   /RD1126/Simulation/verilog/timing_verilog.do			--> Timing simulation script file for verilog



*******IMPORTANT NOTES:*************
1. Unzip the RD1126_revyy.y.zip file using the existing folder names, where yy.y is the current version of the zip file.

2. If there is lpf file available for the reference design:
	2.1 use Constraint Files >> Add >> Exiting File to import the lpf to Diamond project and set it to be active,
	
3. If there is sty file (strategy file for Diamond) available for the design, go to File List tab on the left 
   side of the GUI. Right click on Strategies >> Add >> Existing File. Then right click on the imported file 
   name and select "Set as Active Strategy".


===================================================================================================  
Using Diamond Software:
---------------------------------------------------------------------------------------------------  
HOW TO CREATE A PROJECT IN DIAMOND:
1. Launch Diamond software, in the GUI, select File >> New Project, click Next
2. In the New Project popup, select the Project location and provide a Project name and implementation 
   name, click Next.
3. Add the necessary source files from the RD1126\source directory, click Next
4. Select the desired part and speedgrade. You may use RD1126.pdf to see which device and speedgrade 
   can be selected to achieve the published timing result 
5. Click Finish. Now the project is successfully created. 
6. MAKE SURE the provided lpf and/or sty files are used in the current directory. 
      
----------------------------------------------------------------------------------------------------    
HOW TO RUN SIMULATION UNDER DIAMOND:
----------------------------------------------------------------------------------------------------      

1. Bring up the Simulation Wizard under the Tools menu 

2. Next provide a name for simulation project.
	2.1 For post-route simulation, must export verilog or vhdl simulation file after Place and Route
	
3. Next add the test bench files form the RD1126\TestBench directory & source files from RD1126\Source 
   directory for Function Simation & exported post-route netlist file for Timing Simulation.
	3.1 For VHDL, make sure the top-level test bench is last to be added

4. Next click Finish, this will bring up the Aldec simulator automatically

5. In Aldec environment, you can manually activate the simulation or you can use a script
	5.1 Use the provided script in the RD1126\Simulation\<language> directory
	  a. For functional simulation, change the library name to the device family
	  	i) MachXO2: ovi_machxo2 for verilog, machxo2 for vhdl
	  	
		b. For POST-ROUTE simulation, open the script and change the following:
			i) The sdf file name and the path pointing to your sdf file.
		   The path usually looks like "./<implementation_name>/<sdf_file_name>.sdf"
		  ii) Change the library name using the library name described above
		c. Click Tools > Execute Macro and select the xxx.do file to run the simulation
		d. This will run the simulation until finish
		
	5.2 Manually activate the simulation
		a. Click Simulation > Initialize Simulation
		b. Click File > New > Waveform, this will bring up the Waveform panel
		c. Click on the top-level testbench, drag all the signals into the Waveform panel
		d. At the Console panel, type "run -all" for VHDL simulation, or "run -all" for Verilog 
		   simulation
		e. For timing simulation, you must manually add 
		   -sdfmax UUT="./UFM_WB/UFM_WB_UFM_WB_vo.sdf"
		   into the asim or vsim command. Use the command in timing_xxx.do as an example



Note: In timing simulation you may see some warnings about narrow widths. These warnings can be ignored. These pulses happend during the mdio low so would not affect functionality.


-----------------------------------------------------------------------------------------------------
How to run Fit / Place and Route, .BIT generation, and Timing Analysis:
-----------------------------------------------------------------------------------------------------

1. Double click on Place and Route Design. This will bring the design through synthesis, mapping, and place and route.

2. Double click on Export Bitstream File (.BIT) for MachXO2 deisgn flow. This will generate the bit file for the design.

3. For timing information, double click on
   Place and Route Trace Report from MachXO2 design to get the timing analysis result.
