function [Kpol,Kgrid,Kee,V] = VFI(beta,alpha,delta,sigma,tol)

% capital estado estacionario
Kee = ((beta*alpha)/(1-beta*(1-delta)))^(1/(1-alpha));

nK=100; % numero de puntos en la grilla
Kgrid = linspace(0.1,2*Kee,nK); % grilla entre 0.1 y 2*Kee, con 100 ptos

% Iteracion de la funcion valor, partiendo con cualquier guess
% Antes de iterar la funcion valor, definimos una matriz de consumos que
% depende de todas las combis de K y K' y la utilidad dada por esas combis
% de C
C = zeros(nK,nK); % Matriz de consumo, todas combis de K y K' (kt y kt+1)
U = zeros(nK,nK,size(sigma,2)); % Matriz de utilidad, todas combis de K y K' (kt y kt+1)
for ih = 1:nK      % ih es como "iteracion hoy"
	for im = 1:nK  % im es como "iteracion maniana"
    	% Se generan las posibles combinaciones de c y c' con la
        % expresion que sale de la restriccion presupuestaria
        C(ih,im) = Kgrid(ih)^alpha + (1-delta)*Kgrid(ih)-Kgrid(im);
        % Basados en consumo, encontramos la utilidad para cada sigma
        if sigma==1         % si sigma=1, fn de util converge a log
            U(ih,im) = log(C(ih,im));
        else
            U(ih,im) = ((C(ih,im)^(1-sigma))-1)/(1-sigma);
        end
        % Dado que el consumo no deberia ser negativo, si llega a
        % serlo, definimos la utilidad a un nivel muy bajo, para que no
        % sea elegido como maximo
        if C(ih,im)<0
            U(ih,im) = -10^10;
        end
	end 
end

% Definimos la variable que tendra la utilidad indirecta para que entre al loop
% Nuestro guess inicial para V0 es un vector de 0 con un nro de elementos
% igual a la cantidad de valores que hay en la grilla
V0 = zeros(nK,1);
% Cantidad maxima de iteraciones que permitiremos en el loop
itermax = 100000;

% Iteracion funcion valor
% Con tic echamos a andar un reloj para ver cuanto demora
tic;
for iter = 1:itermax
        % Encontramos utilidad indirecta para cada combinacion de ih e im 
        % de forma matricial, para ahorrar tiempo
        T = U + beta*repmat(V0',[nK 1]);
        % Guardamos el maximo que optimizaria
        [Vnew,index] = max(T,[],2);
        dif = max(abs(Vnew-V0));
        % Si la diferencia anterior es menor al nivel de tolerancia,
        % diremos que la serie converge, y guardamos Kpol
        if dif < tol
            fprintf('\n Funcion iteracion valor converge en: %g iteraciones \n',iter)
            V = Vnew;
            Kpol = Kgrid(index);
            break
        end 
        V0 = Vnew;
end 
toc;


end