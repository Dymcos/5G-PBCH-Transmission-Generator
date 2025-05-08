%% Initialization
clc; clear all; close all;
addpath("Transmitter\");
out = [];

% Setup following data: ————————————————————————————————————————————————————
    SFN = 55; % initial frame number
    caseLetter = 'B'; % freq. config case letter, see [38.213, 4.1] // only {'A', 'B', 'C'} are supported
    NCRBSSB = 80; % number of common resource block with first subcarrier of SS/PBCH block expressed in 15 kHz SCS units
    kSSB = 6; % 0...23 (recalculates to 0...15 for case 'A')
    NCellId = 680; % 0...1007
    channelBandwidth = 50;
    subframesAmount = 5; % determines signals' length
    fs = 50e6; % signals' samplerate
    dmrsTypeAPos = randi([0 1], [1 1]);
    SIB1 = randi([0 1], [1 8]);
    cellBarred = randi([0 1], [1 1]);
    intraFreqReselection = randi([0 1], [1 1]);
% end data setupping    ————————————————————————————————————————————————————


carrierFrequency = 4; %GHz
conf = caseConfiguration(caseLetter,carrierFrequency,1,0);
kSSB = mod(kSSB, 12 * 2^conf.mu); 
subCarrierSpacingCommon = ~(caseLetter == 'A');
MIB = defineMib(SFN , subCarrierSpacingCommon, kSSB, dmrsTypeAPos, SIB1, cellBarred , intraFreqReselection);
rg = ResourceGrid(1,channelBandwidth,conf.mu);
NSizeGrid = length(rg.resourceGrid(:,1))/12;
duration = subframesAmount * 1e-3;

%% 5G-PBCH-Transmission-Generator waveform

waveform = pbchSignalGenerator(fs,duration,mod(SFN,16),0,caseLetter,NCRBSSB, bitget(kSSB,5),carrierFrequency,channelBandwidth,NCellId,MIB);

%% MATLAB 5G Toolbox waveform

[matlwave, matlFs] = useMATLABgenerator(channelBandwidth, NCellId, subframesAmount, SFN * 10, fs, conf.scs, NSizeGrid, ...
    'normal',strcat("Case ",caseLetter),NCRBSSB,kSSB,[0 MIB]);

val = max(abs(xcorr(waveform,matlwave.' ,"normalized")));
disp(strcat("Maximum value of normalized waveforms' correlation is ",num2str(val)))


waveform = waveform / max(abs(waveform));
matlwave = matlwave / max (abs(matlwave));
wavespec = fft(waveform);
matlspec = fft(matlwave);

if val <0.6
[val, idx] = max(abs(xcorr(wavespec,matlspec.' ,"normalized")));
disp(strcat("Maximum value of normalized spectrums' correlation is ", num2str(val)))
disp(strcat("Frequency shift between two spectrums is ", num2str(abs(idx-length(waveform))*fs/length(waveform)),  " Hz"))
end

% Out painting
figure

subplot(3,1,1)
plot(real(waveform))
title("Real part of model's waveform")

subplot(3,1,2)
plot(real(matlwave))
title("Real part of MATLAB waveform")

subplot(3,1,3)
plot(abs(xcorr(waveform,matlwave.' ,"normalized")))
title("Abs of waveforms' correlation function")
