clear all
close all

beta = 45;
alpha = 10;
v_c = [-0.6; 0; 0];


v_c_b = inv(rotz(-beta)*roty(alpha))*v_c