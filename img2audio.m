%%This is a file that converts image into sound for transmission
i = imread('baby.jpg');
i = imresize(i, [480, 320]);
ibw = rgb2gray(i);
[ir, ig, ib] = imsplit(i);

%% Section to show the generated images
% figure
% subplot(2, 2, 1), imshow(ibw);
% subplot(2, 2, 2), imshow(ir);
% subplot(2, 2, 3), imshow(ib);
% subplot(2, 2, 4), imshow(ig);
%%
%Use the black and white image to generate the encoded data
f_start = 200;
f_end = 10200;
f_period = (f_end - f_start) / 320;
fs = 144000;
t = linspace(0, 0.25, fs);
separator = sin(2 * pi * 1000 * t/4);
final_encoded_signal = separator;
sample = ibw(152, :);
freq_array = 0;
freq = 0;
freq_temp = 0;
iteration_counter = 0;
for row_counter = 1:480
    sample = ibw(row_counter, :);
    for frequency = f_start : f_period : (f_end - f_period)
        freq_array(uint8(frequency / f_period)) = frequency;
        freq = freq + double(sample(uint8(frequency / f_period))) * sin(2 * pi * frequency * t);
    end
    final_encoded_signal = [final_encoded_signal separator freq];
    iteration_counter = iteration_counter + 1;
    disp(iteration_counter);
end
%%
%Plotting the frequency components of the generated signal
f = fft(freq);
n = length(freq);
x = (1:n);
y = fftshift(f);
power = abs(f).^2/n;

figure
subplot(1, 2, 1), plot(sample)
subplot(1, 2, 2), plot((1:10200), power(1:10200))
