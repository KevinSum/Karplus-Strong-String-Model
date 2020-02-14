function output = loop( delayLine, noteLength, gain, fc, fs)

%This function outputs a karplus strong note sound based on the input
%parameters - 
%karplus(delay line/excitation signal, length of sound, feedback gain, cutoff frequency) 

% Get length of the input delay line
L = length(delayLine);

% Output
output = zeros(1,L);

% 2nd Order Low pass filter coefficients
k = tan(pi*fc/fs);
b0 = k^2/(1+sqrt(2)*k + k^2);
b1 = 2*k^2/(1 + sqrt(2)*k + k^2);
b2 = k^2/(1+sqrt(2)*k + k^2);
a1 = 2*(k^2-1)/(1+sqrt(2)*k + k^2);
a2 = (1-sqrt(2)*k + k^2)/(1+sqrt(2)*k + k^2);

% Arrays to store previous filter inputs and outputs
x = [0 0];
y = [0 0];

for n = 1:noteLength
    % Set current output sample to the final value in the delay line
    output(n) = delayLine(L);
    
    % Low Pass Filter
    filterOutput = b0*delayLine(L) + b1*x(1) + b2*x(2) - a1*y(1) - a2*y(2);
    
    % Feedback gain
    filterOutput = filterOutput * gain; 

    %Save current filter input and output values to use as the "previous" values for the next loop
    x = [delayLine(L) x(1)];
    y = [filterOutput y(1)];
    
    % Shift delay_line wave one step right
    delayLine = [filterOutput, delayLine(1:L-1)];
end