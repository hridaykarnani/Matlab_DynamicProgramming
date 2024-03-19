%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Intro to Matlab Course: Session 2                     %
%                           Hriday Karnani                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOGICAL OPERATORS, CONDITIONAL STATEMENTS, LOOPS, PLOTS & FUNCTIONS
% Operaciones logicas, conditional statements, loops, graficos y funciones

% Esta sesion se enfoca en operadores relacionales y logicos, 
% conditional statements, loops, graficos y funciones en Matlab.
% Empieza con un entendimiento basico de operaciones logicos y avanza con 
% conditional statements del tipo if-else para tomar decisiones. 
% Revisamos los 'for' y 'while' loops en procesos iterativos. Esta sesion
% tambien incluye una introduccion a graficos y funciones


%% 1. Operadores logicos y relacionales

% OPERADORES RELACIONALES
% == (igual a), ~= (no igual a), < (menor a), > (mayor a),
% <= (menor o igual a), >= (mayor o igual a).

% OPERADORES LOGICOS
% && (Y): Verdadero si ambas condiciones se cumplen 
% || (O): Verdadero si al menos una condicion se cumple.

% Note: & vs. &&. (lo mismo para | vs. ||)
% & operarador logico elemento a elemento: opera en arrays 
% && elemento 2 no se evalua si el primero es falso (para ||, elem 2 no se 
%    evalua si el 1 es verdadero: operates on logical expressions)

% Aplicandolo a objetos
% Defina un vector
vec = [1, 2, 3, 4, 5];
mat = [1 1 ; 4 5];

% Encuentre elementos mayores a 3
mayoraTres  = vec > 3
menoraCuatro= mat < 4

% Use expresiones logicas para referenciar elementos de una matriz
% Defina una matriz
A = [-1, 2, -3; 4, 5, -6];

% Crea un vector con los elementos que cumplen la condicion
A(A < 0)

% Reemplaza elementos negativos de A con un 1
A(A < 0) = 1;
A

% Remplaza elementos positivos de la primera fila con un 5
A(1, A(1, :) > 0) = 5;
A

% Encuentra elementos en A que son mayores a 2 y menores a 5
elemSeleccionados = A(A > 2 & A <= 5);
elemSeleccionados

%% 2.1. Declaraciones Condicionales: 'if', 'elseif', 'else'

% Las declaraciones condicionales permiten ejecutar diferentes bloques de código basados
% en condiciones especificadas.

% - 'if': si la condición es verdadera, se ejecuta el bloque de código dentro.
% - 'else': se usa junto con 'if', cuando la condición 'if' es falsa, el
%           bloque de código dentro es ejecutado
% - 'elseif': se usa junto con 'if', cubre otros casos definidos por otras
%             condiciones. Cuando la condición 'elseif' es verdadera, el
%             bloque de código dentro es ejecutado

% Ejemplo:
numero = 5;
if numero > 0
    disp('El número es positivo.');
end % ¡siempre necesitas el end!

% Agregar 'else' a la declaración 'if'
numero = -4
if numero > 0
    disp('El número es positivo.');
else
    disp('El número no es positivo.');
end

% Usar 'elseif' para múltiples condiciones
numero=0
if numero > 0
    disp('El número es positivo.');
elseif numero < 0
    disp('El número es negativo.');
else
    disp('El número es cero.');
end

%% 2.2. Declaraciones Condicionales: Condiciones Conjuntas

% Las condiciones conjuntas en MATLAB utilizan los operadores lógicos 'AND' (&&) y 'OR' (||)
% para combinar múltiples criterios en una declaración condicional.

% Ejemplo: Comprobar si un número es mayor que 0 y menor que 10
numero = 5;
if numero > 0 && numero < 10 % Ambas condiciones deben ser verdaderas
    disp('El número es mayor que 0 y menor que 10.');
else
    disp('El número no cumple las condiciones.');
end

% Ejemplo usando 'OR' (||)
% Comprobar si un número es menor que 0 o mayor que 10
if numero < 0 || numero > 10 % Al menos una condición debe ser verdadera
    disp('El número es menor que 0 o mayor que 10.');
else
    disp('El número está entre 0 y 10, inclusive.');
end

% Ejemplo usando 'AND' y 'OR' juntos
% Comprobar si aprueba el ramo
examen_final = 5;
prueba1 =4.2;
prueba2 =3.5;
prueba3 = 3;
prom_pruebas = mean([prueba1 prueba2 prueba3 examen_final]);
if (prom_pruebas >= 3.95) || ... % ... salto de línea del código
    (examen_final>=5.5)
    disp('Aprueba');
else
    disp('No aprueba');
end

% Nota: Usa paréntesis para agrupar condiciones y ordenar la evaluación,
% especialmente al combinar '&&' y '||' en la misma declaración.

