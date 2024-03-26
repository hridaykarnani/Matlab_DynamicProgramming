function [beta,ee,t_stat] = MCO(X,Y)
    beta = (X'*X)\(X'*Y); % coeficientes
    error = Y - X*beta;  % estos son los residuos
    T = size(X,1); % nro observaciones
    N = size(X,2); % nro regresores
    ee = (1./(T-N))*((error'*error)\(X'*X)); % errores estandar
    ee = sqrt(diag(ee)); % nos interesa solo la diagonal de la matriz var-cov (por ahora)
    t_stat = beta./ee;
end