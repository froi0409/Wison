import { Component, OnInit } from '@angular/core';

import * as wisonParser from '../../assets/jsFiles/wison.js';

@Component({
  selector: 'app-area-texto',
  templateUrl: './area-texto.component.html',
  styleUrls: ['./area-texto.component.css']
})
export class AreaTextoComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

  parseWison(entrada:string) {
    alert(entrada);
    var parserWison = wisonParser;
    parserWison.parse(entrada);
  }

}
