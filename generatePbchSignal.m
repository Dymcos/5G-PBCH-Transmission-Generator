function waveform = generatePbchSignal(...
    fs, ...
    duration, ...
    startFrame, ...
    startHRF, ...
    caseLetter, ...
    NCRBSSB, ...
    SSB, ...
    absolutePointA, ...
    channelBandwidth, ...
    NCellId, ...
    MIB, ...
    isCpExtended, ...
    powerFactor...
    )
%GENERATEPBCHSIGNAL The function creates time-domain 5G NR PBCH signal
%   Detailed explanation goes here
    arguments
        fs (1,1) {mustBePositive} % sample rate in Hz
        duration (1,1) {mustBePositive} % waveform's duration in seconds
        startFrame (1,1) {mustBeMember(startFrame, 1:15)} % integer
        startHRF (1,1) {mustBeMember(startHRF, [0 1])} % bit
        caseLetter
        NCRBSSB (1,1)
        SSB (1,1) % bit for Lmax_ = 4 or 8
        absolutePointA
        channelBandwidth
        NCellId (1,1)
        MIB
        isCpExtended
        powerFactor {mustBeVector} = [1 1 1 1]
    end
    startFrame = startFrame + bit2int([MIB(1:6) 0 0 0 0].',10);
    config = caseConfiguration(caseLetter, absolutePointA);
    kSSB = bit2int([MIB(8:10)].',3);
    if ismember(config.Lmax_, [4 8])
        kSSB = kSSB + bit2int([SSB 0 0 0].', 4);
    end
    HRF_DURATION = 5e-3;
    HRFsAmount = ceil(duration / HRF_DURATION);
    wavetable = zeros(2*floor(HRF_DURATION * fs), HRFsAmount);
    for absoluteHRFindex = 0:HRFsAmount-1
        HRF = mod(absoluteHRFindex + startHRF,2);
        SFN = startFrame + floor((absoluteHRFindex + startHRF) / 2);
        rg = createPbchHalfFrame(caseLetter, absolutePointA, channelBandwidth, NCellId, MIB, SFN, HRF, NCRBSSB, kSSB,powerFactor);
        wavetable(:, absoluteHRFindex +1) = ofdmSignalGenerator(fs, rg, channelBandwidth, 0, config, isCpExtended).';
    end
    waveform = reshape(wavetable,[1 length(wavetable(:,1))*length(wavetable(1,:))]);
end

