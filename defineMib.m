function MIB = defineMib(...
    SFN, ...
    subCarrierSpacingCommon,...
    kSSB,...
    dmrsTypeAPos,...
    SIB1,...
    cellBarred,...
    intraFrequencyReselection)

    arguments
    SFN (1,1) % integer
    subCarrierSpacingCommon (1,1){mustBeMember(subCarrierSpacingCommon,[0,1])} % bit
    kSSB (1,1) % integer
    dmrsTypeAPos (1,1){mustBeMember(dmrsTypeAPos,[0,1])} % bit
    SIB1 (1,8) {mustBeMember(SIB1,[0,1])} % 8 bits
    cellBarred (1,1){mustBeMember(cellBarred,[0,1])} % bit
    intraFrequencyReselection (1,1){mustBeMember(intraFrequencyReselection,[0,1])} % bit
    end
    
    bSFN = int2bit(SFN,10).';
    bkSSB=int2bit(kSSB,5).';    
    
    MIB = [bSFN(1:6) subCarrierSpacingCommon bkSSB(end-3:end) dmrsTypeAPos SIB1 cellBarred intraFrequencyReselection 0];

end