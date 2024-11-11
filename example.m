%% Initializing

clc; clear all; close all;

config = caseConfiguration("C",4,1,0);

SFN = 0;
MIB = defineMib(0, SFN ,0,0 , 0,[0 1 0 1 1 0 0 1] ,0 ,0);
NCRBSSB = 10; % number of common resource block containing first subcarrier of SS/PBCH block expressed in units assuming 15 kHz SCS (= offsetToPointA)
kSSB = 20; % offset to subcarrier 0 in NCRBSSB resource block expressed in subcarriers assuming 15 kHz SCS
NCellId = 250;
symbolOffset = 20;
subcarrierOffset = (NCRBSSB*12+kSSB)*2^-config.mu; % subcarrier offset
NGridStart = 0; % the number of common resource block where the grid starts

%% Create frame
rg = createPbchFrame('C', 4, 50, NCellId, MIB, SFN, symbolOffset, NCRBSSB, kSSB,[1 0.9 0.8 0.7]);

%timeSignal = ofdmSignalGenerator(rg,NGridStart,config,0,60e6);

%% Resource grid painting
figure
plt = pcolor(abs(rg));
plt.EdgeColor = "none";
xlabel ('OFDM symbols');
ylabel  ("subcarriers");