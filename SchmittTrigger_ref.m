% CMOS Schmitt Trigger reference implementation

close; clear; clc;

%% constants

parameters;

time_scale=1000;
time_steps=time_scale;
t_max = 3*time_scale;

C_L = 2e1*time_scale;
C_m = 5*time_scale;

input_slope = (V_DD/time_scale)*1e1;
a = [input_slope -input_slope];
c = [time_scale 2*time_scale];

export_accuracy = 10;

%% Matlab simulation

tspan = 0:time_scale/time_steps:t_max;
syms V_in(t) V_1(t) V_2(t) V_out(t)

%         V_1  V_2      V_out
V_init = [V_DD 1.05  V_DD];
vars=[V_1 V_2 V_out];
C = [C_m C_m C_L];

% ----------------------------------------------------------------
% MODEL SECTION

[I_1,I_2,I_out] = SchmittTrigger(V_in, V_1, V_2, V_out);
I_1 = I_1 / C(1);
I_2 = I_2 / C(2);
I_out = I_out / C(end);

% ----------------------------------------------------------------
% SIMULATION SECTION

baseODE = odeFunction([I_1;I_2;I_out], vars, [V_in(t)]);

V_in = @(t) ( V_DD./(1+exp(-(a(1)*(t-c(1))))) ) + ...
    ( V_DD./(1+exp(-(a(2)*(t-c(2))))) ) - V_DD;

F = @(t,vars) baseODE(t,vars,[V_in(t)]);
[t,V] = ode113(F, tspan, V_init);

% ----------------------------------------------------------------
% OUTPUT SECTION

figure
plot(tspan,V_in(tspan), 'Color', [0 0.7 0], 'LineWidth',2); hold on;
plot(t(:,1),V(:,1), 'b', 'LineWidth',2); hold on;
plot(t(:,1),V(:,2), 'c', 'LineWidth',2); hold on;
plot(t(:,1),V(:,end), 'Color', [0.8 0 0], 'LineWidth',2); hold on;
legend('V_{in}','V_1','V_2','V_{out}');
xlabel('time')
ylabel('voltage')

disp('simulation finished successfully')

%% Write data to file

fid = fopen('exports/ST_traces.dat','wt');
for ii = 1:size(t,1)
    fprintf(fid,'%g %g %g %g %g %g\n',tspan(1,ii)/1000, V_in(tspan(1,ii)), ...
        t(ii,1)/1000, V(ii,1), V(ii,2), V(ii,end));
end
fclose(fid);

disp('traces written successfully')

%% C2E2 export

remove = char('V_in(t)', 'V_1(t)', 'V_2(t)', 'V_out(t)');
replacements = char('stim_local', 'V1', 'V2', 'Vout');

fileID = fopen('exports/SchmittTrigger_ref.txt','w');

fprintf(fileID, 'Schmitt Trigger\n');
fprintf(fileID, ['simulation time: ', num2str(t_max), '\n']);
fprintf(fileID, ['time step: ', num2str(time_scale/time_steps), '\n']);
fprintf(fileID, ['input slopes: [', num2str(a), ']\n']);
fprintf(fileID, ['input shifts: [', num2str(c), ']\n']);
fprintf(fileID, ['C = [', num2str(C), ']\n']);

text = replace_text(char(vpa(I_1,export_accuracy)), remove, replacements);
export_formula('V1_dot', text, fileID);

text = replace_text(char(vpa(I_2,export_accuracy)), remove, replacements);
export_formula('V2_dot', text, fileID);

text = replace_text(char(vpa(I_out,export_accuracy)), remove, replacements);
export_formula('Vout_dot', text, fileID);

fclose(fileID);

disp('C2E2 file generated sucessfully')