%% 3. Bucles
clc;clear

% Hay dos tipos de bucles: 'for' y 'while'

% - 'for': ejecuta comandos PARA un conjunto de valores

% - 'while': ejecuta comandos MIENTRAS algo sea verdadero

%% 3.1. Bucles: Bucles 'for'

% Un bucle 'for' se utiliza para repetir un grupo de declaraciones un número fijo
% predeterminado de veces.

% Ejemplo: Imprimir números del 1 al 5
for i = 1:5 % 'i' es la variable que tomará cada valor en cada iteración
    disp(i)
end % siempre necesitas el end!

% Otro ejemplo con vectores
x=zeros(1,10);
for i=1:10
    x(1,i)= 10 + i;
end
x

%% 3.2. Bucles: Bucles Anidados

% Los bucles anidados en MATLAB permiten la ejecución de un conjunto de declaraciones
% múltiples veces, con cada conjunto de iteraciones realizado dentro de otro
% bucle. (Bucles dentro de Bucles)

% Ejemplo: Imprimir Combinaciones de Nombres y Apellidos

% Lista de nombres y apellidos (LA LISTA TIENE CELDAS)
nombres = {'Arturo', 'Esteban', 'Vicente'};
apellidos = {'Vidal', 'Pavez', 'Pizarro'};

% Accedes a ellos con {}
nombres{1}

% Bucle anidado para imprimir todas las combinaciones de nombres y apellidos
disp('Lista de Nombres y Apellidos:');
for i = 1:length(nombres)
    for j = 1:length(apellidos)
        nombreCompleto = [nombres{i} ' ' apellidos{j}];
        disp(nombreCompleto);
    end
end

% Ejemplo: Almacenar Valores en una Matriz
% Inicializa una matriz de 3x3
n=3;
matriz = zeros(n, n);

% Bucle anidado para llenar la matriz con valores
% Vamos a llenarla con el producto de sus índices de fila y columna
for i = 1:3
    for j = 1:3
        matriz(i, j) = i * j;
    end
end

% Muestra la matriz resultante
disp(matriz);

%% 3.3. Bucles: Bucles 'While'

% Un bucle 'while' continúa ejecutando un bloque de código mientras
% una condición especificada sea verdadera.

% Ejemplo: Imprimir números del 1 al 5
contador = 1;
while contador <= 5
    disp(contador);
    contador = contador + 1;
end

%CUIDADO CON LOS BUCLES WHILE, ¡PODRÍAS CREAR UNO INFINITO!
contador = 6;
while contador ~= 5
    disp(contador);
    contador = contador + 1;
end

% Si queremos que un bucle se detenga antes de alcanzar su conjunto, podemos usar Break
while contador ~= 5
    disp(contador);
    contador = contador + 1;
    if contador==1000
        break
    end
end

% EJEMPLO ECONÓMICO
% Monto inicial de inversión
inversionInicial = 1000; % en dólares
% Tasa de interés anual
tasaInteresAnual = 0.05; % 5%
% Monto objetivo
montoObjetivo = 1500; % La meta de inversión en dólares
% Inicializar variables
montoActual = inversionInicial;
anios = 0;
while montoActual < montoObjetivo
    montoActual = montoActual * (1 + tasaInteresAnual);
    % Incrementar el contador de años
    anios = anios + 1;
end

% Muestra el número total de años necesarios para alcanzar el monto objetivo
disp(['Años totales necesarios para alcanzar el monto objetivo: ' num2str(anios)]);

%% 4. Gráficos y Funciones

% 'cd' = 'change directory'
% cambia esto a tu propio directorio
cd('G:\Mi unidad\Semestre 11 (ME 3)\Ayudantias\SDP')
% 'addpath' te permite agregar una ruta diferente desde la que te gustaría
% extraer funciones, datos, etc. aquí, solo estoy agregando una carpeta dentro del
% directorio seleccionado
addpath('base_funciones')

% quiero leer la base de datos como una tabla. podría usar otras formas
datos = readtable("base_23.xls");
% también podría leerlo como una matriz. ten en cuenta que el formato de las fechas se pierde
% pero, es un poco más fácil trabajar cada variable (ya que MatLab está hecho para
% matrices)
datos = readmatrix('base_23.xls'); % también ten en cuenta que '' y "" son intercambiables
% Abramos ambas variables y veamoslo

