import { Component, OnInit } from '@angular/core';

import * as wisonParser from '../../assets/jsFiles/wison.js';

@Component({
  selector: 'app-area-texto',
  templateUrl: './area-texto.component.html',
  styleUrls: ['./area-texto.component.css']
})
export class AreaTextoComponent implements OnInit {

  linea = "1";
  columna = '1';
  salida = 'No hay datos de salida';
  constructor() { }

  ngOnInit(): void {
  }
//Método que nos sirve para hallar la posición del cursor en el area de texto
  actualizarPosicion(textarea) {
    var textLines = textarea.value.substr(0, textarea.selectionStart).split("\n");
    var currentLine = textLines.length;
    var currentColumn = textLines[textLines.length-1].length + 1;
    this.linea = currentLine;
    this.columna = currentColumn;
  }

  parseWison(entrada:string) {
    //Limpiamos los listados
    this.limpiarArreglos();

    try {
      wisonParser.parse(entrada);
      //Se tienen problemas para ejecutar la función que detecta los errores
      //wisonParser.getListaErrores(this.salida);
      if(wisonParser.listaErrores.length == 0) {
        this.salida = 'La entrada ha sido analizada con éxito';
      } else {
        //Agregamos los errores en la salirda
        var variable = wisonParser.listaErrores;
        this.salida = 'Advertencias:\n';
        for(let i = 0; i < variable.length; i++) {
          this.salida += variable[i] + '\n';
        }
      }
    } catch(error) {
      this.salida='Error Irrecuperable';
      console.error(error);
    }
  }

  limpiarArreglos() {
    wisonParser.listaErrores.splice(0, wisonParser.listaErrores.length);
    wisonParser.listaErrores.length = 0;
    wisonParser.listaTerminales.splice(0, wisonParser.listaTerminales.length);
    wisonParser.listaTerminales.length = 0;
    wisonParser.listaNoTerminales.splice(0, wisonParser.listaNoTerminales.length);
    wisonParser.listaNoTerminales.length = 0;
    wisonParser.reglasDeProduccion.splice(0, wisonParser.reglasDeProduccion.length);
    wisonParser.reglasDeProduccion.length = 0;
  }

}