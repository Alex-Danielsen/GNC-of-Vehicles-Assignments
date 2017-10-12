%% Sim Parms
%Input values
angle1 = deg2rad(5);
t1     = 100;
angle2 = deg2rad(-5);
t2     = t1+100;
angle3 = deg2rad(15);
t3     = t2+100;
angle4 = deg2rad(-20);
t4     = t3+200;

total_time = t4;
%% Model Parameters
%Constants
alpha_phi1 = 2.87;
alpha_phi2 = -0.65;
g = 9.8; %m/s
V_g = 637 * 1000 / 3600; % Ground speed = air speed with no wind
dist = deg2rad(2); %rad

%parms to roll loop
e_phi_max   = deg2rad(15); %rad
delta_a_max = deg2rad(25); %rad
zeta_phi    = 0.707; %damping factor


%Roll loop constants
k_p_phi = delta_a_max/e_phi_max * sign(alpha_phi2);
omega_n_phi = sqrt(k_p_phi*alpha_phi2);
k_d_phi = (2*zeta_phi*omega_n_phi - alpha_phi1)/alpha_phi2;
k_i_phi = 0;

%parms to course loop
W_chi       = 10;  %Beard says to choose at least 5
zeta_chi    = 1; %Start guess at critical damping

%Course loop constants
omega_n_chi = omega_n_phi/W_chi;
k_p_chi = 2*zeta_chi*omega_n_chi*V_g/g;
k_i_chi = omega_n_chi^2*V_g/g;



%% Set up state space model
A = [-0.322 0.052 0.028 -1.12   0.002;
     0      0     1     -0.001  0;
     -10.6  0     -2.87 0.46    -0.65;
     6.87   0     -0.04 -0.32   -0.02;
     0      0     0     0       -10
     ];
B = [0 0 0 0 10]';
C = [0 0 0 1 0;
     0 0 1 0 0;
     1 0 0 0 0;
     0 1 0 0 0];
 
 


%Initial - beta, phi, p, r, delta_a
x0 =       [0    0    0  0  0];

%% Anti windup
antiWindupBound = 0.05;


%% Kalman Fileter
% Continuous
A_kalman = [-0.322 0.052 0.028 -1.12 ;
     0      0     1     -0.001  ;
     -10.6  0     -2.87 0.46    ;
     6.87   0     -0.04 -0.32   ;      
     ];
B_kalman = [.002 0 -0.65 -0.02]';
C_kalman = [0 0 0 1;
     0 0 1 0;
     0 1 0 0];
 
E_kalman = diag([1 1 1 1]);

% Digitalization
h = 0.01;

[Phi, Delta] = c2d(A_kalman, B_kalman, h);
[Phi, Gamma] = c2d(A_kalman, E_kalman, h);

Q = 10^-6*diag([1 1 1 1]);
R = deg2rad(diag([2 0.5 0.2]));

x_bar_0 = [0, 0, 0, 0]';
P_bar_0 = Q;
Phi_k = Phi;
Delta_k = Delta;
Gamma_k = Gamma;
H_k = C_kalman;
Q_k = Q;
R_k = R;

h_meas = .01;
phi_var = 2;
p_var   = 0.5;
r_var   = 0.2;