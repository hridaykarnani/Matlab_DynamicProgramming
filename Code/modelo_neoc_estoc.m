%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Intro a Matlab: Modelo Neoclasico Estocastico                 %
%                           Hriday Karnani                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% En este mfile resolvemos el modelo neoclasico de crecimiento
% estocastico usando iteraciones de la funcion valor. Graficamos
% iteraciones de la VF y de las funciones de politica. 

%% Parametros y grilla
clc;clear;
beta  = 0.95; alpha = 0.33; delta = 0.1; sigma = 2; 
tol   = 1e-6; nZ = 2; %Número posible de valores del shock
Zgrid = [0.9 1.1];
Pz = [0.8 0.2; 0.2 0.8];

Kee=((beta*alpha)/(1-beta*(1-delta)))^(1/(1-alpha));
nK = 1000;
Kgrid=linspace(0.1*Kee,2*Kee,nK);

%% VFI

% Consumos (LOOPS)
C=zeros(nK,nK,nZ); % noten que es 3-d, valores =/= para los 2 estados
aux=zeros(nK,nK,nZ);
for i=1:nK %k hoy
    for j=1:nK %k mañana
        for z=1:nZ %z hoy
            C(i,j,z)=(Zgrid(z)*(Kgrid(i)^alpha))+(1-delta)*Kgrid(i)-Kgrid(j);
            if C(i,j,z)<=0 %marco consumos negativos o cero
                aux(i,j,z)=1; % dummy aux por si consumo optimo es negativo
            end
        end
    end
end

% Encontramos la utilidad de forma matricial, un poco mas eficiente
% %Utilidad
if sigma~=1
    U=((C.^(1-sigma))-1)/(1-sigma);
else %sigma=1
    U = log(C);
end

U(logical(aux))=-inf; %consumo cero o negativo

% Ahora hacemos la VFI con matrices
V0=zeros(nK,nZ);
Vnew=zeros(nK,nZ);
Kpolicy=zeros(nK,nZ);
maxIter=1000;
tic;
for iter=1:maxIter
    for z=1:nZ %z hoy
        % Vesperado = E(V0|z) = prob(z'=0.9|z)*V0(k',z'=0.9)+ prob(z'=1.1|z)*V0(k',z'=1.1) 
        Vesperado = sum(Pz(z,:).*V0,2)';
        [maxx,indx]=max(U(:,:,z) + beta*Vesperado,[],2);
        Vnew(:,z)=maxx;
        Kpolicy(:,z)=Kgrid(indx);
    end 
    dif=max(max(abs(Vnew-V0)));
    V0=Vnew;    
    if dif<tol
        fprintf('\n Value converge luego de: %g iteraciones \n',iter)
        break;
    end
end
fprintf('\n Value converge en: %g segundos \n',toc)

% Graficos
figure(1)
plot(Kgrid,Vnew) % grafico funcion valor
xlabel('K hoy','interpret','latex')
ylabel('Value function','interpret','latex');
legend('z bajo', 'z alto')


% grafico policy
figure(2)
plot(Kgrid,Kpolicy);hold on;
plot(Kgrid,Kgrid,'k--')
xlabel('K hoy','interpret','latex')
xlabel('K hoy','interpret','latex')
legend('z bajo','z alto','Línea 45°')

%policy consumo
Cpolicy=zeros(nK,nZ);
for i=1:nK %k hoy
    for z=1:nZ %z hoy
        Cpolicy(i,z)=Zgrid(z)*(Kgrid(i)^alpha) - Kpolicy(i,z) + (1-delta)*Kgrid(i);
    end
end

% graficos policy
figure(3)
plot(Kgrid,Cpolicy)
xlabel('K hoy','interpret','latex')
ylabel('C hoy','interpret','latex')
legend('z bajo','z alto')

%% Simulacion de series
% Simulación de series de tiempo
n_periods = 1500;
burn_in = 1000;
k0 = Kee;
z0 = Zgrid(1);

c_series = zeros(n_periods, 1);
k_series = zeros(n_periods, 1);
i_series = zeros(n_periods, 1);

% Simulación de la serie de tiempo
for t = 1:n_periods
    % Encuentra el índice correspondiente al valor de z0 en Zgrid
    [~, z_index] = ismember(z0, Zgrid);
    % Encuentra el índice correspondiente al valor de k0 en Kgrid
    [~, k_index] = min(abs(k0 - Kgrid));
    
    % Encuentra el índice correspondiente a la política óptima para k
    k_policy_index = find(Kgrid == Kpolicy(k_index, z_index));
    
    % Calcula el consumo y la inversión
    c_series(t) = Zgrid(z_index) * (Kgrid(k_index)^alpha) + (1 - delta) * Kgrid(k_index) - Kgrid(k_policy_index);
    i_series(t) = Kgrid(k_policy_index) - (1 - delta) * Kgrid(k_index);
    
    % Actualiza k0 y z0 para el próximo período
    k0 = Kgrid(k_policy_index);
    % Actualiza z0 para el próximo período según la matriz de transición P
    p_values = Pz(z_index, :);
    z0 = Zgrid(randsample(1:length(Zgrid), 1, true, p_values));
    k_series(t+1) = k0;
end

% Elimina las primeras observaciones de la serie de tiempo
c_series = c_series(burn_in+1:end);
k_series = k_series(burn_in+2:end);
i_series = i_series(burn_in+1:end);

% Calcula la media y la varianza del capital y el consumo
mean_k = mean(k_series);
var_k = var(k_series);
mean_c = mean(c_series);
var_c = var(c_series);

% Calcula la correlación de primer orden para el capital
corr_k = corr(k_series(1:end-1), k_series(2:end));

% Muestra los resultados
fprintf('Media del capital: %.4f\n', mean_k);
fprintf('Varianza del capital: %.4f\n', var_k);
fprintf('Media del consumo: %.4f\n', mean_c);
fprintf('Varianza del consumo: %.4f\n', var_c);
fprintf('Correlación de primer orden para el capital: %.4f\n', corr_k);

% Grafica las series de tiempo
figure;
subplot(3,1,1);
plot(1:n_periods-burn_in, c_series);
title('Consumo');
subplot(3,1,2);
plot(1:n_periods-burn_in, k_series);
title('Capital');
subplot(3,1,3);
plot(1:n_periods-burn_in, i_series);
title('Inversión');

%% Estimar AR(p)
% Usaremos la funcion MCO que creamos en la segunda sesion
cd('G:\Mi unidad\Semestre 11 (ME 3)\Ayudantias\SDP')
addpath('base_funciones')
% AR(1)
X = [ones(size(k_series,1)-1,1) k_series(1:end-1) ];
Y = k_series(2:end);
[b_ar1,ee_ar1,t_ar1] = MCO(X,Y);

% AR(2)
X = [ones(size(k_series,1)-2,1) k_series(2:end-1) k_series(1:end-2) ];
Y = k_series(3:end);
[b_ar2,ee_ar2,t_ar2] = MCO(X,Y);

% AR(3)
X = [ones(size(k_series,1)-3,1) k_series(3:end-1) k_series(2:end-2) k_series(1:end-3) ];
Y = k_series(4:end);
[b_ar3,ee_ar3,t_ar3] = MCO(X,Y);

% AR(4)
X = [ones(size(k_series,1)-4,1) k_series(4:end-1) k_series(3:end-2) k_series(2:end-3) k_series(1:end-4) ];
Y = k_series(5:end);
[b_ar4,ee_ar4,t_ar4] = MCO(X,Y);

