%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Intro a Matlab: Modelo de Búsqueda de McCall                 %
%                           Hriday Karnani                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% En este mfile resolvemos el modelo de search basico de McCall
% usando iteraciones de la funcion valor para encontrar el salario de 
% reserva y otros. Graficamos iteraciones de la VF y de las funciones de 
% politica. 

%% Parámetros del modelo
clc;clear all;
n = 50; a = 200; b = 100; % Estos son parametros para la distribucion 
                          % beta-binomial. No nos interesa mucho entenderlo
q=zeros(n+1,1); % buscamos la PDF de la distribucion beta-binomial 
                % para cada valor entre 0 y n
% Generamos la distribucion beta-binomial 
for x=0:n
    q(x+1,:) = exp(gammaln(n + 1)-gammaln(x + 1)-gammaln(n - x + 1))*...
                     beta((a + x),(b + n - x))/beta(a,b);
                 % no se preocupen por esto, asumanlo dado
end

c = 10; % Compensación por desempleo 
beta = 0.99; % Factor de descuento

% Valores predeterminados para el arreglo de salarios y probabilidades
n = 50; % generaremos 50 posibles salarios
w_min = 5;
w_max = 30;
w = linspace(w_min, w_max, n+1)'; % generamos grilla de salarios posibles
plot(w,q)

% Valores iniciales de la función de valor para cada valor de la grilla
% (comenzando con todos los salarios aceptados)
v = w ./ (1 - beta);
% Iteración de la función de valor
num_iteraciones = 1000; % Número máximo de iteraciones
tolerancia = 1e-6; % Tolerancia para la convergencia

figure;hold on; % haremos una figura de algunas iteraciones
for iter = 1:num_iteraciones
    % Calcular los valores de aceptar y rechazar para cada salario
    valores_accion = zeros(n+1, 2); % Inicializar matriz de valores de acción

    for i = 1:(n+1) % aca iteramos la funcion valor: [acepta,rechaza]
                    % para cada posible salario que pueda extraer
        valores_accion(i, :) = [w(i) / (1 - beta), c + beta * sum(v .* q)];
    end
    
    % Actualizar la función de valor para cada salario
    v_next = max(valores_accion, [], 2); 
    % Tomar el máximo de los valores de aceptar y rechazar
    if iter<=5 % graficamos las primeras 5 iteraciones de la fn valor
        plot(w, v, '-', 'DisplayName', ['iteración ', num2str(iter-1)]); 
    end
    % Comprobar convergencia
    if max(abs(v_next - v)) < tolerancia
        fprintf('Convergencia alcanzada en la iteración %d.\n', iter);
        break;
    end
    
    % Actualizar la función de valor para la siguiente iteración
    v = v_next;
end
xlabel('Salario'); % Terminamos el grafico de las primeras iteraciones
ylabel('Valor');
title('Función de Valor');
legend('show','Location','best');
hold off;

% Gráfico de la función de valor final
figure;
plot(w, v, '-o');
xlabel('Salario');
ylabel('Valor');
title('Función de Valor');

% El salario de reserva viene dado por:
(1-beta).*(c+beta*sum(v.*q))
fprintf('El salario de reserva es %d.\n', (1-beta).*(c+beta*sum(v.*q)));


%% Estatica Comparativa

% Creamos una funcion con el VFI para el modelo de search

% Tenemos que agregar nuestro directorio para poder usar las funciones
% guardadas
cd('G:\Mi unidad\Semestre 11 (ME 3)\Ayudantias\SDP')
addpath('base_funciones')

% Aplicamos la funcion, comprobamos que tengamos el mismo resultado de
% antes
[v,q] = McCallSearch(c,beta);
% salario de reserva:
(1-beta).*(c+beta*sum(v.*q))
fprintf('El salario de reserva es %d.\n', (1-beta).*(c+beta*sum(v.*q)));

% Generamos un vector de los posibles c y beta
c_pos = linspace(5,15,11); beta_pos = linspace(0.89,0.99,11);
% Inicializamos la matriz de salarios de reserva
rw = zeros(length(c_pos),length(beta_pos));
for cs = 1:length(c_pos)
    for bs = 1:length(beta_pos) % resolvemos el modelo para cada (c,beta)
        [v,q] = McCallSearch(c_pos(cs),beta_pos(bs)); % buscamos rw
         rw(cs,bs) = (1-beta_pos(bs)).*(c_pos(cs)+beta_pos(bs)*sum(v.*q));
    end
end

% Hacemos un grafico para mostrar los resultados
figure;
contourf(c_pos, beta_pos, rw, 'LineStyle', 'none'); % 'LineStyle', 'none' para eliminar las líneas de contorno
colorbar; % Agregar una barra de color para interpretación visual

% Etiquetas de ejes y título
xlabel('Bono de cesantia','interpret','latex');
ylabel('\beta');
title('Salario de reserva','interpret','latex');

% Hacemos el grafico tridimensionalmente
figure;
surf(c_pos, beta_pos, rw);
colorbar; % Agregar una barra de color para interpretación visual

% Etiquetas de ejes y título
xlabel('Bono de cesantia','interpret','latex');
ylabel('\beta');
zlabel('Salario de reserva','interpret','latex');
title('Salario de reserva (3D)','interpret','latex');