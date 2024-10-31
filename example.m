%% Initializing

clc; clear all; close all;

SFN = 0;
MIB = defineMib(0, SFN ,0,0 , 0,[0 1 0 1 1 0 0 1] ,0 ,0);
NCRBSSB = 20;
kSSB = 5;
NCellId = 250;
symbolOffset = 20;
subcarrierOffset = NCRBSSB*12+kSSB;

config = caseConfiguration("C",4,1,0);

%% Create frame
rg = createPbchFrame('C', 4, 50, NCellId, MIB, SFN, symbolOffset, NCRBSSB, kSSB,[1 0.9 0.8 0.7]);

%% Resource grid painting
figure
plt = pcolor(abs(rg));
plt.EdgeColor = "none";
xlabel ('OFDM symbols');
ylabel  ("subcarriers");