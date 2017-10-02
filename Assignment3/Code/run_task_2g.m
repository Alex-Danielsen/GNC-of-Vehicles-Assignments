clear all
% close all

%% Sim Constants
modelParms

%% Run Sim
modelName = 'Sim2g';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

%% Plot results
plotting

