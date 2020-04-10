function scrambCadena=scrambler(encCadena)
Pref=[0,0,0,0,1,1,1,0,1,1,1,1,0,0,1,0,1,1,0,0,1,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,1,1,0,0,0,1,0,1,1,1,0,1,0,1,1,0,1,1,0,0,0,0,0,1,1,0,0,1,1,0,1,0,1,0,0,1,1,1,0,0,1,1,1,1,0,1,1,0,1,0,0,0,0,1,0,1,0,1,0,1,1,1,1,1,0,1,0,0,1,0,1,0,0,0,1,1,0,1,1,1,0,0,0,1,1,1,1,1,1,1];
tam=length(encCadena);
out=zeros(tam, 1);
tampref=length(Pref);
ind2=1;
for ind=1:tam
    out(ind)=xor(Pref(ind2),encCadena(ind));
    
    if ind2==(length(Pref))
        ind2=1;
    else
        ind2=ind2+1;
    end
    
end
scrambCadena=logical(out);
end
