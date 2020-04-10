function [mappedCadena] = mapper(intlvCadena,NBPC)
mappedCadena=zeros(2,97);
M=2^(NBPC);
A=1; %Determina la potencia transmitida en cada portadora (por símbolo OFDM)
	switch NBPC
		case 1
			a=[0]';b=[1]';
			modulation=[a; b;];
			fases=[0 pi];
		case 2
			a=[0;0]';b=[0;1]';c=[1;1]';d=[1;0]';
			modulation=[a; b; c; d];
			fases=[0 pi/2 pi 3*pi/2];
		case 3
			a=[0;0;0]';b=[0;0;1]';c=[0;1;1]';d=[0;1;0]';
			e=[1;1;0]';f=[1;1;1]';g=[1;0;1]';h=[1;0;0]';
			modulation=[a; b; c; d; e; f; g; h];
			fases=[0 pi/4 pi/2 3*pi/4 pi 5*pi/4 3*pi/2 -pi/4];
	end
	for n=1:2
		for k=1:97
			%Aquí sacamos el conjunto de bits que hay que agrupar
			if k==1
				faseout=pi;
			else
				%Seleccionamos numeros de Nbits en Nbits
				mat_aux=intlvCadena((NBPC*(k-2)+1): NBPC*(k-2)+ NBPC,n)';
				%Calculamos fase del bit a enviar
				for i=1:length(modulation)
					if isequal(mat_aux,modulation(i,:))
						fasein=fases(i);
					end 
				end
				faseout=fase_old+fasein;
				if faseout> 3*pi/2
					faseout=faseout-2*pi;
				end
			end
			fase_old=faseout;
			mappedCadena(n,k)=A*exp(j*faseout);
		end
	end
end