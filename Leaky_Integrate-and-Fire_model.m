% =============================================================================
% Author: Christian Danilo Arroyo Herrera
% Module: Neural Computing — University of Lincoln, School of Computer Science
% Assessment: 1 | Academic Year 2025/2026
% This code is the author's own original work submitted as a university assessment.
% AUTHOR_FINGERPRINT: Q2hyaXN0aWFuIERhbmlsbyBBcnJveW8gSGVycmVyYXxjYXJyb3lvaGVycmVyYUBnbWFpbC5jb20=
% =============================================================================

% Part 1A: The Single Cell (LIF Model)

clear; clc; close all;

tau_m = 10;         % Membrane time constant (ms)
R = 10;             % Membrane resistance (MOhms)
V_rest = -65;       % Resting potential (mV)
V_th = -50;         % Spike threshold (mV)
V_reset = -70;      % Reset potential after spike (mV)
ref_period = 5;     % Refractory period (ms)

dt = 0.01;          % Time step (ms)
T = 100;            % Total simulation duration (ms)
time = 0:dt:T;      % Time vector

% Test different inputs: 0.5, 1, 2, 5 nA
I_in = 1;           
I_ext = I_in * ones(size(time)); 

V = V_rest * ones(size(time)); % Voltage vector
spikes = zeros(size(time));    % Spike raster
ref_timer = 0;                 % Refractory period timer

for t = 1:length(time)-1
    if ref_timer > 0
        V(t+1) = V_reset;
        ref_timer = ref_timer - dt;
    else
        dV = (-(V(t) - V_rest) + R * I_ext(t)) / tau_m;
        
        V(t+1) = V(t) + dV * dt;
        
        if V(t+1) >= V_th
            V(t+1) = 20;        % Artificial spike peak for visualization (mV)
            spikes(t+1) = 1;    % Record spike event
            ref_timer = ref_period; % Start refractory countdown
        end
    end
end

figure('Color','w', 'Position', [100, 100, 1000, 600]);

subplot(2,1,1);
plot(time, V, 'k', 'LineWidth', 1.5); hold on;
yline(V_th, '--r', 'Threshold (-50mV)', 'LineWidth', 1.2);
yline(V_rest, ':b', 'Resting (-65mV)', 'LineWidth', 1.2);
title(['LIF Dynamics (Input Current = ' num2str(I_in) ' nA)']);
ylabel('Potential (mV)');
xlabel('Time (ms)');
grid on;
ylim([-80 30]); 

subplot(2,1,2);
stem(time, spikes, 'Color', [0.2 0.2 0.2], 'Marker', 'none', 'LineWidth', 1.5);
title('Spike Train');
ylabel('Spike Event');
xlabel('Time (ms)');
ylim([0 1.5]); set(gca, 'YTick', []);
grid on;