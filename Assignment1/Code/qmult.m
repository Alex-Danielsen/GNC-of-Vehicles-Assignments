function [ q_out ] = qmult( q, qd )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
eta1 = q(1);
eta2 = qd(1);
epi1 = q(2:4);
epi2 = qd(2:4);

q_out = [eta1*eta2-epi1'*epi2;
         eta1*epi2+eta2*epi1+Smtrx(epi1)*epi2];

end

