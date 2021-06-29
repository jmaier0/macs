% RS Latch reference imlementation.

close; clear; clc;

%% constants

parameters;

time_scale=1000;
time_steps=time_scale;
t_max = 3*time_scale;

C_L = 2e1*time_scale;
C_m = 2e-2*time_scale;

input_slope = (V_DD/time_scale)*1e1;
a = [input_slope -input_slope];
c = [time_scale 1.4*time_scale];

export_accuracy = 10;

%% Matlab simulation

tspan = 0:time_scale/time_steps:t_max;
syms V_S(t) V_R(t) V_Q(t) V_NQ(t) V_mQ(t) V_mNQ(t)

%        V_Q V_mQ V_NQ V_mNQ
V_init = [0  V_DD V_DD V_DD];
vars=[V_Q V_mQ V_NQ V_mNQ];
C = [C_L C_m C_L C_m];

% ----------------------------------------------------------------
% MODEL SECTION

[I_Q, I_mQ, I_NQ, I_mNQ] = RS_Latch(V_R, V_S, V_Q, V_mQ, V_NQ, V_mNQ);
I_Q = I_Q / C(1);
I_mQ = I_mQ / C(2);
I_NQ = I_NQ / C(3);
I_mNQ = I_mNQ / C(4);

% ----------------------------------------------------------------
% SIMULATION SECTION

baseODE = odeFunction([I_Q;I_mQ;I_NQ;I_mNQ], vars, [V_R(t) V_S(t)]);

V_S = @(t) ( V_DD./(1+exp(-(a(1)*(t-c(1))))) ) + ...
    ( V_DD./(1+exp(-(a(2)*(t-c(2))))) ) - V_DD;
V_R = @(t) max(-t,0); % constant value

F = @(t,vars) baseODE(t,vars,[V_R(t),V_S(t)]);
[t,V] = ode113(F, tspan, V_init);

% ----------------------------------------------------------------
% OUTPUT SECTION

figure
plot(tspan,V_R(tspan), 'Color', [0 0.7 0], 'LineWidth',2); hold on;
plot(tspan,V_S(tspan), 'b', 'LineWidth',2); hold on;
plot(t(:,1),V(:,3), 'c', 'LineWidth',2); hold on;
plot(t(:,1),V(:,1), 'Color', [0.8 0 0], 'LineWidth',2); hold on;
legend('V_R','V_S','V_{NQ}','V_{Q}');

% debug output of internal signals
% figure
% plot(t_all,V_NQ_all, 'b', 'LineWidth',2); hold on;
% plot(t_all,V_Q_all, 'Color', [0 0.5 0], 'LineWidth',2); hold on;
% plot(t_all,V_mNQ_all, 'Color', [0.7 0 0], 'LineWidth',2); hold on;
% plot(t_all,V_mQ_all, 'Color', [0 0.7 0.7], 'LineWidth',2); hold on;
% legend('V_{NQ}','V_{Q}','V_{mNQ}','V_{mQ}');

disp('simulation finished successfully')

%% C2E2 export

remove = char('V_S(t)', 'V_R(t)', 'V_Q(t)', 'V_mQ(t)', 'V_NQ(t)', ...
    'V_mNQ(t)');
replacements = char('stim_local', '0', 'VQ', 'VmQ', 'VNQ', 'VmNQ');

fileID = fopen('exports/RS_Latch_ref.txt','w');

fprintf(fileID, 'RS Latch\n');
fprintf(fileID, ['simulation time: ', num2str(t_max), '\n']);
fprintf(fileID, ['time step: ', num2str(time_scale/time_steps), '\n']);
fprintf(fileID, ['input slopes: [', num2str(a), ']\n']);
fprintf(fileID, ['input shifts: [', num2str(c), ']\n']);
fprintf(fileID, ['C = [', num2str(C), ']\n']);

text = replace_text(char(vpa(I_Q,export_accuracy)), remove, replacements);
export_formula('VQ_dot', text, fileID);

text = replace_text(char(vpa(I_mQ,export_accuracy)), remove, replacements);
export_formula('VmQ_dot', text, fileID);

text = replace_text(char(vpa(I_NQ,export_accuracy)), remove, replacements);
export_formula('VNQ_dot', text, fileID);

text = replace_text(char(vpa(I_mNQ,export_accuracy)), remove, replacements);
export_formula('VmNQ_dot', text, fileID);

fclose(fileID);

disp('C2E2 file generated sucessfully')
