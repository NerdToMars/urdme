function model = coli_model_4x(coli2dist,mesh_auto)
%COLI_MODEL Generate Comsol 4.x model for separating E. coli.
%   FEM = COLI_MODEL(COLI2DIST,MESH_HAUTO) uses Comsol to generate a
%   FEM-struct FEM which is a model of two E. colis in separation. The
%   distance is controlled by input COLI2DIST which is the distance of
%   separation between the two bacteria. An optional input MESH_HAUTO
%   governs the mesh resolution.

% P. Bauer 2012-10-26
% Initially generated by COMSOL 4.3 (4.3.0.233)

import com.comsol.model.*
import com.comsol.model.util.*

% optional input
if nargin < 2
  mesh_auto = 5;
end

% check
if abs(coli2dist) > 4.5e-6
  warning('Separation distance is longer than E. coli objects.');
end

model = ModelUtil.create('Model');

model.name('coli4x.mph');

model.modelNode.create('mod1');

%geometry
model.geom.create('geom1', 3);

%cylinder 1
model.geom('geom1').feature.create('c1','Cylinder');
model.geom('geom1').feature('c1').set('axistype','cartesian');
model.geom('geom1').feature('c1').set('axis','1 0 0');
model.geom('geom1').feature('c1').set('type','solid');
model.geom('geom1').feature('c1').set('r','0.5e-6');
model.geom('geom1').feature('c1').set('h','3.5e-6');
model.geom('geom1').feature('c1').set('pos','-1.75e-6 0 0');
model.geom('geom1').runAll;

%sphere 1
model.geom('geom1').feature.create('s1','Sphere');
model.geom('geom1').feature('s1').set('axistype','cartesian');
model.geom('geom1').feature('s1').set('axis','0 0 1');
model.geom('geom1').feature('s1').set('type','solid');
model.geom('geom1').feature('s1').set('r','0.5e-6');
model.geom('geom1').feature('s1').set('pos','-1.75e-6 0 0');
model.geom('geom1').runAll;

%sphere 2
model.geom('geom1').feature.create('s2','Sphere');
model.geom('geom1').feature('s2').set('axistype','cartesian');
model.geom('geom1').feature('s2').set('axis','0 0 1');
model.geom('geom1').feature('s2').set('type','solid');
model.geom('geom1').feature('s2').set('r','0.5e-6');
model.geom('geom1').feature('s2').set('pos','1.75e-6 0 0');
model.geom('geom1').runAll;

%union 1
model.geom('geom1').feature.create('u1','Union');
model.geom('geom1').feature('u1').selection('input').set({'c1','s1','s2'});
model.geom('geom1').feature('u1').set('intbnd','off');
model.geom('geom1').feature('u1').set('repairtol','1e-5');
model.geom('geom1').runAll;

%move 1
model.geom('geom1').feature().create('m1','Move');
model.geom('geom1').feature('m1').selection('input').set({'u1'});
model.geom('geom1').feature('m1').set('keep','on');
model.geom('geom1').feature('m1').set('displ',{num2str(coli2dist),'0','0'});
model.geom('geom1').runAll;

%union 2
model.geom('geom1').feature.create('u2','Union');
model.geom('geom1').feature('u2').selection('input').set({'u1','m1'});
model.geom('geom1').feature('u2').set('intbnd','off');
model.geom('geom1').feature('u2').set('repairtol','1e-5');
model.geom('geom1').runAll;

%run geometry
model.geom('geom1').runAll;

%mesh
mesh1=model.mesh.create('mesh1', 'geom1');
mesh1.feature('size').set('hauto',mesh_auto);

%parameters & variables
model.param.set('Dcyt', '2.5e-12');
model.param.set('Dmem', '1e-14');

model.variable.create('var1');
model.variable('var1').model('mod1');
model.variable('var1').set('rdme_sdlevel', '2');

model.variable.create('var2');
model.variable('var2').model('mod1');
model.variable('var2').selection.geom('geom1', 3);
model.variable('var2').selection.all;
model.variable('var2').set('rdme_sd', '1');

model.variable.create('var3');
model.variable('var3').model('mod1');
model.variable('var3').selection.geom('geom1', 2);
model.variable('var3').selection.all;
model.variable('var3').set('rdme_sd', '2');

%physics
model.physics.create('chds', 'DilutedSpecies', 'geom1', {'c'});
model.physics('chds').prop('Convection').set('Convection', '0');
model.physics('chds').prop('MassConsistentStabilization').set('massStreamlineDiffusion', '0');
model.physics('chds').prop('MassConsistentStabilization').set('massCrosswindDiffusion', '0');

model.physics('chds').field('concentration').component({'c' 'c2' 'c3' 'c4' 'c5'});
model.physics('chds').field('concentration').component(1, 'MinD_c_atp');
model.physics('chds').field('concentration').component(2, 'MinD_m');
model.physics('chds').field('concentration').component(3, 'Min_e');
model.physics('chds').field('concentration').component(4, 'MinDE');
model.physics('chds').field('concentration').component(5, 'MinD_c_adp');

model.physics('chds').feature('cdm1').set('D_1', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});
model.physics('chds').feature('cdm1').set('D_3', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});
model.physics('chds').feature('cdm1').set('D_0', {'Dcyt' '0' '0' '0' 'Dcyt' '0' '0' '0' 'Dcyt'});
model.physics('chds').feature('cdm1').set('D_2', {'Dcyt' '0' '0' '0' 'Dcyt' '0' '0' '0' 'Dcyt'});
model.physics('chds').feature('cdm1').set('D_4', {'Dcyt' '0' '0' '0' 'Dcyt' '0' '0' '0' 'Dcyt'});

%study
model.study.create('std1');
model.study('std1').feature.create('time', 'Transient');
model.study('std1').feature('time').activate('chds', true);

%solution
model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'time');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'time');
model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.1,1)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.0010);
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').feature('fc1').set('jtech', 'once');
model.sol('sol1').feature('t1').feature('fc1').set('maxiter', 5);
model.sol('sol1').feature('t1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('t1').feature('i1').set('prefuntype', 'left');
model.sol('sol1').feature('t1').feature('i1').set('rhob', 20);
model.sol('sol1').feature('t1').feature('i1').set('itrestart', 50);
model.sol('sol1').feature('t1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('t1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('prefun', 'gmg');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('mcasegen', 'any');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature.create('sl1', 'SORLine');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('iter', 2);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('linerelax', 0.4);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('seconditer', 1);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('relax', 0.3);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature.create('sl1', 'SORLine');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sl1').set('iter', 2);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sl1').set('linerelax', 0.4);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sl1').set('seconditer', 2);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sl1').set('relax', 0.5);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('cs').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('fc1').set('jtech', 'once');
model.sol('sol1').feature('t1').feature('fc1').set('maxiter', 5);
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').feature('t1').feature('i1').set('linsolver', 'precond');
model.sol('sol1').attach('std1');

%result
model.result.create('pg1', 3);
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('slc1', 'Slice');
model.result('pg1').feature('slc1').set('expr', 'MinD_c_atp');
model.result('pg1').feature('slc1').set('descr', 'Concentration');
model.result('pg1').name('Concentration (chds)');
model.result.create('pg2', 3);
model.result('pg2').set('data', 'dset1');
model.result('pg2').feature.create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', 'MinD_c_atp');
model.result('pg2').feature('surf1').set('descr', 'Concentration');
model.result('pg2').name('Concentration (chds) 1');

%execute
model.sol('sol1').runAll;
model.result('pg1').run;