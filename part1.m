clc;
clear;
%--------------------------------------------------------------------------------------------
% AWGN channel simulation for QPSK
p = .25; % ML probability
number = 1e8; % number of how many points need to transmit
SNR = [0:3:15];

sigma = []; % noise
correct = []; % correct signal
error = []; % wrong signal 
for k = 1:6
    sigma(k) = 1. / (sqrt(10.^(SNR(k)/10))); % compute noise
    n1(k,:) = sigma(k)*randn(1, number); % the first dimension of noise
    n2(k,:) = sigma(k)*randn(1, number); % second dimension of noise
end %k
Z = rand(1, number); %generate 1e8 symbols which forms uniform distribution

p_e = []; % the probability of error signal

%QPSK signals
factor = sqrt(2) / 2; % distance
x1 = factor * [1 1]; % coordinates of each point
x2 = factor * [-1 1];
x3 = factor * [-1 -1];
x4 = factor * [1 -1];

% Y = X + N;
X = [];  % X is the transmit signal
t1 = [];
t2 = [];
y1 = []; % received signal
y2 = []; % received signal

for k = 1:6
    for i = 1:number
        if Z(i) < .25
            X = x1;
            y1(i) = X(1) + n1(k, i); % compute the recieved signals
            y2(i) = X(2) + n2(k, i);
            t1(i) = X(1);
            t2(i) = X(2);
        elseif Z(i) > .25 && Z(i) < .5
            X = x2;
            y1(i) = X(1) + n1(k, i);
            y2(i) = X(2) + n2(k, i);
            t1(i) = X(1);
            t2(i) = X(2);
        elseif Z(i) > .5 && Z(i) < .75
            X = x3;
            y1(i) = X(1) + n1(k, i);
            y2(i) = X(2) + n2(k, i);
            t1(i) = X(1);
            t2(i) = X(2);
        elseif Z(i) > .75 && Z(i) < 1
            X = x4;
            y1(i) = X(1) + n1(k, i);
            y2(i) = X(2) + n2(k, i);
            t1(i) = X(1);
            t2(i) = X(2);
        end   % if
    end % i

    %judge which region does Y exist
    s1 = [];
    s2 = [];
    for i = 1:number
        if y1(i) > 0 && y2(i) > 0
            s1(i) = x1(1);  % determine the received signals by using the constellation
            s2(i) = x1(2);
        elseif y1(i) < 0 && y2(i) > 0
            s1(i) = x2(1);
            s2(i) = x2(2);
        elseif y1(i) < 0 && y2(i) < 0
            s1(i) = x3(1);
            s2(i) = x3(2);
        elseif y1(i) > 0 && y2(i) < 0
            s1(i) = x4(1);
            s2(i) = x4(2);
        end % if 
    end % i
    correct(k) = 0; 
    error(k) = 0;
    for i = 1: number
        if (s1(i) == t1(i)) && (s2(i) == t2(i))
            correct(k) = correct(k) + 1; % correct situation
        else 
            error(k) = error(k) + 1; % wrong situation
        end % if
    end % i
    p_e(k) = error(k) / number; % compute experimental probability
end

%---------------------------------Theoretical -----------------------------------------------------------
delta = sqrt(2);
for k = 1:6 
    P_e(k) = 2.*qfunc(delta/(2*sigma(k))); %compute theoretical probability by using formula
end % k

figure;
simulation = semilogy(SNR, p_e, 'r--'); % plot simulation result
hold on;
theoretical = semilogy(SNR, P_e, 'b--'); % plot theoretical result
xlabel('SNR[dB]');
ylabel('Symbol Error Rate');
title('The symbol error rate over SNR[dB] for QPSK under AWGN channel.');
legend([simulation, theoretical], 'Experiment Simulation', 'Theoretical Performance', 'Location', 'southwest');





