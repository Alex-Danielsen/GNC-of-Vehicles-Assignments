clear all
% close all

n = 3;

modelParms
k_i_phi_vec = [-100:.01:100];
poles = zeros(n, length(k_i_phi_vec));
diffVec = zeros(n, length(k_i_phi_vec));

legendEntry = {};
figure()
for i= 1:length(k_i_phi_vec)
    poles(:,i) = roots([1 (alpha_phi1+alpha_phi2*k_d_phi) (alpha_phi2*k_p_phi) (alpha_phi2*k_i_phi_vec(i))]);
    if(i>1)
        diffVec(:, i) = poles(:,i)-poles(:,i-1);
        
        if(min(real(poles(:,i)) < 0) && ~min(real(poles(:,i-1) < 0)))
            scatter(real(poles(:,i)), imag(poles(:,i))); hold on;
            legendEntry = [legendEntry strcat('k_i_{\phi} = ', num2str(k_i_phi_vec(i)))];
            k_i_phi_vec(i)
        end
        
        if(~min(real(poles(:,i)) < 0) && min(real(poles(:,i-1) < 0)))
            scatter(real(poles(:,i)), imag(poles(:,i))); hold on
            legendEntry = [legendEntry strcat('k_i_{\phi} = ', num2str(k_i_phi_vec(i)))];
            k_i_phi_vec(i)
        end
        
    end
    
    poles_copy = poles(:,i);
    if((norm(diffVec(:,i)) > .20) && i > 1)
        poles_prev = poles(:,i-1);
        pos_correction = zeros(n,1);
        for l = 1:3
            for k = 1:3
                p_r = real(poles(l,i));
                p_i = imag(poles(l,i));
                prev_r = real(poles_prev(k));
                prev_i = imag(poles_prev(k));
                epsilon_r = abs(prev_r/10) + 1/167;
                epsilon_i = abs(prev_i/10) + 1/167;
                if((prev_r - epsilon_r < p_r && prev_r + epsilon_r > p_r) && (prev_i - epsilon_i < p_i && prev_i + epsilon_i > p_i))
                    pos_correction(l) = k;
                end
            end
        end
        for l = 1:n
            poles(pos_correction(l),i) = poles_copy(l);
        end
    end
end

h1 = plot(complex(poles(1,:))); hold on, h2 = plot(complex(poles(2,:))); h3 = plot(complex(poles(3,:)));
line2arrow(h1); line2arrow(h2); line2arrow(h3);
grid on
xlabel('Real'); ylabel('Imaginary')
legend([legendEntry(1), legendEntry(2), 'pole 1', 'pole 2', 'pole 3'])
title('Root Locus with k_i_\phi values that cross the stability boundary')