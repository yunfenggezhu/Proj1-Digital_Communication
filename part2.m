clc;
clear;
%--------------------------------------------------------------------------------------------
% AWGN channel simulation for 4-PAM
p = .25; % ML probability
number = 1e8; % generate enough symbols
delta = sqrt(.8);
SNR = [0:3:15]; % SNR range
sigma = []; 
correct = [];
error = [];
for k = 1:6
    sigma(k) = 1. / (sqrt(10.^(SNR(k)/10)));  % compute noise
    n(k, :) = sigma(k)*randn(1, number);
end % k
Z = rand(1, number); %generate 1e8 symbols which forms uniform distribution

p_e_4PAM = []; % error probability of 4PAM

%4PAM signals
x1 = -1.5 * delta; % coordinates of the symbols
x2 = -.5 * delta;
x3 = .5 * delta;
x4 = 1.5 * delta;

% Y = X + N;
X = [];  % X is the transmit signal
Y = [];
S = []; % which is the x hat
for k = 1:6
    for i = 1:number
        if Z(i) < .25
            X(i) = x1;
            Y(i) = x1 + n(k, i); % compute received signals
        elseif Z(i) > .25 && Z(i) < .5
            X(i) = x2;
            Y(i) = x2 + n(k, i);
        elseif Z(i) > .5 && Z(i) < .75
            X(i) = x3;
            Y(i) = x3 + n(k, i);
        elseif Z(i) > .75 && Z(i) < 1
            X(i) = x4;
            Y(i) = x4 + n(k, i);
        end    % if
    end % i

    %judge which region does Y exist
    for i = 1:number
        if Y(i) < -delta
            S(i) = x1; % determine which region is the received signal, by the constellation
        elseif Y(i) < 0 && Y(i) > -delta
            S(i) = x2;
        elseif Y(i) > 0 && Y(i) < delta
            S(i) = x3;
        elseif Y(i) > delta 
            S(i) = x4;
        end % if
    end % i
    correct(k) = 0;
    error(k) = 0;
    for i = 1: number
        if (X(i) == S(i))
            correct(k) = correct(k) + 1; % correct situation
        else
            error(k) = error(k) + 1; % wrong situation
        end % if
    end % i
    p_e_4PAM(k) = error(k) / number; % probability of 4PAM
end % k

%---------------------------------Theoretical -----------------------------------------------------------
for k = 1:6
    P_e(k) = 1.5.*qfunc(delta/(2*sigma(k))); % theoretical value by using formula
end % k

figure;
simulation = semilogy(SNR, p_e_4PAM, 'r--'); % plot of simulation
hold on;
theoretical = semilogy(SNR, P_e, 'b*'); % plot of theoretical
xlabel('SNR[dB]');
ylabel('Symbol Error Rate');
title('The symbol error rate over SNR[dB]for 4-PAM under AWGN channel.');
legend([simulation, theoretical], 'Experiment Simulation', 'Theoretical Performance', 'Location', 'southwest');


