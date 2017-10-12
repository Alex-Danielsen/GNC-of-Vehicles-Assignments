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
N  = 4200;                    % number of samples

% model parameters
U = 1.5; %m/s
R = 100;
omega = U/R;
m=100;
r=2;
I_cg = m*r^2*eye(3);
k_d = 20;
k_p = 1;
I = I_cg;%diag( [100 100 100]);%[50 100 80]);       % inertia matrix
I_inv = inv(I);

%Current parameters
U_c     = 0.6;
beta_c  = 45;
alpha_c = 10;
v_c_f = [-U_c 0 0]'; %velocity of current in flow axis
R_b2f = rotz(-beta_c)*roty(alpha_c); %Rotation from body to flow
R_f2b = inv(R_b2f); % Rotation matrix from flow to body
v_c_b = R_f2b*v_c_f;

% constants
deg2rad = pi/180;   
rad2deg = 180/pi;

phi = 0*deg2rad;            % initial Euler angles
theta = 2*deg2rad;
psi = 30*deg2rad;

q = euler2q(phi,theta,psi);   % transform initial Euler angles to q

p_n = [0 0 10]';              % Initial NED position
w_b = [0 0 0]';               % Initial angular rates

[J, J11, J22] = eulerang(phi, theta, psi);

table = zeros(N+1,28);        % memory allocation



%% FOR-END LOOP
for i = 1:N+1,
   t = (i-1)*h;                  % time
   tau = [0 0 0]';%[1 2 1]';      % control law

   [phi,theta,psi] = q2euler(q); % transform q to Euler angles
   [J,J1,J2] = quatern(q);       % kinematic transformation matrices
   
   %body frame velocities
   u = U*cos(omega*t);
   v = U*sin(omega*t);
   w = 0;
   v_b = [u v w]';
   
   p_dot_n = J11*v_b;
   q_dot = J2*w_b;                        % quaternion kinematics
   w_dot = I_inv*(Smtrx(I*w_b)*w_b + tau);  % rigid-body kinetics
   
   %calculate relative velocities
   v_r_b = v_b - v_c_b;
   U_r = norm(v_r_b);
   
   %Calculate sideslip, crab and course angles
   beta_r = atan2(v_r_b(2), v_r_b(1));
   beta   = atan2(v_b(2), v_b(1));
   chi = psi + beta;
   
   table(i,:) = [t q' phi theta psi w_b' tau' p_n' v_b' v_r_b' beta_r beta chi U U_r];  % store data in table
   
   q = q + h*q_dot;	             % Euler integration
   w_b = w_b + h*w_dot;
   p_n = p_n + h*p_dot_n;
   
   
   q  = q/norm(q);               % unit quaternion normalization
end 

%% PLOT FIGURES
t       = table(:,1);  
q       = table(:,2:5); 
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

clf
figure(gcf)
subplot(511),plot(t,phi),xlabel('time (s)'),ylabel('deg'),title('\phi'),grid
subplot(512),plot(t,theta),xlabel('time (s)'),ylabel('deg'),title('\theta'),grid
subplot(513),plot(t,psi),xlabel('time (s)'),ylabel('deg'),title('\psi'),grid
subplot(514),plot(t,w_b),xlabel('time (s)'),ylabel('deg/s'),title('w'),grid
subplot(515),plot(t,tau),xlabel('time (s)'),ylabel('Nm'),title('\tau'),grid

figure()
plot(t,w_b),xlabel('time (s)'),ylabel('deg/s'),title('w')

figure()
plot(t,q),xlabel('time (s)'),ylabel('epsilon'),title('epsilon')

y_n = p_n(:, 1);
x_n = p_n(:, 2);
figure()
h1 = plot(x_n,y_n);
xlim([min(x_n) max(x_n)]), ylim([min(y_n) max(y_n)])
title('trajectory of the boat in 2-d'), xlabel('east (meters)'), ylabel('north (meters)')
line2arrow(h1)

figure()
subplot(211), plot(t, v_b),  legend('u = u_r', 'v = v_r', 'w = w_r'), ylabel('velocity components (m/s)'), title('relative velocity in body frame, no current')
subplot(212), plot(t, v_r_b), legend('u_r', 'v_r', 'w_r'), ylabel('velocity components (m/s)'), xlabel('time'), title('relative velocity in body frame, with current')

figure()
plot(t, rad2deg*[beta_r, beta, chi]), legend('\beta_r = sideslip', '\beta = crab', '\chi = course')
xlabel('time (sec)'), ylabel('angle (deg)'), title('sideslip, course, and crab angles, with current')

figure()
plot(t, rad2deg*[beta, beta, chi]), legend('\beta_r = sideslip', '\beta = crab', '\chi = course')
xlabel('time (sec)'), ylabel('angle (deg)'), title('sideslip, course, and crab angles, no current')

figure()
plot(t, [U, U_r]), legend('speed = relative speed without current', 'relative speed with current')
xlabel('speed (m/s)'), ylabel('time (sec)'), title('speed over time')