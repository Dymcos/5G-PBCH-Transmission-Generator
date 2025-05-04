%% Initializing

clc; clear all; close all;

config = caseConfiguration("C",4,1,0);

channelBandwidth = 50;
SFN = 6;
MIB = defineMib(SFN ,0,0 , 0,[0 1 0 1 1 0 0 1] ,0 ,0);
NCRBSSB = 10; % number of common resource block containing first subcarrier of SS/PBCH block expressed in units assuming 15 kHz SCS (= offsetToPointA)
kSSB = 20; % offset to subcarrier 0 in NCRBSSB resource block expressed in subcarriers assuming 15 kHz SCS
NCellId = 250;
symbolOffset = 0;
subcarrierOffset = (NCRBSSB*12+kSSB)*2^-config.mu; % subcarrier offset
NGridStart = 0; % the number of common resource block where the grid starts

fs = 50e6;

%% Create frame
rg = createPbchFrame('B', 4, channelBandwidth, NCellId, MIB, SFN, symbolOffset, NCRBSSB, kSSB,[1 0.9 0.8 0.7]);

%% Resource grid painting
figure
plt = pcolor(abs(rg));
plt.EdgeColor = "none";
xlabel ('OFDM symbols');
ylabel  ("Subcarriers");

%% Signal generator

%waveform = ofdmSignalGenerator(fs,rg(:,1:280),channelBandwidth,NGridStart,config,0);
waveform = generatePbchSignal(fs,50e-3,mod(SFN,16),1,'B',NCRBSSB,floor(mod(kSSB,16)/8),4,channelBandwidth,NCellId,MIB,0);

%% Signal painting
figure Name OFDM

samples = 1:length(waveform);
plot(samples, real(waveform));
tickShift = floor(length(waveform)/(50));
tickVals = tickShift * (0:floor(length(waveform)/tickShift));
xticks(tickVals)
xValsPrecision = 0.001;
xValsUnits = 1e-3; % for ms
xticklabels(num2str([ceil((tickVals/fs / xValsUnits / xValsPrecision).') * xValsPrecision]))
xlabel('t, ms')
ylabel('Re[s(t)]');
disp('DONE');
