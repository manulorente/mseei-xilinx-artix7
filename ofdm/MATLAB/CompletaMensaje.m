function [inputCadena] = CompletaMensaje(bits_tx,tipoModulacion)
tammensaje=size(bits_tx,1);
c=0;

    switch tipoModulacion
        case 'DBPSK'
           while(mod((tammensaje+c)*2+12,96)~=0)    
             c=c+1;  
           end
            
        case 'DQPSK'
            while(mod((tammensaje+c)*2+12,192)~=0)
             c=c+1;
            end
            
        case 'D8PSK'
            
            while(mod((tammensaje+c)*2+12,288)~=0)
             c=c+1;
            end
        otherwise
            disp('Tipo de modulacion incorrecta.');
            disp('Introduce DBPSK, DQPSK, D8PSK.');
    end
            aux=zeros((c+6),1);
            inputCadena=[bits_tx;aux];

end




