import { parseTemplate } from '@angular/compiler';
import { Component, OnInit } from '@angular/core';
//import * as wison from '../../assets/js/wison.js';
//var wison = require("../../assets/js/wison.js");




@Component({
  selector: 'app-wison-area',
  templateUrl: './wison-area.component.html',
  styleUrls: ['./wison-area.component.css']
})
export class WisonAreaComponent implements OnInit {

  posicion = "(0 ,0)";
  ngOnInit(): void {
   
  }

  actualizarCursor(value:string) {
    
  }

  
  
}