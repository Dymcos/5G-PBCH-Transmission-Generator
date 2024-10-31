function pbch = generatePbch(MIB,SFN,HRF, Lmax_, SSBparam, NCellId)
    %PbchGenerator Procedure of PBCH bit string generation [TS 38.212, 7.1]
    arguments
        MIB (1,24) % MIB binary sequence (MSB to LSB)
        SFN (1,1) % system frame number positive integer (0...1023)
        HRF (1,1) % half frame bit
        Lmax_ (1,1) % = 4|8|64 maximum number of candidate SS/PBCH blocks in half frame [4.1, TS 38.213]
        SSBparam (1,1) % kSSB if Lmax_ = 4|8 or iSSB if Lmax_ = 64
        NCellId (1,1) % cell identificator (0...1007)
    end
    pbch = payloadGeneration(MIB,SFN,HRF, SSBparam,Lmax_);
    pbch = scrambling(pbch,NCellId,Lmax_);
    pbch = attachParityBits(pbch,'crc24c');
    pbch = polarCoding(pbch);
    pbch = rateMatching(pbch);
end