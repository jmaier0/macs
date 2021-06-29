% Inverter loop driven in metastability

close; clear; clc;

%% constants

parameters;

time_scale=5000;
time_steps=time_scale;
t_max = 2*time_scale;

C_L = 2e1*time_scale;
C_m = 2e-2*time_scale;

input_slope = (V_DD/time_scale)*1e1;
a = [input_slope -input_slope];
c = [time_scale 2*time_scale];

export_accuracy = 10;

%% Matlab simulation

tspan = 0:time_scale/time_steps:t_max;
syms V_in(t) V_m(t) V_out(t)

%         V_m  V_out
V_init = [V_DD 0];
vars=[V_m V_out];
C = [C_m C_L];

% ----------------------------------------------------------------
% MODEL SECTION

I_m = INV(V_out, V_m)/10 + INV(V_in, V_m);
I_m = I_m / C(1);

I_out = INV(V_m, V_out);
I_out = I_out / C(end);

% ----------------------------------------------------------------
% SIMULATION SECTION

V_in = @(t) ( V_DD./(1+exp(-(a(1)*(t-c(1))))) ) + ...
    ( V_DD./(1+exp(-(a(2)*(t-c(2))))) ) - V_DD;

baseODE = odeFunction([I_m;I_out], vars, V_in(t));

F = @(t,vars) baseODE(t,vars);
[t,V] = ode113(F, tspan, V_init);

% ----------------------------------------------------------------
% OUTPUT SECTION

figure
plot(tspan,V_a(tspan), 'Color', [0 0.7 0], 'LineWidth',2); hold on;
plot(t(:,1),V(:,1), 'b', 'LineWidth',2); hold on;
plot(t(:,1),V(:,2), 'Color', [0.8 0 0], 'LineWidth',2); hold on;
legend('V_in','V_m','V_{out}');

disp('simulation finished successfully')

%% C2E2 export

remove = char('V_m(t)', 'V_out(t)');
replacements = char('Vm', 'Vout');

fileID = fopen('exports/INV_loop_MS.txt','w');

fprintf(fileID, 'Inverter Loop\n');
fprintf(fileID, ['simulation time: ', num2str(t_max), '\n']);
fprintf(fileID, ['time step: ', num2str(time_scale/time_steps), '\n']);
fprintf(fileID, ['V_TH = ', num2str(V_TH), '\n']);
fprintf(fileID, ['deviation = ', num2str(deviation), '\n']);
fprintf(fileID, ['C = [', num2str(C), ']\n']);

text = replace_text(char(vpa(I_m,export_accuracy)), remove, replacements);
export_formula('Vm_dot', text, fileID);

text = replace_text(char(vpa(I_out,export_accuracy)), remove, replacements);
export_formula('Vout_dot', text, fileID);

fclose(fileID);

disp('C2E2 file generated sucessfully')
