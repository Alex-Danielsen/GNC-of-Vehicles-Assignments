clear all
% close all

%% Sim Constants
modelParms

%% Run Sim
modelName = 'Sim3e_simulinkKalman';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

%% Plot results
plotting

