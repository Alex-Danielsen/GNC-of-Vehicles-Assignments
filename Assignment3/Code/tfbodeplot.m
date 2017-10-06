modelParms;
s = tf('s');

%% Transfer function if W_chi = 10
%Transfer function between aileron and p:
p_open_loop = minreal(alpha_phi2/(s+alpha_phi1));
p_derivative_closed_loop = minreal(p_open_loop/(1+k_d_phi*p_open_loop));

%Transfer function between phi and phi_c open loop:
H_phi_open_loop = minreal((k_i_phi/s+k_p_phi)*p_derivative_closed_loop/s);

% Transfer function between phi and phi_c:
% Equal to H_phi_closed_loop = minreal(tf([k_p_phi*alpha_phi2], [1, (alpha_phi1+alpha_phi2*k_d_phi), k_p_phi*alpha_phi2]));
H_phi_closed_loop = minreal(H_phi_open_loop/(1+H_phi_open_loop));

% Transfer function between chi and chi_c open loop with disturbance set to
% zero:
H_chi_open_loop = minreal((k_i_chi/s + k_p_chi)*H_phi_closed_loop*g/(V_g*s));

% Transfer function between chi and chi_c closed loop:
H_chi_closed_loop = minreal(H_chi_open_loop/(1+H_chi_open_loop));

figure();
hold on;
bodeplot(H_phi_open_loop);
bodeplot(H_chi_open_loop);
legend('H_\phi', 'H_\chi with W_\chi = 10');
title('Bodeplot of the roll open loop and the course open loop');

hold off;

figure();
hold on;
bodeplot(H_phi_closed_loop);
bodeplot(H_chi_closed_loop);
legend('H_\phi_closed_loop', 'H_\chi_closed_loop with W_\chi = 10');
title('Bodeplot of the roll closed loop and the course closed loop');

hold off;

figure();
margin(H_chi_open_loop);
legend('H_\chi_open_loop with W_\chi = 10');

%% Transfer functions if W_chi = 1
W_chi = 1;
%Course loop constants
omega_n_chi = omega_n_phi/W_chi;
k_p_chi = 2*zeta_chi*omega_n_chi*V_g/g;
k_i_chi = omega_n_chi^2*V_g/g;

%Transfer function between aileron and p:
p_open_loop = minreal(alpha_phi2/(s+alpha_phi1));
p_derivative_closed_loop = minreal(p_open_loop/(1+k_d_phi*p_open_loop));

%Transfer function between phi and phi_c open loop:
H_phi_open_loop = minreal((k_i_phi/s+k_p_phi)*p_derivative_closed_loop/s);

% Transfer function between phi and phi_c:
% Equal to H_phi = minreal(H_phi_open_loop/(1+H_phi_open_loop))
H_phi_closed_loop = minreal(tf([k_p_phi*alpha_phi2], [1, (alpha_phi1+alpha_phi2*k_d_phi), k_p_phi*alpha_phi2]));

% Transfer function between chi and chi_c open loop with disturbance set to
% zero:
H_chi_open_loop = minreal((k_i_chi/s + k_p_chi)*H_phi_closed_loop*g/(V_g*s));

% Transfer function between chi and chi_c closed loop:
H_chi_closed_loop = minreal(H_chi_open_loop/(1+H_chi_open_loop));

figure();
hold on;
bodeplot(H_phi_open_loop);
bodeplot(H_chi_open_loop);
legend('H_\phi', 'H_\chi with W_\chi = 1');
title('Bodeplot of the roll open loop and the course open loop');

hold off;

figure();
margin(H_chi_open_loop);
legend('H_\chi_open_loop with W_\chi = 1');
