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
([\']|[\‘]|[\’])([^\' \‘ \’ \n ' ']+)([\']|[\‘]|[\’])                    return 'PR'

<<EOF>>     return 'EOF'
(.*)           { listaErrores.push('Error Sintáctico. Linea ' + yylloc.first_line + ". Columna " + (yylloc.first_column + 1) + ". Descripción:" + yytext + " es un simbolo no reconocido por la gramática"); }
//.           return 'INVALID'

/lex

%start inicio

%{
    var listaErrores = [];
    var listaTerminales = [];
    var listaNoTerminales = [];
    var reglasDeProduccion = [];

    function getListaErrores() {
        alert('Si entra en la funcion');
        return null;
    }

    function insertarError(linea, columna, descripcion) {
        var columnaSumada = columna + 1;
        listaErrores.push('Error Sintáctico. Linea ' + linea + ". Columna " + columnaSumada + ". Descripción: " + descripcion);
    }

    function insertarErrorSemántico(linea, columna, descripcion) {
        var columnaSumada = columna + 1;
        listaErrores.push('Error Semántico. Linea ' + linea + ". Columna " + columnaSumada + ". Descripción: " + descripcion);
    }
    
    function verificarReglaDeProduccion() {
        for(let i = 0; i < reglasDeProduccion.length; i++) {
            var produccion = reglasDeProduccion[i];
            verificarRecursividadIzquierda(produccion);
            verificarFactorizacion(produccion);
        }
    }

    function verificarRecursividadIzquierda(produccion) {
        for(let i  = 0; i < produccion.condiciones.length; i++) {
            for(let j = 0; j < produccion.condiciones[i].length-1; j++) {
                if(produccion.condiciones[i][j] === produccion.simboloNoTerminal) {
                    var cadena = '';
                    for(let k = 0; k < produccion.condiciones[i].length; k++) {
                        cadena += produccion.condiciones[i][k] + ' ';
                    }
                    listaErrores.push("Advertencia: La regla de producción del símbolo no terminal " + produccion.simboloNoTerminal + " tiene recursividad por la izquierda en su regla " + cadena + ", reescriba la regla de producción");
                }
            }
        }
    }

    function verificarFactorizacion(produccion) {
        var listaAux = [];
        for(let i  = 0; i < produccion.condiciones.length; i++) {
        
            var simbolo;
            if(produccion.condiciones[i].length === 0) {
                simbolo = 'cadenaVacia';
            } else {
                simbolo = produccion.condiciones[i][0];
            }

            if(listaAux.includes(simbolo)) {
                listaErrores.push("Advertencia: La regla de producción del simbolo no terminal " + produccion.simboloNoTerminal + " debe ser factorizada en las producciones que inician con el simbolo " + simbolo);
            } else {
                listaAux.push(simbolo);
            }
            console.log("Se encontró el simbolo: " + simbolo);
        
        }
    }

    exports.listaErrores = listaErrores;
    exports.listaTerminales = listaTerminales;
    exports.listaNoTerminales = listaNoTerminales;  
    exports.reglasDeProduccion = reglasDeProduccion;

%}

%%

inicio :    inicio_wison EOF
            | error EOF { insertarError(this._$.first_line, this._$.first_column, 'Error'); }
            | error { insertarError(this._$.first_line, this._$.first_column, 'Error Irrecuperable'); }
            ;

inicio_wison :  WISON INTER_A definicion_lexica definicion_sintactica INTER_C WISON 
                | error INTER_A definicion_lexica definicion_sintactica INTER_C WISON   { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la palabra Wison'); }
                | WISON error definicion_lexica definicion_sintactica INTER_C WISON     { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el simbolo ¿'); }
                | error definicion_lexica definicion_sintactica INTER_C WISON           { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la instruccion Wison ¿'); }
                | WISON INTER_A definicion_lexica definicion_sintactica error       { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la instruccion ? Wison'); }
                ;

//Inicio de la definición léxica
definicion_lexica : LEX LLA_A PUNTOS cuerpo_definicion_lexica PUNTOS LLA_C              
                    | error LLA_A PUNTOS cuerpo_definicion_lexica PUNTOS LLA_C      { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la palabra Lex'); }
                    | LEX error PUNTOS cuerpo_definicion_lexica PUNTOS LLA_C        { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el símbolo {'); }
                    | LEX LLA_A error cuerpo_definicion_lexica PUNTOS LLA_C         { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el símbolo :'); }
                    | error cuerpo_definicion_lexica PUNTOS LLA_C                   { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la expresión Lex {:'); }
                    | LEX LLA_A PUNTOS cuerpo_definicion_lexica error               { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la expresion :}'); }
                    ;

cuerpo_definicion_lexica :  cuerpo_definicion_lexica definicion_terminal
                            | definicion_terminal
                            ;

definicion_terminal :   TERMINAL TERMINAL_SYM FLECHA_SIMPLE declaracion_terminal PUNTO_COMA
                        {
                            if(listaTerminales.includes($2)) {
                                insertarErrorSemántico(this._$.first_line, this._$.first_column, 'El simbolo terminal ' + $2 + ' ya se encuentra definido');
                            } else {
                                listaTerminales.push($2); //Declaración de los no terminales, se puede modificar
                            }
                        }
                        
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



definicion_sintactica : SYNTAX LLA_A LLA_A PUNTOS cuerpo_definicion_sintactica PUNTOS LLA_C LLA_C       { verificarReglaDeProduccion(); }   
                        | error LLA_A LLA_A PUNTOS cuerpo_definicion_sintactica PUNTOS LLA_C LLA_C      { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la palabra Syntax'); }
                        | SYNTAX error LLA_A PUNTOS cuerpo_definicion_sintactica PUNTOS LLA_C LLA_C     { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el sumbolo {. (Recuerde que la isntrucción exacta es: Syntax {{:}})'); }
                        | SYNTAX LLA_A error PUNTOS cuerpo_definicion_sintactica PUNTOS LLA_C LLA_C     { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el sumbolo {. (Recuerde que la isntrucción exacta es: Syntax {{:}})'); }
                        | SYNTAX LLA_A LLA_A error cuerpo_definicion_sintactica PUNTOS LLA_C LLA_C      { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el simbolo :'); }
                        | error cuerpo definicion_sintactica PUNTOS LLA_C LLA_C                     { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la instrucción Syntax {{:'); }
                        | SYNTAX LLA_A LLA_A PUNTOS cuerpo_definicion_sintactica error              { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba exactamente lo simbolos :}}'); }
                        ;

cuerpo_definicion_sintactica :  definicion_no_terminales apoyo_cuerpo_definicion
                                //| definicion_no_terminales error reglas_de_produccion       { insertarError(this._$.first_line, this._$.first_column, 'Error al declarar el simbolo inicial de la gramática'); }
                                ;

apoyo_cuerpo_definicion :   simbolo_inicial reglas_de_produccion
                            | error reglas_de_produccion            { insertarError(this._$.first_line, this._$.first_column, 'Error al declarar el simbolo inicial de la gramática. La estructura debe ser: Initial_Sim \'Simbolo no terminal\' ;'); }
                            ;

//Definimos los no terminales de wison
definicion_no_terminales :  definicion_no_terminales no_terminal_definido
                            | no_terminal_definido
                            ;

no_terminal_definido :  NO_TERMINAL NO_TERMINAL_SYM PUNTO_COMA
                        {
                            if(listaNoTerminales.includes($2)) {
                                insertarErrorSemántico(this._$.first_line, this._$.first_column, 'El simbolo no terminal ' + $2 + ' ya se encuentra definido');
                            } else {
                                listaNoTerminales.push($2);
                            }
                        }
                        | error NO_TERMINAL_SYM PUNTO_COMA              { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la palabra No_Terminal'); }
                        | error PUNTO_COMA                              { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la expresión No_Terminal \'Simbolo no terminal\''); }
                        | NO_TERMINAL error PUNTO_COMA                  { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba un nombre válido para el símbolo no terminal'); }
                        | NO_TERMINAL NO_TERMINAL_SYM error             { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el simbolo ;'); }
                        ;


//Definimos el simbolo inicial de wison
simbolo_inicial :   INITIAL_SIM NO_TERMINAL_SYM PUNTO_COMA           
                    //| error NO_TERMINAL_SYM PUNTO_COMA          { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba la palabra INITIAL_SIM'); }
                    //| error PUNTO_COMA                          { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba exactamente la instruccion INITIAL_SIM \'Simbolo no terminal\''); }
                    | INITIAL_SIM error PUNTO_COMA              { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba un símbolo no terminal válido para ser asignado como simbolo inicial. Verifique si el simbolo no terminal contiene caracteres inválidos o si hace falta el simbolo ; de fin de instruccion'); }
                    | INITIAL_SIM NO_TERMINAL error             { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el símbolo ;'); }
                    ;

//Definimos las reglas de produccion de wison
reglas_de_produccion :  reglas_de_produccion regla_de_produccion_definida
                        | regla_de_produccion_definida
                        ;

regla_de_produccion_definida :  NO_TERMINAL_SYM FLECHA_DOBLE cuerpo_regla_de_produccion PUNTO_COMA
                                {
                                    if(listaNoTerminales.includes($1)) {
                                        var reglaProduccion = new Object();
                                        reglaProduccion.simboloNoTerminal = $1;
                                        reglaProduccion.condiciones = $3;
                                        reglasDeProduccion.push(reglaProduccion);
                                    } else {
                                        insertarErrorSemántico(this._$.first_line, this._$.first_column, 'El simbolo no terminal ' + $1 + ' no se encuentra definido');
                                    }
                                }
                                | FLECHA_DOBLE cuerpo_regla_de_produccion PUNTO_COMA                    { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba un simbolo no terminal'); }
                                | NO_TERMINAL_SYM error cuerpo_regla_de_produccion PUNTO_COMA           { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba el simbolo <='); }
                                | NO_TERMINAL_SYM FLECHA_DOBLE cuerpo_regla_de_produccion error         { insertarError(this._$.first_line, this._$.first_column, 'Se esperaba un simbolo ;'); }
                                ;

cuerpo_regla_de_produccion :    cuerpo_regla_de_produccion simbolos_regla_de_produccion
                                {
                                    if($2 !== null) {
                                        if($2 === '|') {
                                            var nuevoArray = [];
                                            $1.push(nuevoArray);
                                        } else if($1 !== null) {
                                            //Insertamos el simbolo a la regla de producción
                                            $1[$1.length - 1].push($2);
                                        }
                                    }
                                    $$ = $1;
                                }
                                | simbolos_regla_de_produccion
                                {
                                    var array = [];
                                    if($1 !== null) {
                                        var arrayProvisional = [];
                                        arrayProvisional.push($1);
                                        array.push(arrayProvisional);
                                    }
                                    $$ = array;
                                }
                                ;

simbolos_regla_de_produccion :  NO_TERMINAL_SYM
                                {
                                    if(listaTerminales.includes($1) || listaNoTerminales.includes($1)) {
                                        $$ = $1
                                    } else {
                                        insertarErrorSemántico(this._$.first_line, this._$.first_column, 'El simbolo ' + $1 + ' no está definido dentro de los simbolos no terminales ni en los simbolos terminales');
                                    }
                                }
                                | TERMINAL_SYM
                                {
                                    if(listaTerminales.includes($1) || listaNoTerminales.includes($1)) {
                                        $$ = $1
                                    } else {
                                        insertarErrorSemántico(this._$.first_line, this._$.first_column, 'El simbolo ' + $1 + ' no está definido dentro de los simbolos no terminales ni en los simbolos terminales');
                                    }
                                }
                                | OR            {$$ = $1}
                                ;