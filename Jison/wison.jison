%lex

%%
//A partir de aquí declaramos los tokens a utilizar
[ \r\t\n]   {}
//Comentarios de linea
"#".*   //Comentario de linea
//Comentario de Bloque
//[/][*][*]



//Simbolos fundamentales
"¿"         return 'INTER_A'
[?]         return 'INTER_C'
"{"         return 'LLA_A'
"}"         return 'LLA_C'
":"         return 'PUNTOS'
";"         return 'PUNTO_COMA'
"<-"        return 'FLECHA_SIMPLE'
"<="        return 'FLECHA_DOBLE'
[*]         return 'KLEENE'
[+]         return 'MAS'
[(]         return 'PAR_A'
[)]         return 'PAR_C'      
[|]         return 'OR'
(("[")("aA-zZ")("]"))   return 'ALL_LETTERS'
(("[")("0-9")("]"))    return 'DIGIT'

//Palabras Reservadas
(Wison)         return 'WISON'
(Terminal)      return 'TERMINAL'
[L][e][x]             return 'LEX'
(Syntax)        return 'SYNTAX'
(No_Terminal)   return 'NO_TERMINAL'
(Initial_Sim)   return 'INITIAL_SIM'

//Expresiones Especiales
[$][_]([a-zA-Z]|[0-9]|[_])+     return 'TERMINAL_SYM'
[%][_]([a-zA-Z]|[0-9]|[_])+     return 'NO_TERMINAL_SYM'
[\'][^\']+[\']                     return 'PR'


<<EOF>>     return 'EOF'
.           return 'INVALID'

/lex

%start inicio

%{
    
%}

%%

inicio :    inicio_wison EOF
            ;

inicio_wison :  WISON INTER_A definicion_lexica definicion_sintactica INTER_C WISON
                ;

//Inicio de la definición léxica
definicion_lexica : LEX LLA_A PUNTOS cuerpo_definicion_lexica PUNTOS LLA_C
                    ;

cuerpo_definicion_lexica :  cuerpo_definicion_lexica definicion_terminal
                            | definicion_terminal
                            ;

definicion_terminal :   TERMINAL TERMINAL_SYM FLECHA_SIMPLE declaracion_terminal PUNTO_COMA
                        ;

declaracion_terminal :  PR
                        | estructura_especial
                        | cuerpo_concatenacion
                        ;

//Permite Concatenar
cuerpo_concatenacion :  cuerpo_concatenacion concatenacion
                        | concatenacion
                        ;

concatenacion : PAR_A estructura_especial PAR_C
                | PAR_A TERMINAL_SYM operador PAR_C
                ;

estructura_especial :   | DIGIT operador
                        | ALL_LETTERS operador
                        ;

operador :  INTER_C
            | KLEENE
            | MAS
            |
            ;



definicion_sintactica : SYNTAX LLA_A LLA_A PUNTOS cuerpo_definicion_sintactica PUNTOS LLA_C LLA_C
                        ;

cuerpo_definicion_sintactica :  definicion_no_terminales simbolo_inicial reglas_de_produccion
                                ;

//Definimos los no terminales de wison
definicion_no_terminales :  definicion_no_terminales no_terminal_definido
                            | no_terminal_definido
                            ;

no_terminal_definido :  NO_TERMINAL NO_TERMINAL_SYM PUNTO_COMA
                        ;


//Definimos el simbolo inicial de wison
simbolo_inicial :   INITIAL_SIM NO_TERMINAL_SYM PUNTO_COMA
                    ;

//Definimos las reglas de produccion de wison
reglas_de_produccion :  reglas_de_produccion regla_de_produccion_definida
                        | regla_de_produccion_definida
                        ;

regla_de_produccion_definida :  NO_TERMINAL_SYM FLECHA_DOBLE cuerpo_regla_de_produccion PUNTO_COMA
                                ;

cuerpo_regla_de_produccion :    cuerpo_regla_de_produccion simbolos_regla_de_produccion
                                | simbolos_regla_de_produccion
                                ;

simbolos_regla_de_produccion :  NO_TERMINAL_SYM
                                | TERMINAL_SYM 
                                | OR
                                ;