%Course
figure()
chi.data = rad2deg(chi.data); chi_c.data = rad2deg(chi_c.data);
plot(chi); hold on; plot(chi_c)
legend('\chi', '\chi^c')
title('Course'); xlabel('time (sec)'); ylabel('course (deg)')

%Input
figure()
delta_a.data = rad2deg(delta_a.data);
plot(delta_a)
legend('\delta_a')
title('Aeleron Input'); xlabel('time (sec)'); ylabel('aeileron deflection (deg)')

%Yaw
figure()
phi.data = rad2deg(phi.data); phi_c.data = rad2deg(phi_c.data);
plot(phi); hold on; plot(phi_c)
legend('\phi', '\phi^c')
title('Roll'); xlabel('time (sec)'); ylabel('Yaw (deg)')