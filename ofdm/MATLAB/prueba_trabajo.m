clear all
load d8psk
NBPC=3;  
%% Algoritmo general
intlvCadena=intlvStream;
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
			%Pillamos numeros de Nbits en Nbits
            mat_aux=intlvCadena((NBPC*(k-2)+1): NBPC*(k-2)+ NBPC,n)'
	        %Calculamos fase del bit a enviar
			for i=1:length(modulation)
                if isequal(mat_aux,modulation(i,:))
                    fasein=fases(i)
                end 
            end
            faseout=fase_old+fasein;
			if faseout> 3*pi/2
				faseout=faseout-2*pi;
			end
        end
		fase_old=faseout;
		mappedCadena(n,k)=A*exp(j*faseout)
    end
end


% for n=1:2
    % for k=1:97
        % %Aquí sacamos el conjunto de bits que hay que agrupar
        % if k==1
            % ref=find(fases==(-1+0i));
			% %Buscamos el indice de la referencia
			% inc=fases(ref);
			% inc_grad=fase_grad(ref);
        % else
			% %Pillamos numeros de Nbits en Nbits
			% k
            % mat_aux=intlvCadena((NBPC*(k-2)+1): NBPC*(k-2)+ NBPC,n)'
	        % %Calculamos fase del bit a enviar
			% for i=1:length(modulation)
                % if isequal(mat_aux,modulation(i,:))
                    % pha=fases(i);
                % end 
            % end
			% %inc_grad=inc_gradold+fase_grad(find(fases==pha));
			% inc_grad=inc_gradold+fase_grad(find((fases==pha)))
			% if inc_grad > 270
				% inc_grad=inc_grad-360
			% end
			% inc=fases(find(fase_grad==inc_grad));
        % end
		% inc_gradold=inc_grad
		% mappedCadena(k,n)=A*inc
    % end
% end
% mappedCadena=mappedCadena';

% r=sqrt(2)/2;
% switch NBPC
    % case 1
        % a=[0]';b=[1]';
        % modulation=[a; b;];
        % fases=[1+0i -1+0i];
		% fase_grad=[0 180];
    % case 2
        % a=[0;0]';b=[0;1]';c=[1;1]';d=[1;0]';
        % modulation=[a; b; c; d];
        % fases=[1+0i 0+1i -1+0i -0-1i];
		% fase_grad=[0 90 180 270];
    % case 3
        % a=[0;0;0]';b=[0;0;1]';c=[0;1;1]';d=[0;1;0]';
        % e=[1;1;0]';f=[1;1;1]';g=[1;0;1]';h=[1;0;0]';
        % modulation=[a; b; c; d; e; f; g; h];
        % fases=[1+0i r+r*i 0+1i -r+r*i -1+0i -r-r*i -0-1i r-r*i];
		% fase_grad=[0 45 90 135 180 270 -45];
% end