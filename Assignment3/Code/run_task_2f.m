clear all
% close all

%% Sim Constants
modelParms

%% Run Sim
modelName = 'Sim2f';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

%% Plot results
plotting

