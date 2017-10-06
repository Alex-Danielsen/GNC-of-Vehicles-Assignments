%% 2b)
rootlocus

%% 2d)
tfbodeplot

%% 2e)
% W_chi = 10
clear all
modelParms

% Run Sim
modelName = 'Sim2e';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

% Plot results
plotting

% W_chi = 7
clear all
modelParms
%parms to course loop
W_chi       = 7;  %Beard says to choose at least 5
zeta_chi    = 1; %Start guess at critical damping

%Course loop constants
omega_n_chi = omega_n_phi/W_chi;
k_p_chi = 2*zeta_chi*omega_n_chi*V_g/g;
k_i_chi = omega_n_chi^2*V_g/g;

% Run Sim
modelName = 'Sim2e';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

% Plot results
plotting

%% 2f)
% W_chi = 10
clear all
modelParms

% Run Sim
modelName = 'Sim2f';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

% Plot results
plotting

% W_chi = 7
clear all
modelParms
%parms to course loop
W_chi       = 7;  %Beard says to choose at least 5
zeta_chi    = 1; %Start guess at critical damping

%Course loop constants
omega_n_chi = omega_n_phi/W_chi;
k_p_chi = 2*zeta_chi*omega_n_chi*V_g/g;
k_i_chi = omega_n_chi^2*V_g/g;

% Run Sim
modelName = 'Sim2f';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

% Plot results
plotting

%% 2g)
% W_chi = 10
clear all
modelParms

% Run Sim
modelName = 'Sim2g';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

% Plot results
plotting

% W_chi = 7
clear all
modelParms
%parms to course loop
W_chi       = 7;  %Beard says to choose at least 5
zeta_chi    = 1; %Start guess at critical damping

%Course loop constants
omega_n_chi = omega_n_phi/W_chi;
k_p_chi = 2*zeta_chi*omega_n_chi*V_g/g;
k_i_chi = omega_n_chi^2*V_g/g;

% Run Sim
modelName = 'Sim2g';
sim('chi_reference.slx');
sim(strcat(modelName, '.slx'));

% Plot results
plotting