function resourceGrid = createPbchFrame(caseLetter, absolutePointA, channelBandwidth, NCellId, MIB, SFN, symbolOffset, NCRBSSB, kSSB, powerFactor)
% creates one frame transmission of Physical Broadcast Channel (PBCH)

            arguments
                caseLetter char % freq. config case letter, see [38.213, 4.1]
                absolutePointA (1,1)  % absolute frequency Point A in GHZ
                channelBandwidth (1,1) % channel bandwidth in MHz
                NCellId (1,1) % cell identity number (0...1007)
                MIB (1,23) % 23 bit sequence
                SFN (1,1) % system frame number
                symbolOffset (1,1) % time-domain offset in symbols
                NCRBSSB(1,1) % frequency-domain offset from PointA in units of resource blocks assuming 15 kHz SCS
                kSSB (1,1) % frequency-domain offset from PointA in subcarriers assuming 15 kHz SCS (0...23)
                powerFactor (1,4) = [1 1 1 1] % power allocation scaling factor [<pss> <ss> <pbch> <dmrs>]
            end
            
            % Get resource grid configuration
            config = caseConfiguration(caseLetter,absolutePointA);

            % Create resource grid
            rg=ResourceGrid(channelBandwidth,config.mu);
        
            % Create SS/PBCH burst
            ss = SsSignals(NCellId);
            ssPbchBurst = zeros(240,2^config.mu*14*10);
            M = 864; % length of generated PBCH bit sequence
            c = pseudoRandomSequence(NCellId,M*config.Lmax_); % sequence for PBCH scrambling
            
            for HRF=0:1 % for each half radio frame
                iSSB = 0; % = 0...Lmax_-1
                HRFSymbolShift = HRF*2^config.mu*7*10;
                for shift = (config.blockIndexes+HRFSymbolShift) % for each block in one HRF
                    
                    % PBCH generation [38.212, 7.1]
                    ssPbchParam = kSSB*(config.Lmax_~=64)+iSSB*(config.Lmax_==64); % selecting kSSB or iSSB
                    pbch = generatePbch(MIB,SFN,HRF,config.Lmax_,ssPbchParam,NCellId);
                    % PBCH scrambling [38.211, 7.3.3.1]
                    pbch(1:M) = mod(pbch(1:M)+ c((1:M)+iSSB*M),2); % iSSB = nu
                    % PBCH modulation [38.211, 7.3.3.2]
                    pbch = qpskModulation(pbch);
                    
                    % Dm-Rs Generation
                    iSSB_ = iSSB + 4*HRF*(config.Lmax_ == 4);
                    dmrs = generatePbchDmRs(iSSB_,NCellId);
                    
                    % block creation
                    ssPbchBurst(1:240,(1:4)+shift) = createSsPbchBlock(ss,pbch,dmrs,NCellId,powerFactor);
                    iSSB=iSSB+1;

                end
            end
            
            % mapping onto resource grid
            subcarrierOffset = (12*NCRBSSB+kSSB)*2^(-config.mu);
            rg.mapToResourceGrid(ssPbchBurst, symbolOffset, subcarrierOffset);
            resourceGrid = rg.resourceGrid;
end