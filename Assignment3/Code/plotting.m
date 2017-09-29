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
chi_pl   = timeseries(rad2deg(chi.data)  , chi.time);
chi_c_pl = timeseries(rad2deg(chi_c.data), chi_c.time);
phi_c_pl = timeseries(rad2deg(phi_c.data), phi_c.time);

%Course
figure()
plot(chi_pl); hold on; plot(chi_c_pl)
legend('\chi', '\chi^c')
title('Course'); xlabel('time (sec)'); ylabel('course (deg)')

%Input
figure()
plot(delta_a_pl); hold on; if(exist('x', 'var')); plot(delta_a_c_pl); end
legend('\delta_a', '\delta_a^c')
title('Aeleron Input'); xlabel('time (sec)'); ylabel('aeileron deflection (deg)')

%Yaw
figure()
plot(phi_pl); hold on; plot(phi_c_pl)
legend('\phi', '\phi^c')
title('Roll'); xlabel('time (sec)'); ylabel('Yaw (deg)')