% Para hacer graficos, se parte con plot(x,y), donde x son los datos del 
% eje x, e y son los datos del eje y
% Antes de graficar lo que nos piden, grafiquemos series aleatorias
% Noten que para crear numeros aleatorios, es bueno fijar una semilla, para
% que lo que creen sea replicable.
set.seed(6)
x = randn(100,1); % randn genera una matriz de 100x1 de valores aleatorios
y = randn(100,1); % que siguen una distribucion normal (0,1) (uds podrian 
                  % definir que la normal tiene otro mu y sigma
plot(x,y) % noten que al hacer esto, nos hizo un grafico de lineas
          % pareciera ser que un grafico tipo scatter (de puntos) es mejor 
          % en este caso, hagamoslo
plot(x,y,'.') % con el tercer argumento, seniale que se grafiquen puntos en
              % vez de lineas. podriamos jugar con eso:
plot(x,y,'x') % y mucho mas...
% Esa es la base de un grafico, ahora vamos agregando capas.
plot(x,y,'.'); 
xlabel('Variable $X$','interpreter','latex')
ylabel('Variable $Y$','interpreter','latex')
title('Un gráfico un poco aburrido')

% podriamos hacer cosas mas entretenidas ...
x = linspace(-2*pi,2*pi);
y1 = sin(x);
y2 = cos(x);
% graficamos las series y1 e y2 en el mismo grafico, noten que primero
% pusimos una combi (x,y) y luego otra combi (x,y)
plot(x,y1,x,y2,'--'); % noten que puse que el 2do grafico sea punteado
                      % super simple de editar!
                      % y asi con muchas cosas. exploren: 
                      % https://la.mathworks.com/help/matlab/ref/plot.html

% Antes, de hacer lo que nos piden, ordenemos un poco los datos y generemos
% algunas variables nuevas.
data2 = data(2:end,:);
data2.TPM = data2.TasaDePol_tica;
data2.Crec_Imacec = ((data.IMACEC(2:end) - data.IMACEC(1:end-1))./data.IMACEC(1:end-1))*100;
data2.Inflacion = (data.IPC(2:end)./data.IPC(1:end-1) - 1)*100;
% Ahora hagamos lo que nos piden:
% Graficamos, con un grafico distinto para cada uno, la serie de tiempo de
% IPC, Imacec y TPM
plot(data.Periodo,data.IPC)
plot(data2.Periodo,data2.Crec_Imacec)
% Noten que hay una componente estacional muy importante. Haremos lo mismo
% pero con crecimiento e inflacion anio a anio
% Ahora partimos los datos un anio despues (hacemos esto para evitar 
% trabajar con NAs
data3 = data(13:end,:);
data3.TPM = data3.TasaDePol_tica;
data3.Crec_Imacec = ((data.IMACEC(13:end) - data.IMACEC(1:end-12))./data.IMACEC(1:end-12))*100;
data3.Inflacion = (data.IPC(13:end)./data.IPC(1:end-12) - 1)*100;

% Graficamos
plot(data3.Periodo,data3.Crec_Imacec);
xlabel('Periodo');ylabel('Crecimiento Anual Imacec')
plot(data3.Periodo,data3.Inflacion)
xlabel('Periodo');ylabel('Inflación a 12 meses')
plot(data3.Periodo,data3.TPM)
xlabel('Periodo');ylabel('TPM')

% Podemos graficar todos en uno
plot(data3.Periodo,data3.Crec_Imacec); hold on
plot(data3.Periodo,data3.Inflacion); hold on
plot(data3.Periodo,data3.TPM);
legend('Crec. Imacec','Inflacion','TPM')
hold off

% O bien, tener distintos graficos uno al lado del otro
subplot(1,3,1) % esto indica que queremos una figura de 1 fila, 3 columnas
               % y este es el primer grafico subplot(fila,columna,nro graf)
plot(data3.Periodo,data3.Crec_Imacec);
xlabel('Periodo');ylabel('Crecimiento Anual Imacec')
subplot(1,3,2)
plot(data3.Periodo,data3.Inflacion)
xlabel('Periodo');ylabel('Inflación a 12 meses')
subplot(1,3,3)
plot(data3.Periodo,data3.TPM)
xlabel('Periodo');ylabel('TPM')

% Ahora, estimamos por MCO la relacion entre crecimiento (var. dep.) e
% inflacion (var indep). La funcion en MCO.m. Revisemosla
% Ahora apliquemos la funcion y analicemos los resultados
% Creamos la matriz X de regresores que incluye la constante
X = [ones(size(data3.Inflacion,1),1) data3.Inflacion];
% Creamos el vector Y de la variable independiente
Y = data3.Crec_Imacec;
[beta,ee,t] = MCO(X,Y);

% Juguemos con algunas cosas entretenidas. Que pasa si usamos el tercer 
% rezago de la inflacion?
X = [ones(size(data3.Inflacion,1)-3,1) data3.Inflacion(1:end-3) ];
Y = data3.Crec_Imacec(4:end);
[beta,ee,t] = MCO(X,Y);
