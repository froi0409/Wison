import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-prueba-segunda',
  templateUrl: './prueba-segunda.component.html',
  styleUrls: ['./prueba-segunda.component.css']
})
export class PruebaSegundaComponent implements OnInit {

  nombre="Juan";
  apellido="Diaz";
  edad = 18;
  //empresa = "hola";

  constructor() { }

  ngOnInit(): void {
  }

  llamaEmpresa(value:string) {
    
  }

}
