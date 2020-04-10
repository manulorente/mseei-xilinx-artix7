function [encCadena] = convolutional_encoder(inputCadena)

%En este caso cuento con que sea el bloque inicial el que va a dejar 
%el mensaje en el formato que yo necesito, con todos los ceros necesarios
%y el tamaño justo para rellenar simbolos exactos

tanmensaje=length(inputCadena);
reg=zeros(1,7);%creamos el registro en su estado inicial
salida=zeros(((tanmensaje*2)),1); %Para que el bucle for sea mas eficiente
ind2=1:2:length(salida); 
for ind=1:tanmensaje
    
   reg(1)= inputCadena(ind);
   salida(ind2(ind))=xor(xor(reg(1),reg(2)),xor(reg(4),xor(reg(6),reg(7))));
   salida(ind2(ind)+1)=xor(xor(reg(1),reg(4)),xor(reg(5),reg(7)));
   reg(2:end)=reg(1:end-1); 
    
end
encCadena=salida;
end
