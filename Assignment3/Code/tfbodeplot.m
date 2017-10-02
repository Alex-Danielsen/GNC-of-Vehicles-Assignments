modelParms;


s = tf('s');

%Transfer function between aileron and p:
p_open_loop = k_p_phi*alpha_phi2/(s+alpha_phi1);
p_closed_loop = p_open_loop/(1+k_d_phi*p_open_loop);

%Transfer function between phi and phi_c open loop:
H_phi_open_loop = p_closed_loop/(1+p_closed_loop);

% Transfer function between phi and phi_c:
H_phi = minreal(tf([k_p_phi*alpha_phi2], [1, (alpha_phi1+alpha_phi2*k_d_phi), k_p_phi*alpha_phi2]));

% Transfer function between chi and chi_c open loop with disturbance set to
% zero:
H_chi_open_loop = minreal((k_i_chi/s + k_p_chi)*H_phi*g/(V_g*s));

% Transfer function between chi and chi_c closed loop:
H_chi = H_chi_open_loop/(1+H_chi_open_loop);

figure();
margin(H_phi_open_loop);

figure();
margin(H_chi_open_loop);