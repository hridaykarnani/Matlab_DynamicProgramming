%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Intro a Matlab: Modelo Neoclasico Deterministico              %
%                           Hriday Karnani                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% En este mfile resolvemos el modelo neoclasico de crecimiento
% deterministico usando iteraciones de la funcion valor. Graficamos
% iteraciones de la VF y de las funciones de politica. 

%% Parametros
clear;clc
beta=0.95;
alpha=0.33;
delta=0.1;
sigma=2;
tol = 10^(-6);

% capital estado estacionario
% Pregunta 1
Kee = ((beta*alpha)/(1-beta*(1-delta)))^(1/(1-alpha));

%% Problema - VFI
% Pregunta 2, grilla
nK=100; % numero de puntos en la grilla
Kgrid = linspace(0.1,2*Kee,nK); % grilla entre 0.1 y 2*Kee, con 100 ptos

% Pregunta 3
V0 = zeros(nK,1);
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
        U(ih,im) = ((C(ih,im)^(1-sigma))-1)/(1-sigma);
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
    T = zeros(nK,nK); % Para cada iteracion, volvemos a crear la matriz 
                      % donde guardamos los =/= valores de la fn valor
    for ih=1:nK       % Iteramos sobre =/= combinaciones de k y k'
        for im=1:nK   
            T(ih,im) = U(ih,im) + beta*V0(im); % T guarda las distintas
                                               % combis de la fn valor
        end 
    end 
    [Vnew,index] = max(T,[],2);  % Guardamos el max entre valores de grilla
                                 % de la fn valor. Partimos la iteracion
                                 % con V^{i}. Vnew es V^{i+1}
    dif = max(abs(Vnew-V0));     % Vemos si la dif entre V^{i+1} y V^{i} es
    if dif < tol                 % menor en valor abs al criterio de tol
        fprintf('\n Funcion iteracion valor converge en: %g iteraciones \n',iter)
        V = Vnew;                % Si la dif es menor, terminamos el loop
        Kpol = Kgrid(index);     % y encontramos la fn de politica para K
        break
    end 
    V0 = Vnew;                   % Si la dif no es menor a criterio,
                                 % actualizamos V^{i+1} para la sgte
                                 % iteracion
end 
toc; % Vemos cuanto tiempo demora en converger

subplot(2,2,1) % Vamos a crear una figura que incluya los 3 graficos al 
               % mismo tiempo. aca dije que quiero tener 2 filas y 2
               % columnas de graficos, y este es el primer grafico de todos
plot(Kgrid,V); % graficamos la grilla de K contra la funcion valor
xlabel('$K_t$','interpreter','latex'); % noten que podemos definir titulos
                                       % usando simbolos de latex
ylabel('Value function','interpret','latex');
title('Titulo');

subplot(2,2,2) % 2do grafico de la figura q tendra 2 filas y 2 columnas
plot(Kgrid,Kpol); % graficamos grilla de K contra la funcion de politica de K
hold on
plot(Kgrid,Kgrid,'r')
xlabel('$K_t$','interpreter','latex')
ylabel('K policy','interpret','latex');
title('Titulo');
hold off;

Cpol = Kgrid.^alpha + Kpol + (1-delta)*Kgrid; % encontramos fn de pol de C
subplot(2,2,3) % tercer grafico de la figura con 2 filas y 2 columnas
plot(Kgrid,Cpol) % graficamos grilla de K contra C
xlabel('$K_t$','interpreter','latex')
ylabel('C','interpret','latex');
title('Titulo');
hold off;

%% Traduciendo el loop en operaciones vectoriales
% Pregunta 4

tic;
V0 = zeros(nK,1);
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


%% Replicando el ejercicio y cambiando parametros
% Preguntas 5. y 6. 
% Para ahorrar espacio de codigo, vamos a crear una funcion con el proceso
% de VFI. A la funcion le vamos a entregar parametros y ella nos devolvera
% la funcion de politica para K, nro de iteraciones en la que converge, etc

% Primero, crearemos la funcion en VFI.m. Noten que para crear la funcion,
% basicamente copiamos y pegamos lo hecho arriba y le decimos a Matlab que
% sera una funcion con ciertos inputs y ciertos outputs. Lo veremos en
% VFI.m

% Tenemos que agregar nuestro directorio para poder usar las funciones
% guardadas
cd('G:\Mi unidad\Semestre 11 (ME 3)\Ayudantias\SDP')
addpath('base_funciones')

% Antes de responder la pregunta 5, haremos un 'sanity check'. Veremos si
% con la funcion logramos replicar lo que ya encontramos arriba. Tambien
% comparamos tiempo de ejecucion:
beta=0.95;alpha=0.33;delta=0.1;sigma=2; % BASELINE
[Kpol,Kgrid,Kee,V] = VFI_Neoc_Deterministico(beta,alpha,delta,sigma,tol);
% Graficamos funcion valor
plot(Kgrid,V); % graficamos la grilla de K contra la funcion valor
xlabel('$K_t$','interpreter','latex');
ylabel('Value function','interpret','latex');
title('Funcion Valor');

% Pregunta 5.a.
beta=0.95;alpha=0.66;delta=0.1;sigma=2; % solo duplicamos alpha
[KpolA,KgridA,KeeA,VA] = VFI_Neoc_Deterministico(beta,alpha,delta,sigma,tol);
% Graficamos funcion valor
plot(KgridA,VA); % graficamos la grilla de K contra la funcion valor
xlabel('$K_t$','interpreter','latex');
ylabel('Value function','interpret','latex');
title('Funcion Valor');

% Pregunta 5.b.
beta=0.95;alpha=0.33;delta=0.1;sigma=5; % solo aumentamos sigma
[Kpol5B,Kgrid5B,Kee5B,V5B] = VFI_Neoc_Deterministico(beta,alpha,delta,sigma,tol);
% Graficamos funcion valor
plot(Kgrid5B,V5B); % graficamos la grilla de K contra la funcion valor
xlabel('$K_t$','interpreter','latex');
ylabel('Value function','interpret','latex');
title('Funcion Valor');
