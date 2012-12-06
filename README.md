urdme
=====

Using Comsol Multiphysics 3.5
=====
1. Start Comsol and open a model file, e.g. urdme-1.2/examples/mincde/coli.mph.2. From Comsol, start Matlab:     File > Client/Server/MATLAB > Connect to MATLAB3. Initialize the Matlab environment.� Change Matlab�s working directory to the folder for the URDME model you wish to simulate. At the Matlab command prompt type	>> cd urdme-1.2/examples/mincde/4. Export the model geometry from Comsol to Matlab.� Update the Model data: Solve > Update Model3
� Export the data:File > Export > FEM Structure as �fem�5. Simulate the model. At the Matlab command prompt type:         >> umod = urdme(fem,�mincde�)6. Visualize the results. At the Matlab command prompt type:	>> postplot(umod.comsol,�Tetdata�,�MinD m�)
Using Comsol Multiphysics 4.x
====

1. Start the Comsol interface to Matlab (�LiveLink�), ./comsol server matlab in Unix-based systems.2. Change Matlab�s working directory to the folder for the URDME model you wish to simulate. At the Matlab command prompt type	>> cd urdme-1.2/examples/mincde/3. Load the Comsol geometry into Matlab:     	>> fem = mphload(�coli.mph�)4. Simulate the model. At the Matlab command prompt type:    	 >> umod = urdme(fem,�mincde�);5. Visualize the results. At the Matlab command prompt type:	>> umod.comsol.result.create(�res1�,�PlotGroup3D�);	>> umod.comsol.result(�res1�).set(�t�,�900�);	>> umod.comsol.result(�res1�).feature.create(�surf1�, �Surface�);	>> umod.comsol.result(�res1�).feature(�surf1�).set(�expr�, �MinD m�); >> mphplot(umod.comsol,�res1�);6. Optionally, save the output to a mph-file for further observations in the Comsol GUI: >> mphsave(umod.comsol,�coli output.mph�)