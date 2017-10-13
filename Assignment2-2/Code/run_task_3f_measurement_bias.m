clear all
% close all

b = 30;

%% Sim Constants
modelParms
phi_bias = deg2rad(b);
p_bias = 0;
r_bias = 0;

%% Run Sim
modelName = 'Sim3f_measurement_bias';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

%% Plot results
plotting

%% Sim Constants
modelParms
phi_bias = 0;
p_bias = deg2rad(b);
r_bias = 0;

%% Run Sim
modelName = 'Sim3f_measurement_bias';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx')); 

%% Plot results
plotting

%% Sim Constants
modelParms
phi_bias = 0;
p_bias = 0;
r_bias = deg2rad(b);

%% Run Sim
modelName = 'Sim3f_measurement_bias';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

%% Plot results
plotting

