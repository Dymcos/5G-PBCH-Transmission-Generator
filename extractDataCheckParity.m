function [data,is_data_valid]=extractDataCheckParity(bitstream,crc_type)
    % checks whether the data responds to parity 
    % bits and returns the data and a validation flag.
    % see 5.1. CRC calculation of TS38.212
    arguments
        bitstream           % data with parity bits
        crc_type string     % must be "crc<length><?letter>" letter is only necessary crc24_.
    end
    
    % choose length
    switch(crc_type)
        case "crc6"
            N=6;
        case "crc11"
            N=11;
        case "crc16"
            N=16;
        case {"crc24a","crc24b","crc24c"}
            N=24;
        otherwise
            throw(MException('crcTypeErr',...
                "Invalid crc type. Must be one of {crc6, crc11," + ...
                "crc16, crc24a, crc24b, crc24c}."))
    end
    % extracting data
    data=bitstream(1:end-N);
    
    % checking crc (must be zeros)
    [~,crc]=attachParityBits(bitstream,crc_type,false);
    is_data_valid=~any(crc);
end
