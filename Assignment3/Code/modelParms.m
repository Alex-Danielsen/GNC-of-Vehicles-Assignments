%Constants
alpha_phi1 = 2.87;
alpha_phi2 = -0.65;
g = 9.8; %m/s
V_g = 637; % Ground speed = air speed with no wind
dist = deg2rad(2); %rad

%parms to roll loop
e_phi_max   = deg2rad(15); %rad
delta_a_max = deg2rad(25); %rad
zeta_phi    = 0.707; %damping factor

%parms to course loop
W_chi       = 10;  %Beard says to choose at least 5
zeta_chi    = 1; %Start guess at critical damping


%Roll loop constants
k_p_phi = delta_a_max/e_phi_max * sign(alpha_phi2);
omega_n_phi = sqrt(k_p_phi*alpha_phi2);
k_d_phi = (2*zeta_phi*omega_n_phi - alpha_phi1)/alpha_phi2;
k_i_phi = 0;

%Course loop constants
omega_n_chi = omega_n_phi/W_chi;
k_p_chi = 2*zeta_chi*omega_n_chi*V_g/g;
k_i_chi = omega_n_chi^2*V_g/g;
