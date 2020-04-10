function [intlvCadena] = interleaver(scrambCadena,M)
    NBPC=M;
    NBPS=96*NBPC;
    intlvCadena=zeros(length(scrambCadena)/2,2);
    s=8*(1+floor((NBPC/2)));
    for k=1:NBPS
        k2=k-1;
        h=((NBPS/s)*(mod(k2,s))+floor(k2/s));
       intlvCadena(h+1,1)=scrambCadena(k);
    end
    for k=NBPS+1:2*NBPS
        k=k-NBPS;
        k2=k-1;
        h=((NBPS/s)*(mod(k2,s))+floor(k2/s));
        intlvCadena(h+1,2)=scrambCadena(k+NBPS);
    end

end