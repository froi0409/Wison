import { Component } from '@angular/core';
import * as wisonParser from '../assets/wison.js';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'WisonApp';
  informacion = 'Editor de Texto';
  constructor() {

  }

  ngOnInit() {

  }

  parsear(entrada:string) {
    //var parserWison = wisonParser;
    console.log("entrada: ");
    console.log(entrada);
    //parserWison.parse(entrada);
  }

}
