% NOR reference implementation

close; clear; clc;

%% constants

parameters;

time_scale=1000;
time_steps=time_scale;
t_max = 3*time_scale;

C_L = 8e-5*time_scale;

input_slope = (V_DD/time_scale)*1e1;
a = [input_slope -input_slope];
c = [time_scale 1.3*time_scale];

export_accuracy = 10;

%% Matlab simulation

tspan = 0:time_scale/time_steps:t_max;
syms V_in(t) V_cn(t) V_cp(t) V_out(t) V_DSN(t) V_SDP(t)

%         V_out
V_init = 0;
vars=V_out;
C = C_L;

% ----------------------------------------------------------------
% MODEL SECTION

I_out = TG(V_in, V_cn, V_cp, V_out, V_DSN, V_SDP);
I_out = I_out / C_L;

% ----------------------------------------------------------------
% SIMULATION SECTION

baseODE = odeFunction(I_out, vars, [V_in(t) V_cn(t) V_cp(t)]);

V_in = @(t) V_DD./(1+exp(-(a(1)*(t-c(1))))) ;
%V_c = @(t) V_DD./(1+exp(-(a(2)*(t-c(2))))) ;
V_cn = @(t) max(-1*t,V_DD); % constant value
V_cp = @(t) min(1*t,0); % constant value

V_SDP = @(t) max(V_in-V_out, 0);
V_DSN = @(t) max(V_out-V_in, 0);

F = @(t,vars) baseODE(t,vars,[V_in(t),V_cn(t), V_cp(t)]);
[t,V] = ode113(F, tspan, V_init);

% ----------------------------------------------------------------
% OUTPUT SECTION

figure
plot(tspan,V_in(tspan), 'Color', [0 0.7 0], 'LineWidth',2); hold on;
plot(tspan,V_cn(tspan), 'b', 'LineWidth',2); hold on;
plot(tspan,V_cp(tspan), 'c', 'LineWidth',2); hold on;
plot(t(:,1),V(:,1), 'Color', [0.8 0 0], 'LineWidth',2); hold on;
legend('V_in','V_cn','V_cp','V_{out}');

disp('simulation finished successfully')
%% Write data to file

fid = fopen('exports/NOR_traces.dat','wt');
for ii = 1:size(t,1)
    fprintf(fid,'%g %g %g %g %g %g\n',tspan(1,ii)/1000, V_a(tspan(1,ii)), ...
        V_b(tspan(1,ii)), t(ii,1)/1000, V(ii,1), V(ii,2));
end
fclose(fid);

disp('traces written successfully')

%% C2E2 export

remove = char('V_a(t)', 'V_b(t)', 'V_m(t)', 'V_out(t)');
replacements = char('stim_local', '0', 'Vm', 'Vout');

fileID = fopen('exports/NOR_ref.txt','w');

fprintf(fileID, 'NOR gate\n');
fprintf(fileID, ['simulation time: ', num2str(t_max), '\n']);
fprintf(fileID, ['time step: ', num2str(time_scale/time_steps), '\n']);
fprintf(fileID, ['input slopes: [', num2str(a), ']\n']);
fprintf(fileID, ['input shifts: [', num2str(c), ']\n']);
fprintf(fileID, ['C = [', num2str(C), ']\n']);

text = replace_text(char(vpa(I_m,export_accuracy)), remove, replacements);
export_formula('Vm_dot', text, fileID);

text = replace_text(char(vpa(I_out,export_accuracy)), remove, replacements);
export_formula('Vout_dot', text, fileID);

fclose(fileID);

disp('C2E2 file generated sucessfully')
