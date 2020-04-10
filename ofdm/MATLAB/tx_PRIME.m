function [txSalida]= tx_PRIME(tipoModulacion,ON)
%Creacion del transmisor
warning('off'); % Eliminamos warnings 
FolderName = ['Results'];
RepoProject='C:\'; %Project path

if exist('TX_proyectoSEC\Results','dir')==0
    mkdir(['C:\TX_proyectoSEC'], FolderName);
end
path_cal=[RepoProject 'TX_proyectoSEC\Results'];

%Generacion del mensaje a transmitir
%nombres='Guillermo Gomez Chavez Manuel Lorente Alman Luis Garcia Gonzalez';

bits_tx=[0 1 0 0 0 1 1 1 0 1 1 1 0 1 0 1 0 1 1 0 1 0 0 1 0 1 1 0 1 1 0 0 0 1 1 0 1 1 0 0 0 1 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 1 1 0 1 1 0 1 1 0 1 0 1 1 0 0 1 0 1 0 1 1 1 1 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 1 1 0 1 0 1 1 0 0 0 0 1 0 1 1 0 1 1 1 0 0 1 1 1 0 1 0 1 0 1 1 0 0 1 0 1 0 1 1 0 1 1 0 0 0 0 1 0 0 0 0 0 0 1 0 0 1 1 0 0 0 1 1 0 1 1 1 1 0 1 1 1 0 0 1 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 0 0 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 1 0 0 1 1 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1 0 0 1 0 1 1 1 0 0 1 1 0 0 1 0 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 0 0 0 1 0 1 1 1 0 0 1 0 0 1 1 0 0 0 1 1 0 1 1 0 1 0 0 1 0 1 1 0 0 0 0 1]';

ERROR=0;

   switch tipoModulacion
        case 'DBPSK'
            M=1;
        case 'DQPSK'
            M=2;
        case 'D8PSK'
            M=3;
        otherwise
	    ERROR=1;
    end
    if (ON==1 && ERROR ~=1)
	
	    fich=fopen(strcat(path_cal,strcat('\bits_tx_',tipoModulacion,'.txt' )),'w');
        fich1=fopen(strcat(path_cal,strcat('\inputStream_',tipoModulacion,'.txt' )),'w');
	    fich2=fopen(strcat(path_cal,strcat('\encStream_',tipoModulacion,'.txt' )),'w');
	    fich3=fopen(strcat(path_cal,strcat('\scrambStream_',tipoModulacion,'.txt' )),'w');
		fich4=fopen(strcat(path_cal,strcat('\intlvStream_',tipoModulacion,'.txt' )),'w');
	    fich5=fopen(strcat(path_cal,strcat('\mappedStream_',tipoModulacion,'.txt' )),'w');
	    fich6=fopen(strcat(path_cal,strcat('\txOut_',tipoModulacion,'.txt' )),'w');
		
		fprintf(fich,'%d\n', bits_tx);
		
		inputCadena=CompletaMensaje(bits_tx,tipoModulacion);
		fprintf(fich1,'%d\n', inputCadena);
		
        encCadena = convolutional_encoder(inputCadena);
		fprintf(fich2,'%d\n', encCadena);
		
        scrambCadena= scrambler(encCadena);
		fprintf(fich3,'%d\n', scrambCadena);
		
        intlvCadena = interleaver(scrambCadena,M);
		fprintf(fich4,'%d\n', intlvCadena);
		
        mappedCadena = mapper(intlvCadena,M);
		fprintf(fich5,'%d\n', mappedCadena);
		
		%fprintf(fich6,'******** Salida del sistema completo********\n');
        txSalida = transFourier(mappedCadena);
		fprintf(fich6,'%d\n', txSalida);
		
		
		
		fclose(fich);
		fclose(fich1);
		fclose(fich2);
		fclose(fich3);
		fclose(fich4);
		fclose(fich5);
        fclose(fich6);
			
		%Guardar workspace en directorio 
        file_ws=strcat('\workspace', tipoModulacion ,'.mat');
        save([path_cal file_ws]);
		
		disp('Ficheros con resultados generados en C:\TX_proyectoSEC\Results\ y workspace correspondiente.');
			
    elseif ERROR==1
    	disp('Tipo de modulacion incorrecta.');
        disp('Introduce DBPSK, DQPSK, D8PSK');
    else
        disp('Sistema apagado... para encender ON=1.');
        disp('Ejemplo -> tx_PRIME(DQPSK,1)');
    end
end
