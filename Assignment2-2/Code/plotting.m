%Extract data for different cases
if(exist('x', 'var'))
    beta_pl    = timeseries(rad2deg(x.data(:,1)), x.time);
    phi_pl     = timeseries(rad2deg(x.data(:,2)), x.time);
    p_pl       = timeseries(rad2deg(x.data(:,3)), x.time);
    r_pl       = timeseries(rad2deg(x.data(:,4)), x.time);
    delta_a_pl = timeseries(rad2deg(x.data(:,5)), x.time);
    delta_a_c_pl = timeseries(rad2deg(delta_a_c.data), delta_a_c.time);
else
    delta_a_pl  = timeseries(rad2deg(delta_a.data), delta_a.time);
    phi_pl = timeseries(rad2deg(phi.data), phi.time);
end
if(exist('x_hat', 'var'))
    beta_hat_pl    = timeseries(rad2deg(x_hat.data(:,1)), x_hat.time);
    phi_hat_pl     = timeseries(rad2deg(x_hat.data(:,2)), x_hat.time);
    p_hat_pl       = timeseries(rad2deg(x_hat.data(:,3)), x_hat.time);
    r_hat_pl       = timeseries(rad2deg(x_hat.data(:,4)), x_hat.time);
    
    phi_meas_pl = timeseries(phi_meas.data.*180./pi, phi_meas.time);
    p_meas_pl = timeseries(p_meas.data.*180./pi, p_meas.time);
    r_meas_pl = timeseries(r_meas.data.*180./pi, r_meas.time);
end
chi_pl   = timeseries(rad2deg(chi.data)  , chi.time);
chi_c_pl = timeseries(rad2deg(chi_c.data), chi_c.time);
phi_c_pl = timeseries(rad2deg(phi_c.data), phi_c.time);


%Course
figure()
subplot(311)
plot(chi_pl); hold on; plot(chi_c_pl)
legend('\chi', '\chi^c')
title({modelName, strcat('\zeta_\chi = ', num2str(zeta_chi), '   W_\chi = ', num2str(W_chi)), 'Course'});  
ylabel('course (deg)'); %xlabel('time (sec)');

%Input
subplot(312)
plot(delta_a_pl); hold on; if(exist('x', 'var')); plot(delta_a_c_pl); end
legend('\delta_a', '\delta_a^c')
title('Aeleron Input');  ylabel('aeileron deflection (deg)'); xlabel('');

%Roll
subplot(313)
plot(phi_pl); hold on; plot(phi_c_pl)
legend('\phi', '\phi^c')
title('Roll'); xlabel('Time (sec)'); ylabel('Yaw (deg)')

%Integrator windup
figure()
plot(intergratorTerm)
title({modelName, 'Integrator term'})
xlabel('Time (sec)'); ylabel('Affect from integrator (unitless)')

%Roll, roll rate, yaw rate
figure()
subplot(311)
plot(phi_pl); hold on; plot(phi_hat_pl); plot(phi_meas_pl); 
legend('true \phi', 'kalman \phi', 'measured \phi')
title({modelName, 'Kalman Estimates vs. Measure vs. True State', 'Roll'})
ylabel('\phi (deg)')

subplot(312)
plot(p_pl); hold on; plot(p_hat_pl); plot(p_meas_pl)
legend('true p', 'kalman p', 'measured p')
title('Roll rate')
ylabel('p (deg/s)')

subplot(313)
plot(r_pl); hold on; plot(r_hat_pl); plot(r_meas_pl);
legend('true r', 'kalman r', 'measured r')
title('Yaw rate')
ylabel('r (deg/s)'); xlabel('Time (sec)')