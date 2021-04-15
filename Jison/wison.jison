%lex

%%
//A partir de aquí declaramos los tokens a utilizar
[ \r\t\n]   {}
//Comentarios de linea
"#".*   //Comentario de linea
//Comentario de Bloque
[/][*][*][^*]*[*]+([^/*][^*]*[*]+)*[/] //Comentario de Bloque



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
([\']|[\‘]|[\’])([^\' \‘ \’]+)([\']|[\‘]|[\’])                    return 'PR'


<<EOF>>     return 'EOF'
.           return 'INVALID'

/lex

%start inicio

%{
    var listaErrores = [];

    function getListaErrores() {
        alert('Si entra en la funcion');
        return null;
    }

    function insertarError(linea, columna, descripcion) {
        listaErrores.push('Error Sintáctico. Linea ' + linea + ". Columna " + columna + ". Descripción: " + descripcion);
    }

    exports.listaErrores = listaErrores;

%}

%%

inicio :    inicio_wison EOF
            | error EOF { insertarError(this._$.first_line, this._$.first_column, 'Error'); }
            ;

inicio_wison :  WISON INTER_A definicion_lexica definicion_sintactica INTER_C WISON
                | error definicion_lexica definicion_sintactica INTER_C WISON           { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la instruccion Wison ¿'); }
                | WISON INTER_A definicion_lexica definicion_sintactica error       { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la instruccion ? Wison'); }
                ;

//Inicio de la definición léxica
definicion_lexica : LEX LLA_A PUNTOS cuerpo_definicion_lexica PUNTOS LLA_C              
                    //| error LLA_A PUNTOS cuerpo_definicion_lexica PUNTOS LLA_C      { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la palabra Lex'); }
                    //| LEX error PUNTOS cuerpo_definicion_lexica PUNTOS LLA_C        { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el símbolo {'); }
                    //| LEX LLA_A error cuerpo_definicion_lexica PUNTOS LLA_C         { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el símbolo :'); }
                    | error cuerpo_definicion_lexica PUNTOS LLA_C                   { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la expresión Lex {:'); }
                    | LEX LLA_A PUNTOS cuerpo_definicion_lexica error               { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la expresion :}'); }
                    ;

cuerpo_definicion_lexica :  cuerpo_definicion_lexica definicion_terminal
                            | definicion_terminal
                            ;

definicion_terminal :   TERMINAL TERMINAL_SYM FLECHA_SIMPLE declaracion_terminal PUNTO_COMA
                        | error TERMINAL_SYM FLECHA_SIMPLE declaracion_terminal PUNTO_COMA                  { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la palabra Terminal'); }
                        | TERMINAL error FLECHA_SIMPLE declaracion_terminal PUNTO_COMA                      { insertarError(this._$.first_line, this._$.first_column, 'Error en el símbolo terminal declarado'); }
                        | TERMINAL TERMINAL_SYM error declaracion_terminal PUNTO_COMA                       { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el simbolo ->'); }
                        //| TERMINAL TERMINAL_SYM FLECHA_SIMPLE error PUNTO_COMA                              { insertarError(this._$.first_line, this._$.first_column, 'Error en la asignación de valor al terminal'); }
                        | error PUNTO_COMA                                                                  { insertarError(this._$.first_line, this._$.first_column, 'Error en la definición del terminal'); }
                        | TERMINAL TERMINAL_SYM FLECHA_SIMPLE declaracion_terminal error                    { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba un ;'); }
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
                        | error cuerpo definicion_sintactica PUNTOS LLA_C LLA_C                     { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la instrucción Syntax {{:'); }
                        | SYNTAX LLA_A LLA_A PUNTOS cuerpo_definicion_sintactica error              { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba exactamente lo simbolos :}}'); }
                        ;

cuerpo_definicion_sintactica :  definicion_no_terminales simbolo_inicial reglas_de_produccion
                                | definicion_no_terminales error reglas_de_produccion       { insertarError(this._$.first_line, this._$.first_column, 'Error al declarar el simbolo inicial de la gramática'); }
                                ;

//Definimos los no terminales de wison
definicion_no_terminales :  definicion_no_terminales no_terminal_definido
                            | no_terminal_definido
                            ;

no_terminal_definido :  NO_TERMINAL NO_TERMINAL_SYM PUNTO_COMA
                        | error NO_TERMINAL_SYM PUNTO_COMA              { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la palabra No_Terminal'); }
                        | error PUNTO_COMA                              { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la expresión No_Terminal \'Simbolo no terminal\''); }
                        | NO_TERMINAL error PUNTO_COMA                  { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba un nombre válido para el símbolo no terminal'); }
                        | NO_TERMINAL NO_TERMINAL_SYM error             { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el simbolo ;'); }
                        ;


//Definimos el simbolo inicial de wison
simbolo_inicial :   INITIAL_SIM NO_TERMINAL_SYM PUNTO_COMA
                    ;

//Definimos las reglas de produccion de wison
reglas_de_produccion :  reglas_de_produccion regla_de_produccion_definida
                        | regla_de_produccion_definida
                        ;

regla_de_produccion_definida :  NO_TERMINAL_SYM FLECHA_DOBLE cuerpo_regla_de_produccion PUNTO_COMA
                                | FLECHA_DOBLE cuerpo_regla_de_produccion PUNTO_COMA                    { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba un simbolo no terminal'); }
                                | NO_TERMINAL_SYM error cuerpo_regla_de_produccion PUNTO_COMA           { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el simbolo <='); }
                                | NO_TERMINAL_SYM FLECHA_DOBLE cuerpo_regla_de_produccion error         { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba un simbolo ;'); }
                                ;

cuerpo_regla_de_produccion :    cuerpo_regla_de_produccion simbolos_regla_de_produccion
                                | simbolos_regla_de_produccion
                                ;

simbolos_regla_de_produccion :  NO_TERMINAL_SYM
                                | TERMINAL_SYM 
                                | OR
                                ;