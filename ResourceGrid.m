classdef ResourceGrid<handle
    properties
        resourceGrid
        % main grid
        mu
        % subcarrier spacing cofiguration (Δf=2^mu*15 [kHz])
    end
    methods 
        function obj = ResourceGrid(channelBandwidth,mu)
            % createResourceGrid
            % creates empty Resource grid for this
            % configuration [38.211, 4.3.2] or wipes
            % all data in the grid
            arguments
                channelBandwidth (1,1) % channel bandwidth, MHz see [38.101-1: Table 5.3.2-1]
                mu % case configuration structure, see [38.213, 4.1]
            end
            obj.mu = mu;
            ResourceGridConstants;
            NRBSeq=MaximumTransmissionBandwidthConfiguration(2^mu*15); % 2^mu*15 = SCS
            NRB=NRBSeq(channelBandwidth);
            obj.resourceGrid=zeros(12*NRB,2^mu*14*10); % 2^mu*14 = number of symbols in subframe
        end
        function mapToResourceGrid(obj, dataMatrix, symbOfs, scOfs)
            arguments
                obj
                dataMatrix % input data matrix
                symbOfs (1,1)  = 0 % time domain offset expressed in number of OFDM symbols
                scOfs (1,1) = 0 % frequency domain offset expressed in number of subcarriers
            end
            obj.resourceGrid(scOfs+(1:length(dataMatrix(:,1))),symbOfs+(1:length(dataMatrix(1,:))))=dataMatrix;
        end
    end
end