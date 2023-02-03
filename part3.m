clc;
clear;
SNR = [0:3:15]; % SNR RANGE
load('Task1_QPSK_BER.mat'); % load the simulation data of QPSK
load('task_4PAM_BER.mat'); % load the simulation data of 4PAM

figure;
QPSK = semilogy(SNR, p_e, 'r--'); % plot of QPSK
hold on;
PAM = semilogy(SNR, p_e_4PAM, 'b'); % plot of PAM
xlabel('SNR[dB]');
ylabel('Symbol Error Rate');
title('The symbol error rate over SNR[dB] for QPSK and 4-PAM under AWGN channel.');
legend([QPSK, PAM], 'QPSK', '4-PAM', 'Location', 'southwest');

