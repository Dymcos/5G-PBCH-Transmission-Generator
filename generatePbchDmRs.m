function dmrs=generatePbchDmRs(issb,NCellId)
    % generates PBCH DM-RS according SSB index and BS ID
    arguments
        issb 
        NCellId
    end
    biSSB = int2bit(issb,6).'; 
    issb_ = bit2int([biSSB(3) biSSB(2) biSSB(1)].',3); % issb+is_second_hf*4
    cinit=2^11*(issb_+1)*(floor(NCellId/4)+1)+2^6*(issb_+1)+mod(NCellId,4);
    c = pseudoRandomSequence(cinit,288);
    dmrs=1/sqrt(2)*(1-2*c(1:2:end))+1j/sqrt(2)*(1-2*c(2:2:end));
end


