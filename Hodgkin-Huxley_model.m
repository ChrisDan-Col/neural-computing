% =============================================================================
% Author: Christian Danilo Arroyo Herrera
% Module: Neural Computing — University of Lincoln, School of Computer Science
% Assessment: 1 | Academic Year 2025/2026
% This code is the author's own original work submitted as a university assessment.
% AUTHOR_FINGERPRINT: Q2hyaXN0aWFuIERhbmlsbyBBcnJveW8gSGVycmVyYXxjYXJyb3lvaGVycmVyYUBnbWFpbC5jb20=
% =============================================================================

% Part 1B: Hodgkin-Huxley Model

clear; clc; close all;

C_m = 1.0;    % Membrane capacitance (uF/cm^2)
g_Na = 60.0; % Max Sodium conductance (mS/cm^2)
g_K = 36.0;   % Max Potassium conductance (mS/cm^2)
g_L = 0.3;    % Leak conductance (mS/cm^2)
E_Na = 50;    % Sodium reversal potential (mV)
E_K = -77;    % Potassium reversal potential (mV)
E_L = -54.4;  % Leak reversal potential (mV)
V_rest = -65; % Resting potential (mV)

dt = 0.01;  % Time step (ms)
T = 30;     % Simulation duration (ms)
time = 0:dt:T;

I_ext = zeros(size(time));
I_ext(time >= 5 & time <= 6) = 10; 

V = V_rest * ones(size(time));
m = 0.05;   % Sodium activation gate
h = 0.6;    % Sodium inactivation gate
n = 0.32;   % Potassium activation gate

m_val = zeros(size(time));
h_val = zeros(size(time));
n_val = zeros(size(time));

alpha_n = @(v) 0.01 * (v + 55) / (1 - exp(-(v + 55) / 10));
beta_n  = @(v) 0.125 * exp(-(v + 65) / 80);
alpha_m = @(v) 0.1 * (v + 40) / (1 - exp(-(v + 40) / 10));
beta_m  = @(v) 4 * exp(-(v + 65) / 18);
alpha_h = @(v) 0.07 * exp(-(v + 65) / 20);
beta_h  = @(v) 1 / (1 + exp(-(v + 35) / 10));

for t = 2:length(time)
    v_prev = V(t-1);
    
    m = m + dt * (alpha_m(v_prev) * (1 - m) - beta_m(v_prev) * m);
    h = h + dt * (alpha_h(v_prev) * (1 - h) - beta_h(v_prev) * h);
    n = n + dt * (alpha_n(v_prev) * (1 - n) - beta_n(v_prev) * n);
    
    INa = g_Na * (m^3) * h * (v_prev - E_Na);
    IK  = g_K  * (n^4)     * (v_prev - E_K);
    IL  = g_L              * (v_prev - E_L);
    
    V(t) = v_prev + dt * (I_ext(t) - (INa + IK + IL)) / C_m;
    
    m_val(t)=m; h_val(t)=h; n_val(t)=n;
end

figure('Color','w', 'Position', [100, 100, 800, 700]);

subplot(3,1,1);
area(time, I_ext, 'FaceColor', [0.8 0.8 0.8]);
ylabel('Current (\muA/cm^2)');
title('Input Stimulus');
grid on;

subplot(3,1,2);
plot(time, V, 'k', 'LineWidth', 2);
ylabel('Voltage (mV)');
title('Action Potential');
grid on;

subplot(3,1,3);
plot(time, m_val, 'r', 'LineWidth', 1.5); hold on;
plot(time, h_val, 'g', 'LineWidth', 1.5);
plot(time, n_val, 'b', 'LineWidth', 1.5);
legend('m (Na activ)', 'h (Na inactiv)', 'n (K activ)');
xlabel('Time (ms)');
title('Channel Gating Dynamics');
grid on;