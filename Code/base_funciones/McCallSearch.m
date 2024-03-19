function [v,q] = McCallSearch(c,Beta)

    n = 50;
    a = 200;
    b = 100;
    q=zeros(n+1,1); % buscamos la PDF de la distribucion beta-binomial 
                    % para cada valor entre 0 y n
    for x=0:n
        q(x+1,:) = exp(gammaln(n + 1)-gammaln(x + 1)-gammaln(n - x + 1))*...
                         beta((a + x),(b + n - x))/beta(a,b);
                     % no se preocupen por esto, asumanlo dado
    end

    % c = 10; % Compensación por desempleo
    % beta = 0.99; % Factor de descuento

    % Valores predeterminados para el arreglo de salarios y probabilidades
    n = 50;
    w_min = 5;
    w_max = 30;
    w = linspace(w_min, w_max, n+1)';

    % Valores iniciales de la función de valor (comenzando con todos los salarios aceptados)
    v = w ./ (1 - Beta);
    % Iteración de la función de valor
    num_iteraciones = 1000; % Número máximo de iteraciones
    tolerancia = 1e-6; % Tolerancia para la convergencia
    for iter = 1:num_iteraciones
        % Calcular los valores de aceptar y rechazar para cada salario
        valores_accion = zeros(n+1, 2); % Inicializar matriz de valores de acción
        for i = 1:(n+1)
            valores_accion(i, :) = [w(i) / (1 - Beta), c + Beta * sum(v .* q)];
        end

        % Actualizar la función de valor para cada salario
        v_next = max(valores_accion, [], 2); % Tomar el máximo de los valores de aceptar y rechazar
        % Comprobar convergencia
        if max(abs(v_next - v)) < tolerancia
            fprintf('Convergencia alcanzada en la iteración %d.\n', iter);
            break;
        end

        % Actualizar la función de valor para la siguiente iteración
        v = v_next;
    end
end