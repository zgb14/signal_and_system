%%prepare process
%the basic frequency is f_low_do
f_low_do = 174.61;
%K is the step parameter between two frequencies
K = 2^(1/12);
%Fs is pot rate
Fs = 8000;
frequency = zeros(2 , 12);
frequency(1 , 1) = f_low_do;
for i = 2 : 12
    frequency(1 , i) = frequency(1 , i-1)*K;
end
i = 1 : 12;
frequency(2 , i) = frequency(1 , i) * 2;

f_basic = frequency(2 , 1);
frequency_step = zeros(1 , 14);
for j = 1 : 2
    i = 1 : 3;
    frequency_step(1 , i + 7 * (j - 1)) = frequency(j , 2 * i - 1);
    frequency_step(1 , 4 + 7 * (j - 1)) = frequency(j , 6);
    i = 5 : 7;
    frequency_step(1 , i + 7 * (j - 1)) = frequency(j , 2 * i - 2);
end
%下面代表音调的矩阵中每一个元素代表一个八分音符
length = 16;
dfh = [ 12 , 12 , 12 , 13 ,  9 , 9 , 9 , 9 , 8 , 8 , 8 , 6 , 9 , 9 , 9 , 9 ];
t1 = 1 : length * Fs/4;
t1(1 : Fs/2) = (1 : Fs/2) .* 2/Fs;
t1(Fs/2 + 1 : Fs * 3/4) = (1 : Fs/4) .* 4/Fs;
t1(Fs * 3/4 + 1 : Fs) = (1 : Fs/4) .* 4/Fs;
t1(Fs + 1 : 2 * Fs) = (1 : Fs) .* 1/Fs;
t1(2 * Fs + 1 : 2 * Fs + Fs/2) = (1 : Fs/2) .* 2/Fs;
t1(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = (1 : Fs/4) .* 4/Fs;
t1(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) = (1 : Fs/4) .* 4/Fs;
t1(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) = (1 : Fs) .* 1/Fs;
y1(1 : Fs/2) = sin(2 * 2 * pi * frequency_step(dfh(1)) * t1(1 : Fs/2));
y1(Fs/2 + 1 : Fs * 3/4) = sin(2 * pi * frequency_step(dfh(3)) * t1(Fs/2 + 1 : Fs * 3/4));
y1(Fs * 3/4 + 1 : Fs) = sin(2 * pi * frequency_step(dfh(4)) * t1(Fs * 3/4 + 1 : Fs));
y1(Fs + 1 : 2 * Fs) = sin(4 * 2 * pi * frequency_step(dfh(5)) * t1(Fs + 1 : 2 * Fs));

y1(2 * Fs + 1 : 2 * Fs + Fs/2) = sin(2 * 2 * pi * frequency_step(dfh(9)) * t1(2 * Fs + 1 : 2 * Fs + Fs/2));
y1(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = sin(2 * pi * frequency_step(dfh(11)) * t1(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4));
y1(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) = sin(2 * pi * frequency_step(dfh(12)) * t1(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs));
y1(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) = sin(4 * 2 * pi * frequency_step(dfh(13)) * t1(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs));
sound(y1 , Fs);
save dongfanghong.mat frequency_step t1 y1 Fs dfh;
save frequency.mat frequency frequency_step K Fs;