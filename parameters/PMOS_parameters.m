%%%%% PMOS parameters

mu_0 = 1.0445e-2;   % m^2/Vs
epsox = 3.9;        % unitless
t_ox = 2.75e-9;      % m
W = 6.3e-7;         % m
V_T = 0.47;          % V
v_sat = 6e8;        % m/s
theta=0.09;         % V^-1

C_ox = epsox * eps_0 / t_ox;  % F/m^2
%C_ox = 1.42e13; % F/m^2
