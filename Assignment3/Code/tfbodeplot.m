modelParms;


s = tf('s');

%Transfer function between aileron and p:
p_open_loop = minreal(alpha_phi2/(s+alpha_phi1));
p_derivative_closed_loop = minreal(p_open_loop/(1+k_d_phi*p_open_loop));

%Transfer function between phi and phi_c open loop:
H_phi_open_loop = minreal((k_i_phi/s+k_p_phi)*p_derivative_closed_loop/s);

% Transfer function between phi and phi_c:
% Equal to H_phi = minreal(H_phi_open_loop/(1+H_phi_open_loop))
H_phi = minreal(tf([k_p_phi*alpha_phi2], [1, (alpha_phi1+alpha_phi2*k_d_phi), k_p_phi*alpha_phi2]));

% Transfer function between chi and chi_c open loop with disturbance set to
% zero:
H_chi_open_loop = minreal((k_i_chi/s + k_p_chi)*H_phi*g/(V_g*s));

% Transfer function between chi and chi_c closed loop:
H_chi = minreal(H_chi_open_loop/(1+H_chi_open_loop));

figure();
hold on;
bodeplot(H_phi);
bodeplot(H_chi);
legend('H_\phi', 'H_\chi');
title('Bodeplot of the roll closed loop and the course closed loop');

hold off;

figure();
margin(H_phi_open_loop);
legend('H_\phi');
figure();
margin(H_chi_open_loop);
legend('H_\chi');