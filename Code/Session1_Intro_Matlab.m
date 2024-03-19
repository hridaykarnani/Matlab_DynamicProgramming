%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Curso de Introducción a Matlab: Sesión 1                 %
%                           Hriday Karnani                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INTRODUCCIÓN A MATLAB: ENTORNO Y MATRICES
% Esta sesión está diseñada para introducir conceptos fundamentales
% en MATLAB. Cubre los conceptos básicos de los elementos del escritorio 
% de MATLAB, incluyendo el espacio de trabajo, ventana de comandos y 
% editor. Los ejercicios prácticos se centran en operaciones matemáticas 
% básicas, concatenación de cadenas, creación de scripts y operaciones 
% avanzadas con matrices.

%% 0. Escritorio de Matlab: Explicado

% Carpeta Actual (Current Folder): directorio de trabajo

% Espacio de Trabajo (Workspace): realiza un seguimiento de las variables

% Ventana de Comandos (Command Window): ejecuta comandos
    % 1. Símbolo de Comando (>>): es el comienzo de la línea de comando.
    % 2. Para ejecutar un comando, presione ENTER.
    % 3. variable = expresión: asigna a una variable.

% Editor: para editar un "Script"

% EJECUTAR:
2 + 3 % como no lo asignamos a una var, se almacena en ans.
a = 50 % Asigna un nombre a la variable: no es necesario definir el tipo de variable
A = 55 % Nombre de variable distingue mayúsculas y minúsculas
a = 100 % El valor anterior se reemplaza 
b = a^2 % Crea nuevas variables a partir de otras
c = a + b; % El punto y coma suprime la salida
disp(c) % Muestra el valor, también se puede ver haciendo clic en Espacio de Trabajo
mensaje = '¡Uso MATLAB!'; % Variable de cadena entre comillas simples
disp(mensaje)

%% Tipos de objetos relevantes

% Numeric (double, prob. la que mas usaran)
% la variable b que crearon es tipo numeric (double)
class(a)
% Character & strings
class(mensaje)
% Arrays (en gral, cell. array = formacion): puede contener distintos tipos
d = {42 rand(5) 'abcd'};
class(d)
% Structure array (super util!!). Son arrays pero mas ordenadas. Sirve para
% guardar muchos objetos en una sola variable. por ej, supongan que quieren
% guardar el output de una regresion. Partamos asumiendo que quieren
% guardar Coef, Matriz de Var-Cov y T-stat:
reg.coef = [0.5 1.75]; % estoy inventando los nros
reg.ee = [0.4 0.005; 0.005 0.25]; % cree una matriz, despues lo entenderemos
reg.tstat = [1.25 7];
% ahora vean el output desde workspace

% Variables en 3 dimensiones. Asuman que quieren hacer un nested for-loop
% con 3 'nests' y guardar todo el output en una variable:
% Un ejemplo concreto: hacen una estimacion por MCO y quieren calcular la
% matriz de var-cov con bootstrap. quieren guardar la matriz var-cov de
% cada iteracion. noten que la matriz var-cov es NxN, entonces necesitan
% una matriz NxNxJ (J iteraciones) para guardarlo en UNA variable: 3-D
A = [1 2 3; 4 5 6; 7 8 9];
A(:,:,2) = [10 11 12; 13 14 15; 16 17 18];


%% 1. ¿Qué es un Script? Álgebra Básica

% Ventana de Comandos: Evalúa expresiones individuales.
% Editor: Un Script almacena una secuencia de instrucciones en m-files(*.m).
% Ejecutar un script: MATLAB ejecuta comandos en el m-file.

% IMPORTANTE:
% Antes de ejecutar, puede ser necesario guardar el script
% El nombre del script no puede tener espacios ni símbolos extraños
% Al usar doble comentario (%%), se crean secciones que pueden ejecutarse por separado

% COMANDOS ÚTILES
clear; % Limpia el Espacio de Trabajo
clc; % Limpia la Ventana de Comandos

% Es práctica común eliminar todo del espacio de trabajo y
% la ventana de comandos antes de ejecutar un nuevo script.
% Esto se hace para evitar nombres de variables potencialmente 
% conflictivos y definiciones de funciones

% Otros
pwd % Imprime el directorio actual.
ls % Lista todos los archivos en el directorio actual.
lookfor disp % Busca ayuda para palabras clave.
help disp % Proporciona información sobre una función.

%% 2. Matrices
clc;
clear;

% Creación de un Vector Fila
r = [1 2 3];
r = [1, 2, 3]; % "," pueden separar filas por "," o por espacios

% Creación de un Vector Columna
c = [1; 2; 3]; % Las columnas se separan por ";"

% Traspuesta
r % si no pones ";" después de una línea de código, verás su salida
r' % para mostrar la traspuesta de una matriz, simplemente incluir "'"
c
c'

% Creación de Vector como una Secuencia
seq=[0:0.5:5]

linspace(0,5) % Vector fila de 100 valores igualmente espaciados
linspace(0,10,3) % Vector fila de n valores igualmente espaciados

% Creación de una Matriz
M = [1 2 3; 4 5 6; 7 8 9];

% Matrices de Ceros, Unos e Identidad
z= zeros(1, 2) % Crea una matriz de n-por-m de ceros.
o= ones(2, 3) % Crea una matriz de n-por-m de unos.
e= eye(4,5) % Crea una matriz de identidad de n-por-n.
nanmat= NaN(3,3) % NaN significa NotANumber(0/0 o Sin datos)

% Manipulación de Matrices y Vectores

% Crear matrices A y B de 2x2
A = [1 1; 1 1]
B = [2 1; 1 1]

% Traspuesta de A y B
A'
B'

% Inversa
A^(-1)
inv(A)

% Suma de Matrices
A + B

% Resta de Matrices
A - B

% Multiplicación de Matrices
A * B % Producto matricial de A y B
A .* B % Multiplicación elemento a elemento de A y B

% Concatenación
[A B] % Concatenación horizontal de A y B
[A; B] % Concatenación vertical de A y B

% Concatenación por repetición
repmat(B,1,2) % repetir 1 vez Vertical 2 veces Hor
repmat(B,2,1) % repetir 2 veces Vertical 1 vez Hor
repmat(B,2,2) % repetir 2 veces Vertical 2 veces Hor

A(1, 1) % Acceso al primer elemento de A
B(2, :) % Acceso a la segunda fila de B (":" significa TODO)
A(:, 1) % Acceso a la primera columna de A
diag(A) % Devuelve la diagonal como un vector
A(1,1)=5; % cambiar el primer elemento por el valor 5
A
a=B(2,2) % definir 'a' como el elemento 2,2 de la matriz B

C=eye(5) % matriz identidad 5x5
C(5,3:end) % Accede a elementos de la fila 5, columnas de 3 al final
C(1,[1,3]) % Accede a la primera fila, primer y tercer elemento


b=[1 4 1];

% Ordenar Elementos de menor a mayor
sort(b)

B=[1 2 3 ; 6 5 4 ; 8 7 9];

% Tamaño de la Matriz B
size(B) % Devuelve el tamaño de la matriz B como un vector de fila de dos elementos.
size(B,1) % Devuelve el número de filas en la matriz B (Primera Dimensión).
size(B,2) % Devuelve el número de columnas en la matriz B (Segunda Dimensión).

% Remodelar la Matriz B en una matriz 1x9
BS = reshape(B, 1, 9); % Remodela la matriz B en una matriz 1x9.

% Suma de Elementos
sum(b)
sum(B) % Suma por Columna
sum(B,1) % Suma por Columna
sum(B, 2) % Suma por Fila
