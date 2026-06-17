% =============================================================================
% Author: Christian Danilo Arroyo Herrera
% Module: Neural Computing — University of Lincoln, School of Computer Science
% Assessment: 1 | Academic Year 2025/2026
% This code is the author's own original work submitted as a university assessment.
% AUTHOR_FINGERPRINT: Q2hyaXN0aWFuIERhbmlsbyBBcnJveW8gSGVycmVyYXxjYXJyb3lvaGVycmVyYUBnbWFpbC5jb20=
% =============================================================================

% Part 3: Networks & Cognition

clear; clc; close all;

N_neurons = 5;
dt = 0.1;
T_sim = 500; % ms
steps = T_sim/dt;
time = 0:dt:T_sim-dt;

tau = 10;
R = 10; 
V_rest = -65;
V_th = -50;
V_reset = -70;

% Weight Matrix
% Scenario 1: Fully Excitatory
W = rand(N_neurons) * 0.5; 

% Scenario 2: Mixed (Excitatory/Inhibitory)
%W = randn(N_neurons) * 0.5; % Gaussian (+ and - values)

W(1:N_neurons+1:end) = 0;

freq = 10; % Hz
amp = 2;   % nA
noise_amp = 5; 
I_input = amp * sin(2*pi*freq*time/1000) + noise_amp * randn(N_neurons, steps);

V = zeros(N_neurons, steps) + V_rest;
spikes = zeros(N_neurons, steps);

for t = 1:steps-1
    I_syn = sum(W .* spikes(:, t)', 2) * 20; % Gain factor 20
    
    I_total = I_input(:, t) + I_syn;
    
    dV = (-(V(:, t) - V_rest) + R * I_total) / tau;
    V(:, t+1) = V(:, t) + dV * dt;
    
    did_spike = V(:, t+1) >= V_th;
    spikes(did_spike, t+1) = 1;
    V(did_spike, t+1) = V_reset;
end

figure('Name', 'Part 3A: Network Activity', 'Color', 'w');
subplot(2,1,1);
[row, col] = find(spikes);
plot(col*dt, row, 'k.', 'MarkerSize', 12);
ylim([0 N_neurons+1]);
title('Raster Plot');
xlabel('Time (ms)'); ylabel('Neuron #');
grid on;

subplot(2,1,2);
firing_rates = movmean(spikes, 50, 2); 
imagesc(corrcoef(firing_rates'));
colorbar;
title('Correlation Matrix');
xlabel('Neuron #'); ylabel('Neuron #');


steps_ltp = 1000;
pre_spikes = double(rand(1, steps_ltp) > 0.9); 

calcium = 0;
calcium_decay = 0.95;
w = 0.5;                % Initial weight
w_history = zeros(1, steps_ltp);
Ca_history = zeros(1, steps_ltp);
Ca_threshold = 2.0;     % LTP threshold

for t = 1:steps_ltp
    if pre_spikes(t) == 1
        calcium = calcium + 1; 
    end
    
    calcium = calcium * calcium_decay;
    
    if calcium > Ca_threshold
        w = w + 0.005; 
    end
    
    w_history(t) = w;
    Ca_history(t) = calcium;
end

figure('Name', 'Part 3B: Synaptic Plasticity', 'Color', 'w');
subplot(2,1,1);
plot(Ca_history, 'b', 'LineWidth', 1.5);
yline(Ca_threshold, 'r--', 'LTP Threshold');
title('Post-Synaptic Calcium');
ylabel('[Ca^{2+}]'); grid on;

subplot(2,1,2);
plot(w_history, 'k', 'LineWidth', 2);
title('Synaptic Weight Evolution');
xlabel('Time Steps'); ylabel('Weight (w)');
grid on;


input_horizontal = [0 0 0; 1 1 1; 0 0 0]; 
input_vertical   = [0 1 0; 0 1 0; 0 1 0]; 

W_horz_detector = [0 0 0; 1 1 1; 0 0 0]; 
W_vert_detector = [0 1 0; 0 1 0; 0 1 0];

% Disease Simulation (Neurodegeneration)
% disease_noise = randn(3,3) * 0.5; W_horz_detector = W_horz_detector + disease_noise;

response_H_neuron = sum(sum(input_horizontal .* W_horz_detector));
response_V_neuron = sum(sum(input_horizontal .* W_vert_detector));

figure('Name', 'Part 3C: Edge Detection', 'Color', 'w');

subplot(2,2,1);
imagesc(input_horizontal); title('Visual Input'); axis off;

subplot(2,2,2);
bar([response_H_neuron, response_V_neuron]);
xticklabels({'Horz Neuron', 'Vert Neuron'});
title('Network Response');
ylabel('Firing Rate');
grid on;