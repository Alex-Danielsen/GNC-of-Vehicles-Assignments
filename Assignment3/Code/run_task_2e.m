clear all
close all

%% Sim Constants
modelParms

%% Run Sim
modelName = 'Sim2e';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

%% Plot results
plotting

