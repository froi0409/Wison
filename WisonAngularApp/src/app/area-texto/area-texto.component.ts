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

  constructor() { }

  ngOnInit(): void {
  }

  parseWison(entrada:string) {
    alert(entrada);
    //var parserWison = wisonParser;
    wisonParser.parse(entrada);
  }

  //Método que nos sirve para hallar la posición del cursor en el area de texto
  actualizarPosicion(textarea) {
    var textLines = textarea.value.substr(0, textarea.selectionStart).split("\n");
    var currentLine = textLines.length;
    var currentColumn = textLines[textLines.length-1].length + 1;
    this.linea = currentLine;
    this.columna = currentColumn;
  }

}
