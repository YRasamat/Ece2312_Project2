%% ECE2312
%%Project 2
%%William Gerlach & Yonik Rasamat


% Constants
sr = 44100; % Sampling rate in Hz
duration = 5; % Duration in seconds (same as the speech file)
frequency = 5000; % Frequency of the sine tone in Hz

% Calculate the number of samples needed
numSamples = duration * sr;

% Generate the time vector
t = linspace(0, duration, numSamples);
%% Part 1: Sine Wav Generation
% Generate the sine wave
sineWave = sin(2 * pi * frequency * t);

% Play the sine tone
sound(sineWave, sr);

% Save the sine tone to a WAV file
filename = 'Will&Yonik-sinetone.wav'; 
audiowrite(filename, sineWave, sr);


window_size= 256;
% Plot the spectrogram
spectrogram(sineWave,window_size, 128, 512, sr, 'yaxis');
title('Spectrogram of Sine Tone @ 5000 Hz');
ylim([0 8]);
%% Part 2: Chirp Generation

%Chirp signal generation

freqStart = 0;
freqEnd = 8000;

%using matlab's built in 'chirp' function
%'linear' is to increase chirp linearly with time
chirp8k = chirp(t,freqStart, duration, freqEnd, 'linear');

%play chirp signal
sound(chirp8k, sr);

%save to WAV file

filename = 'Will&Yonik-chirp.wav';
audiowrite(filename, chirp8k, sr)

window_size= 256;
% Plot the spectrogram
spectrogram(chirp8k,window_size, 128, 512, sr, 'yaxis');
title('Spectrogram of Chirp Signal, 0-8 kHz');
ylim([0 8]);
%% Part 3:CETK Audio Signal
% 
cetkFreq = [1174.66, 1318.51, 1046.50, 523.25, 783.99]; 
t = linspace(0, 1, sr);
for c = 1:5
    sineWave(c,:) = sin(2 * pi * cetkFreq(:,c) * t);
end
cetkFinal = [sineWave(1,:),sineWave(2,:), sineWave(3,:), sineWave(4,:), sineWave(5,:)];
sound(cetkFinal, sr);
audiowrite('Will&Yonik-CETK.wav', cetfFinal, sr);

spectrogram(cetfFinal,window_size, 128, 512, sr, 'yaxis')
ylim([0 4]);
t = linspace(0, duration, sr);
%% Part 4: Combining sound files


QBFdata = audioread('quick_brown_fox.wav');
QBFdata = QBFdata.';
speechChirp = QBFdata + sineWave;

%need to normalize the audio data, 
% "Warning: Data Clipped when writing file"

max_amplitude = max(abs(speechChirp));

if max_amplitude > 1
    speechChirp = speechChirp / max_amplitude; 
end


sound(speechChirp, sr);

filename = 'Will&Yonik-speechchirp.wav';
audiowrite(filename, speechChirp, sr);

window_size= 256;
% Plot the spectrogram
spectrogram(speechChirp,window_size, 128, 512, sr, 'yaxis');
axis xy;
title('Spectrogram of Speech + Sin');
ylabel("Frequency");
ylim([0 8]);

%% Part 5: Speech and audio Filtering
%define cutoff frequency
wc= 4000;

%lowpass filter- butterworth 
order=30;
[b, a] = butter(order, wc/(sr/2), 'low');

butteredSignal=filter(b, a, speechChirp);


%need to normalize the audio data, 
% "Warning: Data Clipped when writing file"

max_amplitude = max(abs(butteredSignal));

if max_amplitude > 1
     butteredSignal = butteredSignal / max_amplitude; 
end

sound(butteredSignal,sr);
filename = 'Will&Yonik-filteredspeechsine.wav'; 
audiowrite(filename, butteredSignal, sr);

% Plot the spectrogram
spectrogram(butteredSignal,window_size, 128, 512, sr, 'yaxis');
title('Spectrogram of Filtered Speech + Sin');
ylim([0 8]);





%% Part 6: Stereo Fun

rightChannel = speechChirp;

leftChannel = QBFdata;

stereoFun = [leftChannel', rightChannel'];

sound(stereoFun, sr);
filename = 'Will&Yonik-stereospeechsine.wav'; 
audiowrite(filename, stereoFun, sr);

%% Spectrograms of said channels
window_size = 256;
figure;
subplot(1,2,1);
spectrogram(leftChannel,window_size,  128, 512, sr, 'yaxis');
title('Left Channel Spectrogram');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

ylim([0 8]);

subplot(1,2,2);
spectrogram(rightChannel, window_size, 128, 512, sr, 'yaxis');
title('Right Channel Spectrogram');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

ylim([0 8]);

hold off