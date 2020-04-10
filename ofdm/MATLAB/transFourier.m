function ifftCadena = transFourier(mappedCadena)
%Este bloque constituye conjuntamente la ifft y el prefijo ciclico
auxceros=complex(zeros(1,16)); %Necesario para poner a 0 las portadoras
                      %que no nos interesan, (1,16) y (114,128)
numsimbolos=size(mappedCadena,1);
 for i=1:numsimbolos 
     cadenaOrdenada=[auxceros,mappedCadena(i,:),auxceros(1:15)];
     %16 ceros a bajas frecuencias, las 97 portadoras y otros 15 ceros
     aux=ifft(ifftshift(cadenaOrdenada),128);
     %Esta es la parte en la que incluimos el prefijo ciclico de cada
     %simbolo y mantenemos el orden
     if(i==1)
      out=[aux(117:end),aux];
     else
      out=[out,aux(117:end),aux];
     end

 end
ifftCadena=out;
