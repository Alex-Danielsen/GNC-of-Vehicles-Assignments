clear all
close all


m=100;
r=2;
I_cg = m*r^2*eye(3);

k_d = 20;
k_p = 1;

syms w_1 w_2 w_3

I_cg*Smtrx(I_cg*[w_1; w_2; w_3])*[w_1; w_2; w_3]

A = [zeros(3, 3) .5*eye(3,3);
     zeros(3, 3) zeros(3, 3)];
B = [zeros(3, 3); 1/(m*r^2)*eye(3)];

A_c = [zeros(3,3)            .5*eye(3);
       (-k_p/(m*r^2))*eye(3) (-k_d/(m*r^2))*eye(3)]
   
eig(A_c)