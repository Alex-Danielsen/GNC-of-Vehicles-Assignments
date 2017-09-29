clear all
close all

n = 3;

modelParms
k_i_phi_vec = [-100:.01:100];
poles = zeros(n, length(k_i_phi_vec));
diffVec = zeros(n, length(k_i_phi_vec));

pos_correction = zeros(n,1);
for i = 1:n
    pos_correction(i) = i;
end

for i= 1:length(k_i_phi_vec)
    poles(:,i) = roots([1 (alpha_phi1+alpha_phi2*k_d_phi) (alpha_phi2*k_p_phi) (alpha_phi2*k_i_phi_vec(i))]);
    if(i>1)
        diffVec(:, i) = poles(:,i)-poles(:,i-1);
    end
    
    poles_copy = poles(:,i);
    for l = 1:n
        poles(l,i) = poles_copy(pos_correction(l));
    end
    
    if(norm(diffVec(:,i)) > .1)
        i
        poles_prev = poles(:,i-1);
        for l = 1:3
            for k = 1:3
                epsilon = poles_prev(k)/20;
                if(poles_prev(k) - epsilon < poles(l,i) && poles(l,i) < poles_prev(k) + epsilon)
                    corr_position(l) = k
                end
            end
        end
        for l = 1:n
            poles(l,i) = poles_copy(pos_correction(l));
        end
    end
end

h1 = plot(poles(1,:)); hold on, h2 = plot(poles(2,:)); h3 = plot(poles(3,:));
line2arrow(h1); line2arrow(h2); line2arrow(h3);
grid on