% =============================================================================
% Author: Christian Danilo Arroyo Herrera
% Module: Neural Computing — University of Lincoln, School of Computer Science
% Assessment: 1 | Academic Year 2025/2026
% This code is the author's own original work submitted as a university assessment.
% AUTHOR_FINGERPRINT: Q2hyaXN0aWFuIERhbmlsbyBBcnJveW8gSGVycmVyYXxjYXJyb3lvaGVycmVyYUBnbWFpbC5jb20=
% =============================================================================

% Part 2: Dendrites & Cable Theory

clear; clc; close all;

L_um = 500;             
L = L_um * 1e-4;        % Length in cm (standard unit)
dx_um = 10;
dx = dx_um * 1e-4;      % Spatial step (cm)
Nx = round(L/dx) + 1;   % Number of spatial points
x_vector = linspace(0, L, Nx);
x_plot = x_vector * 1e4; % Convert back to um for plotting

diam_um = 2;
radius_cm = (diam_um/2) * 1e-4; % Radius in cm
Ra_base = 150;          % Axial resistance (Ohm*cm)
Rm_base = 10000;        % Membrane resistance (Ohm*cm^2)
Cm_base = 1.0e-6;       % Capacitance (F/cm^2) -> 1 uF/cm^2

T_total = 15;           % Total time (ms)
dt_base = 0.005;        % Base time step (ms)

stim_dur = 0.5;         % Duration (ms)
V_pulse = 50;           % Amplitude (mV)

scenario_names = {'A. Base Case', 'B. Large Radius', 'C. Low Rm', 'D. Myelinated'};

R_scenarios = [radius_cm, 4e-4, radius_cm, radius_cm];     % Radius (cm)
Rm_scenarios = [Rm_base, Rm_base, Rm_base/2, Rm_base];     % Rm (Ohm*cm^2)
Cm_scenarios = [Cm_base, Cm_base, Cm_base, Cm_base/10];    % Cm (F/cm^2)

results_V = cell(1, 4);
results_t = cell(1, 4);

fprintf('Starting Simulations...\n');

for s = 1:4
    r = R_scenarios(s);
    Rm = Rm_scenarios(s);
    Cm = Cm_scenarios(s);
    
    fprintf('  Running %s ... ', scenario_names{s});
    
    lambda = sqrt((r * Rm) / (2 * Ra_base)); % Length constant
    tau = Rm * Cm;                           % Time constant
    
    dt_sec = dt_base * 1e-3; 
    stability_factor = (dx^2 * tau) / (2 * lambda^2);
    
    if dt_sec >= stability_factor
        dt_safe = stability_factor * 0.9; % Safety margin
        dt = dt_safe * 1000; % Convert back to ms
        fprintf('[dt adjusted: %.4f ms] ', dt);
    else
        dt = dt_base;
    end
    
    t = 0:dt:T_total;
    Nt = length(t);
    dt_s = dt * 1e-3;
    
    diff_coeff = (dt_s / tau) * (lambda^2 / dx^2);
    decay_coeff = (dt_s / tau);
    
    V = zeros(Nt, Nx); 
    
    for n = 1:Nt-1
        V_old = V(n, :);
        V_new = V_old;

        for i = 2:Nx-1
            spatial_deriv = V_old(i+1) - 2*V_old(i) + V_old(i-1);
            V_new(i) = V_old(i) + diff_coeff * spatial_deriv - decay_coeff * V_old(i);
        end
        
        V_new(Nx) = V_new(Nx-1); % Sealed right end
        
        if t(n) <= stim_dur
            V_new(1) = V_pulse; 
        else
            V_new(1) = V_new(2); % Sealed end after pulse
        end
        
        V(n+1, :) = V_new;
    end
    
    results_V{s} = V;
    results_t{s} = t;
    fprintf('Done.\n');
end

figure('Name', 'Spatial Profiles', 'Color', 'w', 'Position', [50, 50, 1000, 700]);
snapshot_times = [0.5, 2, 5, 10]; % ms
plot_colors = lines(length(snapshot_times));

for s = 1:4
    subplot(2, 2, s);
    hold on;
    V_data = results_V{s};
    t_data = results_t{s};
    
    for k = 1:length(snapshot_times)
        [~, idx] = min(abs(t_data - snapshot_times(k)));
        if idx <= length(t_data)
            plot(x_plot, V_data(idx, :), 'Color', plot_colors(k,:), 'LineWidth', 2, ...
                'DisplayName', sprintf('t=%.1f ms', t_data(idx)));
        end
    end
    
    title(scenario_names{s}, 'FontWeight', 'bold');
    xlabel('Distance (\mum)');
    ylabel('Voltage (mV)');
    ylim([0 55]); grid on;
    if s==1 || s==2, legend('Location', 'northeast'); end
end

figure('Name', 'Comparison at Midpoint', 'Color', 'w', 'Position', [100, 100, 800, 400]);
mid_idx = round(Nx/2);
mid_dist_um = x_plot(mid_idx);

hold on;
styles = {'k', 'b--', 'r-.', 'g'};
for s = 1:4
    plot(results_t{s}, results_V{s}(:, mid_idx), styles{s}, ...
        'LineWidth', 2, 'DisplayName', scenario_names{s});
end
hold off;

title(['Voltage at Midpoint (x = ' num2str(mid_dist_um) ' \mum)']);
xlabel('Time (ms)'); ylabel('Voltage (mV)');
legend('Location', 'Best');
grid on; xlim([0 T_total]);