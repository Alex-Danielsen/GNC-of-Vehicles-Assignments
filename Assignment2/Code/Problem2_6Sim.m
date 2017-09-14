% M-script for numerical integration of the attitude dynamics of a rigid 
% body represented by unit quaternions. The MSS m-files must be on your
% Matlab path in order to run the script.
%
% System:                      .
%                              q = T(q)w
%                              .
%                            I w - S(Iw)w = tau
% Control law:
%                            tau = constant
% 
% Definitions:             
%                            I = inertia matrix (3x3)
%                            S(w) = skew-symmetric matrix (3x3)
%                            T(q) = transformation matrix (4x3)
%                            tau = control input (3x1)
%                            w = angular velocity vector (3x1)
%                            q = unit quaternion vector (4x1)
%
% Author:                   2016-05-30 Thor I. Fossen 
clear all
close all
%% USER INPUTS
h = 0.1;                     % sample time (s)
N  = 30000;                    % number of samples

% model parameters
U_r = 1.5; %m/s
R = 100;
omega = U_r/R;

%Current parameters
U_c     = 0.6;
beta_c  = 45;
alpha_c = 10;
v_c_f = [-U_c 0 0]'; %velocity of current in flow axis
R_b2f = rotz(-beta_c)*roty(alpha_c); %Rotation from body to flow
R_f2b = inv(R_b2f); % Rotation matrix from flow to body
v_c_b = R_f2b*v_c_f;

v_c_n = [U_c*cos(alpha_c)*cos(beta_c);
         U_c*sin(beta_c);
         U_c*sin(alpha_c)*cos(beta_c)]; % Current velocity in ned

% constants
deg2rad = pi/180;   
rad2deg = 180/pi;

% initial Euler angles
phi = -1*deg2rad;            
theta = 2*deg2rad;
psi = 0*deg2rad;

quat = euler2q(phi,theta,psi);   % transform initial Euler angles to q

p_n = [0 0 10]';              % Initial NED position
w_b = [0 0 0]';               % Initial angular rates

%rudder
delta = 5*deg2rad; %initial rudder angle
K = .1;
T = 50;
zeta_p = .1;
zeta_q = .2;
omega_p = .1;
omega_q = .05;

table = zeros(N+1,31);        % memory allocation


%% FOR-END LOOP
for i = 1:N+1,
   t = (i-1)*h;                  % time
   tau = [0 0 0]';               % control law
   
   %Change rudder angle at 700 seconds
   if t > 700
       delta = 10*deg2rad;
   end

   [phi,theta,psi] = q2euler(quat); % transform q to Euler angles
   [J,J1,J2] = quatern(quat);       % kinematic transformation matrices
   
   %Rotational dynamics from the rudder
   p = w_b(1); q1 = w_b(2); r = w_b(3);
   p_dot = -2*zeta_p*omega_p*p - omega_p^2*phi;
   q_dot = -2*zeta_q*omega_q*q1 - omega_q^2*theta;
   r_dot = (delta*K - r) / T;
   
   %body frame relative velocities
   u_r = U_r*cos(r*t);
   v_r = U_r*sin(r*t);
   w_r = 0;
   v_r_b = [u_r v_r w_r]';
   
   %Current in body frame
   v_c_b = inv(J1)*v_c_n;
   
   %Velocity in body and NED
   v_b = v_r_b + v_c_b;
   v_n = J1*v_b;   
   
   p_dot_n = J1*v_b; %translational kinematics
   quat_dot = J2*w_b;                        % quaternion kinematics
   w_dot = [p_dot; q_dot; r_dot]; %I_inv*(Smtrx(I*w_b)*w_b + tau);  % rigid-body kinetics
   
   %Calculate speed
   U = norm(v_b);
   
   %Calculate sideslip, crab and course angles
   beta_r = atan2(v_r_b(2), v_r_b(1));
   beta   = atan2(v_b(2), v_b(1));
   chi = mod(psi + beta + pi, 2*pi) - pi;
   
   table(i,:) = [t quat' phi theta psi w_b' tau' p_n' v_b' v_r_b' beta_r beta chi U U_r v_n'];  % store data in table
   
   quat = quat + h*quat_dot;	             % Euler integration
   w_b = w_b + h*w_dot;
   p_n = p_n + h*p_dot_n;
   
   quat  = quat/norm(quat);               % unit quaternion normalization
end 

%% PLOT FIGURES
t       = table(:,1);  
quat       = table(:,2:5); 
phi     = rad2deg*table(:,6);
theta   = rad2deg*table(:,7);
psi     = rad2deg*table(:,8);
w_b     = rad2deg*table(:,9:11);  
tau     = table(:,12:14);
p_n     = table(:,15:17);
v_b     = table(:,18:20);
v_r_b   = table(:,21:23);
beta_r  = table(:,24);
beta    = table(:,25);
chi     = table(:,26);
U       = table(:,27);
U_r     = table(:,28);
v_n     = table(:,29:31);

clf
figure(gcf)
subplot(311),plot(t,phi),xlabel('time (s)'),ylabel('deg'),title('\phi'),grid
subplot(312),plot(t,theta),xlabel('time (s)'),ylabel('deg'),title('\theta'),grid
subplot(313),plot(t,psi),xlabel('time (s)'),ylabel('deg'),title('\psi'),grid
% subplot(514),plot(t,w_b),xlabel('time (s)'),ylabel('deg/s'),title('w'),grid
% subplot(515),plot(t,tau),xlabel('time (s)'),ylabel('Nm'),title('\tau'),grid

figure()
plot(t,w_b),legend('p', 'q', 'r'),xlabel('time (s)'),ylabel('deg/s'),title('w')

figure()
plot(t,p_n),legend('N', 'E', 'D'),xlabel('time (s)'),ylabel('m'),title('p_n')

indices = (700/h);
y_n_1 = p_n(1:indices, 1);
x_n_1 = p_n(1:indices, 2);
y_n_2 = p_n(indices:end, 1);
x_n_2 = p_n(indices:end, 2);
figure()
h1 = plot(x_n_1,y_n_1); hold on
h2 = plot(x_n_2,y_n_2, '-r');
%xlim([min(x_n) max(x_n)]), ylim([min(y_n) max(y_n)])
title('trajectory of the boat in 2-d'), xlabel('east (meters)'), ylabel('north (meters)')
legend('first 700 secs, \delta = 5 deg', 'after 700 secs, \delta = 10 deg')
line2arrow(h1)
line2arrow(h2)


figure()
subplot(211), plot(t, v_b),  legend('u', 'v', 'w'), ylabel('velocity components (m/s)'), title('velocity in body frame')
subplot(212), plot(t, v_r_b), legend('u_r', 'v_r', 'w_r'), ylabel('velocity components (m/s)'), xlabel('time'), title('relative velocity in body frame')

figure()
plot(t, v_n), legend('u', 'v', 'w'), ylabel('velocity components (m/s)'), title('velocity in NED frame')

figure()
plot(t, rad2deg*[beta_r, beta, chi]), legend('\beta_r = sideslip', '\beta = crab', '\chi = course')
xlabel('time (sec)'), ylabel('angle (deg)'), title('sideslip, course, and crab angles')

figure()
plot(t, [U, U_r]), legend('speed', 'relative speed')
ylabel('speed (m/s)'), xlabel('time (sec)'), title('speed over time')

delta_input = ones(N + 1,1)*5;
delta_input = delta_input + [zeros(indices,1); ones(N-indices + 1,1)]*5;
figure()
plot(t, delta_input)
legend('\delta')
ylabel('degrees'), xlabel('time (sec)'), title('rudder input')
ylim([0,15])